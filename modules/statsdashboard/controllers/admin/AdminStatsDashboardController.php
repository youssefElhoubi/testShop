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

        // NEW: Capture dynamic limit, default to 20 if empty
        $selectedLimit = (int) Tools::getValue('filter_limit', 20);
        if ($selectedLimit < 1) $selectedLimit = 20;

        $page = (int) Tools::getValue('page', 1);
        if ($page < 1) $page = 1;

        // 2. Fetch drop-down data
        $brands = Manufacturer::getManufacturers(false, $this->context->language->id);
        $suppliers = Supplier::getSuppliers(false, $this->context->language->id);
        $years = $this->getAvailableYears();

        // 3. Pagination Logic (Count total products matching filters)
        $totalProducts = $this->getProductCount($selectedBrand, $selectedSupplier);
        // Use the dynamic $selectedLimit here
        $totalPages = ceil($totalProducts / $selectedLimit);

        // 4. Fetch the pivoted product list
        // Pass $selectedLimit instead of $limit
        $productsList = $this->getProductSalesList($selectedYear, $selectedBrand, $selectedSupplier, $page, $selectedLimit);

        if (Tools::isSubmit('export_csv')) {
            // We pass the list to our new export function and kill the script so HTML doesn't render
            $this->exportToCsv($productsList);
        }

        // 5. Assign to Smarty
        $this->context->smarty->assign([
            'productsList' => $productsList,
            'brands' => $brands,
            'suppliers' => $suppliers,
            'years' => $years,
            'selectedYear' => $selectedYear,
            'selectedBrand' => $selectedBrand,
            'selectedSupplier' => $selectedSupplier,
            'selectedLimit' => $selectedLimit, // NEW: Send limit to the view
            'page' => $page,
            'totalPages' => $totalPages,
            'form_url' => $this->context->link->getAdminLink('AdminStatsDashboard')
        ]);
        
        $this->setTemplate('dashboard.tpl');
    }

    /**
     * Executes the SQL query with a MONTHLY PIVOT, PAGINATION, and URL GENERATION.
     */
    private function getProductSalesList($year, $id_brand, $id_supplier, $page, $limit)
    {
        $id_lang = (int) $this->context->language->id;
        $id_shop = (int) $this->context->shop->id;
        $offset = ($page - 1) * $limit;

        $yearCondition = ($year > 0) ? ' AND YEAR(o.date_add) = ' . (int)$year : '';
        $orderCheck = 'o.id_order IS NOT NULL';

        $sql = 'SELECT 
                    p.id_product,
                    pl.name as product_name,
                    
                    /* NEW: Fetch the exact live stock right now from the database */
                    IFNULL((SELECT SUM(quantity) FROM ' . _DB_PREFIX_ . 'stock_available WHERE id_product = p.id_product), 0) as current_stock,
                    
                    /* Monthly Breakdown */
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 1 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as jan,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 2 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as feb,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 3 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as mar,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 4 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as apr,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 5 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as may,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 6 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as jun,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 7 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as jul,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 8 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as aug,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 9 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as sep,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 10 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as oct,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 11 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as nov,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' AND MONTH(o.date_add) = 12 ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as decem,
                    
                    /* Grand Totals */
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' ' . $yearCondition . ' THEN od.product_quantity ELSE 0 END), 0) as total_sold,
                    IFNULL(SUM(CASE WHEN ' . $orderCheck . ' ' . $yearCondition . ' THEN od.total_price_tax_excl ELSE 0 END), 0) as total_profit
                    
                FROM ' . _DB_PREFIX_ . 'product p
                LEFT JOIN ' . _DB_PREFIX_ . 'product_lang pl 
                    ON (p.id_product = pl.id_product AND pl.id_lang = ' . $id_lang . ' AND pl.id_shop = ' . $id_shop . ')
                LEFT JOIN ' . _DB_PREFIX_ . 'order_detail od 
                    ON p.id_product = od.product_id
                LEFT JOIN ' . _DB_PREFIX_ . 'orders o 
                    ON od.id_order = o.id_order
                WHERE 1 ';

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

        // Generate the clickable Admin link for each product
        if (is_array($result) && !empty($result)) {
            foreach ($result as &$row) {
                $row['product_link'] = $this->context->link->getAdminLink('AdminProducts', true, [
                    'id_product' => $row['id_product']
                ]);
            }
        }

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
        // Ask the DB for the oldest order year
        $sql = 'SELECT MIN(YEAR(date_add)) FROM ' . _DB_PREFIX_ . 'orders';
        $minYear = (int) Db::getInstance()->getValue($sql);
        $currentYear = (int) date('Y');

        // If the store is brand new and has no orders, default to this year
        if ($minYear === 0 || $minYear > $currentYear) {
            $minYear = $currentYear;
        }

        $years = [];
        // Build the array from today down to the oldest year
        for ($i = $currentYear; $i >= $minYear; $i--) {
            $years[] = $i;
        }
        return $years;
    }
    /**
     * Generates a CSV file and forces the browser to download it.
     */
    private function exportToCsv($data)
    {
        // 1. Clear any random HTML or empty spaces that might corrupt the file
        if (ob_get_level() && ob_get_length() > 0) {
            ob_clean();
        }

        // 2. Set headers to force Excel download
        header('Content-Type: text/csv; charset=utf-8');
        header('Content-Disposition: attachment; filename="Store_Stats_' . date('Y-m-d') . '.csv"');

        // 3. Open output stream
        $output = fopen('php://output', 'w');

        // 4. Add a UTF-8 BOM. This is a magic trick that forces Microsoft Excel to 
        // properly read special characters (like accents or symbols) instead of showing gibberish.
        fputs($output, chr(0xEF) . chr(0xBB) . chr(0xBF));

        // 5. Write the Column Headers
        // We use a semicolon (;) because Excel in European/African regions reads it better than a comma.
        fputcsv($output, [
            'Product Name', 
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', 
            'Live Stock', 
            'Total Qty', 
            'Total Profit (Tax Excl)'
        ], ';');

        // 6. Loop through the data and write each row
        if (!empty($data)) {
            foreach ($data as $row) {
                fputcsv($output, [
                    $row['product_name'],
                    $row['jan'], $row['feb'], $row['mar'], $row['apr'], 
                    $row['may'], $row['jun'], $row['jul'], $row['aug'], 
                    $row['sep'], $row['oct'], $row['nov'], $row['decem'],
                    $row['current_stock'],
                    $row['total_sold'],
                    // Round the profit to 2 decimals so Excel handles it as a clean number
                    round($row['total_profit'], 2) 
                ], ';');
            }
        }

        // 7. Close the file and kill the script so PrestaShop doesn't print HTML into our CSV
        fclose($output);
        exit;
    }
}
