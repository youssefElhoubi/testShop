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

        // 1. Capture GET parameters (Filters)
        $selectedYear = Tools::getValue('filter_year', date('Y'));
        $selectedBrand = (int) Tools::getValue('filter_brand', 0);
        $selectedSupplier = (int) Tools::getValue('filter_supplier', 0);

        // 2. Fetch drop-down data for the UI
        $brands = Manufacturer::getManufacturers(false, $this->context->language->id);
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        $years = $this->getAvailableYears();

        // 3. Fetch the actual stats based on filters
        $stats = $this->getFilteredStats($selectedYear, $selectedBrand, $selectedSupplier);

        // 4. Send variables to Smarty template
        $this->context->smarty->assign([
            'stats' => $stats,
            'brands' => $brands,
            'suppliers' => $suppliers,
            'years' => $years,
            'selectedYear' => $selectedYear,
            'selectedBrand' => $selectedBrand,
            'selectedSupplier' => $selectedSupplier,
            // Generate the form submission URL
            'form_url' => $this->context->link->getAdminLink('AdminStatsDashboard')
        ]);

        $this->setTemplate('dashboard.tpl');
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
                LEFT JOIN ' . _DB_PREFIX_ . 'product p ON p.id_product = od.id_product
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