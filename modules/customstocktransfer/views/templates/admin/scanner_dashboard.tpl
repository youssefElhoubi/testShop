<script type="text/javascript">
    window.cstConfig = {
        ajaxUrl: '{$link->getAdminLink('AdminCustomStockScanner')|addslashes}'
    };
</script>

<div class="scanner-wrapper d-flex flex-column vh-100 bg-light">
    <!-- Header -->
    <div class="scanner-header d-flex justify-content-between align-items-center p-4 bg-white shadow-sm w-100">
        <h2 class="mb-0 text-dark font-weight-bold">Stock Scanner</h2>
        <button type="button" class="btn btn-primary btn-lg rounded-pill px-4 shadow-sm" id="btn-view-scanner-cart" data-toggle="modal" data-target="#scannerCartModal">
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
                            <div class="form-group mb-4">
                                <input type="text" 
                                       id="dedicated-scanner-input" 
                                       class="form-control text-center font-weight-bold scanner-input" 
                                       placeholder="Shoot barcode here..." 
                                       autofocus 
                                       autocomplete="off">
                            </div>
                            <div class="alert alert-info border-0 shadow-sm scanner-instruction mb-0" role="alert">
                                <i class="icon-info-circle mr-2"></i> Ensure your scanner is connected and this field is focused.
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cart Modal -->
<div class="modal fade" id="scannerCartModal" tabindex="-1" role="dialog" aria-labelledby="scannerCartModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content scanner-modal-content border-0 shadow-lg">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                <h4 class="modal-title font-weight-bold text-dark" id="scannerCartModalLabel">Scanner Cart</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" class="scanner-modal-close-icon">&times;</span>
                </button>
            </div>
            <div class="modal-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover table-striped align-middle mb-0 scanner-table">
                        <thead class="thead-dark">
                            <tr>
                                <th scope="col" class="text-center scanner-table-img-col border-0">Image</th>
                                <th scope="col" class="border-0">Product Name</th>
                                <th scope="col" class="text-center scanner-table-qty-col border-0">Qty</th>
                                <th scope="col" class="text-center scanner-table-action-col border-0">Action</th>
                            </tr>
                        </thead>
                        <tbody id="scanner-cart-items-container">
                            <!-- Items will be injected here via JS -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer bg-light border-top-0 scanner-modal-footer p-4">
                <button type="button" class="btn btn-outline-secondary btn-lg scanner-btn-close px-4" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success btn-lg px-5 shadow-sm" id="btn-confirm-scanner-transfer">
                    <i class="icon-check mr-2"></i> Confirm Transfer
                </button>
            </div>
        </div>
    </div>
</div>
