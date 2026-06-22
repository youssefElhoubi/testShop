<?php
class AdminStatsDashboardController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
    }
    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);
        
        // This registers and loads our custom CSS file
        $this->addCSS($this->module->getPathUri() . 'views/css/admin_dashboard.css');
    }

    public function initContent()
    {
        parent::initContent();

        // 1. Capture Filters & Pagination
        $selectedYear = (int) Tools::getValue('filter_year', 0);
        $selectedBrand = (int) Tools::getValue('filter_brand', 0);
        $selectedSupplier = (int) Tools::getValue('filter_supplier', 0);
        
        $page = (int) Tools::getValue('page', 1);
        if ($page < 1) $page = 1;
        $limit = 20;

        // 2. Fetch drop-down data
        $brands = Manufacturer::getManufacturers(false, $this->context->language->id);
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        $years = $this->getAvailableYears();

        // 3. Pagination Logic (Count total products matching filters)
        $totalProducts = $this->getProductCount($selectedBrand, $selectedSupplier);
        $totalPages = ceil($totalProducts / $limit);

        // 4. Fetch the pivoted product list
        $productsList = $this->getProductSalesList($selectedYear, $selectedBrand, $selectedSupplier, $page, $limit);

        // 5. Assign to Smarty
        $this->context->smarty->assign([
            'productsList' => $productsList,
            'brands' => $brands,
            'suppliers' => $suppliers,
            'years' => $years,
            'selectedYear' => $selectedYear,
            'selectedBrand' => $selectedBrand,
            'selectedSupplier' => $selectedSupplier,
            'page' => $page,
            'totalPages' => $totalPages,
            'form_url' => $this->context->link->getAdminLink('AdminStatsDashboard')
        ]);

        $this->setTemplate('dashboard.tpl');
    }

    /**
     * Executes the SQL query with a MONTHLY PIVOT and PAGINATION.
     */
    private function getProductSalesList($year, $id_brand, $id_supplier, $page, $limit)
    {
        $id_lang = (int) $this->context->language->id;
        $id_shop = (int) $this->context->shop->id;
        $offset = ($page - 1) * $limit;

        // The CASE WHEN statements act as a Pivot Table, turning rows of dates into Monthly columns
        $sql = 'SELECT 
                    pl.name as product_name,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 1 THEN od.product_quantity ELSE 0 END), 0) as jan,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 2 THEN od.product_quantity ELSE 0 END), 0) as feb,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 3 THEN od.product_quantity ELSE 0 END), 0) as mar,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 4 THEN od.product_quantity ELSE 0 END), 0) as apr,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 5 THEN od.product_quantity ELSE 0 END), 0) as may,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 6 THEN od.product_quantity ELSE 0 END), 0) as jun,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 7 THEN od.product_quantity ELSE 0 END), 0) as jul,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 8 THEN od.product_quantity ELSE 0 END), 0) as aug,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 9 THEN od.product_quantity ELSE 0 END), 0) as sep,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 10 THEN od.product_quantity ELSE 0 END), 0) as oct,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 11 THEN od.product_quantity ELSE 0 END), 0) as nov,
                    IFNULL(SUM(CASE WHEN MONTH(o.date_add) = 12 THEN od.product_quantity ELSE 0 END), 0) as decem,
                    IFNULL(SUM(od.product_quantity), 0) as total_sold,
                    IFNULL(SUM(od.total_price_tax_excl), 0) as total_profit
                FROM ' . _DB_PREFIX_ . 'product p
                LEFT JOIN ' . _DB_PREFIX_ . 'product_lang pl 
                    ON (p.id_product = pl.id_product AND pl.id_lang = ' . $id_lang . ' AND pl.id_shop = ' . $id_shop . ')
                LEFT JOIN ' . _DB_PREFIX_ . 'order_detail od 
                    ON p.id_product = od.product_id
                LEFT JOIN ' . _DB_PREFIX_ . 'orders o 
                    ON (o.id_order = od.id_order AND o.valid = 1'; 

        if ($year > 0) {
            $sql .= ' AND YEAR(o.date_add) = ' . (int)$year;
        }
        $sql .= ') WHERE 1 ';

        if ($id_brand > 0) {
            $sql .= ' AND p.id_manufacturer = ' . (int)$id_brand;
        }
        if ($id_supplier > 0) {
            $sql .= ' AND p.id_supplier = ' . (int)$id_supplier;
        }

        $sql .= ' GROUP BY p.id_product';
        $sql .= ' ORDER BY total_sold DESC, p.id_product ASC';
        $sql .= ' LIMIT ' . (int)$limit . ' OFFSET ' . (int)$offset;

        $result = Db::getInstance()->executeS($sql);
        return $result ? $result : [];
    }

    /**
     * Gets the total number of products for the pagination math.
     */
    private function getProductCount($id_brand, $id_supplier)
    {
        $sql = 'SELECT COUNT(DISTINCT p.id_product) FROM ' . _DB_PREFIX_ . 'product p WHERE 1 ';
        if ($id_brand > 0) {
            $sql .= ' AND p.id_manufacturer = ' . (int)$id_brand;
        }
        if ($id_supplier > 0) {
            $sql .= ' AND p.id_supplier = ' . (int)$id_supplier;
        }
        return (int) Db::getInstance()->getValue($sql);
    }

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