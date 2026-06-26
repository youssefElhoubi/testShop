<div class="custom-transfer-wrapper">
{if isset($confirmations) && $confirmations}
    <div class="cst-alert cst-alert-success mb-4">
        <div class="cst-alert-icon">
            <i class="icon-check"></i>
        </div>

        <div class="cst-alert-content">
            {foreach from=$confirmations item=confirmation}
                <p>{$confirmation|escape:'htmlall':'UTF-8'}</p>
            {/foreach}
        </div>
    </div>
{/if}

{if isset($errors) && $errors}
    <div class="cst-alert cst-alert-danger mb-4">
        <div class="cst-alert-icon">
            <i class="icon-warning"></i>
        </div>

        <div class="cst-alert-content">
            {foreach from=$errors item=error}
                <p>{$error|escape:'htmlall':'UTF-8'}</p>
            {/foreach}
        </div>
    </div>
{/if}

<div class="cst-dashboard">

    <div class="cst-hero">

        <div class="cst-hero-content">

            <div>

                <span class="cst-hero-badge">
                    Inventory Management
                </span>

                <h1>
                    Stock Transfer Dashboard
                </h1>

                <p>
                    Manage stock across all stores with a modern inventory workflow.
                </p>

            </div>

            <div class="cst-view-switch">

                <button type="button" class="js-stock-view-toggle active" data-view="grid">

                    <i class="icon-th"></i>

                    Grid

                </button>

                <button type="button" class="js-stock-view-toggle" data-view="table">

                    <i class="icon-list"></i>

                    Table

                </button>

            </div>

        </div>

    </div>


    <div class="cst-stat-grid">

        <div class="cst-stat-card">

            <div class="cst-stat-number">
                {if isset($total_products)}{$total_products|intval}{else}{$products|count}{/if}
            </div>

            <div class="cst-stat-label">
                Products
            </div>

        </div>

        <div class="cst-stat-card">

            <div class="cst-stat-number">
                {$shops|count}
            </div>

            <div class="cst-stat-label">
                Stores
            </div>

        </div>

        <div class="cst-stat-card">

            <div class="cst-stat-number">

                {assign var="lowStockCount" value=0}

                {foreach from=$products item=product}
                    {if $product.is_low_stock}
                        {assign var="lowStockCount" value=$lowStockCount+1}
                    {/if}
                {/foreach}

                {$lowStockCount}

            </div>

            <div class="cst-stat-label">
                Low Stock
            </div>

        </div>

        <div class="cst-stat-card">

            <div class="cst-stat-number">
                Active
            </div>

            <div class="cst-stat-label">
                Dashboard
            </div>

        </div>

    </div>

    {if $products|count}

        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" id="cst-filter-form">
            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">

            <div class="cst-advanced-filters">
                <div class="cst-filter-grid">
                    <div class="cst-filter-group">
                        <label>Category</label>
                        <select class="form-control cst-input" name="filter_category">
                            <option value="">All Categories</option>
                            {foreach from=$categories item=category}
                                <option value="{$category.id_category|intval}" {if isset($filter) && $filter.category == $category.id_category}selected{/if}>{$category.name|escape:'htmlall':'UTF-8'}</option>
                            {/foreach}
                        </select>
                    </div>
                    
                    <div class="cst-filter-group">
                        <label>Quantity</label>
                        <div class="cst-filter-range">
                            <input type="number" class="form-control cst-input" name="filter_qty_min" placeholder="Min" value="{if isset($filter) && $filter.qty_min !== null}{$filter.qty_min}{/if}">
                            <span>-</span>
                            <input type="number" class="form-control cst-input" name="filter_qty_max" placeholder="Max" value="{if isset($filter) && $filter.qty_max !== null}{$filter.qty_max}{/if}">
                        </div>
                    </div>
                    
                    <div class="cst-filter-group">
                        <label>Price</label>
                        <div class="cst-filter-range">
                            <input type="number" step="0.01" class="form-control cst-input" name="filter_price_min" placeholder="Min" value="{if isset($filter) && $filter.price_min !== null}{$filter.price_min}{/if}">
                            <span>-</span>
                            <input type="number" step="0.01" class="form-control cst-input" name="filter_price_max" placeholder="Max" value="{if isset($filter) && $filter.price_max !== null}{$filter.price_max}{/if}">
                        </div>
                    </div>
                    
                    <div class="cst-filter-group">
                        <label>Status</label>
                        <select class="form-control cst-input" name="filter_status">
                            <option value="" {if !isset($filter) || $filter.status === null}selected{/if}>All</option>
                            <option value="1" {if isset($filter) && $filter.status === 1}selected{/if}>Active</option>
                            <option value="0" {if isset($filter) && $filter.status === 0}selected{/if}>Inactive</option>
                        </select>
                    </div>
                </div>
                
                <div class="cst-filter-actions mt-3 text-right">
                    <button type="button" class="btn btn-default cst-btn-outline mr-2" onclick="window.location.href='{$form_action|escape:'htmlall':'UTF-8'}';">
                        <i class="icon-eraser"></i> Clear Filters
                    </button>
                    <button type="submit" name="submitCustomStockTransferSearch" value="1" class="btn btn-primary cst-btn-primary">
                        <i class="icon-filter"></i> Apply Filters
                    </button>
                </div>
            </div>

            <div class="cst-toolbar">

                <div class="cst-search">

                    <i class="icon-search"></i>

                    <input name="product_search" type="text" value="{$product_search|escape:'htmlall':'UTF-8'}" placeholder="Search by product name or reference...">

                    <button type="submit" name="submitCustomStockTransferSearch" value="1">

                        Search

                    </button>

                </div>

                <div class="cst-toolbar-right">

                    <span>

                        <strong id="customstocktransfer-result-count">
                            {if isset($total_products)}{$total_products|intval}{else}{$products|count}{/if}
                        </strong>

                        Products

                    </span>

                </div>

            </div>
        </form>

        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" id="cst-transfer-form">
            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">

            <div class="cst-bulk-actions row mb-4 align-items-end">
                <div class="col-md-4">
                    <label>Source Store</label>
                    <select class="form-control cst-input" name="source_shop_id">
                        <option value="">Select source</option>
                        {foreach from=$shops item=shop}
                            <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="col-md-4">
                    <label>Destination Store</label>
                    <select class="form-control cst-input" name="destination_shop_id">
                        <option value="">Select destination</option>
                        {foreach from=$shops item=shop}
                            <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                        {/foreach}
                    </select>
                </div>
                <div class="col-md-4">
                    <button type="submit" name="submitCustomStockTransfer" value="1"
                        class="btn btn-primary cst-btn-primary w-100">
                        <i class="icon-exchange"></i> Submit Bulk Transfer
                    </button>
                </div>
            </div>

            <div id="customstocktransfer-grid-view" class="cst-view is-active">

                <div class="cst-products-grid">

                    {foreach from=$products item=product}

                        <div class="cst-product" data-cst-product-item data-stock-view="grid"
                            data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">

                            <div class="cst-product-card">

                                <div class="cst-product-image-wrapper">

                                    {if $product.cover_url}

                                        <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" class="cst-product-image"
                                            alt="{$product.name|escape:'htmlall':'UTF-8'}">

                                    {else}

                                        <div class="cst-product-placeholder">

                                            <i class="icon-picture"></i>

                                        </div>

                                    {/if}

                                    {if $product.is_low_stock}

                                        <span class="cst-status low">

                                            ● Low Stock

                                        </span>

                                    {else}

                                        <span class="cst-status healthy">

                                            ● Healthy

                                        </span>

                                    {/if}

                                </div>

                                <div class="cst-product-body">

                                    <div class="cst-product-id">

                                        Product #{$product.id_product|intval}

                                    </div>

                                    <h3 class="cst-product-name">

                                        {$product.name|escape:'htmlall':'UTF-8'}

                                    </h3>

                                    <div class="cst-divider"></div>

                                    <div class="cst-stock-list">

                                        {foreach from=$product.shops item=productShop}

                                            <div class="cst-stock-row">

                                                <div>

                                                    <div class="cst-store-name">

                                                        {$productShop.shop_name|escape:'htmlall':'UTF-8'}

                                                    </div>

                                                </div>

                                                <div>

                                                    <span class="cst-stock-badge {$productShop.badge_class}">

                                                        {$productShop.quantity_in_this_shop|intval}

                                                    </span>

                                                </div>

                                            </div>

                                        {/foreach}

                                    </div>

                                    <div class="cst-divider"></div>

                                    {if $product.stock_diff > 20}
                                        <div class="mb-2">
                                            <span class="badge badge-warning font-weight-bold">⚠️ High Imbalance (Diff:
                                                {$product.stock_diff|intval})</span>
                                        </div>
                                    {/if}

                                    {if $product.stock_diff == 0 && $product.total_stock > 0}
                                        <div class="mb-2 font-weight-bold text-danger">🔴 Stocks are completely identical.</div>
                                    {/if}

                                    <div class="d-flex justify-content-between align-items-center mt-2">
                                        <label class="mb-0">
                                            <input type="checkbox" name="bulk_product_ids[]"
                                                value="{$product.id_product|intval}" class="cst-product-checkbox"
                                                {if $product.total_stock == 0}disabled="disabled" {/if}>
                                            Select
                                        </label>
                                        <input type="number" class="form-control cst-input" style="width: 80px;"
                                            name="bulk_quantities[{$product.id_product|intval}]" value="1" min="1"
                                            {if $product.total_stock == 0}disabled="disabled" {/if}>
                                    </div>

                                </div>

                            </div>

                        </div>

                    {/foreach}

                </div>

            </div>

            <div id="customstocktransfer-table-view" class="cst-view" data-stock-view="table">

                <div class="cst-table-wrapper">

                    <table class="cst-table">

                        <thead>

                            <tr>

                                <th></th>

                                <th>ID</th>

                                <th>Product</th>

                                <th>Inventory</th>

                                <th>Status</th>

                                <th class="text-right">Quantity</th>

                            </tr>

                        </thead>

                        <tbody>

                            {foreach from=$products item=product}

                                <tr data-cst-product-item data-stock-view="table"
                                    data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">

                                    <td>
                                        <input type="checkbox" name="bulk_product_ids[]" value="{$product.id_product|intval}"
                                            class="cst-product-checkbox" {if $product.total_stock == 0}disabled="disabled"
                                            {/if}>
                                    </td>

                                    <td>

                                        <span class="cst-table-id">

                                            #{$product.id_product|intval}

                                        </span>

                                    </td>

                                    <td>

                                        <div class="cst-table-product">

                                            {if $product.cover_url}

                                                <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" class="cst-table-image"
                                                    alt="{$product.name|escape:'htmlall':'UTF-8'}">

                                            {else}

                                                <div class="cst-table-placeholder">

                                                    <i class="icon-picture"></i>

                                                </div>

                                            {/if}

                                            <div>

                                                <div class="cst-table-product-name">

                                                    {$product.name|escape:'htmlall':'UTF-8'}

                                                </div>

                                                <div class="cst-table-subtitle">

                                                    Product ID:
                                                    {$product.id_product|intval}

                                                </div>

                                            </div>

                                        </div>

                                    </td>

                                    <td>

                                        <div class="cst-table-stock">

                                            {foreach from=$product.shops item=productShop}

                                                <div class="cst-mini-stock">

                                                    <span>

                                                        {$productShop.shop_name|escape:'htmlall':'UTF-8'}

                                                    </span>

                                                    <strong>

                                                        {$productShop.quantity_in_this_shop|intval}

                                                    </strong>

                                                </div>

                                            {/foreach}

                                        </div>

                                    </td>

                                    <td>

                                        {if $product.is_low_stock}

                                            <span class="cst-status low">

                                                ● Low Stock

                                            </span>

                                        {else}

                                            <span class="cst-status healthy">

                                                ● Healthy

                                            </span>

                                        {/if}

                                    </td>

                                    <td class="text-right">

                                        {if $product.stock_diff > 20}
                                            <div class="mb-2">
                                                <span class="badge badge-warning font-weight-bold">⚠️ High Imbalance (Diff:
                                                    {$product.stock_diff|intval})</span>
                                            </div>
                                        {/if}

                                        {if $product.stock_diff == 0 && $product.total_stock > 0}
                                            <div class="mb-2 font-weight-bold text-danger">🔴 Stocks are completely identical.</div>
                                        {/if}

                                        <input type="number" class="form-control cst-input d-inline-block" style="width: 80px;"
                                            name="bulk_quantities[{$product.id_product|intval}]" value="1" min="1"
                                            {if $product.total_stock == 0}disabled="disabled" {/if}>

                                    </td>

                                </tr>

                            {/foreach}

                        </tbody>

                    </table>

                </div>

            </div>
        </form>

            <div class="row mt-4 mb-4" style="align-items: center;">
                <div class="col-md-6" style="display: flex; align-items: center; gap: 15px;">
                    <div>
                        Showing
                        {if isset($total_products) && $total_products == 0}0{else}{(($current_page - 1) * $limit) + 1}{/if} to
                        {if $current_page * $limit > $total_products}{$total_products}{else}{$current_page * $limit}{/if} of
                        {$total_products} products
                    </div>
                    <select class="form-control cst-input" style="width: auto; height: 42px; padding: 0 15px;" onchange="window.location.href='{$form_action|escape:'htmlall':'UTF-8'}&page=1&limit='+this.value+'&product_search={$product_search|escape:'url':'UTF-8'}';">
                        <option value="10" {if $limit == 10}selected{/if}>10 per page</option>
                        <option value="20" {if $limit == 20}selected{/if}>20 per page</option>
                        <option value="50" {if $limit == 50}selected{/if}>50 per page</option>
                        <option value="100" {if $limit == 100}selected{/if}>100 per page</option>
                    </select>
                </div>
                <div class="col-md-6">
                    {if isset($total_pages) && $total_pages > 1}
                        <ul class="pagination justify-content-end mb-0">
                            <li class="page-item {if $current_page <= 1}disabled{/if}">
                                <a class="page-link"
                                    href="{$form_action|escape:'htmlall':'UTF-8'}&page={$current_page - 1}&limit={$limit}&product_search={$product_search|escape:'url':'UTF-8'}">
                                    &laquo; Previous
                                </a>
                            </li>
                            {for $p=1 to $total_pages}
                                <li class="page-item {if $p == $current_page}active{/if}">
                                    <a class="page-link"
                                        href="{$form_action|escape:'htmlall':'UTF-8'}&page={$p}&limit={$limit}&product_search={$product_search|escape:'url':'UTF-8'}">{$p}</a>
                                </li>
                            {/for}
                            <li class="page-item {if $current_page >= $total_pages}disabled{/if}">
                                <a class="page-link"
                                    href="{$form_action|escape:'htmlall':'UTF-8'}&page={$current_page + 1}&limit={$limit}&product_search={$product_search|escape:'url':'UTF-8'}">
                                    Next &raquo;
                                </a>
                            </li>
                        </ul>
                    {/if}
                </div>
            </div>

    {else}
        <div class="cst-empty">

            <div class="cst-empty-icon">

                <i class="icon-archive"></i>

            </div>

            <h2>

                No Products Found

            </h2>

            <p>

                There are currently no active products available for transfer.

            </p>

        </div>
    {/if}
</div>
</div>
</div>