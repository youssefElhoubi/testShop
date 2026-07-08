    <?php

    if (!defined('_PS_VERSION_')) {
        exit;
    }

    require_once dirname(__FILE__) . '/../../classes/StockTransfer.php';

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
            $this->context->controller->addJS('https://cdn.jsdelivr.net/npm/jsbarcode@3.11.5/dist/JsBarcode.all.min.js', false);
            $this->addCSS($baseUri . 'views/css/transfer.css');
            $this->addJS($baseUri . 'views/js/transfer.js');
        }

        public function postProcess()
        {
            return parent::postProcess();
        }

        public function ajaxProcessConfirmCart(){
            $sourceStoreId = (int) Tools::getValue('source_shop_id');
            $destStoreId = (int) Tools::getValue('destination_shop_id');
            $cartItems = Tools::getValue('cart_items');

            if (!$sourceStoreId || !$destStoreId) {
                die(json_encode(['success' => false, 'message' => 'Invalid stores selected.']));
            }

            if (!is_array($cartItems) || empty($cartItems)) {
                die(json_encode(['success' => false, 'message' => 'Cart is empty.']));
            }

            Db::getInstance()->execute('START TRANSACTION');

            try {
                $barcode = 'TRF-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -4));
                
                $resHeader = Db::getInstance()->insert('transfers', [
                    'id_store_from' => $sourceStoreId,
                    'id_store_to' => $destStoreId,
                    'barcode' => pSQL($barcode),
                    'status' => 'pending',
                    'date_add' => date('Y-m-d H:i:s'),
                    'date_upd' => date('Y-m-d H:i:s'),
                ]);

                if (!$resHeader) {
                    throw new Exception('Failed to insert transfer header.');
                }

                $idTransfer = (int) Db::getInstance()->Insert_ID();

                foreach ($cartItems as $item) {
                    if (!isset($item['id_product']) || empty($item['id_product'])) {
                        continue; // Or log an error, but don't try to query a missing index
                    }

                    $idProduct = (int) $item['id_product'];
                    $idProductAttribute = isset($item['id_product_attribute']) ? (int) $item['id_product_attribute'] : 0;
                    $quantity = (int) $item['qty'];

                    if ($quantity <= 0) continue;

                    $resDetail = Db::getInstance()->insert('transfer_details', [
                        'id_transfer' => $idTransfer,
                        'id_product' => $idProduct,
                        'id_product_attribute' => $idProductAttribute,
                        'quantity' => $quantity
                    ]);

                    if (!$resDetail) {
                        throw new Exception('Failed to insert transfer detail for product ' . $idProduct);
                    }
                }

                Db::getInstance()->execute('COMMIT');
                
                // Send email notification to admin
                $adminEmail = Configuration::get('PS_SHOP_EMAIL');
                if ($adminEmail) {
                    Mail::Send(
                        (int) $this->context->language->id,
                        'transfer_request',
                        $this->trans('New Stock Transfer Request Pending Approval', [], 'Modules.Customstocktransfer.Admin'),
                        [
                            '{product_id}'  => 'Multiple Products',
                            '{quantity}'    => count($cartItems),
                            '{store_from}'  => $sourceStoreId,
                            '{store_to}'    => $destStoreId,
                        ],
                        $adminEmail,
                        null, null, null, null, null,
                        _PS_MODULE_DIR_ . $this->module->name . '/mails/'
                    );
                }

                die(json_encode(['success' => true]));

            } catch (Exception $e) {
                Db::getInstance()->execute('ROLLBACK');
                die(json_encode(['success' => false, 'message' => $e->getMessage()]));
            }
        }

        public function ajaxProcessScanBarcode()
        {
            $barcode = pSQL(trim(Tools::getValue('barcode')));
            $idLang = (int) $this->context->language->id;
            $sourceStoreId = (int) Tools::getValue('source_shop_id', 0);

            if (empty($barcode)) {
                die(json_encode(['success' => false, 'message' => 'Barcode is empty.']));
            }

            // Search product table first
            $sql = 'SELECT p.id_product, 0 AS id_product_attribute, pl.name, p.ean13
                    FROM `' . _DB_PREFIX_ . 'product` p
                    LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON (p.id_product = pl.id_product AND pl.id_lang = ' . $idLang . ')
                    WHERE p.ean13 = \'' . $barcode . '\'';
            
            $product = Db::getInstance()->getRow($sql);

            // If not found in product, search product_attribute
            if (!$product) {
                $sqlAttr = 'SELECT pa.id_product, pa.id_product_attribute, pl.name, pa.ean13
                            FROM `' . _DB_PREFIX_ . 'product_attribute` pa
                            LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON (pa.id_product = pl.id_product AND pl.id_lang = ' . $idLang . ')
                            WHERE pa.ean13 = \'' . $barcode . '\'';
                $product = Db::getInstance()->getRow($sqlAttr);
            }

            if ($product) {
                $maxQty = StockAvailable::getQuantityAvailableByProduct((int)$product['id_product'], (int)$product['id_product_attribute'], $sourceStoreId);

                die(json_encode([
                    'success' => true,
                    'product' => [
                        'id_product' => (int)$product['id_product'],
                        'id_product_attribute' => (int)$product['id_product_attribute'],
                        'name' => $product['name'],
                        'max_qty' => (int)$maxQty
                    ]
                ]));
            } else {
                die(json_encode(['success' => false, 'message' => 'Product not found for this barcode.']));
            }
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
                $query->where('pl.name LIKE \'%' . $productSearchEscaped . '%\' OR p.reference LIKE \'%' . $productSearchEscaped . '%\'');
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
            $query->select('p.id_product, pl.name, pl.link_rewrite, p.ean13');
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
                $query->where('pl.name LIKE \'%' . $productSearchEscaped . '%\' OR p.reference LIKE \'%' . $productSearchEscaped . '%\'');
            }

            $query->groupBy('p.id_product, pl.name, pl.link_rewrite, p.ean13');
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
                    'ean13' => (string) $row['ean13'],
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
