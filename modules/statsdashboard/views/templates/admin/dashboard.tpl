{assign var=pageProductsCount value=0}
{assign var=pageUnitsSold value=0}
{assign var=pageProfit value=0}
{assign var=pageStock value=0}
{if isset($productsList) && $productsList|@count > 0}
    {foreach from=$productsList item=product}
        {assign var=pageProductsCount value=$pageProductsCount+1}
        {assign var=pageUnitsSold value=$pageUnitsSold+$product.total_sold}
        {assign var=pageProfit value=$pageProfit+$product.total_profit}
        {assign var=pageStock value=$pageStock+$product.current_stock}
    {/foreach}
{/if}

<main class="statsdashboard" aria-labelledby="statsdashboard-title">
    <header class="statsdashboard__hero">
        <div class="statsdashboard__hero-copy">
            <p class="statsdashboard__eyebrow">{l s='Store intelligence' mod='statsdashboard'}</p>
            <h1 class="statsdashboard__title" id="statsdashboard-title">{l s='Product Sales Breakdown' mod='statsdashboard'}</h1>
            <p class="statsdashboard__subtitle">
                {l s='Compare monthly sales, live stock, and profit across your catalog with a focused, executive-ready dashboard.' mod='statsdashboard'}
            </p>
        </div>

        <div class="statsdashboard__hero-actions" aria-label="Dashboard actions">
        <a class="statsdashboard__action statsdashboard__action--ghost" href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&filter_limit={$selectedLimit}&filter_shop={$selectedShop}">
                {l s='Refresh view' mod='statsdashboard'}
            </a>
            <span class="statsdashboard__status">
                <span class="statsdashboard__status-dot" aria-hidden="true"></span>
                {l s='Live data' mod='statsdashboard'}
            </span>
        </div>
    </header>

    <section class="statsdashboard__kpis" aria-label="Current page summary">
        <article class="statsdashboard-card">
            <p class="statsdashboard-card__label">{l s='Products shown' mod='statsdashboard'}</p>
            <p class="statsdashboard-card__value">{$pageProductsCount}</p>
            <p class="statsdashboard-card__meta">{l s='Rows on the current page' mod='statsdashboard'}</p>
        </article>

        <article class="statsdashboard-card">
            <p class="statsdashboard-card__label">{l s='Units sold' mod='statsdashboard'}</p>
            <p class="statsdashboard-card__value">{$pageUnitsSold}</p>
            <p class="statsdashboard-card__meta">{l s='Selected filters and period' mod='statsdashboard'}</p>
        </article>

        <article class="statsdashboard-card">
            <p class="statsdashboard-card__label">{l s='Live stock' mod='statsdashboard'}</p>
            <p class="statsdashboard-card__value">{$pageStock}</p>
            <p class="statsdashboard-card__meta">{l s='Inventory still available' mod='statsdashboard'}</p>
        </article>

        <article class="statsdashboard-card statsdashboard-card--accent">
            <p class="statsdashboard-card__label">{l s='Profit' mod='statsdashboard'}</p>
            <p class="statsdashboard-card__value">{displayPrice price=$pageProfit}</p>
            <p class="statsdashboard-card__meta">{l s='Tax excluded gross profit' mod='statsdashboard'}</p>
        </article>
    </section>

    <section class="statsdashboard-panel" aria-labelledby="filters-heading">
        <div class="statsdashboard-panel__header">
            <div>
                <p class="statsdashboard-panel__eyebrow">{l s='Filters' mod='statsdashboard'}</p>
                <h2 class="statsdashboard-panel__title" id="filters-heading">{l s='Refine results' mod='statsdashboard'}</h2>
            </div>
            <p class="statsdashboard-panel__description">{l s='Filter by year, brand, or supplier, then export the current slice when you need a spreadsheet.' mod='statsdashboard'}</p>
        </div>

        <form method="get" action="{$form_url|escape:'html':'UTF-8'}" class="statsdashboard-filters" aria-label="Sales filters">
            <input type="hidden" name="controller" value="AdminStatsDashboard">
            <input type="hidden" name="token" value="{$token|escape:'html':'UTF-8'}">

            <!-- NEW: Store Filter Dropdown -->
            <div class="statsdashboard-field">
                <label class="statsdashboard-field__label" for="filter_shop">{l s='Store' mod='statsdashboard'}</label>
                <select name="filter_shop" id="filter_shop" class="statsdashboard-field__control">
                    <option value="0">{l s='All Stores' mod='statsdashboard'}</option>
                    {if isset($shops)}
                        {foreach from=$shops item=shop}
                            <option value="{$shop.id_shop}" {if $selectedShop == $shop.id_shop}selected{/if}>{$shop.name|escape:'html':'UTF-8'}</option>
                        {/foreach}
                    {/if}
                </select>
            </div>

            <div class="statsdashboard-field">
                <label class="statsdashboard-field__label" for="filter_year">{l s='Year' mod='statsdashboard'}</label>
                <select name="filter_year" id="filter_year" class="statsdashboard-field__control">
                    <option value="0">{l s='All Years' mod='statsdashboard'}</option>
                    {foreach from=$years item=year}
                        <option value="{$year}" {if $selectedYear == $year}selected{/if}>{$year}</option>
                    {/foreach}
                </select>
            </div>

            <div class="statsdashboard-field">
                <label class="statsdashboard-field__label" for="filter_brand">{l s='Brand' mod='statsdashboard'}</label>
                <select name="filter_brand" id="filter_brand" class="statsdashboard-field__control">
                    <option value="0">{l s='All Brands' mod='statsdashboard'}</option>
                    {foreach from=$brands item=brand}
                        <option value="{$brand.id_manufacturer}" {if $selectedBrand == $brand.id_manufacturer}selected{/if}>{$brand.name|escape:'html':'UTF-8'}</option>
                    {/foreach}
                </select>
            </div>

            <div class="statsdashboard-field">
                <label class="statsdashboard-field__label" for="filter_supplier">{l s='Supplier' mod='statsdashboard'}</label>
                <select name="filter_supplier" id="filter_supplier" class="statsdashboard-field__control">
                    <option value="0">{l s='All Suppliers' mod='statsdashboard'}</option>
                    {foreach from=$suppliers item=supplier}
                        <option value="{$supplier.id_supplier}" {if $selectedSupplier == $supplier.id_supplier}selected{/if}>{$supplier.name|escape:'html':'UTF-8'}</option>
                    {/foreach}
                </select>
            </div>

            <div class="statsdashboard-field">
                <label class="statsdashboard-field__label" for="filter_limit">{l s='Rows per page' mod='statsdashboard'}</label>
                <select name="filter_limit" id="filter_limit" class="statsdashboard-field__control">
                    <option value="10" {if $selectedLimit == 10}selected{/if}>10</option>
                    <option value="20" {if $selectedLimit == 20}selected{/if}>20</option>
                    <option value="50" {if $selectedLimit == 50}selected{/if}>50</option>
                    <option value="100" {if $selectedLimit == 100}selected{/if}>100</option>
                    <option value="500" {if $selectedLimit == 500}selected{/if}>500</option>
                </select>
            </div>

            <div class="statsdashboard-filters__actions">
                <button type="submit" class="statsdashboard-button statsdashboard-button--primary">
                    {l s='Apply filters' mod='statsdashboard'}
                </button>

                <button type="submit" name="export_csv" value="filtered" class="statsdashboard-button statsdashboard-button--secondary">
                    <i class="icon-file-text"></i> {l s='Export Filtered' mod='statsdashboard'}
                </button>

                <button type="submit" name="export_csv" value="all" class="statsdashboard-button statsdashboard-button--secondary">
                    <i class="icon-globe"></i> {l s='Export Global (All)' mod='statsdashboard'}
                </button>
            </div>
        </form>
    </section>

    <section class="statsdashboard-panel" aria-labelledby="results-heading">
        <div class="statsdashboard-panel__header">
            <div>
                <p class="statsdashboard-panel__eyebrow">{l s='Results' mod='statsdashboard'}</p>
                <h2 class="statsdashboard-panel__title" id="results-heading">{l s='Monthly sales table' mod='statsdashboard'}</h2>
            </div>
            <p class="statsdashboard-panel__description">{l s='Scroll horizontally on smaller screens to inspect each month, then jump through the catalog with pagination below.' mod='statsdashboard'}</p>
        </div>

        <div class="statsdashboard-table-shell">
            <table class="statsdashboard-table">
                <caption class="sr-only">{l s='Sales by month, stock, total sales, and profit' mod='statsdashboard'}</caption>
                <thead>
                    <tr>
                        <th scope="col">{l s='Product Name' mod='statsdashboard'}</th>
                        <th scope="col" class="statsdashboard-table__month">Jan</th>
                        <th scope="col" class="statsdashboard-table__month">Feb</th>
                        <th scope="col" class="statsdashboard-table__month">Mar</th>
                        <th scope="col" class="statsdashboard-table__month">Apr</th>
                        <th scope="col" class="statsdashboard-table__month">May</th>
                        <th scope="col" class="statsdashboard-table__month">Jun</th>
                        <th scope="col" class="statsdashboard-table__month">Jul</th>
                        <th scope="col" class="statsdashboard-table__month">Aug</th>
                        <th scope="col" class="statsdashboard-table__month">Sep</th>
                        <th scope="col" class="statsdashboard-table__month">Oct</th>
                        <th scope="col" class="statsdashboard-table__month">Nov</th>
                        <th scope="col" class="statsdashboard-table__month">Dec</th>
                        <th scope="col" style="color: black" class="statsdashboard-table__stock">{l s='Live Stock' mod='statsdashboard'}</th>
                        <th scope="col" class="statsdashboard-table__total statsdashboard-table__total--sales">{l s='Total sales' mod='statsdashboard'}</th>
                        <th scope="col" class="statsdashboard-table__total statsdashboard-table__total--profit">{l s='Total Profit' mod='statsdashboard'}</th>
                    </tr>
                </thead>
                <tbody>
                    {if isset($productsList) && $productsList|@count > 0}
                        {foreach from=$productsList item=product}
                            <tr>
                                <th scope="row" class="statsdashboard-table__product">
                                    <a href="{$product.product_link|escape:'html':'UTF-8'}" target="_blank" rel="noopener noreferrer" class="statsdashboard-product-link">
                                        <span class="statsdashboard-product-link__name">{$product.product_name|escape:'html':'UTF-8'}</span>
                                        <span class="statsdashboard-product-link__icon" aria-hidden="true">↗</span>
                                    </a>
                                </th>
                                <td>{$product.jan}</td>
                                <td>{$product.feb}</td>
                                <td>{$product.mar}</td>
                                <td>{$product.apr}</td>
                                <td>{$product.may}</td>
                                <td>{$product.jun}</td>
                                <td>{$product.jul}</td>
                                <td>{$product.aug}</td>
                                <td>{$product.sep}</td>
                                <td>{$product.oct}</td>
                                <td>{$product.nov}</td>
                                <td>{$product.decem}</td>
                                <td class="statsdashboard-table__stock-value">{$product.current_stock}</td>
                                <td class="statsdashboard-table__sales">{$product.total_sold}</td>
                                <td class="statsdashboard-table__profit">{displayPrice price=$product.total_profit}</td>
                            </tr>
                        {/foreach}
                    {else}
                        <tr>
                            <td colspan="16">
                                <div class="statsdashboard-empty" role="status" aria-live="polite">
                                    <div class="statsdashboard-empty__icon" aria-hidden="true">⌘</div>
                                    <h3 class="statsdashboard-empty__title">{l s='No sales data found for these filters.' mod='statsdashboard'}</h3>
                                    <p class="statsdashboard-empty__text">{l s='Try clearing one or more filters, or choose a different year to reveal matching products.' mod='statsdashboard'}</p>
                                </div>
                            </td>
                        </tr>
                    {/if}
                </tbody>
            </table>
        </div>
    </section>

    {if isset($totalPages) && $totalPages > 1}
        <nav class="statsdashboard-pagination" aria-label="{l s='Pagination' mod='statsdashboard'}">
            {if $page > 1}
                <a class="statsdashboard-pagination__link statsdashboard-pagination__link--prev" href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&filter_limit={$selectedLimit}&filter_shop={$selectedShop}&page={$page-1}">
                    &laquo; {l s='Prev' mod='statsdashboard'}
                </a>
            {/if}

            <div class="statsdashboard-pagination__pages" role="list">
                {for $p=1 to $totalPages}
                    <a class="statsdashboard-pagination__link {if $p == $page}is-active{/if}" href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&filter_limit={$selectedLimit}&filter_shop={$selectedShop}&page={$p}" {if $p == $page}aria-current="page" {/if}>
                        {$p}
                    </a>
                {/for}
            </div>

            {if $page < $totalPages}
                <a class="statsdashboard-pagination__link statsdashboard-pagination__link--next" href="{$form_url|escape:'html':'UTF-8'}&filter_year={$selectedYear}&filter_brand={$selectedBrand}&filter_supplier={$selectedSupplier}&filter_limit={$selectedLimit}&filter_shop={$selectedShop}&page={$page+1}">
                    {l s='Next' mod='statsdashboard'} &raquo;
                </a>
            {/if}
        </nav>
    {/if}
</main>