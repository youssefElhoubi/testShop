<?php

namespace PrestaShop\Module\Customstocktransfer\Repository;

use Db;
use DbQuery;

class CustomStockTransferRepository
{
    public function getTotalProductsCount(int $idLang, int $idShopForName, string $productSearch = '', array $filter = []): int
    {
        $query = new DbQuery();
        $query->select('COUNT(DISTINCT p.id_product)');
        $query->from('product', 'p');

        $statusCondition = (isset($filter['status']) && $filter['status'] !== null) ? ' AND ps.active = ' . (int)$filter['status'] : ' AND ps.active = 1';
        $query->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product' . $statusCondition);
        $query->innerJoin('product_lang', 'pl', 'pl.id_product = p.id_product AND pl.id_lang = ' . $idLang . ' AND pl.id_shop = ' . $idShopForName);

        if (isset($filter['category']) && $filter['category'] > 0) {
            $query->innerJoin('category_product', 'cp', 'cp.id_product = p.id_product');
            $query->where('cp.id_category = ' . (int)$filter['category']);
        }

        if (isset($filter['brand']) && $filter['brand'] > 0) {
            $query->where('p.id_manufacturer = ' . (int)$filter['brand']);
        }

        if ($productSearch !== '') {
            $productSearchEscaped = pSQL($productSearch);
            $query->where('pl.name LIKE \'%' . $productSearchEscaped . '%\' OR p.reference LIKE \'%' . $productSearchEscaped . '%\'');
        }

        return (int) Db::getInstance()->getValue($query);
    }

    public function getProductsDashboardData(int $idLang, int $idShopForName, int $page = 1, int $limit = 20, string $productSearch = '', array $filter = []): array
    {
        $query = new DbQuery();
        $query->select('p.id_product, pl.name, pl.link_rewrite');
        $query->from('product', 'p');

        $statusCondition = (isset($filter['status']) && $filter['status'] !== null) ? ' AND ps.active = ' . (int)$filter['status'] : ' AND ps.active = 1';
        $query->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product' . $statusCondition);
        $query->innerJoin('product_lang', 'pl', 'pl.id_product = p.id_product AND pl.id_lang = ' . $idLang . ' AND pl.id_shop = ' . $idShopForName);

        if (isset($filter['category']) && $filter['category'] > 0) {
            $query->innerJoin('category_product', 'cp', 'cp.id_product = p.id_product');
            $query->where('cp.id_category = ' . (int)$filter['category']);
        }

        if (isset($filter['brand']) && $filter['brand'] > 0) {
            $query->where('p.id_manufacturer = ' . (int)$filter['brand']);
        }

        if ($productSearch !== '') {
            $productSearchEscaped = pSQL($productSearch);
            $query->where('pl.name LIKE \'%' . $productSearchEscaped . '%\' OR p.reference LIKE \'%' . $productSearchEscaped . '%\'');
        }

        $query->groupBy('p.id_product, pl.name, pl.link_rewrite');
        $query->orderBy('pl.name ASC');

        $offset = (int) (($page - 1) * $limit);
        $query->limit($limit, $offset);

        $result = Db::getInstance()->executeS($query);
        return is_array($result) ? $result : [];
    }

    public function productExists(int $idProduct): bool
    {
        $sql = new DbQuery();
        $sql->select('p.id_product');
        $sql->from('product', 'p');
        $sql->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product AND ps.active = 1');
        $sql->where('p.id_product = ' . $idProduct);

        return (bool) Db::getInstance()->getValue($sql);
    }

    public function getTransferHistory(): array
    {
        $result = Db::getInstance()->executeS('SELECT * FROM `' . _DB_PREFIX_ . 'transfers`');
        return is_array($result) ? $result : [];
    }
}
