<div class="panel">
    <div class="panel-heading">
        <i class="icon-bar-chart"></i> {l s='Product Sales Breakdown' mod='statsdashboard'}
    </div>

    <form method="get" action="{$form_url|escape:'html':'UTF-8'}" class="form-inline well">
        <input type="hidden" name="controller" value="AdminStatsDashboard">
        <input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}">

        <div class="form-group">
            <label for="filter_year">{l s='Year' mod='statsdashboard'}</label>
            <select name="filter_year" id="filter_year" class="form-control">
                <option value="0">{l s='All Years' mod='statsdashboard'}</option>
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

    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>{l s='ID' mod='statsdashboard'}</th>
                    <th>{l s='Reference' mod='statsdashboard'}</th>
                    <th>{l s='Product Name' mod='statsdashboard'}</th>
                    <th>{l s='Year' mod='statsdashboard'}</th>
                    <th class="text-center">{l s='Quantity Sold' mod='statsdashboard'}</th>
                </tr>
            </thead>
            <tbody>
                {if isset($productsList) && $productsList|@count > 0}
                    {foreach from=$productsList item=product}
                        <tr>
                            <td>{$product.id_product}</td>
                            <td>{if $product.reference}{$product.reference}{else}--{/if}</td>
                            <td>{$product.product_name}</td>
                            <td>{$product.sales_year}</td>
                            <td class="text-center" style="font-weight: bold; font-size: 1.1em;">
                                {$product.total_sold}
                            </td>
                        </tr>
                    {/foreach}
                {else}
                    <tr>
                        <td colspan="5" class="text-center">
                            {l s='No sales data found for these filters.' mod='statsdashboard'}
                        </td>
                    </tr>
                {/if}
            </tbody>
        </table>
    </div>
</div>