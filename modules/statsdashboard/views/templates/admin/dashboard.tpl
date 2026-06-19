<div class="panel">
    <div class="panel-heading">
        <i class="icon-bar-chart"></i> {l s='Store Performance Dashboard' mod='statsdashboard'}
    </div>

    <!-- Filter Form -->
    <form method="get" action="{$form_url|escape:'html':'UTF-8'}" class="form-inline well">
        <input type="hidden" name="controller" value="AdminStatsDashboard">
        <input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}">

        <div class="form-group">
            <label for="filter_year">{l s='Year' mod='statsdashboard'}</label>
            <select name="filter_year" id="filter_year" class="form-control">
                {foreach from=$years item=year}
                    <option value="{$year}" {if $selectedYear == $year}selected{/if}>{$year}</option>
                {/foreach}
            </select>
        </div>

        <div class="form-group">
            <label for="filter_brand">{l s='Brand' mod='statsdashboard'}</label>
            <select name="filter_brand" id="filter_brand" class="form-control">
                <option value="0">{l s='All Brands' mod='statsdashboard'}</option>
                {foreach from=$brands item=brand}
                    <option value="{$brand.id_manufacturer}" {if $selectedBrand == $brand.id_manufacturer}selected{/if}>{$brand.name}</option>
                {/foreach}
            </select>
        </div>

        <div class="form-group">
            <label for="filter_supplier">{l s='Supplier' mod='statsdashboard'}</label>
            <select name="filter_supplier" id="filter_supplier" class="form-control">
                <option value="0">{l s='All Suppliers' mod='statsdashboard'}</option>
                {foreach from=$suppliers item=supplier}
                    <option value="{$supplier.id_supplier}" {if $selectedSupplier == $supplier.id_supplier}selected{/if}>{$supplier.name}</option>
                {/foreach}
            </select>
        </div>

        <button type="submit" class="btn btn-primary">
            <i class="icon-filter"></i> {l s='Filter' mod='statsdashboard'}
        </button>
    </form>

    <hr>

    <!-- Stats Display -->
    <div class="row">
        <div class="col-md-4">
            <div class="panel text-center">
                <h3>{l s='Total Orders' mod='statsdashboard'}</h3>
                <h2>{$stats.total_orders|intval}</h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="panel text-center">
                <h3>{l s='Items Sold' mod='statsdashboard'}</h3>
                <h2>{$stats.total_items_sold|intval}</h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="panel text-center">
                <h3>{l s='Total Revenue' mod='statsdashboard'}</h3>
                <h2>{displayPrice price=$stats.total_revenue}</h2>
            </div>
        </div>
    </div>
</div>