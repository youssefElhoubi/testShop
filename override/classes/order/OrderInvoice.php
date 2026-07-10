<?php
/**
 * Override of OrderInvoice class to inject live stock data.
 */
class OrderInvoice extends OrderInvoiceCore
{
    /**
     * Get order products and append live stock information.
     *
     * @param bool|array $products
     * @param bool|array $selected_products
     * @param bool|array $selected_qty
     * @return array Products with price, quantity, and live stock data
     */
    public function getProducts($products = false, $selected_products = false, $selected_qty = false)
    {
        // Get the standard products array from the core class
        $products_result = parent::getProducts($products, $selected_products, $selected_qty);

        // Iterate over products to append stock data
        foreach ($products_result as &$product) {
            $id_product = (int)$product['product_id'];
            $id_product_attribute = (int)$product['product_attribute_id'];
            
            // Get Shop ID, fallback to context shop if not available in order detail
            $id_shop = isset($product['id_shop']) ? (int)$product['id_shop'] : (int)Context::getContext()->shop->id;

            // 1. Get Live "In Stock" quantity
            $current_stock_live = StockAvailable::getQuantityAvailableByProduct(
                $id_product,
                $id_product_attribute,
                $id_shop
            );

            // 2. Get Live "Reserved" quantity
            $reserved_stock_live = 0;
            
            // Query the stock_available table directly to ensure we get the exact reserved stock
            $sql = new DbQuery();
            $sql->select('reserved_quantity');
            $sql->from('stock_available');
            $sql->where('id_product = ' . (int)$id_product);
            $sql->where('id_product_attribute = ' . (int)$id_product_attribute);
            $sql->where('id_shop = ' . (int)$id_shop);
            
            $reserved_qty_result = Db::getInstance()->getValue($sql);
            
            if ($reserved_qty_result !== false) {
                $reserved_stock_live = (int)$reserved_qty_result;
            }

            // Append the values to the product array so they can be used in Smarty
            $product['current_stock_live'] = (int)$current_stock_live;
            $product['reserved_stock_live'] = (int)$reserved_stock_live;
        }

        return $products_result;
    }
}
