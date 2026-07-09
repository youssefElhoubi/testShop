<table width="100%" border="0" cellpadding="0" cellspacing="0" class="address-table">
	<tr>
		<td width="50%" class="address-box" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="section-title">ADRESSE DE LIVRAISON</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Prénom/Nom:</span>
						{$addresses.delivery->firstname|escape:'html':'UTF-8'} {$addresses.delivery->lastname|escape:'html':'UTF-8'}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Adresse:</span>
						{$addresses.delivery->address1|escape:'html':'UTF-8'}{if $addresses.delivery->address2}, {$addresses.delivery->address2|escape:'html':'UTF-8'}{/if}{if $addresses.delivery->postcode} - {$addresses.delivery->postcode|escape:'html':'UTF-8'}{/if} {$addresses.delivery->city|escape:'html':'UTF-8'}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Ville:</span>
						{$addresses.delivery->city|escape:'html':'UTF-8'}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Tél. :</span>
						{if $addresses.delivery->phone_mobile}{$addresses.delivery->phone_mobile|escape:'html':'UTF-8'}{elseif $addresses.delivery->phone}{$addresses.delivery->phone|escape:'html':'UTF-8'}{/if}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">E-mail:</span>
						{$customer.email|escape:'html':'UTF-8'}
					</td>
				</tr>
			</table>
		</td>
		<td width="50%" valign="top">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td class="section-title">ADRESSE DE FACTURATION</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Prénom/Nom:</span>
						{$addresses.invoice->firstname|escape:'html':'UTF-8'} {$addresses.invoice->lastname|escape:'html':'UTF-8'}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Adresse:</span>
						{$addresses.invoice->address1|escape:'html':'UTF-8'}{if $addresses.invoice->address2}, {$addresses.invoice->address2|escape:'html':'UTF-8'}{/if}{if $addresses.invoice->postcode} - {$addresses.invoice->postcode|escape:'html':'UTF-8'}{/if} {$addresses.invoice->city|escape:'html':'UTF-8'}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Ville:</span>
						{$addresses.invoice->city|escape:'html':'UTF-8'}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">Tél. :</span>
						{if $addresses.invoice->phone_mobile}{$addresses.invoice->phone_mobile|escape:'html':'UTF-8'}{elseif $addresses.invoice->phone}{$addresses.invoice->phone|escape:'html':'UTF-8'}{/if}
					</td>
				</tr>
				<tr>
					<td class="address-line">
						<span class="bold">E-mail:</span>
						{$customer.email|escape:'html':'UTF-8'}
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>