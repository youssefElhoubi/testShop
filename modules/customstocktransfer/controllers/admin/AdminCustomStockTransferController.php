<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminCustomStockTransferController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        $this->show_toolbar = false;
        parent::__construct();

        $this->meta_title = $this->trans('Stock Transfer', [], 'Modules.Customstocktransfer.Admin');
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);

        $baseUri = $this->module->getPathUri();
        $this->addCSS($baseUri . 'views/css/transfer.css');
        $this->addJS($baseUri . 'views/js/transfer.js');
    }

    public function postProcess()
    {


        if (Tools::isSubmit('submitEditQuantity')) {
            $idProduct = (int) Tools::getValue('id_product');
            $newQuantity = (int) Tools::getValue('new_quantity');
            $maxQuantity = (int) Tools::getValue('max_quantity');

            if ($idProduct <= 0 || !$this->productExists($idProduct)) {
                $this->setFlashMessage(false, $this->trans('Invalid product.', [], 'Modules.Customstocktransfer.Admin'));
                $this->redirectToDashboard();
                return false;
            }

            if ($newQuantity < 0) {
                $this->setFlashMessage(false, $this->trans('Quantity cannot be less than 0.', [], 'Modules.Customstocktransfer.Admin'));
                $this->redirectToDashboard();
                return false;
            }

            $maxLimit = $maxQuantity > 0 ? $maxQuantity : 99999;
            if ($newQuantity > $maxLimit) {
                $this->setFlashMessage(false, sprintf($this->trans('Quantity cannot exceed the maximum allowed value (%d).', [], 'Modules.Customstocktransfer.Admin'), $maxLimit));
                $this->redirectToDashboard();
                return false;
            }

            StockAvailable::setQuantity($idProduct, 0, $newQuantity, $this->context->shop->id);

            $this->setFlashMessage(true, $this->trans('Stock quantity updated successfully.', [], 'Modules.Customstocktransfer.Admin'));
            $this->redirectToDashboard();
            return false;
        }

        if (!Tools::isSubmit('submitCustomStockTransfer')) {
            return parent::postProcess();
        }

        $sourceShopId = (int) Tools::getValue('source_shop_id');
        $destinationShopId = (int) Tools::getValue('destination_shop_id');
        $bulkProductIds = Tools::getValue('bulk_product_ids');
        $bulkQuantities = Tools::getValue('bulk_quantities');

        if (!Validate::isUnsignedId($sourceShopId)) {
            $this->setFlashMessage(false, $this->trans('Please select a valid source store.', [], 'Modules.Customstocktransfer.Admin'));
            $this->redirectToDashboard();
            return false;
        }

        if (!Validate::isUnsignedId($destinationShopId)) {
            $this->setFlashMessage(false, $this->trans('Please select a valid destination store.', [], 'Modules.Customstocktransfer.Admin'));
            $this->redirectToDashboard();
            return false;
        }

        if ($sourceShopId === $destinationShopId) {
            $this->setFlashMessage(false, $this->trans('The source and destination stores must be different.', [], 'Modules.Customstocktransfer.Admin'));
            $this->redirectToDashboard();
            return false;
        }

        if (!is_array($bulkProductIds) || empty($bulkProductIds)) {
            $this->setFlashMessage(false, $this->trans('Please select at least one product to transfer.', [], 'Modules.Customstocktransfer.Admin'));
            $this->redirectToDashboard();
            return false;
        }

        $availableShopIds = array_map(static function (array $shop) {
            return (int) $shop['id_shop'];
        }, Shop::getShops(true, null, false));

        if (!in_array($sourceShopId, $availableShopIds, true) || !in_array($destinationShopId, $availableShopIds, true)) {
            $this->setFlashMessage(false, $this->trans('The selected stores are not available.', [], 'Modules.Customstocktransfer.Admin'));
            $this->redirectToDashboard();
            return false;
        }

        $successCount = 0;
        $errorCount = 0;

        foreach ($bulkProductIds as $idProduct) {
            $idProduct = (int) $idProduct;
            $quantity = isset($bulkQuantities[$idProduct]) ? (int) $bulkQuantities[$idProduct] : 0;

            if ($quantity <= 0 || !$this->productExists($idProduct)) {
                $errorCount++;
                continue;
            }

            $currentSourceQuantity = (int) StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $sourceShopId);
            if ($currentSourceQuantity < $quantity) {
                $errorCount++;
                continue;
            }

            $currentDestinationQuantity = (int) StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $destinationShopId);

            StockAvailable::setQuantity($idProduct, 0, $currentSourceQuantity - $quantity, $sourceShopId);
            StockAvailable::setQuantity($idProduct, 0, $currentDestinationQuantity + $quantity, $destinationShopId);

            $successCount++;
        }

        if ($successCount > 0) {
            $message = sprintf($this->trans('Successfully transferred %d product(s).', [], 'Modules.Customstocktransfer.Admin'), $successCount);
            if ($errorCount > 0) {
                $message .= ' ' . sprintf($this->trans('Failed for %d product(s).', [], 'Modules.Customstocktransfer.Admin'), $errorCount);
            }
            $this->setFlashMessage(true, $message);
        } else {
            $this->setFlashMessage(false, $this->trans('Failed to transfer products. Check quantities and stock availability.', [], 'Modules.Customstocktransfer.Admin'));
        }

        $this->redirectToDashboard();
        return false;
    }

    public function initContent()
    {
        parent::initContent();

        $page = (int) Tools::getValue('page', 1);
        if ($page < 1) {
            $page = 1;
        }

        $limit = (int) Tools::getValue('limit', 0);
        if ($limit > 0) {
            $this->context->cookie->__set('customstocktransfer_limit', $limit);
            $this->context->cookie->write();
        } else {
            $limit = (int) $this->context->cookie->__get('customstocktransfer_limit');
        }

        if ($limit < 1) {
            $limit = 10;
        }

        $productSearch = trim(Tools::getValue('product_search', ''));

        $filter = [
            'category' => (int)Tools::getValue('filter_category'),
            'brand' => Tools::getValue('filter_brand') !== false && Tools::getValue('filter_brand') !== '' ? (int)Tools::getValue('filter_brand') : null,
            'status' => Tools::getValue('filter_status') !== false && Tools::getValue('filter_status') !== '' ? (int)Tools::getValue('filter_status') : null,
        ];

        $categories = Category::getSimpleCategories($this->context->language->id);
        $brands = Manufacturer::getManufacturers(false, $this->context->language->id, true);

        $shops = $this->getActiveShops();
        $totalProducts = $this->getTotalProductsCount($shops, $productSearch, $filter);
        $totalPages = (int) ceil($totalProducts / $limit);

        if ($page > $totalPages && $totalPages > 0) {
            $page = $totalPages;
        }

        $products = $this->getProductsDashboardData($shops, $page, $limit, $productSearch, $filter);

        $transferHistory = Db::getInstance()->executeS('SELECT * FROM `' . _DB_PREFIX_ . 'transfers`');
        if (!is_array($transferHistory)) {
            $transferHistory = [];
        }

        $this->applyFlashMessage();

        $this->context->smarty->assign([
            'product_search' => $productSearch,
            'filter' => $filter,
            'categories' => $categories,
            'brands' => $brands,
            'products' => $products,
            'shops' => $shops,
            'form_action' => $this->context->link->getAdminLink('AdminCustomStockTransfer'),
            'token' => Tools::getAdminTokenLite('AdminCustomStockTransfer'),
            'current_page' => $page,
            'limit' => $limit,
            'total_products' => $totalProducts,
            'total_pages' => $totalPages,
            'transfer_history' => $transferHistory,
        ]);

        $this->setTemplate('transfer_dashboard.tpl');
    }

    protected function getActiveShops()
    {
        $shops = [];

        foreach (Shop::getShops(true, null, false) as $shop) {
            $shops[] = [
                'id_shop' => (int) $shop['id_shop'],
                'shop_name' => (string) $shop['name'],
            ];
        }

        return $shops;
    }

    protected function getTotalProductsCount(array $shops, $productSearch = '', $filter = [])
    {
        $idLang = (int) $this->context->language->id;
        $idShopForName = (int) $this->context->shop->id;

        if ($idShopForName <= 0 && !empty($shops)) {
            $idShopForName = (int) $shops[0]['id_shop'];
        }

        $query = new DbQuery();
        $query->select('COUNT(DISTINCT p.id_product)');
        $query->from('product', 'p');
        
        $statusCondition = ($filter['status'] !== null) ? ' AND ps.active = ' . (int)$filter['status'] : ' AND ps.active = 1';
        $query->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product' . $statusCondition);
        
        $query->innerJoin('product_lang', 'pl', 'pl.id_product = p.id_product AND pl.id_lang = ' . (int) $idLang . ' AND pl.id_shop = ' . (int) $idShopForName);

        if ($filter['category'] > 0) {
            $query->innerJoin('category_product', 'cp', 'cp.id_product = p.id_product');
            $query->where('cp.id_category = ' . (int)$filter['category']);
        }

        if ($filter['brand'] > 0) {
            $query->where('p.id_manufacturer = ' . (int)$filter['brand']);
        }

        if ($productSearch !== '') {
            $productSearchEscaped = pSQL($productSearch);
            $query->where('pl.name LIKE \'%'.$productSearchEscaped.'%\' OR p.reference LIKE \'%'.$productSearchEscaped.'%\'');
        }

        return (int) Db::getInstance()->getValue($query);
    }

    protected function getProductsDashboardData(array $shops, $page = 1, $limit = 20, $productSearch = '', $filter = [])
    {
        $products = [];
        $idLang = (int) $this->context->language->id;
        $idShopForName = (int) $this->context->shop->id;

        if ($idShopForName <= 0 && !empty($shops)) {
            $idShopForName = (int) $shops[0]['id_shop'];
        }

        $query = new DbQuery();
        $query->select('p.id_product, pl.name, pl.link_rewrite');
        $query->from('product', 'p');
        
        $statusCondition = ($filter['status'] !== null) ? ' AND ps.active = ' . (int)$filter['status'] : ' AND ps.active = 1';
        $query->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product' . $statusCondition);
        
        $query->innerJoin('product_lang', 'pl', 'pl.id_product = p.id_product AND pl.id_lang = ' . (int) $idLang . ' AND pl.id_shop = ' . (int) $idShopForName);

        if ($filter['category'] > 0) {
            $query->innerJoin('category_product', 'cp', 'cp.id_product = p.id_product');
            $query->where('cp.id_category = ' . (int)$filter['category']);
        }

        if ($filter['brand'] > 0) {
            $query->where('p.id_manufacturer = ' . (int)$filter['brand']);
        }

        if ($productSearch !== '') {
            $productSearchEscaped = pSQL($productSearch);
            $query->where('pl.name LIKE \'%'.$productSearchEscaped.'%\' OR p.reference LIKE \'%'.$productSearchEscaped.'%\'');
        }

        $query->groupBy('p.id_product, pl.name, pl.link_rewrite');
        $query->orderBy('pl.name ASC');

        $offset = (int) (($page - 1) * $limit);
        $query->limit((int) $limit, $offset);

        $rows = Db::getInstance()->executeS($query);

        foreach ($rows as $row) {
            $productId = (int) $row['id_product'];
            $shopBreakdown = [];
            $shopQuantities = [];
            $coverUrl = '';

            $cover = Image::getCover($productId);
                if (is_array($cover) && !empty($cover['id_image']) && !empty($row['link_rewrite'])) {
                $coverUrl = $this->context->link->getImageLink(
                    $row['link_rewrite'],
                    (int) $cover['id_image'],
                    'home_default'
                );
            }

            foreach ($shops as $shop) {
                $shopQuantity = (int) StockAvailable::getQuantityAvailableByProduct($productId, 0, (int) $shop['id_shop']);
                $shopQuantities[] = $shopQuantity;

                $shopBreakdown[] = [
                    'id_shop' => (int) $shop['id_shop'],
                    'shop_name' => $shop['shop_name'],
                    'quantity_in_this_shop' => $shopQuantity,
                    'badge_class' => $this->getStockBadgeClass($shopQuantity),
                ];
            }

            $totalStock = (int) array_sum($shopQuantities);
            $maxStock = !empty($shopQuantities) ? (int) max($shopQuantities) : 0;
            $minStock = !empty($shopQuantities) ? (int) min($shopQuantities) : 0;
            $stockDiff = (int) ($maxStock - $minStock);

            $products[] = [
                'id_product' => $productId,
                'name' => (string) $row['name'],
                'link_rewrite' => (string) $row['link_rewrite'],
                'cover_url' => $coverUrl,
                'total_stock' => $totalStock,
                'max_stock' => $maxStock,
                'min_stock' => $minStock,
                'stock_diff' => $stockDiff,
                'total_quantity' => $totalStock,
                'shops' => $shopBreakdown,
                'is_low_stock' => $totalStock < 5,
            ];
        }

        return $products;
    }

    protected function productExists($idProduct)
    {
        $sql = new DbQuery();
        $sql->select('p.id_product');
        $sql->from('product', 'p');
        $sql->innerJoin('product_shop', 'ps', 'ps.id_product = p.id_product AND ps.active = 1');
        $sql->where('p.id_product = ' . (int) $idProduct);

        return (bool) Db::getInstance()->getValue($sql);
    }

    protected function getStockBadgeClass($quantity)
    {
        if ((int) $quantity === 0) {
            return 'badge-danger';
        }

        if ((int) $quantity <= 5) {
            return 'badge-warning';
        }

        return 'badge-success';
    }

    protected function redirectToDashboard()
    {
        Tools::redirectAdmin($this->context->link->getAdminLink('AdminCustomStockTransfer'));
    }

    protected function setFlashMessage($isSuccess, $message)
    {
        $this->context->cookie->__set('customstocktransfer_success', (int) $isSuccess);
        $this->context->cookie->__set('customstocktransfer_message', (string) $message);
        $this->context->cookie->write();
    }

    protected function applyFlashMessage()
    {
        $message = (string) $this->context->cookie->__get('customstocktransfer_message');
        if ($message === '') {
            return;
        }

        $isSuccess = (int) $this->context->cookie->__get('customstocktransfer_success');
        if ($isSuccess === 1) {
            $this->confirmations[] = $message;
        } else {
            $this->errors[] = $message;
        }

        $this->context->cookie->__unset('customstocktransfer_success');
        $this->context->cookie->__unset('customstocktransfer_message');
        $this->context->cookie->write();
    }
}