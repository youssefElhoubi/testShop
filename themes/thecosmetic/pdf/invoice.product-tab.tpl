<table width="100%" border="0" cellpadding="8" cellspacing="0">
	<thead>
		<tr style="background-color: #1789FC; color: #FFFFFF;">
			<th width="60%" style="text-align: left; font-weight: bold; font-size: 10pt;">DESCRIPTION</th>
			<th width="20%" style="text-align: right; font-weight: bold; font-size: 10pt;">UNIT PRICE</th>
			<th width="20%" style="text-align: right; font-weight: bold; font-size: 10pt;">TOTAL</th>
		</tr>
	</thead>
	<tbody>
		{foreach from=$order_details item=order_detail}
			<tr>
				<td width="60%" style="border-bottom: 1px solid #E0E0E0; text-align: left; vertical-align: middle;">
					<span style="font-weight: bold; color: #333333; font-size: 10pt;">{$order_detail.product_name|escape:'html':'UTF-8'}</span><br />
					<span style="font-size: 8pt; color: #777777;">
						Stock Available: {StockAvailable::getQuantityAvailableByProduct($order_detail.product_id, $order_detail.product_attribute_id)} | Reserved: 0 | Qty: {$order_detail.product_quantity|escape:'html':'UTF-8'}
					</span>
				</td>
				<td width="20%" style="border-bottom: 1px solid #E0E0E0; text-align: right; vertical-align: middle; color: #333333; font-size: 9.5pt;">
					{displayPrice currency=$order->id_currency price=$order_detail.unit_price_tax_incl}
				</td>
				<td width="20%" style="border-bottom: 1px solid #E0E0E0; text-align: right; vertical-align: middle; color: #333333; font-size: 9.5pt;">
					{displayPrice currency=$order->id_currency price=$order_detail.total_price_tax_incl}
				</td>
			</tr>
		{/foreach}
	</tbody>
</table>