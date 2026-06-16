{if isset($my_dynamic_products) && $my_dynamic_products}
            <div class="custom-dynamic-section" style="margin-top: 30px;">
                <h3>Our Latest Products</h3>
                <hr>
                <div class="products row">
                    {foreach from=$my_dynamic_products item=product}
                        <div class="col-md-4" style="margin-bottom: 20px; padding: 15px; border: 1px solid #ddd;">
                            <h4>{$product.name}</h4>
                            <p><strong>Price:</strong> {$product.price|number_format:2} USD</p>
                            <p>{$product.description_short|strip_tags}</p>
                        </div>
                    {/foreach}
                </div>
            </div>
        {/if}