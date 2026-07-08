<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class AdminCustomStockStatsController extends ModuleAdminController
{
    public function __construct()
    {
        $this->bootstrap = true;
        parent::__construct();
    }

    public function setMedia($isNewTheme = false)
    {
        parent::setMedia($isNewTheme);

        $this->context->controller->addJS('https://cdn.jsdelivr.net/npm/chart.js');
        $this->context->controller->addCSS(_MODULE_DIR_ . 'customstocktransfer/views/css/stats.css');
        $this->context->controller->addJS(_MODULE_DIR_ . 'customstocktransfer/views/js/stats.js');
    }

    public function initContent()
    {
        parent::initContent();

        $totalTransferVolume = (int) Db::getInstance()->getValue('SELECT COUNT(id_transfer) FROM `' . _DB_PREFIX_ . 'transfers`');
        
        $totalItemsMoved = (int) Db::getInstance()->getValue('SELECT SUM(quantity) FROM `' . _DB_PREFIX_ . 'transfer_details`');
        
        $statusBreakdown = array(
            'pending' => 0,
            'approved' => 0,
            'completed' => 0,
            'declined' => 0
        );
        $statusResults = Db::getInstance()->executeS('SELECT status, COUNT(id_transfer) as count FROM `' . _DB_PREFIX_ . 'transfers` GROUP BY status');
        
        if ($statusResults) {
            foreach ($statusResults as $row) {
                if (isset($statusBreakdown[$row['status']])) {
                    $statusBreakdown[$row['status']] = (int) $row['count'];
                }
            }
        }

        // Fetch Trends Data (last 30 days)
        $trendsQuery = '
            SELECT DATE(date_add) as transfer_date, COUNT(id_transfer) as count 
            FROM `' . _DB_PREFIX_ . 'transfers` 
            WHERE date_add >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
            GROUP BY DATE(date_add) 
            ORDER BY DATE(date_add) ASC
        ';
        $trendsResults = Db::getInstance()->executeS($trendsQuery);
        $trendsData = [];
        if ($trendsResults) {
            foreach ($trendsResults as $row) {
                $trendsData[] = [
                    'date' => $row['transfer_date'],
                    'count' => (int) $row['count']
                ];
            }
        }

        // Fetch Top 5 Transferred Products
        $idLang = (int) $this->context->language->id;
        $idShop = (int) $this->context->shop->id;
        $topProductsQuery = '
            SELECT td.id_product, SUM(td.quantity) AS total_qty, pl.name 
            FROM `' . _DB_PREFIX_ . 'transfer_details` td
            LEFT JOIN `' . _DB_PREFIX_ . 'product_lang` pl ON (td.id_product = pl.id_product AND pl.id_lang = ' . $idLang . ' AND pl.id_shop = ' . $idShop . ')
            GROUP BY td.id_product 
            ORDER BY total_qty DESC 
            LIMIT 5
        ';
        $topProductsResults = Db::getInstance()->executeS($topProductsQuery);
        $topProductsData = [];
        if ($topProductsResults) {
            foreach ($topProductsResults as $row) {
                $topProductsData[] = [
                    'id_product' => (int) $row['id_product'],
                    'name' => $row['name'] ? $row['name'] : 'Product ID ' . $row['id_product'],
                    'total_qty' => (int) $row['total_qty']
                ];
            }
        }

        // Fetch Store Activity (Sent vs Received)
        $storeActivityData = [];
        $transfersForStores = Db::getInstance()->executeS('SELECT id_store_from, id_store_to FROM `' . _DB_PREFIX_ . 'transfers`');
        if ($transfersForStores) {
            foreach ($transfersForStores as $t) {
                $from = (int) $t['id_store_from'];
                $to = (int) $t['id_store_to'];
                
                if (!isset($storeActivityData[$from])) {
                    $storeActivityData[$from] = ['id_shop' => $from, 'name' => 'Store ' . $from, 'sent' => 0, 'received' => 0];
                }
                if (!isset($storeActivityData[$to])) {
                    $storeActivityData[$to] = ['id_shop' => $to, 'name' => 'Store ' . $to, 'sent' => 0, 'received' => 0];
                }
                
                $storeActivityData[$from]['sent']++;
                $storeActivityData[$to]['received']++;
            }
        }
        
        foreach (Shop::getShops(true, null, false) as $shop) {
            $id_shop = (int) $shop['id_shop'];
            if (isset($storeActivityData[$id_shop])) {
                $storeActivityData[$id_shop]['name'] = $shop['name'];
            }
        }
        $storeActivityData = array_values($storeActivityData);


        $this->context->smarty->assign(array(
            'page_title' => 'Transfer Statistics',
            'total_transfer_volume' => $totalTransferVolume,
            'total_items_moved' => $totalItemsMoved,
            'status_breakdown_json' => json_encode($statusBreakdown),
            'trends_data_json' => json_encode($trendsData),
            'top_products_json' => json_encode($topProductsData),
            'store_activity_json' => json_encode($storeActivityData)
        ));

        $this->setTemplate('stats_dashboard.tpl');
    }
}
