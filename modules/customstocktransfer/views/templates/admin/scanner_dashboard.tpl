<script type="text/javascript">
    window.cstConfig = {
        ajaxUrl: '{$link->getAdminLink('AdminCustomStockScanner')|addslashes}'
    };
</script>

<div class="scanner-dashboard-container container-fluid" style="margin-top: 3rem;">
    <!-- Header -->
    <div class="row mb-5 align-items-center">
        <div class="col-md-6">
            <h2 class="mb-0 text-muted">Stock Scanner</h2>
        </div>
        <div class="col-md-6 text-right">
            <button type="button" class="btn btn-primary btn-lg float-right" id="btn-view-scanner-cart" data-toggle="modal" data-target="#scannerCartModal" style="border-radius: 30px; padding: 10px 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                <i class="icon-shopping-cart"></i> View Cart
                <span class="badge badge-light badge-pill ml-2" id="scanner-cart-badge" style="font-size: 1rem;">0</span>
            </button>
            <div class="clearfix"></div>
        </div>
    </div>

    <!-- Scanner Input Area -->
    <div class="row justify-content-center" style="margin-top: 10vh;">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0" style="border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.08);">
                <div class="card-body p-5 text-center">
                    <div class="mb-4 text-primary">
                        <i class="icon-barcode" style="font-size: 4rem;"></i>
                    </div>
                    <h3 class="mb-4 font-weight-light">Ready to Scan</h3>
                    <div class="form-group">
                        <input type="text" 
                               id="dedicated-scanner-input" 
                               class="form-control text-center font-weight-bold" 
                               style="font-size: 2.5rem; height: 90px; border: 4px solid #e0e0e0; border-radius: 15px; transition: all 0.3s ease; box-shadow: inset 0 2px 4px rgba(0,0,0,0.05);" 
                               placeholder="Shoot barcode here..." 
                               autofocus 
                               autocomplete="off">
                    </div>
                    <p class="text-muted mt-4" style="font-size: 1.1rem;">Ensure your scanner is connected and cursor is in the field above.</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cart Modal -->
<div class="modal fade" id="scannerCartModal" tabindex="-1" role="dialog" aria-labelledby="scannerCartModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable" role="document">
        <div class="modal-content" style="border-radius: 15px; border: none; box-shadow: 0 15px 35px rgba(0,0,0,0.2);">
            <div class="modal-header border-bottom-0 pb-0 pt-4 px-4">
                <h4 class="modal-title font-weight-bold" id="scannerCartModalLabel">Scanner Cart</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" style="font-size: 1.5rem;">&times;</span>
                </button>
            </div>
            <div class="modal-body p-4">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="thead-light">
                            <tr>
                                <th scope="col" class="text-center border-top-0 border-bottom-0 rounded-left" style="width: 120px;">Image</th>
                                <th scope="col" class="border-top-0 border-bottom-0">Product Name</th>
                                <th scope="col" class="text-center border-top-0 border-bottom-0" style="width: 150px;">Qty</th>
                                <th scope="col" class="text-center border-top-0 border-bottom-0 rounded-right" style="width: 100px;">Action</th>
                            </tr>
                        </thead>
                        <tbody id="scanner-cart-items-container">
                            <!-- Items will be injected here via JS -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer bg-light border-top-0" style="border-radius: 0 0 15px 15px; padding: 1.5rem;">
                <button type="button" class="btn btn-outline-secondary btn-lg" data-dismiss="modal" style="border-radius: 10px;">Close</button>
                <button type="button" class="btn btn-success btn-lg px-5" id="btn-confirm-scanner-transfer" style="border-radius: 10px; box-shadow: 0 4px 6px rgba(40,167,69,0.3);">
                    <i class="icon-check mr-2"></i> Confirm Transfer
                </button>
            </div>
        </div>
    </div>
</div>

<style>
    /* Styling adjustments for a distraction-free and modern look */
    #dedicated-scanner-input:focus {
        border-color: #007bff !important;
        box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25) !important;
        outline: none;
    }
    .table td {
        vertical-align: middle;
    }
</style>
