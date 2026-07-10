<?php

class HTMLTemplateInvoice extends HTMLTemplateInvoiceCore
{
    public function getContent()
    {
        // Generate the barcode HTML using native TCPDFBarcode class
        $barcode = new TCPDFBarcode($this->order->reference, 'C128');
        // getBarcodeHTML(width, height, color)
        $custom_barcode = $barcode->getBarcodeHTML(1, 15, 'black');

        // Assign the generated HTML string to a Smarty variable
        $this->smarty->assign(array(
            'custom_barcode' => $custom_barcode
        ));

        // Return parent method to maintain default behavior
        return parent::getContent();
    }
}
