<script type="text/javascript">
    window.cstConfig = {
        ajaxUrl: '{$link->getAdminLink('AdminCustomStockScanner')|addslashes}'
    };
</script>

<div class="scanner-wrapper d-flex flex-column vh-100 bg-light">
    <!-- Header -->
    <div class="scanner-header d-flex justify-content-between align-items-center p-4 bg-white shadow-sm w-100">
        <h2 class="mb-0 text-dark font-weight-bold">Stock Scanner</h2>
        <button type="button" class="btn btn-primary btn-lg rounded-pill px-4 shadow-sm" id="btn-view-scanner-cart"
            data-toggle="modal" data-target="#scannerCartModal">
            <i class="icon-shopping-cart mr-2"></i> View Cart
            <span class="badge badge-light badge-pill ml-2" id="scanner-cart-badge">0</span>
        </button>
    </div>

    <!-- Scanner Input Area -->
    <div class="scanner-body flex-grow-1 d-flex justify-content-center align-items-center">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-6">
                    <div class="card border-0 shadow-lg scanner-card">
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
                            <div class="alert alert-info border-0 shadow-sm scanner-instruction mb-0" role="alert">
                                <i class="icon-info-circle mr-2"></i> Ensure your scanner is connected and this field is
                                focused.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cart Modal -->
<div class="modal fade" id="scannerCartModal" tabindex="-1" role="dialog" aria-labelledby="scannerCartModalLabel"
    aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content scanner-modal-dark-theme border-0 shadow-lg">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4 d-flex justify-content-between align-items-center">
                <h4 class="modal-title font-weight-bold text-white mb-0" id="scannerCartModalLabel">Scanner Cart</h4>
                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close" style="opacity: 0.8; text-shadow: none;">
                    <span aria-hidden="true" class="scanner-modal-close-icon">&times;</span>
                </button>
            </div>
            <div class="modal-body p-4">
                <div id="scanner-cart-items-container">
                    <!-- Items will be injected here via JS as .cst-cart-item divs -->
                </div>
                
                <div class="row mt-4 text-left">
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
            </div>
            <div class="modal-footer border-top-0 px-4 pb-4 pt-2">
                <button type="button" class="btn btn-primary btn-lg w-100 font-weight-bold scanner-btn-confirm" id="btn-confirm-scanner-transfer">
                    Confirm Transfer
                </button>
            </div>
        </div>
    </div>
</div>