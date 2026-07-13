<table width="100%" border="0" cellpadding="0" cellspacing="0" style="text-align: center;">
    <tr>
        <td align="center">
            <span style="font-size: 14pt; font-weight: bold; color: #333333;">Thank you for your order!</span>
            <br /><br />
            <span style="font-size: 9pt; color: #777777;">
                If you have questions about your order, contact us at:<br />
                support@example.com
            </span>
            <br /><br />
            <span style="font-size: 8pt; color: #999999;">
                {$shop_address|escape:'html':'UTF-8'}<br />
                {if isset($shop_details) && !empty($shop_details)}{$shop_details|escape:'html':'UTF-8'}{/if}
            </span>
        </td>
    </tr>
</table>
