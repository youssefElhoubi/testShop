<script type="text/javascript">
    window.cstConfig = {
        ajaxUrl: '{$link->getAdminLink('AdminCustomStockScanner')|addslashes}'
    };
</script>

<div class="scanner-dashboard-container container-fluid">
    <!-- Header -->
    <div class="row mb-5 align-items-center">
        <div class="col-md-6">
            <h2 class="mb-0 text-muted">Stock Scanner</h2>
        </div>
        <div class="col-md-6 text-right">
            <button type="button" class="btn btn-primary btn-lg float-right" id="btn-view-scanner-cart" data-toggle="modal" data-target="#scannerCartModal">
                <i class="icon-shopping-cart"></i> View Cart
                <span class="badge badge-light badge-pill ml-2" id="scanner-cart-badge">0</span>
            </button>
            <div class="clearfix"></div>
        </div>
    </div>

    <!-- Scanner Input Area -->
    <div class="row justify-content-center scanner-input-row">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 scanner-card">
                <div class="card-body p-5 text-center">
                    <div class="mb-4 text-primary">
                        <i class="icon-barcode scanner-icon"></i>
                    </div>
                    <h3 class="mb-4 font-weight-light">Ready to Scan</h3>
                    <div class="form-group">
                        <input type="text" 
                               id="dedicated-scanner-input" 
                               class="form-control text-center font-weight-bold" 
                               placeholder="Shoot barcode here..." 
                               autofocus 
                               autocomplete="off">
                    </div>
                    <p class="text-muted mt-4 scanner-instruction">Ensure your scanner is connected and cursor is in the field above.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cart Modal -->
<div class="modal fade" id="scannerCartModal" tabindex="-1" role="dialog" aria-labelledby="scannerCartModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content scanner-modal-content">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                <h4 class="modal-title font-weight-bold" id="scannerCartModalLabel">Scanner Cart</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" class="scanner-modal-close-icon">&times;</span>
                </button>
            </div>
            <div class="modal-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th scope="col" class="text-center border-top-0 border-bottom-0 rounded-left scanner-table-img-col">Image</th>
                                <th scope="col" class="border-top-0 border-bottom-0">Product Name</th>
                                <th scope="col" class="text-center border-top-0 border-bottom-0 scanner-table-qty-col">Qty</th>
                                <th scope="col" class="text-center border-top-0 border-bottom-0 rounded-right scanner-table-action-col">Action</th>
                            </tr>
                        </thead>
                        <tbody id="scanner-cart-items-container">
                            <!-- Items will be injected here via JS -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer bg-light border-top-0 scanner-modal-footer">
                <button type="button" class="btn btn-outline-secondary btn-lg scanner-btn-close" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-success btn-lg px-5" id="btn-confirm-scanner-transfer">
                    <i class="icon-check mr-2"></i> Confirm Transfer
                </button>
            </div>
        </div>
    </div>
</div>
