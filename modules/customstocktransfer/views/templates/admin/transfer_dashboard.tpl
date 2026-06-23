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
    <h3>
        <i class="icon-exchange"></i>
        Stock transfer dashboard
    </h3>

    {if $products|count}
        <div class="row">
            <div class="col-lg-12">
                {foreach from=$products item=product}
                    <div class="panel" style="margin-bottom: 15px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; gap: 15px;">
                            <div>
                                <strong>#{$product.id_product|intval}</strong> - {$product.name|escape:'htmlall':'UTF-8'}
                                <span style="margin-left: 8px;">Total: {$product.total_quantity|intval}</span>
                                {if $product.is_low_stock}
                                    <span style="margin-left: 8px; color: #c9302c; font-weight: bold;">[!] LOW STOCK</span>
                                {/if}
                            </div>
                        </div>

                        <details style="margin-top: 10px;">
                            <summary style="cursor: pointer;">View stock by store</summary>
                            <ul style="margin: 10px 0 0 20px;">
                                {foreach from=$product.shops item=productShop}
                                    <li>
                                        {$productShop.shop_name|escape:'htmlall':'UTF-8'}: {$productShop.quantity_in_this_shop|intval}
                                    </li>
                                {/foreach}
                            </ul>
                        </details>

                        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" style="margin-top: 15px;">
                            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                            <input type="hidden" name="id_product" value="{$product.id_product|intval}">

                            <div class="form-group" style="display: flex; flex-wrap: wrap; gap: 10px; align-items: end;">
                                <div>
                                    <label for="source_shop_{$product.id_product|intval}">Source Store</label><br>
                                    <select id="source_shop_{$product.id_product|intval}" name="source_shop_id" class="fixed-width-xl" required>
                                        <option value="">-- Select --</option>
                                        {foreach from=$shops item=shop}
                                            <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                                        {/foreach}
                                    </select>
                                </div>

                                <div>
                                    <label for="destination_shop_{$product.id_product|intval}">Destination Store</label><br>
                                    <select id="destination_shop_{$product.id_product|intval}" name="destination_shop_id" class="fixed-width-xl" required>
                                        <option value="">-- Select --</option>
                                        {foreach from=$shops item=shop}
                                            <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'htmlall':'UTF-8'}</option>
                                        {/foreach}
                                    </select>
                                </div>

                                <div>
                                    <label for="quantity_{$product.id_product|intval}">Transfer Quantity</label><br>
                                    <input id="quantity_{$product.id_product|intval}" type="number" name="quantity" min="1" step="1" value="1" required>
                                </div>

                                <div>
                                    <button type="submit" name="submitCustomStockTransfer" value="1" class="btn btn-primary">
                                        Transfer Stock
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                {/foreach}
            </div>
        </div>
    {else}
        <div class="alert alert-warning">No active products were found.</div>
    {/if}
</div>