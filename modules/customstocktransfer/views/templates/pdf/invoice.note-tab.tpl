{if isset($order_invoice->note) && $order_invoice->note}
	<table width="100%" border="0" cellpadding="0" cellspacing="0" class="note-table">
		<tr>
			<td class="note-title">NOTE</td>
		</tr>
		<tr>
			<td class="note-body">{$order_invoice->note|escape:'html':'UTF-8'|nl2br}</td>
		</tr>
	</table>
{/if}