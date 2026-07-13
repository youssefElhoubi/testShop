{assign var=color_border value="#E5E5E5"}
{assign var=color_header value="#F44336"}
{assign var=color_header_text value="#FFFFFF"}
{assign var=color_text_dark value="#333333"}
{assign var=color_text_light value="#777777"}
{assign var=color_bg value="#FFFFFF"}

<style>
    table {
        border-collapse: collapse;
        border-spacing: 0;
        width: 100%;
    }

    td,
    th {
        font-family: Helvetica, Arial, sans-serif;
        font-size: 9pt;
        color: {$color_text_dark};
        vertical-align: top;
        line-height: 1.5;
    }

    .title-sales {
        font-size: 24pt;
        color: {$color_text_dark};
    }

    .title-sales b {
        font-weight: bold;
    }
    
    .title-sales span {
        font-weight: normal;
    }

    .info-label {
        font-size: 8pt;
        color: {$color_text_light};
        text-transform: uppercase;
    }

    .info-value {
        font-size: 9pt;
        color: {$color_text_dark};
        font-weight: bold;
    }

    .section-title {
        font-size: 8pt;
        color: {$color_header};
        text-transform: uppercase;
        font-weight: bold;
    }

    .product-th {
        background-color: {$color_header};
        color: {$color_header_text};
        font-size: 8pt;
        font-weight: bold;
        text-transform: uppercase;
        padding: 8px;
    }

    .product-td {
        border-bottom: 1px solid {$color_border};
        padding: 10px 8px;
    }

    .product-name {
        font-size: 9pt;
        font-weight: bold;
        color: {$color_text_dark};
    }

    .product-meta {
        font-size: 8pt;
        color: {$color_text_light};
    }

    .total-label {
        font-size: 10pt;
        color: {$color_text_light};
    }

    .total-value {
        font-size: 10pt;
        color: {$color_text_dark};
    }

    .grand-total-label {
        font-size: 12pt;
        font-weight: bold;
        color: {$color_text_dark};
    }

    .grand-total-value {
        font-size: 12pt;
        font-weight: bold;
        color: {$color_header};
    }
</style>