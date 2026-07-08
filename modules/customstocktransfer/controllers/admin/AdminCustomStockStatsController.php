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

        $this->context->smarty->assign(array(
            'page_title' => 'Transfer Statistics',
            'total_transfer_volume' => $totalTransferVolume,
            'total_items_moved' => $totalItemsMoved,
            'status_breakdown_json' => json_encode($statusBreakdown),
            'trends_data_json' => json_encode($trendsData)
        ));

        $this->setTemplate('stats_dashboard.tpl');
    }
}
