<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class CustomStockTransfer extends Module
{
    public function __construct()
    {
        $this->name = 'customstocktransfer';
        $this->tab = 'administration';
        $this->version = '1.0.0';
        $this->author = 'PrestaShop';
        $this->need_instance = 0;
        $this->bootstrap = true;

        parent::__construct();

        $this->displayName = $this->trans('Custom Stock Transfer', [], 'Modules.Customstocktransfer.Admin');
        $this->description = $this->trans('Transfer product stock quantities between shops in a multistore setup.', [], 'Modules.Customstocktransfer.Admin');
        $this->ps_versions_compliancy = [
            'min' => '1.7.0.0',
            'max' => _PS_VERSION_,
        ];
    }

    public function install()
    {
        return parent::install() && $this->installTab();
    }

    public function uninstall()
    {
        return $this->uninstallTab() && parent::uninstall();
    }

    protected function installTab()
    {
        if ((int) Tab::getIdFromClassName('AdminCustomStockTransfer') > 0) {
            return true;
        }

        $tab = new Tab();
        $tab->class_name = 'AdminCustomStockTransfer';
        $tab->module = $this->name;
        $tab->active = 1;
        $tab->id_parent = $this->getCatalogParentTabId();
        $tab->name = [];

        foreach (Language::getLanguages(true) as $language) {
            $tab->name[(int) $language['id_lang']] = 'Stock Transfer';
        }

        return (bool) $tab->add();
    }

    protected function uninstallTab()
    {
        $idTab = (int) Tab::getIdFromClassName('AdminCustomStockTransfer');
        if ($idTab <= 0) {
            return true;
        }

        $tab = new Tab($idTab);
        if (!Validate::isLoadedObject($tab)) {
            return true;
        }

        return (bool) $tab->delete();
    }

    protected function getCatalogParentTabId()
    {
        foreach (['AdminCatalog', 'AdminParentCatalog'] as $className) {
            $idParent = (int) Tab::getIdFromClassName($className);
            if ($idParent > 0) {
                return $idParent;
            }
        }

        return 0;
    }

    public function getContent()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminCustomStockTransfer'));
    }
}