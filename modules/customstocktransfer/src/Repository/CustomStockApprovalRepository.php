<?php

namespace PrestaShop\Module\Customstocktransfer\Repository;

use Db;

class CustomStockApprovalRepository
{
    public function getTransfersWithProducts(int $idLang, int $idShop): array
    {
        $sql = 'SELECT t.*, pl.name AS product_name, pl.link_rewrite
                FROM `' . _DB_PREFIX_ . 'transfers` t
                LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl 
                    ON (t.id_product = pl.id_product AND pl.id_lang = ' . $idLang . ' AND pl.id_shop = ' . $idShop . ')
                ORDER BY t.id_transfer DESC';

        $result = Db::getInstance()->executeS($sql);
        return is_array($result) ? $result : [];
    }
}
