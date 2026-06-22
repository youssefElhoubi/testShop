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
    <div class="panel statsdashboard-wrap">
        <div class="panel-heading">
            <i class="icon-bar-chart"></i> {l s='Product Sales Breakdown' mod='statsdashboard'}
        </div>

        <hr>

        <div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>{l s='Product Name' mod='statsdashboard'}</th>
                        <th class="text-center">Jan</th>
                        <th class="text-center">Feb</th>
                        <th class="text-center">Mar</th>
                        <th class="text-center">Apr</th>
                        <th class="text-center">May</th>
                        <th class="text-center">Jun</th>
                        <th class="text-center">Jul</th>
                        <th class="text-center">Aug</th>
                        <th class="text-center">Sep</th>
                        <th class="text-center">Oct</th>
                        <th class="text-center">Nov</th>
                        <th class="text-center">Dec</th>
                        <th class="text-center" style="background-color: #fff3e0; color: #d84315;">{l s='Live Stock' mod='statsdashboard'}</th>
                        <th class="text-center bg-totals">{l s='Total sales' mod='statsdashboard'}</th>
                        <th class="text-right bg-profit">{l s='Total Profit' mod='statsdashboard'}</th>
                    </tr>
                </thead>
                <tbody>
                    {if isset($productsList) && $productsList|@count > 0}
                        {foreach from=$productsList item=product}
                            <tr>
                                <td>
                                    <a href="{$product.product_link|escape:'html':'UTF-8'}" target="_blank" style="text-decoration: none; color: #2563eb; display: flex; align-items: center; gap: 5px;">
                                        <strong>{$product.product_name}</strong>
                                        <i class="icon-external-link" style="font-size: 11px; color: #9ca3af;"></i>
                                    </a>
                                </td>
                                <td class="text-center">{$product.jan}</td>
                                <td class="text-center">{$product.feb}</td>
                                <td class="text-center">{$product.mar}</td>
                                <td class="text-center">{$product.apr}</td>
                                <td class="text-center">{$product.may}</td>
                                <td class="text-center">{$product.jun}</td>
                                <td class="text-center">{$product.jul}</td>
                                <td class="text-center">{$product.aug}</td>
                                <td class="text-center">{$product.sep}</td>
                                <td class="text-center">{$product.oct}</td>
                                <td class="text-center">{$product.nov}</td>
                                <td class="text-center">{$product.decem}</td>

                                <td class="text-center" style="font-weight: bold; color: #d84315; background-color: #fff8e1;">
                                    {$product.current_stock}
                                </td>

                                <td class="text-center col-total">
                                    {$product.total_sold}
                                </td>
                                <td class="text-right col-profit">
                                    {displayPrice price=$product.total_profit}
                                </td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="16" class="text-center" style="padding: 40px; color: #9ca3af;">
                                <i class="icon-inbox" style="font-size: 24px; display: block; margin-bottom: 10px;"></i>
                                {l s='No sales data found for these filters.' mod='statsdashboard'}
                            </td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>

    </div>

    {if isset($totalPages) && $totalPages > 1}
        <div class="row">
            <div class="col-md-12 text-center">
                <ul class="pagination">
                    {if $page > 1}
                        <li>
                            <a href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&page={$page-1}">&laquo; {l s='Prev' mod='statsdashboard'}</a>
                        </li>
                    {/if}

                    {for $p=1 to $totalPages}
                        <li {if $p == $page}class="active" {/if}>
                            <a href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&page={$p}">{$p}</a>
                        </li>
                    {/for}

                    {if $page < $totalPages}
                        <li>
                            <a href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&page={$page+1}">{l s='Next' mod='statsdashboard'} &raquo;</a>
                        </li>
                    {/if}
                </ul>
            </div>
        </div>
    {/if}
</div>

</div>