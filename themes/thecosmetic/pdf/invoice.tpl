{$style_tab}

<table width="100%" border="0" cellpadding="0" cellspacing="0" id="invoice-body">
	<tr>
		<td colspan="12">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td align="center"><h2>UNIVERS PARADISCOUNT</h2></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td colspan="12" height="8">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$summary_tab}</td>
	</tr>

	<tr>
		<td colspan="12" height="8">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$addresses_tab}</td>
	</tr>

	<tr>
		<td colspan="12" height="6">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$payment_tab}</td>
	</tr>

	<tr>
		<td colspan="12" height="4">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$shipping_tab}</td>
	</tr>

	<tr>
		<td colspan="12" height="10">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$product_tab}</td>
	</tr>

	<tr>
		<td colspan="12" height="10">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$total_tab}</td>
	</tr>

	{if isset($note_tab) && $note_tab}
		<tr>
			<td colspan="12" height="10">&nbsp;</td>
		</tr>

		<tr>
			<td colspan="12">{$note_tab}</td>
		</tr>
	{/if}

	<tr>
		<td colspan="12" height="12">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">
			<table width="100%" border="0" cellpadding="0" cellspacing="0" class="footer-box">
				<tr>
					<td width="50%" class="footer-brand-box">
						<span class="footer-thanks">MERCI POUR VOTRE CONFIANCE</span><br />
						<span class="footer-brand-details">
							<strong>UNIVERS PARADISCOUNT</strong><br />
							<a href="https://universparadiscount.ma">https://universparadiscount.ma</a><br />
							FACEBOOK: <strong>UNIVERSPARADISCOUNT</strong><br />
							INSTAGRAM: <strong>UNIVERSPARADISCOUNT</strong>
						</span>
					</td>
					<td width="50%" class="footer-legal-box">
						<span class="footer-legal-title">Société MOUNAW SARL</span><br />
						<span class="footer-legal-details">
							<strong>IF:</strong> 42752584 &nbsp;|&nbsp; <strong>RC:</strong> 143141 &nbsp;|&nbsp; <strong>ICE:</strong> 002405878000060<br />
							<strong>Tél:</strong> +212 6 50 66 59 33<br />
							<strong>Adresse:</strong> M5, Imm N: A1 Angle Rue Alhodal<br />
							Et Rue Ananas, Hay Riad - Rabat
						</span>
					</td>
				</tr>
			</table>
		</td>
	</tr>

</table>