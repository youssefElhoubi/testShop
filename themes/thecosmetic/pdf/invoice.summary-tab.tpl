{assign var=product_count value=$order_details|@count}
{assign var=total_quantity value=0}

{foreach from=$order_details item=order_detail}
	{assign var=total_quantity value=$total_quantity + $order_detail.product_quantity}
{/foreach}

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<!-- Logo on the left -->
		<td width="50%" align="left" valign="top">
			{if $logo_path}
				<img src="{$logo_path}" style="width:{$width_logo}px; height:{$height_logo}px;" />
			{/if}
		</td>
		
		<!-- INVOICE, Date, Number on the right -->
		<td width="50%" align="right" valign="top">
			<span style="font-size: 24pt; font-weight: bold; color: #333333;">INVOICE</span><br /><br />
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td width="50%" align="right" style="font-size: 10pt; color: #555555; font-weight: bold;">Invoice Date:</td>
					<td width="50%" align="right" style="font-size: 10pt; color: #333333;">{dateFormat date=$order->date_add full=0}</td>
				</tr>
				<tr>
					<td width="50%" align="right" style="font-size: 10pt; color: #555555; font-weight: bold;">Invoice Number:</td>
					<td width="50%" align="right" style="font-size: 10pt; color: #333333;">{if isset($order_invoice->number) && $order_invoice->number}{$title|escape:'html':'UTF-8'}{else}{$order->reference}{/if}</td>
				</tr>
			</table>
		</td>
	</tr>
</table>