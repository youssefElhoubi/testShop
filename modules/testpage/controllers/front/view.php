<?php

class TestpageViewModuleFrontController extends ModuleFrontController {
    public function initContent (){
        // die("BINGO! THE FILE IS RUNNING!");
        parent::initContent();

        $id_lang = (int)$this->context->language->id;
        $products = Product::getProducts($id_lang, 0, 10, 'id_product', 'DESC');

        $this->context->smarty->assign([
            'latest_products' => $products
        ]);

        // Keep the template name as latest.tpl, that part is fine
        $this->setTemplate('module:testpage/views/templates/front/latest.tpl');
    }
}