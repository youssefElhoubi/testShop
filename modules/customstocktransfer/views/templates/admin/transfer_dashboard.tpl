{if isset($confirmations) && $confirmations}
    <div class="alert alert-success">
        {foreach from=$confirmations item=confirmation}
            <p class="mb-0">{$confirmation|escape:'htmlall':'UTF-8'}</p>
        {/foreach}
    </div>
{/if}

{if isset($errors) && $errors}
    <div class="alert alert-danger">
        {foreach from=$errors item=error}
            <p class="mb-0">{$error|escape:'htmlall':'UTF-8'}</p>
        {/foreach}
    </div>
{/if}

<div class="card cst-dashboard-shell shadow-sm">
    <div class="card-header d-flex flex-wrap justify-content-between align-items-center gap-3">
        <div>
            <h3 class="mb-1 card-header-title">
                <i class="icon-exchange"></i>
                Stock Transfer Dashboard
            </h3>
            <div class="text-muted small">View stock per store, switch layouts, and transfer quantity inline.</div>
        </div>

        <div class="btn-group cst-view-toggle" role="group" aria-label="View toggle">
            <button type="button" class="btn btn-primary js-stock-view-toggle active" data-view="grid">
                <i class="icon-th"></i> Grid View
            </button>
            <button type="button" class="btn btn-outline-primary js-stock-view-toggle" data-view="table">
                <i class="icon-list"></i> Table View
            </button>
        </div>
    </div>

    <div class="card-body">
        {if $products|count}
            <div class="row mb-3">
                <div class="col-12 col-lg-6">
                    <div class="input-group cst-search-group">
                        <div class="input-group-prepend">
                            <span class="input-group-text bg-white">
                                <i class="icon-search"></i>
                            </span>
                        </div>
                        <input type="search" class="form-control" id="customstocktransfer-search" placeholder="Search products by name or ID">
                        <div class="input-group-append">
                            <button type="button" class="btn btn-outline-secondary" id="customstocktransfer-search-clear">Clear</button>
                        </div>
                    </div>
                </div>

                <div class="col-12 col-lg-6 d-flex align-items-center justify-content-lg-end mt-3 mt-lg-0">
                    <div class="text-muted small">
                        <span id="customstocktransfer-result-count">{$products|count|intval}</span> product(s) shown
                    </div>
                </div>
            </div>

            <div id="customstocktransfer-grid-view" class="cst-view is-active" data-stock-view="grid">
                <div class="row">
                    {foreach from=$products item=product}
                        <div class="col-12 col-xl-6 mb-4" data-cst-product-item data-stock-view="grid" data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">
                            <div class="card h-100 border-0 shadow-sm cst-product-card">
                                <div class="cst-product-media">
                                    {if $product.cover_url}
                                        <img src="{$product.cover_url|escape:'htmlall':'UTF-8'}" alt="{$product.name|escape:'htmlall':'UTF-8'}" class="cst-product-image img-fluid">
                                    {else}
                                        <div class="cst-product-placeholder d-flex align-items-center justify-content-center">
                                            <span class="badge badge-light">No cover image</span>
                                        </div>
                                    {/if}
                                </div>

                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div class="pr-3">
                                            <div class="d-flex flex-wrap align-items-center mb-2">
                                                <h4 class="h5 mb-0 mr-2">#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}</h4>
                                                {if $product.is_low_stock}
                                                    <span class="badge badge-warning">[!] LOW STOCK</span>
                                                {else}
                                                    <span class="badge badge-success">Healthy</span>
                                                {/if}
                                            </div>
                                            <div class="text-muted small">Exact quantities per store are shown below.</div>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        {foreach from=$product.shops item=productShop}
                                            <div class="cst-store-chip">
                                                <span class="font-weight-bold">{$productShop.shop_name|escape:'htmlall':'UTF-8'}</span>
                                                <span class="badge {$productShop.badge_class}">{$productShop.quantity_in_this_shop|intval}</span>
                                            </div>
                                        {/foreach}
                                    </div>

                                    <div class="mt-auto pt-2">
                                        <button type="button"
                                            class="btn btn-primary btn-block btn-lg js-open-transfer-modal"
                                            data-toggle="modal"
                                            data-target="#customstocktransfer-transfer-modal"
                                            data-product-id="{$product.id_product|intval}"
                                            data-product-name="{$product.name|escape:'htmlall':'UTF-8'}">
                                            Transfer Stock
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>

            <div id="customstocktransfer-table-view" class="cst-view" data-stock-view="table">
                <div class="table-responsive">
                    <table class="table table-striped table-bordered table-hover mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th class="align-middle" style="width: 90px;">ID</th>
                                <th class="align-middle">Product</th>
                                <th class="align-middle">Stock by Store</th>
                                <th class="align-middle" style="width: 140px;">Status</th>
                                <th class="align-middle" style="width: 180px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$products item=product}
                                <tr data-cst-product-item data-stock-view="table" data-cst-product-text="#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}">
                                    <td class="align-middle">{$product.id_product|intval}</td>
                                    <td class="align-middle font-weight-semibold">{$product.name|escape:'htmlall':'UTF-8'}</td>
                                    <td class="align-middle">
                                        <div class="d-flex flex-wrap">
                                            {foreach from=$product.shops item=productShop}
                                                <div class="cst-store-chip mr-2 mb-2">
                                                    <span class="font-weight-bold">{$productShop.shop_name|escape:'htmlall':'UTF-8'}</span>
                                                    <span class="badge {$productShop.badge_class}">{$productShop.quantity_in_this_shop|intval}</span>
                                                </div>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td class="align-middle">
                                        {if $product.is_low_stock}
                                            <span class="badge badge-warning">[!] LOW STOCK</span>
                                        {else}
                                            <span class="badge badge-success">Healthy</span>
                                        {/if}
                                    </td>
                                    <td class="align-middle">
                                        <button type="button"
                                                class="btn btn-primary btn-sm js-open-transfer-modal"
                                                data-toggle="modal"
                                                data-target="#customstocktransfer-transfer-modal"
                                                data-product-id="{$product.id_product|intval}"
                                                data-product-name="{$product.name|escape:'htmlall':'UTF-8'}">
                                            Transfer Stock
                                        </button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="modal fade" id="customstocktransfer-transfer-modal" tabindex="-1" role="dialog" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                    <div class="modal-content cst-modal-content">
                        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" id="customstocktransfer-transfer-form">
                            <div class="modal-header">
                                <div>
                                    <h5 class="modal-title mb-1 js-transfer-modal-title">Transfer Stock</h5>
                                    <div class="small text-muted">Move stock between physical stores</div>
                                </div>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>

                            <div class="modal-body">
                                <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                <input type="hidden" name="id_product" value="">

                                <div class="form-row">
                                    <div class="form-group col-12 col-md-4">
                                        <label for="modal_source_shop_id">Source Store</label>
                                        <select id="modal_source_shop_id" name="source_shop_id" class="form-control" required>
                                            <option value="">Select source store</option>
                                            {foreach from=$shops item=shop}
                                                <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                                            {/foreach}
                                        </select>
                                    </div>

                                    <div class="form-group col-12 col-md-4">
                                        <label for="modal_destination_shop_id">Destination Store</label>
                                        <select id="modal_destination_shop_id" name="destination_shop_id" class="form-control" required>
                                            <option value="">Select destination store</option>
                                            {foreach from=$shops item=shop}
                                                <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                                            {/foreach}
                                        </select>
                                    </div>

                                    <div class="form-group col-12 col-md-4">
                                        <label for="modal_quantity">Quantity</label>
                                        <input id="modal_quantity" type="number" name="quantity" min="1" step="1" value="1" class="form-control" required>
                                    </div>
                                </div>

                                <div class="alert alert-info mb-0">
                                    Select the source and destination stores, then confirm the transfer.
                                </div>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <button type="submit" name="submitCustomStockTransfer" value="1" class="btn btn-primary btn-lg">
                                    Transfer Stock
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        {else}
            <div class="alert alert-warning mb-0">No active products were found.</div>
        {/if}
    </div>
</div>
