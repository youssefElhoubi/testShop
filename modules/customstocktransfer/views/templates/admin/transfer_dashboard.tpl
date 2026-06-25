{if isset($confirmations) && $confirmations}
    <div class="alert alert-success">
        {foreach from=$confirmations item=confirmation}
            <p>{$confirmation|escape:'htmlall':'UTF-8'}</p>
        {/foreach}
    </div>
{/if}

{if isset($errors) && $errors}
    <div class="alert alert-danger">
        {foreach from=$errors item=error}
            <p>{$error|escape:'htmlall':'UTF-8'}</p>
        {/foreach}
    </div>
{/if}

<div class="panel">
    <div class="panel-heading">
        <i class="icon-exchange"></i> Stock Transfer Dashboard
    </div>

    <div class="row mb-4" style="margin-bottom: 20px;">
        <div class="col-md-12 text-right">
            <div class="btn-group">
                <button type="button" class="btn btn-default js-stock-view-toggle active" data-view="grid">
                    <i class="icon-th"></i> Grid
                </button>
                <button type="button" class="btn btn-default js-stock-view-toggle" data-view="table">
                    <i class="icon-list"></i> Table
                </button>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-sm-3 col-lg-3">
            <div class="panel">
                <div class="panel-heading">Products</div>
                <div class="text-center">
                    <span style="font-size: 24px;">{if isset($total_products)}{$total_products|intval}{else}{$products|count}{/if}</span>
                </div>
            </div>
        </div>
        <div class="col-sm-3 col-lg-3">
            <div class="panel">
                <div class="panel-heading">Stores</div>
                <div class="text-center">
                    <span style="font-size: 24px;">{$shops|count}</span>
                </div>
            </div>
        </div>
        <div class="col-sm-3 col-lg-3">
            <div class="panel">
                <div class="panel-heading">Low Stock</div>
                <div class="text-center">
                    {assign var="lowStockCount" value=0}
                    {foreach from=$products item=product}
                        {if $product.is_low_stock}
                            {assign var="lowStockCount" value=$lowStockCount+1}
                        {/if}
                    {/foreach}
                    <span style="font-size: 24px;">{$lowStockCount}</span>
                </div>
            </div>
        </div>
        <div class="col-sm-3 col-lg-3">
            <div class="panel">
                <div class="panel-heading">Dashboard</div>
                <div class="text-center">
                    <span style="font-size: 24px;">Active</span>
                </div>
            </div>
        </div>
    </div>

    {if $products|count}

        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" id="customstocktransfer-bulk-form">
            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">

            <div class="panel">
                <div class="panel-heading"><i class="icon-cogs"></i> Bulk Actions</div>
                <div class="row">
                    <div class="col-md-4 form-group">
                        <label class="control-label">Source Store</label>
                        <select class="form-control" name="source_shop_id" required>
                            <option value="">Select source</option>
                            {foreach from=$shops item=shop}
                                <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-4 form-group">
                        <label class="control-label">Destination Store</label>
                        <select class="form-control" name="destination_shop_id" required>
                            <option value="">Select destination</option>
                            {foreach from=$shops item=shop}
                                <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                            {/foreach}
                        </select>
                    </div>
                    <div class="col-md-4 form-group">
                        <label class="control-label">&nbsp;</label>
                        <button type="submit" name="submitCustomStockTransfer" value="1" class="btn btn-primary btn-block">
                            <i class="icon-exchange"></i> Submit Bulk Transfer
                        </button>
                    </div>
                </div>
            </div>

            <div class="row" style="margin-bottom: 15px;">
                <div class="col-md-8">
                    <div class="input-group">
                        <span class="input-group-addon"><i class="icon-search"></i></span>
                        <input id="customstocktransfer-search" type="text" class="form-control" placeholder="Search product by name or ID...">
                        <span class="input-group-btn">
                            <button id="customstocktransfer-search-clear" class="btn btn-default" type="button">Clear</button>
                        </span>
                    </div>
                </div>
                <div class="col-md-4 text-right" style="line-height: 34px;">
                    <strong>{if isset($total_products)}{$total_products|intval}{else}{$products|count}{/if}</strong> Products
                </div>
            </div>

            <div id="customstocktransfer-grid-view" style="display: block;">
                <div class="row">
                    {foreach from=$products item=product}
                        <div class="col-md-4 col-lg-3" data-cst-product-item data-stock-view="grid" data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">
                            <div class="panel">
                                <div class="panel-heading">
                                    #{$product.id_product|intval} - {$product.name|escape:'htmlall':'UTF-8'|truncate:20}
                                    {if $product.is_low_stock}
                                        <span class="label label-danger pull-right">Low</span>
                                    {else}
                                        <span class="label label-success pull-right">Healthy</span>
                                    {/if}
                                </div>
                                
                                <div class="text-center" style="height: 150px; display: flex; align-items: center; justify-content: center;">
                                    {if $product.cover_url}
                                        <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" class="img-responsive" style="max-height: 100%; max-width: 100%; display:inline-block;" alt="{$product.name|escape:'htmlall':'UTF-8'}">
                                    {else}
                                        <i class="icon-picture text-muted" style="font-size: 50px;"></i>
                                    {/if}
                                </div>

                                <hr>

                                <div>
                                    {foreach from=$product.shops item=productShop}
                                        <div class="row" style="margin-bottom: 5px;">
                                            <div class="col-xs-8">{$productShop.shop_name|escape:'htmlall':'UTF-8'}</div>
                                            <div class="col-xs-4 text-right">
                                                <span class="badge {$productShop.badge_class}">{$productShop.quantity_in_this_shop|intval}</span>
                                            </div>
                                        </div>
                                    {/foreach}
                                </div>

                                <hr>

                                {if $product.stock_diff > 20}
                                    <div class="alert alert-warning" style="margin-bottom: 10px; padding: 5px;">⚠️ Imbalance: {$product.stock_diff|intval}</div>
                                {/if}

                                {if $product.stock_diff == 0 && $product.total_stock > 0}
                                    <div class="alert alert-danger" style="margin-bottom: 10px; padding: 5px;">🔴 Identical</div>
                                {/if}

                                <div class="row form-group" style="margin-bottom: 0;">
                                    <div class="col-xs-6">
                                        <div class="checkbox">
                                            <label>
                                                <input type="checkbox" name="bulk_product_ids[]" value="{$product.id_product|intval}" class="cst-product-checkbox" {if $product.total_stock == 0}disabled="disabled"{/if}>
                                                Select
                                            </label>
                                        </div>
                                    </div>
                                    <div class="col-xs-6">
                                        <input type="number" class="form-control" name="bulk_quantities[{$product.id_product|intval}]" value="1" min="1" {if $product.total_stock == 0}disabled="disabled"{/if}>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>

            <div id="customstocktransfer-table-view" style="display: none;" data-stock-view="table">
                <div class="panel">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="cst-select-all" onclick="$('.cst-product-checkbox').prop('checked', this.checked);"></th>
                                <th>ID</th>
                                <th>Product</th>
                                <th>Inventory</th>
                                <th>Status</th>
                                <th class="text-right">Quantity</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$products item=product}
                                <tr data-cst-product-item data-stock-view="table" data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">
                                    <td>
                                        <input type="checkbox" name="bulk_product_ids[]" value="{$product.id_product|intval}" class="cst-product-checkbox" {if $product.total_stock == 0}disabled="disabled"{/if}>
                                    </td>
                                    <td>
                                        #{$product.id_product|intval}
                                    </td>
                                    <td>
                                        <div class="media">
                                            <div class="media-left">
                                                {if $product.cover_url}
                                                    <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" class="media-object img-thumbnail" style="width: 50px; height: 50px; object-fit: contain;" alt="{$product.name|escape:'htmlall':'UTF-8'}">
                                                {else}
                                                    <div class="media-object text-center img-thumbnail" style="width: 50px; height: 50px; background: #f5f5f5; line-height: 40px;">
                                                        <i class="icon-picture"></i>
                                                    </div>
                                                {/if}
                                            </div>
                                            <div class="media-body media-middle">
                                                <h4 class="media-heading" style="margin-bottom: 0;">{$product.name|escape:'htmlall':'UTF-8'}</h4>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        {foreach from=$product.shops item=productShop}
                                            <div style="margin-bottom: 3px;">
                                                {$productShop.shop_name|escape:'htmlall':'UTF-8'}: 
                                                <span class="badge {$productShop.badge_class}">{$productShop.quantity_in_this_shop|intval}</span>
                                            </div>
                                        {/foreach}
                                    </td>
                                    <td>
                                        {if $product.is_low_stock}
                                            <span class="label label-danger">Low Stock</span>
                                        {else}
                                            <span class="label label-success">Healthy</span>
                                        {/if}
                                    </td>
                                    <td class="text-right">
                                        {if $product.stock_diff > 20}
                                            <div class="alert alert-warning" style="margin-bottom: 5px; padding: 5px; display: inline-block;">⚠️ Diff: {$product.stock_diff|intval}</div>
                                        {/if}

                                        {if $product.stock_diff == 0 && $product.total_stock > 0}
                                            <div class="alert alert-danger" style="margin-bottom: 5px; padding: 5px; display: inline-block;">🔴 Identical</div>
                                        {/if}

                                        <input type="number" class="form-control d-inline-block pull-right" style="width: 80px;" name="bulk_quantities[{$product.id_product|intval}]" value="1" min="1" {if $product.total_stock == 0}disabled="disabled"{/if}>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="panel">
                <div class="row">
                    <div class="col-md-6" style="line-height: 34px;">
                        Showing {if isset($total_products) && $total_products == 0}0{else}{(($current_page - 1) * $limit) + 1}{/if} to {if $current_page * $limit > $total_products}{$total_products}{else}{$current_page * $limit}{/if} of {$total_products} products
                    </div>
                    <div class="col-md-6 text-right">
                        {if isset($total_pages) && $total_pages > 1}
                        <ul class="pagination" style="margin: 0;">
                            <li class="{if $current_page <= 1}disabled{/if}">
                                <a href="{$form_action|escape:'htmlall':'UTF-8'}&page={$current_page - 1}&limit={$limit}">
                                    &laquo; Previous
                                </a>
                            </li>
                            {for $p=1 to $total_pages}
                                <li class="{if $p == $current_page}active{/if}">
                                    <a href="{$form_action|escape:'htmlall':'UTF-8'}&page={$p}&limit={$limit}">{$p}</a>
                                </li>
                            {/for}
                            <li class="{if $current_page >= $total_pages}disabled{/if}">
                                <a href="{$form_action|escape:'htmlall':'UTF-8'}&page={$current_page + 1}&limit={$limit}">
                                    Next &raquo;
                                </a>
                            </li>
                        </ul>
                        {/if}
                    </div>
                </div>
            </div>

        </form>
    {else}
        <div class="alert alert-warning">
            <i class="icon-archive"></i> No active products available for transfer.
        </div>
    {/if}

</div>