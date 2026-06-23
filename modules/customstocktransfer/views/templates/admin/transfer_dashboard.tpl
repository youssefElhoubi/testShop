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

<div class="card">
    <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
        <div>
            <h3 class="card-header-title mb-0">
                <i class="icon-exchange"></i>
                Stock Transfer Dashboard
            </h3>
            <small class="text-muted">Per-store stock visibility and transfer controls</small>
        </div>

        <div class="btn-group mt-2 mt-sm-0" role="group" aria-label="View toggle">
            <button type="button" class="btn btn-outline-primary active js-stock-view-toggle" data-view="grid">
                <i class="icon-th"></i> Grid View
            </button>
            <button type="button" class="btn btn-outline-primary js-stock-view-toggle" data-view="table">
                <i class="icon-list"></i> Table View
            </button>
        </div>
    </div>

    <div class="card-body">
        {if $products|count}
            <div id="customstocktransfer-grid-view">
                <div class="row">
                    {foreach from=$products item=product}
                        <div class="col-12 col-lg-6 mb-4">
                            <div class="card h-100 shadow-sm">
                                <div class="card-body d-flex flex-column">
                                    <div class="d-flex justify-content-between align-items-start mb-3">
                                        <div>
                                            <div class="h5 mb-1">#{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}</div>
                                            {if $product.is_low_stock}
                                                <span class="badge badge-warning">[!] LOW STOCK</span>
                                            {/if}
                                        </div>
                                        <button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#customstocktransfer-modal-{$product.id_product|intval}">
                                            Transfer Stock
                                        </button>
                                    </div>

                                    <div class="mb-2 font-weight-bold">Stock by Store</div>
                                    <ul class="list-unstyled mb-3">
                                        {foreach from=$product.shops item=productShop}
                                            {assign var=shopQty value=$productShop.quantity_in_this_shop|intval}
                                            {if $shopQty == 0}
                                                {assign var=badgeClass value='badge-danger'}
                                            {elseif $shopQty <= 5}
                                                {assign var=badgeClass value='badge-warning'}
                                            {else}
                                                {assign var=badgeClass value='badge-success'}
                                            {/if}
                                            <li class="d-flex justify-content-between align-items-center py-1">
                                                <span>{$productShop.shop_name|escape:'htmlall':'UTF-8'}</span>
                                                <span class="badge {$badgeClass}">{$shopQty}</span>
                                            </li>
                                        {/foreach}
                                    </ul>

                                    <div class="mt-auto">
                                        <button type="button" class="btn btn-outline-primary btn-block" data-toggle="modal" data-target="#customstocktransfer-modal-{$product.id_product|intval}">
                                            Open Transfer Form
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            </div>

            <div id="customstocktransfer-table-view" class="d-none">
                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="thead-light">
                            <tr>
                                <th style="width: 80px;">ID</th>
                                <th>Product</th>
                                <th>Stock by Store</th>
                                <th style="width: 160px;">Status</th>
                                <th style="width: 180px;">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$products item=product}
                                <tr>
                                    <td>{$product.id_product|intval}</td>
                                    <td>{$product.name|escape:'htmlall':'UTF-8'}</td>
                                    <td>
                                        <div class="d-flex flex-wrap">
                                            {foreach from=$product.shops item=productShop}
                                                {assign var=shopQty value=$productShop.quantity_in_this_shop|intval}
                                                {if $shopQty == 0}
                                                    {assign var=badgeClass value='badge-danger'}
                                                {elseif $shopQty <= 5}
                                                    {assign var=badgeClass value='badge-warning'}
                                                {else}
                                                    {assign var=badgeClass value='badge-success'}
                                                {/if}
                                                <div class="mr-2 mb-2">
                                                    <span class="font-weight-bold">{$productShop.shop_name|escape:'htmlall':'UTF-8'}:</span>
                                                    <span class="badge {$badgeClass}">{$shopQty}</span>
                                                </div>
                                            {/foreach}
                                        </div>
                                    </td>
                                    <td>
                                        {if $product.is_low_stock}
                                            <span class="badge badge-warning">[!] LOW STOCK</span>
                                        {else}
                                            <span class="badge badge-success">Healthy</span>
                                        {/if}
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-primary" data-toggle="modal" data-target="#customstocktransfer-modal-{$product.id_product|intval}">
                                            Transfer Stock
                                        </button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>

            {foreach from=$products item=product}
                <div class="modal fade" id="customstocktransfer-modal-{$product.id_product|intval}" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}">
                                <div class="modal-header">
                                    <h5 class="modal-title">Transfer Stock - #{$product.id_product|intval} {$product.name|escape:'htmlall':'UTF-8'}</h5>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span>
                                    </button>
                                </div>

                                <div class="modal-body">
                                    <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                    <input type="hidden" name="id_product" value="{$product.id_product|intval}">

                                    <div class="row">
                                        <div class="col-12 col-md-4">
                                            <div class="form-group">
                                                <label for="source_shop_{$product.id_product|intval}">Source Store</label>
                                                <select id="source_shop_{$product.id_product|intval}" name="source_shop_id" class="form-control" required>
                                                    <option value="">Select source store</option>
                                                    {foreach from=$shops item=shop}
                                                        <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                                                    {/foreach}
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-4">
                                            <div class="form-group">
                                                <label for="destination_shop_{$product.id_product|intval}">Destination Store</label>
                                                <select id="destination_shop_{$product.id_product|intval}" name="destination_shop_id" class="form-control" required>
                                                    <option value="">Select destination store</option>
                                                    {foreach from=$shops item=shop}
                                                        <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                                                    {/foreach}
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-4">
                                            <div class="form-group">
                                                <label for="quantity_{$product.id_product|intval}">Quantity</label>
                                                <input id="quantity_{$product.id_product|intval}" type="number" name="quantity" min="1" step="1" value="1" class="form-control" required>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="alert alert-info mb-0">
                                        Choose a source store with available stock and a different destination store.
                                    </div>
                                </div>

                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                    <button type="submit" name="submitCustomStockTransfer" value="1" class="btn btn-primary">
                                        Transfer Stock
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            {/foreach}
        {else}
            <div class="alert alert-warning mb-0">No active products were found.</div>
        {/if}
    </div>
</div>

<script>
    (function ($) {
        function setView(view) {
            var isGrid = view === 'grid';

            $('#customstocktransfer-grid-view').toggleClass('d-none', !isGrid);
            $('#customstocktransfer-table-view').toggleClass('d-none', isGrid);

            $('.js-stock-view-toggle').removeClass('active');
            $('.js-stock-view-toggle[data-view="' + view + '"]').addClass('active');
        }

        $(function () {
            $('.js-stock-view-toggle').on('click', function () {
                setView($(this).data('view'));
            });

            setView('grid');
        });
    })(jQuery);
</script>