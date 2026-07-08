<div class="custom-saas-wrapper">
    <div class="saas-header">
        <h2>{l s='Transfer Statistics' mod='customstocktransfer'}</h2>
        <p class="saas-subtitle">Overview of your inventory movements and pending requests.</p>
    </div>
    
    <div class="saas-dashboard-grid" id="custom-stock-stats-dashboard" data-status-data='{$status_breakdown_json}' data-trends-data='{$trends_data_json}'>
        
        <!-- KPI Cards -->
        <div class="saas-card kpi-card">
            <div class="kpi-content">
                <span class="kpi-title">{l s='Total Transfers' mod='customstocktransfer'}</span>
                <span class="kpi-value">{$total_transfer_volume|escape:'html':'UTF-8'}</span>
            </div>
            <div class="kpi-icon">
                <i class="icon-exchange"></i>
            </div>
        </div>
        
        <div class="saas-card kpi-card">
            <div class="kpi-content">
                <span class="kpi-title">{l s='Total Items Moved' mod='customstocktransfer'}</span>
                <span class="kpi-value">{$total_items_moved|escape:'html':'UTF-8'}</span>
            </div>
            <div class="kpi-icon kpi-icon-items">
                <i class="icon-cubes"></i>
            </div>
        </div>

        <!-- Main Trend Chart -->
        <div class="saas-card chart-card trend-chart-card">
            <h3 class="card-title">{l s='Transfer Volume Trends' mod='customstocktransfer'}</h3>
            <div class="canvas-container">
                <canvas id="transferTrendsChart"></canvas>
            </div>
        </div>

        <!-- Status Doughnut Chart -->
        <div class="saas-card chart-card doughnut-chart-card">
            <h3 class="card-title">{l s='Status Breakdown' mod='customstocktransfer'}</h3>
            <div class="canvas-container">
                <canvas id="transferStatusDoughnut"></canvas>
            </div>
        </div>

    </div>
</div>
