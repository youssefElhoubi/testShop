<?php

class CustomcatalogControllerCore extends FrontController
{


    public function setMedia()
    {
        parent::setMedia();
        $this->registerStylesheet('customcatalog-style', 'assets/css/custom_catalog.css');
        $this->registerJavascript('customcatalog-script', 'assets/js/custom_catalog.js', ['position' => 'bottom']);
    }
    public function initContent()
    {
        parent::initContent();

        $context = Context::getContext();
        $id_lang = (int)$context->language->id;
        $id_shop = (int)$context->shop->id;

        // 1. Get the clicked category ID from the URL (default to 0 if none clicked)
        $selected_category = (int)Tools::getValue('id_category', 0);

        // 2. Fetch all active categories for your custom navigation bar
        $categories_query = new DbQuery();
        $categories_query->select('c.id_category, cl.name');
        $categories_query->from('category', 'c');
        $categories_query->innerJoin('category_lang', 'cl', 'c.id_category = cl.id_category AND cl.id_lang = ' . $id_lang . ' AND cl.id_shop = ' . $id_shop);
        $categories_query->where('c.active = 1 AND c.id_parent > 0'); // Exclude root system category
        $categories_query->orderBy('c.level_depth ASC, cl.name ASC');

        $categories = Db::getInstance()->executeS($categories_query);

        // 3. Fetch products (filtered by category if one is selected)
        $product_query = new DbQuery();

        // ADDED: pl.link_rewrite and i.id_image
        $product_query->select('p.id_product, p.reference, pl.name AS product_name, pl.link_rewrite, cl.name AS category_name, i.id_image');
        $product_query->from('product', 'p');
        $product_query->innerJoin('product_shop', 'ps', 'p.id_product = ps.id_product AND ps.id_shop = ' . $id_shop);
        $product_query->leftJoin('product_lang', 'pl', 'p.id_product = pl.id_product AND pl.id_lang = ' . $id_lang . ' AND pl.id_shop = ' . $id_shop);

        // ADDED: Join the image table to get the default (cover) image
        $product_query->leftJoin('image', 'i', 'p.id_product = i.id_product AND i.cover = 1');

        $product_query->leftJoin('category_product', 'cp', 'p.id_product = cp.id_product');
        $product_query->leftJoin('category_lang', 'cl', 'cp.id_category = cl.id_category AND cl.id_lang = ' . $id_lang . ' AND cl.id_shop = ' . $id_shop);

        if ($selected_category > 0) {
            $product_query->where('cp.id_category = ' . $selected_category);
        }

        $product_query->groupBy('p.id_product');
        $product_query->orderBy('p.id_product ASC');

        $products = Db::getInstance()->executeS($product_query);

        // ADDED: Loop through the products and generate the proper image URL for each one
        $link = $context->link;
        foreach ($products as &$product) {
            if (!empty($product['id_image'])) {
                // 'home_default' is the standard image size for PrestaShop grids. 
                // You can change this to 'large_default' if they look too small.
                $product['product_url'] = $link->getProductLink((int)$product['id_product']);
                $product['price'] = Tools::displayPrice(Product::getPriceStatic((int)$product['id_product']));
                $image_ids = $product['id_product'] . '-' . $product['id_image'];
                $product['image_url'] = $link->getImageLink($product['link_rewrite'], $image_ids, 'home_default');
            } else {
                // Fallback if the product has no image uploaded
                $product['image_url'] = '';
            }
        }

        // 4. Send everything to Smarty
        $this->context->smarty->assign([
            'custom_categories' => $categories,
            'custom_products'   => $products,
            'current_category'  => $selected_category,
            // PrestaShop helper link generator for building clean URLs
            'controller_url'    => $context->link->getPageLink('customcatalog')
        ]);

        $this->setTemplate('custom_catalog');
    }
}
