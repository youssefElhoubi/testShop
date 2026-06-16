<?php
if (!defined('_PS_VERSION_')) {
    exit;
}
class customhook extends Module
{
    public function __construct()
    {
        // die("BINGO! THE FILE IS RUNNING!");
        $this->name = 'customhook';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;
        $this->bootstrap = true;
        parent::__construct();
        $this->displayName = $this->l('My Custom Hook Module');
        $this->description = $this->l('A full module to demonstrate creating and injecting a custom hook.');
        $this->ps_versions_compliancy = array('min' => '1.7', 'max' => _PS_VERSION_);
    }
    public function install()
    {
        return parent::install() && $this->registerHook('displayCustomHook');
    }
    public function uninstall()
    {
        return parent::uninstall();
    }

    public function hookDisplayCustomHook($params)
    {
        $this->context->smarty->assign([
            'custom_message' => 'Hello from the custom hook!'
        ]);
        return $this->display(__FILE__, 'views/templates/hook/custom_template.tpl');

    }
}
