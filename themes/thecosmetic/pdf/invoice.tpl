{$style_tab}

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<!-- Header Banner -->

	<!-- Massive Title -->
	<tr>
		<td colspan="12" style="text-align: center; padding: 40px 0;">
			<span
				style="font-family: 'Times New Roman', Times, serif; font-size: 35pt; font-weight: bold; color: #333333;">INVOICE</span>
		</td>
	</tr>

	<tr>
		<td colspan="12" height="15">&nbsp;</td>
	</tr>

	<tr>
		<td colspan="12">{$summary_tab}</td>
	</tr>

	<!-- Addresses -->
	<tr>
		<td colspan="12">{$addresses_tab}</td>
	</tr>


	<tr>
		<td colspan="12" height="30">&nbsp;</td>
	</tr>

	<!-- Products Table -->
	<tr>
		<td colspan="12">{$product_tab}</td>
	</tr>

	<tr>
		<td colspan="12" height="30">&nbsp;</td>
	</tr>

	<!-- Totals -->
	<tr>
		<td colspan="12">{$total_tab}</td>
	</tr>

	{if isset($note_tab) && $note_tab}
		<tr>
			<td colspan="12" height="20">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="12">{$note_tab}</td>
		</tr>
	{/if}

	<tr>
		<td colspan="12" height="50">&nbsp;</td>
	</tr>

	<!-- Thick Footer Bar -->
	<tr>
		<td colspan="12" style="padding:0;">

			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr>

					<!-- Red accent -->
					<td width="8" bgcolor="#F44336">&nbsp;</td>

					<!-- Footer -->
					<td bgcolor="#F8F8F8" style="padding:18px 25px;">

						<span style="font-size:11pt;font-weight:bold;color:#333333;">
							Thank you for your order!
						</span>

						<br /><br />

						<span style="font-size:9pt;color:#555555;font-weight:bold;">
							Société MOUNAW SARL
						</span>

						<br />

						<span style="font-size:8.5pt;color:#777777;">
							M5, Imm N:A1 Angle Rue Alhodal Et Rue Ananas,
							Hay Riad - Rabat
						</span>

						<br />

						<span style="font-size:8.5pt;color:#777777;">
							+212 6 50 66 59 33
						</span>

					</td>

				</tr>
			</table>

		</td>
	</tr>
</table>