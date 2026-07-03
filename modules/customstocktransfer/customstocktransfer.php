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
        // Table 1: The main transfer cart (Header)
        $sqlTransfers = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'transfers` (
                `id_transfer` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,

                -- Stores
                `id_store_from` INT(10) UNSIGNED NOT NULL,
                `id_store_to` INT(10) UNSIGNED NOT NULL,

                -- Barcode
                `barcode` VARCHAR(100) NOT NULL UNIQUE,

                -- Workflow Status
                `status` ENUM(
                    \'pending\',
                    \'approved\',
                    \'completed\',
                    \'declined\'
                ) NOT NULL DEFAULT \'pending\',

                -- Optional Notes
                `reason` TEXT NULL,
                `notes` TEXT NULL,

                -- Timestamps
                `date_add` DATETIME NOT NULL,
                `date_upd` DATETIME NOT NULL,

                PRIMARY KEY (`id_transfer`),

                INDEX (`id_store_from`),
                INDEX (`id_store_to`),
                INDEX (`status`),
                INDEX (`barcode`)

        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        // Table 2: The transfer details (Products/Items)
        $sqlDetails = 'CREATE TABLE IF NOT EXISTS `' . _DB_PREFIX_ . 'transfer_details` (
                `id_transfer_detail` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
                
                `id_transfer` INT(10) UNSIGNED NOT NULL,
                `id_product` INT(10) UNSIGNED NOT NULL,
                `id_product_attribute` INT(10) UNSIGNED NOT NULL DEFAULT 0,
                `quantity` INT(10) UNSIGNED NOT NULL,

                PRIMARY KEY (`id_transfer_detail`),
                
                INDEX (`id_transfer`),
                INDEX (`id_product`),
                INDEX (`id_product_attribute`)

        ) ENGINE=' . _MYSQL_ENGINE_ . ' DEFAULT CHARSET=utf8;';

        return parent::install() &&
            Db::getInstance()->execute($sqlTransfers) &&
            Db::getInstance()->execute($sqlDetails) &&
            $this->installTab() &&
            $this->registerHook('displayAdminNavBarBeforeEnd');
    }

    public function hookDisplayAdminNavBarBeforeEnd($params)
    {
        // This query remains untouched because status is still on the main transfers table
        $count = (int) Db::getInstance()->getValue(
            'SELECT COUNT(*) FROM `' . _DB_PREFIX_ . 'transfers` WHERE `status` = \'pending\''
        );

        if ($count <= 0) {
            return '';
        }

        $this->context->smarty->assign([
            'pending_transfers_count' => $count,
            'approval_link' => $this->context->link->getAdminLink('AdminCustomStockApproval')
        ]);

        return $this->display(__FILE__, 'views/templates/hook/admin_notification.tpl');
    }

    public function uninstall()
    {
        // Make sure to drop both tables on uninstall
        $sqlTransfers = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'transfers`';
        $sqlDetails = 'DROP TABLE IF EXISTS `' . _DB_PREFIX_ . 'transfer_details`';

        return Db::getInstance()->execute($sqlTransfers) &&
            Db::getInstance()->execute($sqlDetails) &&
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
        $tabs = ['AdminCustomStockTransfer', 'AdminCustomStockApproval'];

        foreach ($tabs as $className) {
            $idTab = (int) Tab::getIdFromClassName($className);
            if ($idTab > 0) {
                $tab = new Tab($idTab);
                if (Validate::isLoadedObject($tab)) {
                    $tab->delete();
                }
            }
        }
        return true;
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