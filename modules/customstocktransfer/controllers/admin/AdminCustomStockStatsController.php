<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminCustomStockStatsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);

        $this->context->controller->addCSS(_MODULE_DIR_ . 'customstocktransfer/views/css/stats.css');
        $this->context->controller->addJS(_MODULE_DIR_ . 'customstocktransfer/views/js/stats.js');
    }

    public function initContent()
    {
        parent::initContent();

        $this->context->smarty->assign(array(
            'page_title' => 'Transfer Statistics'
        ));

        $this->setTemplate('stats_dashboard.tpl');
    }
}
