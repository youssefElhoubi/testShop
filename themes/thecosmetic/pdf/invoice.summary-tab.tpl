{assign var=product_count value=$order_details|@count}
{assign var=total_quantity value=0}

{foreach from=$order_details item=order_detail}
    {assign var=total_quantity value=$total_quantity + $order_detail.product_quantity}
{/foreach}

<table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr>
        <!-- Left: Title & Info -->
        <td width="50%" valign="top">
            <span class="title-sales"><b>Sales</b> <span>Invoice</span></span>
            <br /><br /><br />
            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td width="100%" style="border-left: 2px solid #F44336;">
                        <table width="100%" border="0" cellpadding="2" cellspacing="0">
                            <tr>
                                <td width="50%" class="info-label">&nbsp;&nbsp;INVOICE NUMBER</td>
                                <td width="50%" class="info-value">{if isset($order_invoice->number) && $order_invoice->number}{$title|escape:'html':'UTF-8'}{else}{$order->reference}{/if}</td>
                            </tr>
                            <tr>
                                <td width="50%" class="info-label">&nbsp;&nbsp;ORDER</td>
                                <td width="50%" class="info-value">{$order->reference}</td>
                            </tr>
                            <tr>
                                <td width="50%" class="info-label">&nbsp;&nbsp;ORDER DATE</td>
                                <td width="50%" class="info-value">{dateFormat date=$order->date_add full=0}</td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </td>

        <!-- Right: Logo & Barcode -->
        <td width="50%" align="right" valign="top">
            {if $logo_path}
                <img src="{$logo_path}" style="width:{$width_logo}px; height:{$height_logo}px;" />
            {/if}
            <br /><br /><br />
            {if isset($custom_barcode) && $custom_barcode}
                {$custom_barcode}
            {else}
                <span style="color:red; font-size: 8pt;">Barcode generation failed. Check PHP override.</span>
            {/if}
        </td>
    </tr>
</table>