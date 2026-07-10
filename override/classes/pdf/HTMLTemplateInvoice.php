<?php

class HTMLTemplateInvoice extends HTMLTemplateInvoiceCore
{
    public function getContent()
    {
        // 1. Initialize the native TCPDF barcode generator
        $barcode = new TCPDFBarcode($this->order->reference, 'C128');
        
        // 2. Generate raw PNG image data (bar width: 1, height: 15, color: black)
        $png_data = $barcode->getBarcodePngData(1, 15, array(0, 0, 0));
        
        // 3. Convert to a base64 inline image tag that TCPDF can parse natively
        $custom_barcode = '<img src="@' . base64_encode($png_data) . '" />';

            // 4. Assign the image tag to the Smarty template
        $this->smarty->assign(array(
            'custom_barcode' => $custom_barcode
        ));

        // 5. Return the core content to maintain default behavior
        return parent::getContent();
    }
}