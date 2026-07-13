<table width="100%" border="0" cellpadding="8" cellspacing="0">
    <thead>
        <tr>
            <th width="60%" class="product-th" align="left">ITEMS</th>
            <th width="20%" class="product-th" align="center">QTY</th>
            <th width="20%" class="product-th" align="right">SUBTOTAL</th>
        </tr>
    </thead>
    <tbody>
        {foreach from=$order_details item=order_detail}
            <tr>
                <td width="60%" class="product-td" align="left">
                    <span class="product-name">{$order_detail.product_name|escape:'html':'UTF-8'}</span><br />
                    <span class="product-meta">
                        {if !empty($order_detail.product_reference)}SKU: {$order_detail.product_reference|escape:'html':'UTF-8'} | {/if}Stock Available: {StockAvailable::getQuantityAvailableByProduct($order_detail.product_id, $order_detail.product_attribute_id)} | Reserved: 0
                    </span>
                </td>
                <td width="20%" class="product-td" align="center" style="font-size: 9.5pt; color: #333333;">
                    {$order_detail.product_quantity|escape:'html':'UTF-8'}
                </td>
                <td width="20%" class="product-td" align="right" style="font-size: 9.5pt; color: #333333;">
                    {displayPrice currency=$order->id_currency price=$order_detail.total_price_tax_incl}
                </td>
            </tr>
        {/foreach}
    </tbody>
</table>