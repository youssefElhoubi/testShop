{assign var=promo_count value=$cart_rules|@count}
{assign var=remaining_amount value=$order->total_paid_tax_incl - $order->total_paid_real}
{if $remaining_amount < 0}
	{assign var=remaining_amount value=0}
{/if}

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <!-- Blank Left Column for layout spacing -->
        <td width="50%"></td>
        
        <!-- Right Column containing Totals -->
        <td width="50%">
            <table width="100%" border="0" cellpadding="8" cellspacing="0">
                {if $promo_count}
                <tr>
                    <td width="60%" style="text-align: left; color: #555555; border-bottom: 1px solid #eeeeee;">Code promo:</td>
                    <td width="40%" style="text-align: right; color: #333333; border-bottom: 1px solid #eeeeee;">
                        {foreach from=$cart_rules item=cart_rule name=promo_loop}
                            {$cart_rule.name|escape:'html':'UTF-8'}{if !$smarty.foreach.promo_loop.last}<br />{/if}
                        {/foreach}
                    </td>
                </tr>
                {/if}
                <tr>
                    <td width="60%" style="text-align: left; color: #555555; border-bottom: 1px solid #eeeeee;">Total produits:</td>
                    <td width="40%" style="text-align: right; color: #333333; border-bottom: 1px solid #eeeeee;">{displayPrice currency=$order->id_currency price=$footer.products_before_discounts_tax_incl}</td>
                </tr>
                <tr>
                    <td width="60%" style="text-align: left; color: #555555; border-bottom: 1px solid #eeeeee;">Dont TVA:</td>
                    <td width="40%" style="text-align: right; color: #333333; border-bottom: 1px solid #eeeeee;">{displayPrice currency=$order->id_currency price=$footer.total_taxes}</td>
                </tr>
                <tr>
                    <td width="60%" style="text-align: left; color: #555555; border-bottom: 1px solid #eeeeee;">Frais d'expédition:</td>
                    <td width="40%" style="text-align: right; color: #333333; border-bottom: 1px solid #eeeeee;">{displayPrice currency=$order->id_currency price=$footer.shipping_tax_incl}</td>
                </tr>
                <!-- Balance Due -->
                <tr>
                    <td width="60%" style="background-color: #b5d5b6; text-align: left; color: #385b4f; font-weight: bold; font-size: 11pt;">BALANCE DUE (TTC):</td>
                    <td width="40%" style="background-color: #b5d5b6; text-align: right; color: #385b4f; font-weight: bold; font-size: 11pt;">{displayPrice currency=$order->id_currency price=$footer.total_paid_tax_incl}</td>
                </tr>
                {if $remaining_amount > 0}
                <tr>
                    <td width="60%" style="text-align: left; color: #555555; padding-top: 10px;">Reste à payer:</td>
                    <td width="40%" style="text-align: right; color: #333333; padding-top: 10px;">{displayPrice currency=$order->id_currency price=$remaining_amount}</td>
                </tr>
                {/if}
            </table>
        </td>
    </tr>
</table>