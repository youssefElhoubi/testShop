{assign var=color_border value="#000000"}
{assign var=color_border_light value="#D9D9D9"}
{assign var=color_header value="#F3F3F3"}
{assign var=color_alt value="#FAFAFA"}

<style>
	table {
		border-collapse: collapse;
		margin: 0;
		padding: 0;
	}

	td, th {
		font-family: dejavusans, helvetica, arial, sans-serif;
		font-size: 9pt;
		vertical-align: top;
		white-space: normal;
		padding: 0;
	}

	.center {
		text-align: center;
	}

	.left {
		text-align: left;
	}

	.right {
		text-align: right;
	}

	.bold {
		font-weight: bold;
	}

	.shop-title {
		font-size: 16pt;
		font-weight: bold;
		letter-spacing: 0.3px;
	}

	.section-title {
		font-size: 10pt;
		font-weight: bold;
		text-transform: uppercase;
		padding: 0 0 6px 0;
	}

	.summary-table,
	.address-table,
	.meta-table,
	.product-table,
	.total-table,
	.note-table {
		width: 100%;
	}

	.summary-table td,
	.meta-table td,
	.address-table td,
	.total-table td {
		padding: 3px 0;
	}

	.summary-table {
		border-top: 1px solid {$color_border};
		border-bottom: 1px solid {$color_border};
	}

	.summary-table td {
		padding: 4px 0;
	}

	.summary-label {
		font-weight: bold;
		padding-right: 6px;
	}

	.summary-value {
		font-weight: bold;
	}

	.address-table {
		border: 1px solid {$color_border_light};
	}

	.address-table td {
		padding: 8px 10px;
	}

	.address-box {
		border-right: 1px solid {$color_border_light};
	}

	.address-box:last-child {
		border-right: 0;
	}

	.address-line {
		padding: 1px 0;
	}

	.meta-table {
		border: 1px solid {$color_border_light};
	}

	.meta-label {
		width: 24%;
		font-weight: bold;
		text-transform: uppercase;
	}

	.meta-value {
		width: 76%;
	}

	.product-table {
		border: 1px solid {$color_border};
	}

	.product-table th,
	.product-table td {
		border: 1px solid {$color_border_light};
		padding: 5px 6px;
	}

	.product-table th {
		background: {$color_header};
		font-weight: bold;
		text-transform: uppercase;
		font-size: 8pt;
		vertical-align: middle;
	}

	.product-table tbody tr:nth-child(even) td {
		background: {$color_alt};
	}

	.product-image {
		width: 100%;
		text-align: center;
	}

	.product-image img {
		display: inline-block;
		max-width: 54px;
		max-height: 54px;
	}

	.product-name {
		font-size: 9pt;
		line-height: 1.25;
	}

	.product-muted {
		font-size: 8pt;
		color: #666666;
	}

	.total-table {
		border: 1px solid {$color_border};
	}

	.total-table td {
		border: 1px solid {$color_border_light};
		padding: 5px 6px;
	}

	.total-label {
		width: 68%;
		background: {$color_header};
		font-weight: bold;
	}

	.total-value {
		width: 32%;
		text-align: right;
	}

	.total-emphasis .total-label,
	.total-emphasis .total-value {
		font-weight: bold;
	}

	.footer-box {
		border-top: 1px solid {$color_border_light};
	}

	.footer-text {
		font-size: 8pt;
		line-height: 1.35;
		padding-top: 8px;
	}

	.note-table {
		border: 1px solid {$color_border_light};
	}

	.note-title {
		background: {$color_header};
		font-weight: bold;
		padding: 4px 6px;
		text-transform: uppercase;
	}

	.note-body {
		padding: 5px 6px;
	}
</style>