<?php
class AdminStatsDashboardController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
    }

    public function initContent()
    {
        parent::initContent();

        // 1. Capture GET parameters (Filters). Notice we default to 0 (All Years) now.
        $selectedYear = (int) Tools::getValue('filter_year', 0);
        $selectedBrand = (int) Tools::getValue('filter_brand', 0);
        $selectedSupplier = (int) Tools::getValue('filter_supplier', 0);

        // 2. Fetch drop-down data for the UI
        $brands = Manufacturer::getManufacturers(false, $this->context->language->id);
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        $years = $this->getAvailableYears();

        // 3. Fetch the actual product list based on filters
        $productsList = $this->getProductSalesList($selectedYear, $selectedBrand, $selectedSupplier);

        // 4. Send variables to Smarty template
        $this->context->smarty->assign([
            'productsList' => $productsList,
            'brands' => $brands,
            'suppliers' => $suppliers,
            'years' => $years,
            'selectedYear' => $selectedYear,
            'selectedBrand' => $selectedBrand,
            'selectedSupplier' => $selectedSupplier,
            'form_url' => $this->context->link->getAdminLink('AdminStatsDashboard')
        ]);

        $this->setTemplate('dashboard.tpl');
    }

    /**
     * Executes the SQL query to get a list of products and their sales quantities.
     */
    private function getProductSalesList($year, $id_brand, $id_supplier)
    {
        $id_lang = (int) $this->context->language->id;
        $id_shop = (int) $this->context->shop->id;

        // We flipped the query to start FROM ps_product so all 19 products always show up
        $sql = 'SELECT 
                    p.id_product,
                    p.reference,
                    pl.name as product_name,
                    IFNULL(YEAR(o.date_add), "--") as sales_year,
                    IFNULL(SUM(od.product_quantity), 0) as total_sold
                FROM ' . _DB_PREFIX_ . 'product p
                LEFT JOIN ' . _DB_PREFIX_ . 'product_lang pl 
                    ON (p.id_product = pl.id_product AND pl.id_lang = ' . $id_lang . ' AND pl.id_shop = ' . $id_shop . ')
                LEFT JOIN ' . _DB_PREFIX_ . 'order_detail od 
                    ON p.id_product = od.product_id
                LEFT JOIN ' . _DB_PREFIX_ . 'orders o 
                    ON (o.id_order = od.id_order AND o.valid = 1'; 
                    // o.valid = 1 means the order payment was accepted.

        // We put the year filter INSIDE the join condition. 
        // If we put it in the WHERE clause, it would hide products with 0 sales.
        if ($year > 0) {
            $sql .= ' AND YEAR(o.date_add) = ' . (int)$year;
        }
        $sql .= ') WHERE 1 ';

        // Product-specific filters go in the standard WHERE clause
        if ($id_brand > 0) {
            $sql .= ' AND p.id_manufacturer = ' . (int)$id_brand;
        }
        if ($id_supplier > 0) {
            $sql .= ' AND p.id_supplier = ' . (int)$id_supplier;
        }

        // Group by product and year
        $sql .= ' GROUP BY p.id_product, sales_year';
        // Order by highest sellers first, then by ID so the list stays organized
        $sql .= ' ORDER BY total_sold DESC, p.id_product ASC';

        $result = Db::getInstance()->executeS($sql);

        return $result ? $result : [];
    }

    /**
     * Executes the SQL query to get revenue and items sold.
     */
    private function getFilteredStats($year, $id_brand, $id_supplier)
    {
        $sql = 'SELECT 
                    COUNT(DISTINCT o.id_order) as total_orders,
                    SUM(od.product_quantity) as total_items_sold,
                    SUM(od.total_price_tax_excl) as total_revenue
                FROM ' . _DB_PREFIX_ . 'order_detail od
                LEFT JOIN ' . _DB_PREFIX_ . 'orders o ON o.id_order = od.id_order
                LEFT JOIN ' . _DB_PREFIX_ . 'product p ON p.id_product = od.product_id
                WHERE o.valid = 1 '; // valid = 1 means the order was paid/successful

        if ($year) {
            $sql .= ' AND YEAR(o.date_add) = ' . (int)$year;
        }
        if ($id_brand > 0) {
            $sql .= ' AND p.id_manufacturer = ' . (int)$id_brand;
        }
        if ($id_supplier > 0) {
            $sql .= ' AND p.id_supplier = ' . (int)$id_supplier;
        }

        $result = Db::getInstance()->getRow($sql);

        // Prevent null values if no sales occurred
        return [
            'total_orders' => $result['total_orders'] ?? 0,
            'total_items_sold' => $result['total_items_sold'] ?? 0,
            'total_revenue' => $result['total_revenue'] ?? 0.00
        ];
    }

    /**
     * Helper to populate the Year dropdown.
     */
    private function getAvailableYears()
    {
        $currentYear = (int) date('Y');
        $years = [];
        for ($i = $currentYear; $i >= $currentYear - 5; $i--) {
            $years[] = $i;
        }
        return $years;
    }
}
