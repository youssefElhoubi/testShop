{extends file='page.tpl'}

{block name='page_title'}
    Custom Category Catalog
{/block}

{block name='page_content'}
    <div class="custom-catalog-wrapper">

        {* Modern Navigation Bar *}
        <nav class="custom-category-nav">
            {* Safe URL separator check *}
            {assign var="separator" value="?"}
            {if $controller_url|strpos:"?" !== false}
                {assign var="separator" value="&"}
            {/if}

            <ul>
                <li>
                    <a href="{$controller_url}" class="{if $current_category == 0}active{/if}">
                        All Products
                    </a>
                </li>
                {foreach from=$custom_categories item=category}
                    <li>
                        <a href="{$controller_url}{$separator}id_category={$category.id_category}" class="{if $current_category == $category.id_category}active{/if}">
                            {$category.name}
                        </a>
                    </li>
                {/foreach}
            </ul>
        </nav>

        {* Product Grid *}
        <div class="custom-product-grid">
            {foreach from=$custom_products item=product}

                <a href="{$product.product_url}" class="custom-product-card">
                    {if $product.image_url}
                        <div class="product-image-container">
                            <img src="{$product.image_url}" alt="{$product.product_name}" class="custom-product-image">
                        </div>
                    {/if}

                    <div class="product-info">
                        <div class="category-badge">{$product.category_name}</div>
                        <h3>{$product.product_name}</h3>
                        <div class="reference">Ref: {$product.reference}</div>
                        {* The new Price tag *}
                        <div class="product-price">{$product.price}</div>
                    </div>
                </a>

            {foreachelse}
                <div class="alert alert-warning" style="width: 100%;">
                    No products found in this category.
                </div>
            {/foreach}
        </div>

    </div>
{/block}