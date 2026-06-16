<?php

class CmsController extends CmsControllerCore
{
    public function initContent()
    {
        // 1. Run the normal CMS page loading logic
        parent::initContent();

        // 2. Check if the user is looking at your specific custom page
        // REPLACE '6' WITH YOUR ACTUAL PAGE ID FROM STEP 1
        if (isset($this->cms->id) && $this->cms->id == 6) {
            
            // Fetch the products just like we did before
            $id_lang = (int)$this->context->language->id;
            $products = Product::getProducts($id_lang, 0, 10, 'id_product', 'DESC');

            // Inject the data into the template
            $this->context->smarty->assign([
                'my_dynamic_products' => $products
            ]);
        }
    }
}