<script type="text/javascript">
    window.cstConfig = {
        ajaxUrl: '{$link->getAdminLink('AdminCustomStockScanner')|addslashes}'
    };
</script>

<div class="scanner-wrapper d-flex flex-column min-vh-100 bg-light">
    <!-- Header -->
    <div class="scanner-header d-flex justify-content-between align-items-center p-4 bg-white shadow-sm w-100">
        <h2 class="mb-0 text-dark font-weight-bold">Stock Scanner</h2>
        <span class="badge badge-primary badge-pill" style="font-size: 1.2rem;">
            Cart Items: <span id="scanner-cart-badge">0</span>
        </span>
    </div>

    <!-- Scanner Input Area -->
    <div class="scanner-body flex-grow-1 d-flex justify-content-center align-items-start pt-5 pb-5">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-10 col-lg-8">
                    <div class="card border-0 shadow-lg scanner-card mb-4">
                        <div class="card-body p-5 text-center">
                            <div class="mb-4 text-primary">
                                <i class="icon-barcode scanner-icon"></i>
                            </div>
                            <h2 class="mb-4 font-weight-bold text-dark">Ready to Scan</h2>

                            <div class="cst-scanner-wrapper form-group mb-4">
                                <label for="dedicated-scanner-input" class="cst-scanner-label">Scan Barcode</label>
                                <input type="text" id="dedicated-scanner-input" class="scanner-input" placeholder="Shoot barcode here..." autofocus autocomplete="off">
                                <div id="scanner-feedback-msg" class="cst-scanner-feedback mt-2"></div>
                            </div>
                            <div class="alert alert-info border-0 shadow-sm scanner-instruction mb-4" role="alert">
                                <i class="icon-info-circle mr-2"></i> Ensure your scanner is connected and this field is
                                focused.
                            </div>

                            <!-- Live Cart Feed Container -->
                            <div id="live-scanner-cart-container" class="mt-4 scanner-modal-dark-theme p-4 rounded text-left shadow">
                                <div class="row mb-4">
                                    <div class="col-md-6">
                                        <label for="id_warehouse_from" class="font-weight-bold text-white">From Store/Warehouse</label>
                                        <select class="form-control" id="id_warehouse_from" name="id_warehouse_from">
                                            <option value="0" disabled selected>-- Select a Store --</option>
                                            {if isset($shops) && $shops}
                                                {foreach from=$shops item=shop}
                                                    <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'html':'UTF-8'}</option>
                                                {/foreach}
                                            {/if}
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="id_warehouse_to" class="font-weight-bold text-white">To Store/Warehouse</label>
                                        <select class="form-control" id="id_warehouse_to" name="id_warehouse_to">
                                            <option value="0" disabled selected>-- Select a Store --</option>
                                            {if isset($shops) && $shops}
                                                {foreach from=$shops item=shop}
                                                    <option value="{$shop.id_shop|intval}">{$shop.shop_name|escape:'html':'UTF-8'}</option>
                                                {/foreach}
                                            {/if}
                                        </select>
                                    </div>
                                </div>

                                <div id="scanner-cart-items-container" class="mb-4">
                                    <!-- Items will be injected here via JS as .cst-cart-item divs -->
                                </div>

                                <button type="button" class="btn btn-primary btn-lg w-100 font-weight-bold scanner-btn-confirm" id="btn-confirm-scanner-transfer">
                                    Confirm Transfer
                                </button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>