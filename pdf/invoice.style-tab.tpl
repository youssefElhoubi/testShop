{**
 * Copyright since 2007 PrestaShop SA and Contributors
 * PrestaShop is an International Registered Trademark & Property of PrestaShop SA
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Open Software License (OSL 3.0)
 * that is bundled with this package in the file LICENSE.md.
 * It is also available through the world-wide-web at this URL:
 * https://opensource.org/licenses/OSL-3.0
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to https://devdocs.prestashop.com/ for more information.
 *
 * @author    PrestaShop SA and Contributors <contact@prestashop.com>
 * @copyright Since 2007 PrestaShop SA and Contributors
 * @license   https://opensource.org/licenses/OSL-3.0 Open Software License (OSL 3.0)
 *}

{assign var=color_header value="#F0F0F0"}
{assign var=color_border value="#000000"}
{assign var=color_border_lighter value="#CCCCCC"}
{assign var=color_line_even value="#FFFFFF"}
{assign var=color_line_odd value="#F9F9F9"}
{assign var=font_size_text value="9pt"}
{assign var=font_size_header value="9pt"}
{assign var=font_size_product value="9pt"}
{assign var=height_header value="20px"}
{assign var=table_padding value="4px"}

<style>
    /* Base table reset suited for TCPDF rendering */
    table, th, td {
        margin: 0 !important;
        padding: 0 !important;
        vertical-align: middle;
        font-size: {$font_size_text};
        white-space: normal;
        border-collapse: collapse;
    }

    /* General table containers */
    table.product,
    table#summary-tab,
    table#total-tab,
    table#tax-tab,
    table#payment-tab,
    table#shipping-tab,
    table#note-tab {
        width: 100%;
        border-collapse: collapse;
        border: 1px solid {$color_line_odd};
        font-size: {$font_size_text};
    }

    /* Header styles: dark blue/gray background and white text */
    th.section-title,
    th.product-header,
    th.header,
    th.header-right,
    th.payment,
    th.shipping,
    th.tva {
        background-color: #1F3A57; /* dark blue-gray */
        color: #FFFFFF;
        font-size: {$font_size_header};
        font-weight: bold;
        padding: 8px 6px;
        text-align: left;
        border: 1px solid #E6E9EE;
    }

    th.header-right { text-align: right; }

    /* Table cells: padding and light borders for a clean, modern look */
    td, th {
        padding: 6px 8px;
        border: 1px solid #E6E9EE; /* light gray borders */
        vertical-align: middle;
    }

    /* Product rows and separators */
    tr.product td {
        border-bottom: 1px solid #F0F2F5;
        font-size: {$font_size_product};
        padding: 8px 6px;
    }

    tr.color_line_even { background-color: {$color_line_even}; }
    tr.color_line_odd { background-color: {$color_line_odd}; }

    tr.separator td { border-top: 1px solid #C8CDD6; }

    /* Address and note blocks */
    table#addresses-tab tr td { font-size: large; padding: 6px 4px; }
    table#note-tab td.note { word-wrap: break-word; padding: 10px; }

    /* Typography helpers */
    .left { text-align: left; }
    .right { text-align: right; }
    .center { text-align: center; }
    .bold { font-weight: bold; }
    .white { background-color: #FFFFFF; }

    /* Sizes */
    .big, tr.big td { font-size: 110%; }
    .small, table.small th, table.small td { font-size: small; padding: 4px 6px; }

    /* No floats — keep alignment with text-align only (TCPDF PDF-safe) */

</style>
