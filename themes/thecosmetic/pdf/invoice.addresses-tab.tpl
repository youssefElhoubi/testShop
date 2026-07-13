<table width="100%" border="0" cellpadding="5" cellspacing="0">
    <tr>
        <!-- Billing Address -->
        <td width="50%" style="text-align: left; vertical-align: top;">
            <span style="color: #385b4f; font-weight: bold; font-size: 11pt;">Bill to:</span><br /><br />
            <span style="font-size: 9.5pt; color: #333333; line-height: 1.4;">
                {$addresses.invoice->firstname|escape:'html':'UTF-8'} {$addresses.invoice->lastname|escape:'html':'UTF-8'}<br />
                {$addresses.invoice->address1|escape:'html':'UTF-8'}{if $addresses.invoice->address2}<br />{$addresses.invoice->address2|escape:'html':'UTF-8'}{/if}<br />
                {if $addresses.invoice->postcode}{$addresses.invoice->postcode|escape:'html':'UTF-8'} {/if}{$addresses.invoice->city|escape:'html':'UTF-8'}<br />
                {if $addresses.invoice->phone_mobile}{$addresses.invoice->phone_mobile|escape:'html':'UTF-8'}{elseif $addresses.invoice->phone}{$addresses.invoice->phone|escape:'html':'UTF-8'}{/if}<br />
                {$customer->email|escape:'html':'UTF-8'}
            </span>
        </td>
        <!-- Shipping Address -->
        <td width="50%" style="text-align: left; vertical-align: top;">
            <span style="color: #385b4f; font-weight: bold; font-size: 11pt;">Ship to:</span><br /><br />
            <span style="font-size: 9.5pt; color: #333333; line-height: 1.4;">
                {$addresses.delivery->firstname|escape:'html':'UTF-8'} {$addresses.delivery->lastname|escape:'html':'UTF-8'}<br />
                {$addresses.delivery->address1|escape:'html':'UTF-8'}{if $addresses.delivery->address2}<br />{$addresses.delivery->address2|escape:'html':'UTF-8'}{/if}<br />
                {if $addresses.delivery->postcode}{$addresses.delivery->postcode|escape:'html':'UTF-8'} {/if}{$addresses.delivery->city|escape:'html':'UTF-8'}<br />
                {if $addresses.delivery->phone_mobile}{$addresses.delivery->phone_mobile|escape:'html':'UTF-8'}{elseif $addresses.delivery->phone}{$addresses.delivery->phone|escape:'html':'UTF-8'}{/if}<br />
                {$customer->email|escape:'html':'UTF-8'}
            </span>
        </td>
    </tr>
</table>