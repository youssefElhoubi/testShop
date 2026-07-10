{assign var=product_count value=$order_details|@count}
{assign var=total_quantity value=0}

{foreach from=$order_details item=order_detail}
	{assign var=total_quantity value=$total_quantity + $order_detail.product_quantity}
{/foreach}

<table width="100%" border="0" cellpadding="0" cellspacing="0" class="summary-table">
	<tr>
		<td class="left">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td><span class="summary-label">FACTURE/</span></td>
					<td>
						<table border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td>
									<tcpdf method="write1DBarcode" params="'{$title|escape:'html':'UTF-8'}', 'C128', '', '', '', 15, 0.4, '', 'N'" />
								</td>
							</tr>
							<tr>
								<td class="summary-value">
									#{$title|escape:'html':'UTF-8'}
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="left">
			<span class="summary-label">COMMANDE/</span>
			<span class="summary-value">{$order->id|escape:'html':'UTF-8'}</span>
		</td>
	</tr>
	<tr>
		<td class="left">
			<span class="summary-label">DATE DE COMMANDE/</span>
			<span class="summary-value">{dateFormat date=$order->date_add full=1}</span>
		</td>
	</tr>
	<tr>
		<td class="left">
			<span
				class="summary-label">{$total_quantity|escape:'html':'UTF-8'}/{$product_count|escape:'html':'UTF-8'}</span>
			<span class="summary-value">Quantité d'articles / Nombre de produits</span>
		</td>
	</tr>
</table>