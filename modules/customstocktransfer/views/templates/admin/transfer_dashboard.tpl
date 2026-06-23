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
                {$products|count}
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

        <div class="cst-toolbar">

            <div class="cst-search">

                <i class="icon-search"></i>

                <input id="customstocktransfer-search" type="search" placeholder="Search product by name or ID...">

                <button id="customstocktransfer-search-clear" type="button">

                    Clear

                </button>

            </div>

            <div class="cst-toolbar-right">

                <span>

                    <strong id="customstocktransfer-result-count">
                        {$products|count}
                    </strong>

                    Products

                </span>

            </div>

        </div>
        <div id="customstocktransfer-grid-view" class="cst-view is-active">

            <div class="cst-products-grid">

                {foreach from=$products item=product}

                    <div class="cst-product" data-cst-product-item data-stock-view="grid" data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">

                        <div class="cst-product-card">

                            <div class="cst-product-image-wrapper">

                                {if $product.cover_url}

                                    <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" class="cst-product-image" alt="{$product.name|escape:'htmlall':'UTF-8'}">

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

                                <button type="button" class="cst-transfer-btn js-open-transfer-modal" data-toggle="modal" data-target="#customstocktransfer-transfer-modal" data-product-id="{$product.id_product|intval}" data-product-name="{$product.name|escape:'htmlall':'UTF-8'}">

                                    <i class="icon-exchange"></i>

                                    Transfer Stock

                                </button>

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

                            <th>ID</th>

                            <th>Product</th>

                            <th>Inventory</th>

                            <th>Status</th>

                            <th class="text-right">Action</th>

                        </tr>

                    </thead>

                    <tbody>

                        {foreach from=$products item=product}

                            <tr data-cst-product-item data-stock-view="table" data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">

                                <td>

                                    <span class="cst-table-id">

                                        #{$product.id_product|intval}

                                    </span>

                                </td>

                                <td>

                                    <div class="cst-table-product">

                                        {if $product.cover_url}

                                            <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" class="cst-table-image" alt="{$product.name|escape:'htmlall':'UTF-8'}">

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

                                    <button type="button" class="cst-table-btn js-open-transfer-modal" data-toggle="modal" data-target="#customstocktransfer-transfer-modal" data-product-id="{$product.id_product|intval}" data-product-name="{$product.name|escape:'htmlall':'UTF-8'}">

                                        Transfer →

                                    </button>

                                </td>

                            </tr>

                        {/foreach}

                    </tbody>

                </table>

            </div>

        </div>

        <div class="modal fade" id="customstocktransfer-transfer-modal" tabindex="-1" role="dialog" aria-hidden="true">

            <div class="modal-dialog modal-dialog-centered modal-lg">

                <div class="modal-content cst-modal">

                    <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" id="customstocktransfer-transfer-form">

                        <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">

                        <input type="hidden" name="id_product" value="">

                        <div class="cst-modal-header">

                            <div>

                                <span class="cst-modal-badge">

                                    Inventory Transfer

                                </span>

                                <h2 class="js-transfer-modal-title">

                                    Transfer Stock

                                </h2>

                                <p>

                                    Move inventory between physical stores.

                                </p>

                            </div>

                            <button type="button" class="close" data-dismiss="modal">

                                &times;

                            </button>

                        </div>

                        <div class="cst-modal-body">

                            <div class="row">

                                <div class="col-md-6">

                                    <label>

                                        Source Store

                                    </label>

                                    <select class="form-control cst-input" name="source_shop_id" required>

                                        <option value="">

                                            Select source

                                        </option>

                                        {foreach from=$shops item=shop}

                                            <option value="{$shop.id_shop|intval}">

                                                {$shop.shop_name|escape:'htmlall':'UTF-8'}

                                            </option>

                                        {/foreach}

                                    </select>

                                </div>

                                <div class="col-md-6">

                                    <label>

                                        Destination Store

                                    </label>

                                    <select class="form-control cst-input" name="destination_shop_id" required>

                                        <option value="">

                                            Select destination

                                        </option>

                                        {foreach from=$shops item=shop}

                                            <option value="{$shop.id_shop|intval}">

                                                {$shop.shop_name|escape:'htmlall':'UTF-8'}

                                            </option>

                                        {/foreach}

                                    </select>

                                </div>

                            </div>

                            <div class="mt-4">

                                <label>

                                    Quantity

                                </label>

                                <input type="number" class="form-control cst-input" name="quantity" min="1" value="1" required>

                            </div>

                            <div class="cst-modal-info">

                                <i class="icon-info"></i>

                                Double-check the selected stores before confirming the transfer.

                            </div>

                        </div>

                        <div class="cst-modal-footer">

                            <button type="button" class="btn cst-btn-light" data-dismiss="modal">

                                Cancel

                            </button>

                            <button type="submit" name="submitCustomStockTransfer" value="1" class="btn cst-btn-primary">

                                <i class="icon-exchange"></i>

                                Transfer Stock

                            </button>

                        </div>

                    </form>

                </div>

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