{assign var=product_count value=$order_details|@count}
{assign var=total_quantity value=0}

{foreach from=$order_details item=order_detail}
    {assign var=total_quantity value=$total_quantity + $order_detail.product_quantity}
{/foreach}

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <!-- INVOICE, Date, Number, and Barcode on the right -->
        <td width="50%" align="right" valign="top">
            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td width="50%" align="right" style="font-size: 10pt; color: #555555; font-weight: bold;">Invoice Date:</td>
                    <td width="50%" align="right" style="font-size: 10pt; color: #333333;">
                        {dateFormat date=$order->date_add full=0}
                    </td>
                </tr>
                <tr>
                    <td width="50%" align="right" style="font-size: 10pt; color: #555555; font-weight: bold;">Invoice Number:</td>
                    <td width="50%" align="right" style="font-size: 10pt; color: #333333;">
                        {if isset($title)}
                            {$title|escape:'html':'UTF-8'}
                        {elseif isset($order_invoice->number) && $order_invoice->number}
                            #{$order_invoice->number|string_format:"%06d"}
                        {else}
                            {$order->reference}
                        {/if}
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="right" style="padding-top: 15px;">

                        <!-- Outputting the PHP-generated Barcode -->
                        {if isset($custom_barcode) && $custom_barcode}
                            {$custom_barcode}
                        {else}
                            <span style="color:red; font-size: 8pt;">Barcode generation failed. Check PHP override.</span>
                        {/if}

                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>