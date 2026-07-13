<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <!-- Left Column: Billing & Payment -->
        <td width="50%" valign="top">
            <span class="section-title">BILLING TO</span><br />
            <span style="font-size: 9.5pt; color: #333333; font-weight: bold;">
                {$addresses.invoice->firstname|escape:'html':'UTF-8'} {$addresses.invoice->lastname|escape:'html':'UTF-8'}
            </span>
            <br />
            <span style="font-size: 9pt; color: #333333;">
                {$addresses.invoice->address1|escape:'html':'UTF-8'}
                {if $addresses.invoice->address2}<br />{$addresses.invoice->address2|escape:'html':'UTF-8'}{/if}
                <br />
                {if $addresses.invoice->postcode}{$addresses.invoice->postcode|escape:'html':'UTF-8'} {/if}{$addresses.invoice->city|escape:'html':'UTF-8'}
                <br />
                {if $addresses.invoice->phone_mobile}{$addresses.invoice->phone_mobile|escape:'html':'UTF-8'}{elseif $addresses.invoice->phone}{$addresses.invoice->phone|escape:'html':'UTF-8'}{/if}
                <br />
                {$customer->email|escape:'html':'UTF-8'}
            </span>
            <br /><br />
            <span class="section-title">PAYMENT METHOD</span><br />
            <span style="font-size: 9pt; color: #333333;">{$order->payment|escape:'html':'UTF-8'}</span>
        </td>

        <!-- Right Column: Shipping -->
        <td width="50%" valign="top">
            <span class="section-title">SHIP TO</span><br />
            <span style="font-size: 9.5pt; color: #333333; font-weight: bold;">
                {$addresses.delivery->firstname|escape:'html':'UTF-8'} {$addresses.delivery->lastname|escape:'html':'UTF-8'}
            </span>
            <br />
            <span style="font-size: 9pt; color: #333333;">
                {$addresses.delivery->address1|escape:'html':'UTF-8'}
                {if $addresses.delivery->address2}<br />{$addresses.delivery->address2|escape:'html':'UTF-8'}{/if}
                <br />
                {if $addresses.delivery->postcode}{$addresses.delivery->postcode|escape:'html':'UTF-8'} {/if}{$addresses.delivery->city|escape:'html':'UTF-8'}
                <br />
                {if $addresses.delivery->phone_mobile}{$addresses.delivery->phone_mobile|escape:'html':'UTF-8'}{elseif $addresses.delivery->phone}{$addresses.delivery->phone|escape:'html':'UTF-8'}{/if}
            </span>
            <br /><br />
            <span class="section-title">SHIPPING METHOD</span><br />
            <span style="font-size: 9pt; color: #333333;">Standard Delivery</span>
        </td>
    </tr>
</table>