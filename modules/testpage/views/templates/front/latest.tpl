{extends file='page.tpl'}

{block name='page_content'}
    {* <div style="background: red; color: white; padding: 20px; font-size: 20px; font-weight: bold; text-align: center;">
        THE REAL FRIENDLY URL IS: {$link->getModuleLink('testpage', 'view')}
    </div> *}
    
    {hook h='displayCustomHook'}
    <div class="custom-module-section" style="margin-top: 30px;">
        <h2>Our Latest (Loaded from Module)</h2>
        <hr>
        {if isset($latest_products) && $latest_products}
            <div class="products row">
                {foreach from=$latest_products item=product}
                    <div class="col-md-4" style="margin-bottom: 20px; padding: 15px; border: 1px solid #ddd;">
                        <h4>{$product.name}</h4>
                        <p><strong>Price:</strong> {$product.price|number_format:2} USD</p>
                        <p>{$product.description_short|strip_tags}</p>
                    </div>
                {/foreach}
            </div>
        {else}
            <p>No products found.</p>
        {/if}
    </div>
{/block}