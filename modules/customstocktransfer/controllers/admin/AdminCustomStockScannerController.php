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
        $this->addJS($this->module->getPathUri() . 'views/js/scanner.js');
    }

    public function initContent()
    {
        $this->setTemplate('scanner_dashboard.tpl');
        parent::initContent();
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
        
        if (!Validate::isLoadedObject($product)) {
            die(json_encode([
                'success' => false,
                'message' => 'Invalid product.'
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

        // Get the current stock quantity
        $stock = StockAvailable::getQuantityAvailableByProduct($id_product, $id_product_attribute);

        die(json_encode([
            'success' => true,
            'id_product' => $id_product,
            'id_product_attribute' => $id_product_attribute,
            'name' => $productName,
            'stock' => $stock,
            'image_url' => $imageUrl
        ]));
    }
}
