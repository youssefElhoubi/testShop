{assign var=color_border value="#E0E0E0"}
{assign var=color_border_light value="#EDEDED"}
{assign var=color_header value="#2C3E50"}
{assign var=color_header_text value="#FFFFFF"}
{assign var=color_alt value="#F9F9F9"}

<style>
	table {
		border-collapse: collapse;
		margin: 0;
		padding: 0;
	}

	td, th {
		font-family: helvetica, arial, sans-serif;
		font-size: 9pt;
		color: #333333;
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
		font-size: 18pt;
		font-weight: bold;
		color: #2C3E50;
		letter-spacing: 0.5px;
	}

	.section-title {
		font-size: 11pt;
		font-weight: bold;
		color: #2C3E50;
		text-transform: uppercase;
		padding: 0 0 8px 0;
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
		padding: 4px 0;
	}

	.summary-table {
		border-top: 1px solid {$color_border};
		border-bottom: 1px solid {$color_border};
	}

	.summary-table td {
		padding: 6px 0;
	}

	.summary-label {
		font-weight: bold;
		color: #555555;
		padding-right: 8px;
	}

	.summary-value {
		font-weight: bold;
		color: #2C3E50;
	}

	.address-table {
		border: 1px solid {$color_border};
	}

	.address-table td {
		padding: 10px 12px;
	}

	.address-box {
		border-right: 1px solid {$color_border_light};
	}

	.address-box:last-child {
		border-right: 0;
	}

	.address-line {
		padding: 2px 0;
		line-height: 1.4;
	}

	.meta-table {
		border: 1px solid {$color_border};
	}

	.meta-label {
		width: 25%;
		font-weight: bold;
		color: #555555;
		text-transform: uppercase;
	}

	.meta-value {
		width: 75%;
	}

	.product-table {
		border: 1px solid {$color_border};
	}

	.product-table th,
	.product-table td {
		border: 1px solid {$color_border};
		padding: 8px 10px;
	}

	.product-table th {
		background-color: {$color_header};
		color: {$color_header_text};
		font-weight: bold;
		text-transform: uppercase;
		font-size: 8pt;
		vertical-align: middle;
	}

	.product-table tbody tr:nth-child(even) td {
		background-color: {$color_alt};
	}

	.product-image {
		width: 100%;
		text-align: center;
	}

	.product-image img {
		display: inline-block;
		max-width: 60px;
		max-height: 60px;
	}

	.product-name {
		font-size: 9pt;
		font-weight: bold;
		color: #2C3E50;
		line-height: 1.3;
	}

	.product-muted {
		font-size: 8pt;
		color: #777777;
		padding-top: 2px;
	}

	.total-table {
		border: 1px solid {$color_border};
	}

	.total-table td {
		border: 1px solid {$color_border};
		padding: 8px 10px;
	}

	.total-label {
		width: 70%;
		background-color: {$color_alt};
		color: #555555;
		font-weight: bold;
	}

	.total-value {
		width: 30%;
		text-align: right;
		color: #2C3E50;
	}

	.total-emphasis .total-label,
	.total-emphasis .total-value {
		font-size: 10pt;
		font-weight: bold;
		background-color: #FFFFFF;
		color: #000000;
	}

	.footer-box {
		border-top: 2px solid {$color_header};
	}

	.footer-text {
		font-size: 8pt;
		color: #666666;
		line-height: 1.4;
		padding-top: 10px;
		text-align: center;
	}

	.note-table {
		border: 1px solid {$color_border};
	}

	.note-title {
		background-color: {$color_alt};
		color: #2C3E50;
		font-weight: bold;
		padding: 6px 10px;
		text-transform: uppercase;
		border-bottom: 1px solid {$color_border};
	}

	.note-body {
		padding: 8px 10px;
		line-height: 1.4;
		color: #444444;
	}
</style>
