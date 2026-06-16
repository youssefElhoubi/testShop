<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class Testpage extends Module
{
    public function __construct()
    {
        $this->name = 'testpage';
        $this->tab = 'front_office_features';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;
        $this->bootstrap = true;
        $this->controllers = array("view");

        parent::__construct();

        $this->displayName = $this->l('Test Page');
        $this->description = $this->l('A module to create a custom CMS page with dynamic content.');
        $this->ps_versions_compliancy = array('min' => '1.7', 'max' => _PS_VERSION_);
    }

    public function install()
    {
        return parent::install() && $this->registerHook('moduleRoutes');
    }
    public function hookModuleRoutes($params)
    {
        return [
            'module-testpage-view' => [
                'controller' => 'view',
                'rule' => 'latest-products', // <--- THIS IS YOUR CLEAN URL
                'keywords' => [],
                'params' => [
                    'fc' => 'module',
                    'module' => 'testpage'
                ]
            ]
        ];
    }

    public function uninstall()
    {
        return parent::uninstall();
    }
}
