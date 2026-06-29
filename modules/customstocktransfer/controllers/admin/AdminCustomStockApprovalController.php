<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

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

        // Fetch transfers and join with product_lang for the product name
        $sql = 'SELECT t.*, pl.name AS product_name, pl.link_rewrite
                FROM `' . _DB_PREFIX_ . 'transfers` t
                LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl 
                    ON (t.id_product = pl.id_product AND pl.id_lang = ' . $id_lang . ' AND pl.id_shop = ' . $id_shop . ')
                ORDER BY t.id_transfer DESC';

        $raw_transfers = Db::getInstance()->executeS($sql);

        $grouped_transfers = [
            'pending' => [],
            'approved' => [],
            'declined' => [],
            'completed' => []
        ];

        if (is_array($raw_transfers) && !empty($raw_transfers)) {
            foreach ($raw_transfers as &$transfer) {
                // Generate product image URL using Image::getCover
                $coverUrl = '';
                $cover = Image::getCover($transfer['id_product']);
                if (is_array($cover) && !empty($cover['id_image']) && !empty($transfer['link_rewrite'])) {
                    $coverUrl = $this->context->link->getImageLink(
                        $transfer['link_rewrite'],
                        (int) $cover['id_image'],
                        ImageType::getFormattedName('home')
                    );
                }
                $transfer['image_url'] = $coverUrl;

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
        parent::postProcess();
    }
}
