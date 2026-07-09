{assign var=promo_count value=$cart_rules|@count}
{assign var=remaining_amount value=$order->total_paid_tax_incl - $order->total_paid_real}
{if $remaining_amount < 0}
	{assign var=remaining_amount value=0}
{/if}

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="total-table">
	<tr>
		<td class="total-label">Code promo:</td>
		<td class="total-value">
			{if $promo_count}
				{foreach from=$cart_rules item=cart_rule name=promo_loop}
					{$cart_rule.name|escape:'html':'UTF-8'}{if !$smarty.foreach.promo_loop.last}<br />{/if}
				{/foreach}
			{/if}
		</td>
	</tr>
	<tr>
		<td class="total-label">Total produits:</td>
		<td class="total-value">{displayPrice currency=$order->id_currency price=$footer.products_before_discounts_tax_incl}</td>
	</tr>
	<tr>
		<td class="total-label">Dont TVA:</td>
		<td class="total-value">{displayPrice currency=$order->id_currency price=$footer.total_taxes}</td>
	</tr>
	<tr>
		<td class="total-label">Frais d'expédition:</td>
		<td class="total-value">{displayPrice currency=$order->id_currency price=$footer.shipping_tax_incl}</td>
	</tr>
	<tr class="total-emphasis">
		<td class="total-label">Total (TTC):</td>
		<td class="total-value">{displayPrice currency=$order->id_currency price=$footer.total_paid_tax_incl}</td>
	</tr>
	<tr>
		<td class="total-label">Reste à payer:</td>
		<td class="total-value">{displayPrice currency=$order->id_currency price=$remaining_amount}</td>
	</tr>
</table>