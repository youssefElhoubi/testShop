{assign var=promo_count value=$cart_rules|@count}
{assign var=remaining_amount value=$order->total_paid_tax_incl - $order->total_paid_real}
{if $remaining_amount < 0}
	{assign var=remaining_amount value=0}
{/if}

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <td width="50%"></td>
        <td width="50%">
            <table width="100%" border="0" cellpadding="8" cellspacing="0">
                <tr>
                    <td width="60%" align="right" class="total-label" style="border-bottom: 1px solid #E5E5E5;">Subtotal</td>
                    <td width="40%" align="right" class="total-value" style="border-bottom: 1px solid #E5E5E5;">{displayPrice currency=$order->id_currency price=$footer.products_before_discounts_tax_incl}</td>
                </tr>
                {if $promo_count}
                <tr>
                    <td width="60%" align="right" class="total-label" style="border-bottom: 1px solid #E5E5E5;">Discount</td>
                    <td width="40%" align="right" class="total-value" style="border-bottom: 1px solid #E5E5E5;">
                        {foreach from=$cart_rules item=cart_rule name=promo_loop}
                            -{$cart_rule.name|escape:'html':'UTF-8'}{if !$smarty.foreach.promo_loop.last}<br />{/if}
                        {/foreach}
                    </td>
                </tr>
                {/if}
                <tr>
                    <td width="60%" align="right" class="total-label" style="border-bottom: 1px solid #E5E5E5;">Tax</td>
                    <td width="40%" align="right" class="total-value" style="border-bottom: 1px solid #E5E5E5;">{displayPrice currency=$order->id_currency price=$footer.total_taxes}</td>
                </tr>
                <tr>
                    <td width="60%" align="right" class="total-label" style="border-bottom: 1px solid #E5E5E5;">Shipping</td>
                    <td width="40%" align="right" class="total-value" style="border-bottom: 1px solid #E5E5E5;">{displayPrice currency=$order->id_currency price=$footer.shipping_tax_incl}</td>
                </tr>
                <tr>
                    <td width="60%" align="right" class="grand-total-label" style="padding-top: 15px;">Grand Total</td>
                    <td width="40%" align="right" class="grand-total-value" style="padding-top: 15px; color: #F44336;">{displayPrice currency=$order->id_currency price=$footer.total_paid_tax_incl}</td>
                </tr>
                {if $remaining_amount > 0}
                <tr>
                    <td width="60%" align="right" class="total-label" style="padding-top: 10px;">Balance Due</td>
                    <td width="40%" align="right" class="total-value" style="padding-top: 10px;">{displayPrice currency=$order->id_currency price=$remaining_amount}</td>
                </tr>
                {/if}
            </table>
        </td>
    </tr>
</table>