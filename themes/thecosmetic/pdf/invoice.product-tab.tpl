{assign var=has_images value=$display_product_images}

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="product-table">
	<thead>
		<tr>
			<th width="12%" class="center">IMAGE</th>
			<th width="54%" class="left">DESCRIPTION</th>
			<th width="8%" class="center">QTÉ</th>
			<th width="13%" class="right">PRIX UNITAIRE</th>
			<th width="13%" class="right">TOTAL ARTICLE</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$order_details item=order_detail}
			<tr>
				<td class="center" valign="middle">
					{if $has_images && isset($order_detail.image) && $order_detail.image->id}
						{$order_detail.image_tag nofilter}
					{else}
						&nbsp;
					{/if}
				</td>
				<td class="left" valign="middle">
					{$order_detail.product_name|escape:'html':'UTF-8'}
				</td>
				<td class="center" valign="middle">{$order_detail.product_quantity|escape:'html':'UTF-8'}</td>
				<td class="right" valign="middle">{displayPrice currency=$order->id_currency price=$order_detail.unit_price_tax_incl}</td>
				<td class="right" valign="middle">{displayPrice currency=$order->id_currency price=$order_detail.total_price_tax_incl}</td>
			</tr>
			<tr>
				<td width="12%" style="background-color: #f9f9f9;"></td>
				<td width="88%" colspan="4" class="left" style="background-color: #f9f9f9; font-size: 8pt;">
					Stock Available: {StockAvailable::getQuantityAvailableByProduct($order_detail.product_id, $order_detail.product_attribute_id)} | Reserved: 0
				</td>
			</tr>
		{/foreach}
	</tbody>
</table>