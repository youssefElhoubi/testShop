<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

require_once dirname(__FILE__) . '/../../classes/StockTransfer.php';

class AdminCustomStockApprovalController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
        $this->meta_title = $this->trans('Manage Stock Transfers', [], 'Modules.Customstocktransfer.Admin');
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);

        $baseUri = $this->module->getPathUri();
        $this->addCSS($baseUri . 'views/css/approvale.css');
        $this->addJS($baseUri . 'views/js/approvale.js');
    }

    public function initContent()
    {
        parent::initContent();

        $id_lang = (int) $this->context->language->id;
        $id_shop = (int) $this->context->shop->id;

        // Fetch transfers without joining transfer_details
        $sql = 'SELECT t.*, sf.name as store_from_name, st.name as store_to_name
                FROM `' . _DB_PREFIX_ . 'transfers` t
                LEFT JOIN `' . _DB_PREFIX_ . 'shop` sf ON t.id_store_from = sf.id_shop
                LEFT JOIN `' . _DB_PREFIX_ . 'shop` st ON t.id_store_to = st.id_shop
                ORDER BY t.id_transfer DESC';

        $raw_transfers = Db::getInstance()->executeS($sql);

        $grouped_transfers = [
            'pending'    => [],
            'approved'   => [],
            'prepared'   => [],
            'in_transit' => [],
            'completed'  => [],
            'declined'   => []
        ];

        if (is_array($raw_transfers) && !empty($raw_transfers)) {
            foreach ($raw_transfers as &$transfer) {
                // Group by status
                $status = isset($transfer['status']) && !empty($transfer['status']) ? strtolower($transfer['status']) : 'pending';
                if (!isset($grouped_transfers[$status])) {
                    $grouped_transfers[$status] = [];
                }
                $grouped_transfers[$status][] = $transfer;
            }
        }

        $this->context->smarty->assign([
            'grouped_transfers' => $grouped_transfers,
            'approval_link' => $this->context->link->getAdminLink('AdminCustomStockApproval'),
            'form_action' => $this->context->link->getAdminLink('AdminCustomStockApproval'),
            'token' => Tools::getAdminTokenLite('AdminCustomStockApproval'),
        ]);
        
        $this->setTemplate('approval_dashboard.tpl');
    }
    public function postProcess()
    {
        if (Tools::isSubmit('submitApproveTransfer')) {
            $id_transfer = (int) Tools::getValue('id_transfer');
            $transfer = new StockTransfer($id_transfer);

            if (Validate::isLoadedObject($transfer) && $transfer->status === 'pending') {
                $id_store_from = (int) $transfer->id_store_from;
                $id_store_to = (int) $transfer->id_store_to;

                $sqlDetails = 'SELECT id_product, id_product_attribute, quantity FROM `' . _DB_PREFIX_ . 'transfer_details` WHERE id_transfer = ' . (int)$transfer->id;
                $details = Db::getInstance()->executeS($sqlDetails);

                if (!empty($details)) {
                    $hasEnoughStock = true;
                    // First check stock for all items
                    foreach ($details as $item) {
                        $qty = (int) $item['quantity'];
                        $id_product = (int) $item['id_product'];
                        $id_product_attribute = (int) $item['id_product_attribute'];
                        
                        $qty_from = StockAvailable::getQuantityAvailableByProduct($id_product, $id_product_attribute, $id_store_from);
                        if ($qty_from < $qty) {
                            $hasEnoughStock = false;
                            break;
                        }
                    }

                    if ($hasEnoughStock) {
                        $originalContext = Shop::getContext();
                        $originalShopId = Shop::getContextShopID();
                        
                        try {
                            foreach ($details as $item) {
                                $qty = (int) $item['quantity'];
                                $id_product = (int) $item['id_product'];
                                $id_product_attribute = (int) $item['id_product_attribute'];

                                // Force context to the source store
                                Shop::setContext(Shop::CONTEXT_SHOP, $id_store_from);
                                $current_qty_from = StockAvailable::getQuantityAvailableByProduct($id_product, $id_product_attribute, $id_store_from);
                                StockAvailable::setQuantity($id_product, $id_product_attribute, $current_qty_from - $qty, $id_store_from);
                                
                                // Force context to the destination store
                                Shop::setContext(Shop::CONTEXT_SHOP, $id_store_to);
                                $current_qty_to = StockAvailable::getQuantityAvailableByProduct($id_product, $id_product_attribute, $id_store_to);
                                StockAvailable::setQuantity($id_product, $id_product_attribute, $current_qty_to + $qty, $id_store_to);
                            }
                            
                            $transfer->status = 'approved';
                            $transfer->approved_by = (int) $this->context->employee->id;
                            $transfer->approved_at = date('Y-m-d H:i:s');
                            $transfer->date_upd = date('Y-m-d H:i:s');
                            if ($transfer->update()) {
                                $this->confirmations[] = $this->trans('Transfer approved successfully and stock updated.', [], 'Admin.Notifications.Success');
                            } else {
                                $this->errors[] = $this->trans('Failed to update transfer status.', [], 'Admin.Notifications.Error');
                            }
                        } catch (Exception $e) {
                            $this->errors[] = $e->getMessage();
                        } finally {
                            // Unconditionally restore original context
                            Shop::setContext($originalContext, $originalShopId);
                        }
                    } else {
                        $this->errors[] = $this->trans('Not enough stock in the source store for one or more items.', [], 'Admin.Notifications.Error');
                    }
                } else {
                    $this->errors[] = $this->trans('Transfer has no items.', [], 'Admin.Notifications.Error');
                }
            } else {
                $this->errors[] = $this->trans('Invalid transfer or already processed.', [], 'Admin.Notifications.Error');
            }
        } elseif (Tools::isSubmit('submitDeclineTransfer')) {
            $id_transfer = (int) Tools::getValue('id_transfer');
            $reason = pSQL(Tools::getValue('decline_reason'));
            $transfer = new StockTransfer($id_transfer);

            if (Validate::isLoadedObject($transfer) && $transfer->status === 'pending') {
                if (!empty($reason)) {
                    $transfer->status = 'declined';
                    $transfer->reason = $reason;
                    $transfer->date_upd = date('Y-m-d H:i:s');
                    if ($transfer->update()) {
                        $this->confirmations[] = $this->trans('Transfer declined successfully.', [], 'Admin.Notifications.Success');
                    } else {
                        $this->errors[] = $this->trans('Failed to decline transfer.', [], 'Admin.Notifications.Error');
                    }
                } else {
                    $this->errors[] = $this->trans('Decline reason is required.', [], 'Admin.Notifications.Error');
                }
            } else {
                $this->errors[] = $this->trans('Invalid transfer or already processed.', [], 'Admin.Notifications.Error');
            }
        } elseif (Tools::isSubmit('submitMarkPrepared')) {
            $id_transfer = (int) Tools::getValue('id_transfer');
            $transfer = new StockTransfer($id_transfer);

            if (Validate::isLoadedObject($transfer) && $transfer->status === 'approved') {
                $transfer->status = 'prepared';
                $transfer->prepared_by = (int) $this->context->employee->id;
                $transfer->prepared_at = date('Y-m-d H:i:s');
                $transfer->date_upd = date('Y-m-d H:i:s');

                if ($transfer->update()) {
                    $this->confirmations[] = $this->trans('Transfer marked as prepared.', [], 'Admin.Notifications.Success');
                } else {
                    $this->errors[] = $this->trans('Failed to mark transfer as prepared.', [], 'Admin.Notifications.Error');
                }
            } else {
                $this->errors[] = $this->trans('Invalid transfer or it is not in the approved state.', [], 'Admin.Notifications.Error');
            }
        } elseif (Tools::isSubmit('submitMarkShipped')) {
            $id_transfer = (int) Tools::getValue('id_transfer');
            $transfer = new StockTransfer($id_transfer);

            if (Validate::isLoadedObject($transfer) && $transfer->status === 'prepared') {
                $transfer->status = 'in_transit';
                $transfer->shipped_by = (int) $this->context->employee->id;
                $transfer->shipped_at = date('Y-m-d H:i:s');
                $transfer->date_upd = date('Y-m-d H:i:s');

                if ($transfer->update()) {
                    $this->confirmations[] = $this->trans('Transfer marked as shipped (in transit).', [], 'Admin.Notifications.Success');
                } else {
                    $this->errors[] = $this->trans('Failed to mark transfer as shipped.', [], 'Admin.Notifications.Error');
                }
            } else {
                $this->errors[] = $this->trans('Invalid transfer or it is not in the prepared state.', [], 'Admin.Notifications.Error');
            }
        } elseif (Tools::isSubmit('submitMarkCompleted')) {
            $id_transfer = (int) Tools::getValue('id_transfer');
            $transfer = new StockTransfer($id_transfer);

            if (Validate::isLoadedObject($transfer) && $transfer->status === 'in_transit') {
                $transfer->status = 'completed';
                $transfer->received_by = (int) $this->context->employee->id;
                $transfer->received_at = date('Y-m-d H:i:s');
                $transfer->date_upd = date('Y-m-d H:i:s');

                if ($transfer->update()) {
                    $this->confirmations[] = $this->trans('Transfer successfully marked as completed.', [], 'Admin.Notifications.Success');
                } else {
                    $this->errors[] = $this->trans('Failed to mark transfer as completed.', [], 'Admin.Notifications.Error');
                }
            } else {
                $this->errors[] = $this->trans('Invalid transfer or it is not currently in transit.', [], 'Admin.Notifications.Error');
            }
        }

        parent::postProcess();
    }
    public function ajaxProcessGetTransferDetails()
    {
        $id_transfer = (int) Tools::getValue('id_transfer');
        if (!$id_transfer) {
            die(json_encode(['success' => false, 'message' => 'Invalid transfer ID']));
        }
        
        $id_lang = (int) $this->context->language->id;
        $id_shop = (int) $this->context->shop->id;

        $sql = 'SELECT td.id_product, td.id_product_attribute, td.quantity, pl.name AS product_name
                FROM `' . _DB_PREFIX_ . 'transfer_details` td
                LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl 
                    ON (td.id_product = pl.id_product AND pl.id_lang = ' . $id_lang . ' AND pl.id_shop = ' . $id_shop . ')
                WHERE td.id_transfer = ' . $id_transfer;
        
        $details = Db::getInstance()->executeS($sql);

        die(json_encode(['success' => true, 'details' => $details]));
    }
}
