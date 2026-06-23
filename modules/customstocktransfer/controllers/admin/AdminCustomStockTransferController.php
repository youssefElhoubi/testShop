<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminCustomStockTransferController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->show_toolbar = false;
        parent::__construct();

        $this->meta_title = $this->trans('Stock Transfer', [], 'Modules.Customstocktransfer.Admin');
    }

    public function postProcess()
    {
        if (!Tools::isSubmit('submitCustomStockTransfer')) {
            return parent::postProcess();
        }

        $idProduct = (int) Tools::getValue('id_product');
        $sourceShopId = (int) Tools::getValue('source_shop_id');
        $destinationShopId = (int) Tools::getValue('destination_shop_id');
        $quantity = Tools::getValue('quantity');

        if (!Validate::isUnsignedId($idProduct)) {
            $this->setFlashMessage(false, $this->trans('Please provide a valid product ID.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        if (!Validate::isUnsignedId($sourceShopId)) {
            $this->setFlashMessage(false, $this->trans('Please select a valid source store.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        if (!Validate::isUnsignedId($destinationShopId)) {
            $this->setFlashMessage(false, $this->trans('Please select a valid destination store.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        if (!Validate::isUnsignedInt($quantity) || (int) $quantity <= 0) {
            $this->setFlashMessage(false, $this->trans('Please enter a valid quantity greater than zero.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        if ($sourceShopId === $destinationShopId) {
            $this->setFlashMessage(false, $this->trans('The source and destination stores must be different.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        $availableShopIds = array_map(static function (array $shop) {
            return (int) $shop['id_shop'];
        }, Shop::getShops(true, null, false));

        if (!in_array($sourceShopId, $availableShopIds, true)) {
            $this->setFlashMessage(false, $this->trans('The selected source store is not available.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        if (!in_array($destinationShopId, $availableShopIds, true)) {
            $this->setFlashMessage(false, $this->trans('The selected destination store is not available.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        if (!$this->productExists($idProduct)) {
            $this->setFlashMessage(false, $this->trans('The selected product does not exist or is not active.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        $currentSourceQuantity = (int) StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $sourceShopId);
        if ($currentSourceQuantity < (int) $quantity) {
            $this->setFlashMessage(false, $this->trans('The source store does not have enough stock for this transfer.', [], 'Modules.Customstocktransfer.Admin'));

            return $this->redirectToDashboard();
        }

        $currentDestinationQuantity = (int) StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $destinationShopId);

        StockAvailable::setQuantity($idProduct, 0, $currentSourceQuantity - (int) $quantity, $sourceShopId);
        StockAvailable::setQuantity($idProduct, 0, $currentDestinationQuantity + (int) $quantity, $destinationShopId);

        $this->setFlashMessage(true, $this->trans('Stock transfer completed successfully.', [], 'Modules.Customstocktransfer.Admin'));

        return $this->redirectToDashboard();
    }

    public function initContent()
    {
        parent::initContent();

        $shops = $this->getActiveShops();
        $products = $this->getProductsDashboardData($shops);

        $this->applyFlashMessage();

        $this->context->smarty->assign([
            'products' => $products,
            'shops' => $shops,
            'form_action' => $this->context->link->getAdminLink('AdminCustomStockTransfer'),
            'token' => Tools::getAdminTokenLite('AdminCustomStockTransfer'),
        ]);

        $this->setTemplate('transfer_dashboard.tpl');
    }

    protected function getActiveShops()
    {
        $shops = [];

        foreach (Shop::getShops(true, null, false) as $shop) {
            $shops[] = [
                'id_shop' => (int) $shop['id_shop'],
                'shop_name' => (string) $shop['name'],
            ];
        }

        return $shops;
    }

    protected function getProductsDashboardData(array $shops)
    {
        $products = [];
        $idLang = (int) $this->context->language->id;
        $idShopForName = (int) $this->context->shop->id;

        if ($idShopForName <= 0 && !empty($shops)) {
            $idShopForName = (int) $shops[0]['id_shop'];
        }

        $query = new DbQuery();
        $query->select('p.id_product, pl.name');
        $query->from('product', 'p');
        $query->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product AND ps.active = 1');
        $query->innerJoin('product_lang', 'pl', 'pl.id_product = p.id_product AND pl.id_lang = ' . (int) $idLang . ' AND pl.id_shop = ' . (int) $idShopForName);
        $query->groupBy('p.id_product, pl.name');
        $query->orderBy('pl.name ASC');

        $rows = Db::getInstance()->executeS($query);

        foreach ($rows as $row) {
            $productId = (int) $row['id_product'];
            $shopBreakdown = [];
            $totalQuantity = 0;

            foreach ($shops as $shop) {
                $shopQuantity = (int) StockAvailable::getQuantityAvailableByProduct($productId, 0, (int) $shop['id_shop']);

                $shopBreakdown[] = [
                    'id_shop' => (int) $shop['id_shop'],
                    'shop_name' => $shop['shop_name'],
                    'quantity_in_this_shop' => $shopQuantity,
                ];

                $totalQuantity += $shopQuantity;
            }

            $products[] = [
                'id_product' => $productId,
                'name' => (string) $row['name'],
                'total_quantity' => $totalQuantity,
                'shops' => $shopBreakdown,
                'is_low_stock' => $totalQuantity < 5,
            ];
        }

        return $products;
    }

    protected function productExists($idProduct)
    {
        $sql = new DbQuery();
        $sql->select('p.id_product');
        $sql->from('product', 'p');
        $sql->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product AND ps.active = 1');
        $sql->where('p.id_product = ' . (int) $idProduct);

        return (bool) Db::getInstance()->getValue($sql);
    }

    protected function redirectToDashboard()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminCustomStockTransfer'));
    }

    protected function setFlashMessage($isSuccess, $message)
    {
        $this->context->cookie->__set('customstocktransfer_success', (int) $isSuccess);
        $this->context->cookie->__set('customstocktransfer_message', (string) $message);
        $this->context->cookie->write();
    }

    protected function applyFlashMessage()
    {
        $message = (string) $this->context->cookie->__get('customstocktransfer_message');
        if ($message === '') {
            return;
        }

        $isSuccess = (int) $this->context->cookie->__get('customstocktransfer_success');
        if ($isSuccess === 1) {
            $this->confirmations[] = $message;
        } else {
            $this->errors[] = $message;
        }

        $this->context->cookie->__unset('customstocktransfer_success');
        $this->context->cookie->__unset('customstocktransfer_message');
        $this->context->cookie->write();
    }
}