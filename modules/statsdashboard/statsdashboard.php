<?php
if (!defined('_PS_VERSION_')) {
    exit;
}

class StatsDashboard extends Module
{
    public function __construct()
    {
        $this->name = 'statsdashboard';
        $this->tab = 'administration';
        $this->version = '1.0.0';
        $this->author = 'Your Name';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->l('Custom Stats Dashboard');
        $this->description = $this->l('Displays store statistics filtered by year, brand, and supplier.');
        $this->ps_versions_compliancy = ['min' => '1.7.0.0', 'max' => _PS_VERSION_];
    }

    public function install()
    {
        return parent::install() && $this->installTab();
    }

    public function uninstall()
    {
        return parent::uninstall() && $this->uninstallTab();
    }

    private function installTab()
    {
        $tab = new Tab();
        $tab->active = 1;
        $tab->class_name = 'AdminStatsDashboard';
        $tab->name = array();
        foreach (Language::getLanguages(true) as $lang) {
            $tab->name[$lang['id_lang']] = 'Store Stats';
        }
        // Attaches it under the "SELL" > "Stats" parent menu
        $tab->id_parent = (int) Tab::getIdFromClassName('AdminStats'); 
        $tab->module = $this->name;
        return $tab->save();
    }

    private function uninstallTab()
    {
        $id_tab = (int) Tab::getIdFromClassName('AdminStatsDashboard');
        if ($id_tab) {
            $tab = new Tab($id_tab);
            return $tab->delete();
        }
        return true;
    }
}