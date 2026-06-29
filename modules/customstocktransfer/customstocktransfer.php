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
        $sql = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'transfers` (
            `id_transfer` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
            `id_product` INT(10) UNSIGNED NOT NULL,
            `id_store_from` INT(10) UNSIGNED NOT NULL,
            `id_store_to` INT(10) UNSIGNED NOT NULL,
            `quantity` INT(10) UNSIGNED NOT NULL,
            `status` ENUM(\'pending\', \'approved\', \'declined\', \'completed\') NOT NULL DEFAULT \'pending\',
            `reason` TEXT NULL,
            `date_add` DATETIME NOT NULL,
            PRIMARY KEY (`id_transfer`)
        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        return parent::install() &&
            Db::getInstance()->execute($sql) &&
            $this->installTab();
    }

    public function uninstall()
    {
        $sql = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'transfers`';
        return Db::getInstance()->execute($sql) &&
            $this->uninstallTab() &&
            parent::uninstall();
    }

    protected function installTab()
    {
        $tabs = [
            ['class' => 'AdminCustomStockTransfer', 'name' => 'Stock Request'],
            ['class' => 'AdminCustomStockApproval', 'name' => 'Transfer Approval']
        ];
        foreach ($tabs as $tabData) {
            if ((int) Tab::getIdFromClassName($tabData['class']) > 0) continue;

            $tab = new Tab();
            $tab->class_name = $tabData['class'];
            $tab->module = $this->name;
            $tab->active = 1;
            $tab->id_parent = $this->getCatalogParentTabId();
            $tab->name = [];
            foreach (Language::getLanguages(true) as $lang) {
                $tab->name[(int)$lang['id_lang']] = $tabData['name'];
            }
            $tab->add();
        }
        return true;
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
