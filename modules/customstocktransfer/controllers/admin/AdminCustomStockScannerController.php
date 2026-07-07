<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminCustomStockScannerController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);

        $this->addCSS($this->module->getPathUri() . 'views/css/transfer.css');
        $this->context->controller->addCSS(_MODULE_DIR_ . $this->module->name . '/views/css/scanner.css');
        
        // Inject SweetAlert2
        $this->addJS('https://cdn.jsdelivr.net/npm/sweetalert2@11');
        
        $this->addJS($this->module->getPathUri() . 'views/js/scanner.js');
    }

    public function initContent()
    {
        parent::initContent();

        $shops = $this->getActiveShops();

        $this->context->smarty->assign([
            'shops' => $shops
        ]);

        $this->setTemplate('scanner_dashboard.tpl');
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

    public function ajaxProcessScanBarcode()
    {
        $barcode = Tools::getValue('barcode');

        if (empty($barcode)) {
            die(json_encode([
                'success' => false,
                'message' => 'Barcode is required.'
            ]));
        }

        if (!Validate::isEan13($barcode)) {
            die(json_encode([
                'success' => false,
                'message' => 'Invalid barcode format.'
            ]));
        }

        $id_product = 0;
        $id_product_attribute = 0;

        // Try to find product by ean13 in product_attribute first (combinations)
        $sql = new DbQuery();
        $sql->select('id_product, id_product_attribute');
        $sql->from('product_attribute');
        $sql->where('ean13 = \'' . pSQL($barcode) . '\'');

        $result = Db::getInstance()->getRow($sql);

        if ($result) {
            $id_product = (int)$result['id_product'];
            $id_product_attribute = (int)$result['id_product_attribute'];
        } else {
            // Try to find product by ean13 in product (no combinations)
            $sql = new DbQuery();
            $sql->select('id_product');
            $sql->from('product');
            $sql->where('ean13 = \'' . pSQL($barcode) . '\'');

            $id_product = (int)Db::getInstance()->getValue($sql);
        }

        if (!$id_product) {
            die(json_encode([
                'success' => false,
                'message' => 'Product not found.'
            ]));
        }

        $product = new Product($id_product, false, $this->context->language->id);
        
        if (!Validate::isLoadedObject($product) || !$product->active) {
            die(json_encode([
                'success' => false,
                'message' => 'Invalid or inactive product.'
            ]));
        }

        // Get the current stock quantity immediately to fail fast
        $stock = StockAvailable::getQuantityAvailableByProduct($id_product, $id_product_attribute);

        if ($stock <= 0) {
            die(json_encode([
                'success' => false,
                'message' => 'Product is out of stock.'
            ]));
        }

        $productName = $product->name;
        if ($id_product_attribute > 0) {
            $combinationName = Product::getProductName($id_product, $id_product_attribute, $this->context->language->id);
            if ($combinationName) {
                $productName = $combinationName;
            }
        }

        // Get the Image
        $imageId = false;
        
        // Try attribute image first
        if ($id_product_attribute > 0) {
            $imageId = (int)Db::getInstance()->getValue(
                'SELECT id_image FROM ' . _DB_PREFIX_ . 'product_attribute_image WHERE id_product_attribute = ' . (int)$id_product_attribute
            );
        }
        
        // Fallback to cover
        if (!$imageId) {
            $cover = Image::getCover($id_product);
            if (is_array($cover) && isset($cover['id_image'])) {
                $imageId = (int)$cover['id_image'];
            }
        }
        
        $imageUrl = '';
        if ($imageId) {
            $link_rewrite = is_array($product->link_rewrite) ? $product->link_rewrite : '';
            if (empty($link_rewrite)) {
                $link_rewrite = 'product';
            }
            $imageUrl = $this->context->link->getImageLink($link_rewrite, $imageId, 'small_default');
            
            if (strpos($imageUrl, 'http') !== 0) {
                $imageUrl = $this->context->link->protocol_content . ltrim($imageUrl, '/');
            }
        }

        die(json_encode([
            'success' => true,
            'product' => [
                'id_product' => $id_product,
                'id_product_attribute' => $id_product_attribute,
                'name' => $productName,
                'stock' => $stock,
                'image_url' => $imageUrl,
                'barcode' => $barcode
            ]
        ]));
    }

    public function ajaxProcessSubmitTransfer(){
        $idWarehouseFrom = (int) Tools::getValue('id_warehouse_from');
        $idWarehouseTo = (int) Tools::getValue('id_warehouse_to');
        $cartDataRaw = Tools::getValue('cartData');
        $cartItems = json_decode($cartDataRaw, true);

        if (!$idWarehouseFrom || !$idWarehouseTo || $idWarehouseFrom === $idWarehouseTo) {
            die(json_encode(['success' => false, 'message' => 'Invalid source or destination store.']));
        }

        if (!is_array($cartItems) || empty($cartItems)) {
            die(json_encode(['success' => false, 'message' => 'Cart is empty.']));
        }

        Db::getInstance()->execute('START TRANSACTION');

        try {
            $barcode = 'TRF-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -4));
            
            $resHeader = Db::getInstance()->insert('transfers', [
                'id_store_from' => $idWarehouseFrom,
                'id_store_to' => $idWarehouseTo,
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
                        '{store_from}'  => $idWarehouseFrom,
                        '{store_to}'    => $idWarehouseTo,
                    ],
                    $adminEmail,
                    null, null, null, null, null,
                    _PS_MODULE_DIR_ . $this->module->name . '/mails/'
                );
            }

            die(json_encode([
                'success' => true,
                'message' => 'Stock transfer completed and recorded successfully.'
            ]));

        } catch (Exception $e) {
            Db::getInstance()->execute('ROLLBACK');
            die(json_encode(['success' => false, 'message' => $e->getMessage()]));
        }
    }
}
