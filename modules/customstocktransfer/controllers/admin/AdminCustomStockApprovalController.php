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

        $transfers = Db::getInstance()->executeS('SELECT * FROM `' . _DB_PREFIX_ . 'transfers` ORDER BY id_transfer DESC');

        $this->context->smarty->assign([
            'transfers' => $transfers,
            'approval_link' => $this->context->link->getAdminLink('AdminCustomStockApproval'),
        ]);
        $this->setTemplate('approval_dashboard.tpl');
    }
    public function postProcess()
    {
        parent::postProcess();
    }
}
