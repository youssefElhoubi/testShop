<div class="panel">
    <div class="panel-heading">
        <i class="icon-bar-chart"></i> {l s='Transfer Statistics' mod='customstocktransfer'}
    </div>
    
    <div class="panel-body" id="custom-stock-stats-dashboard" data-status-data="{$status_breakdown_json|escape:'html':'UTF-8'}">
        
        {* KPI Row *}
        <div class="row">
            <div class="col-md-6 col-lg-6">
                <div class="panel kpi-panel">
                    <div class="panel-heading">
                        <i class="icon-exchange"></i> {l s='Total Transfers' mod='customstocktransfer'}
                    </div>
                    <div class="panel-body text-center">
                        <h2 class="kpi-value" style="font-size: 3em; margin: 0; padding: 10px 0;">
                            {$total_transfer_volume|escape:'html':'UTF-8'}
                        </h2>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6 col-lg-6">
                <div class="panel kpi-panel">
                    <div class="panel-heading">
                        <i class="icon-cubes"></i> {l s='Total Items Moved' mod='customstocktransfer'}
                    </div>
                    <div class="panel-body text-center">
                        <h2 class="kpi-value" style="font-size: 3em; margin: 0; padding: 10px 0;">
                            {$total_items_moved|escape:'html':'UTF-8'}
                        </h2>
                    </div>
                </div>
            </div>
        </div>

        {* Charts Grid Row *}
        <div class="row" style="margin-top: 20px;">
            {* Main Trends Chart *}
            <div class="col-md-8 col-lg-8">
                <div class="panel">
                    <div class="panel-heading">
                        <i class="icon-line-chart"></i> {l s='Transfer Trends' mod='customstocktransfer'}
                    </div>
                    <div class="panel-body">
                        <canvas id="transferTrendsChart" style="width: 100%; height: 350px;"></canvas>
                    </div>
                </div>
            </div>

            {* Status Breakdown Doughnut Chart *}
            <div class="col-md-4 col-lg-4">
                <div class="panel">
                    <div class="panel-heading">
                        <i class="icon-pie-chart"></i> {l s='Status Breakdown' mod='customstocktransfer'}
                    </div>
                    <div class="panel-body text-center">
                        <canvas id="transferStatusDoughnut" style="width: 100%; height: 350px;"></canvas>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>
