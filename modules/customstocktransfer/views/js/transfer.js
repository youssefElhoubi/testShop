document.addEventListener('DOMContentLoaded', function () {

    

    // Grab the exact containers
    const gridView = document.getElementById('customstocktransfer-grid-view');
    const tableView = document.getElementById('customstocktransfer-table-view');
    const toggleBtns = document.querySelectorAll('.js-stock-view-toggle');

    // 0. Force Initial State: Show Grid, Hide Table immediately on load
    if (gridView && tableView) {
        gridView.style.display = 'block';
        tableView.style.display = 'none';
    }

    // === UNIFIED CLICK EVENT DELEGATION ===
    document.addEventListener('click', function (e) {

        // 1. View Toggle
        const toggleBtn = e.target.closest('.js-stock-view-toggle');
        if (toggleBtn) {
            e.preventDefault();
            const targetView = toggleBtn.getAttribute('data-view'); // 'grid' or 'table'
            toggleBtns.forEach(b => b.classList.remove('active'));
            toggleBtn.classList.add('active');
            if (targetView === 'grid') {
                gridView.style.display = 'block';
                tableView.style.display = 'none';
            } else if (targetView === 'table') {
                gridView.style.display = 'none';
                tableView.style.display = 'block';
            }
            return;
        }



    });

    // 3. Form Validation logic for Filter Form and Transfer Form

    function showCustomError(message) {
        let alertBox = document.querySelector('.custom-transfer-wrapper > .cst-alert-danger');
        if (!alertBox) {
            alertBox = document.createElement('div');
            alertBox.className = 'cst-alert cst-alert-danger mb-4';
            alertBox.innerHTML = `
                <div class="cst-alert-icon"><i class="icon-warning"></i></div>
                <div class="cst-alert-content"></div>
            `;
            const container = document.querySelector('.custom-transfer-wrapper');
            container.insertBefore(alertBox, container.firstChild);
        }
        alertBox.querySelector('.cst-alert-content').innerHTML = '<p>' + message + '</p>';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function showCustomSuccess(message) {
        if (typeof $.growl !== 'undefined' && $.growl.notice) {
            $.growl.notice({ title: '', message: message });
            return;
        }
        let alertBox = document.querySelector('.custom-transfer-wrapper > .cst-alert-success');
        if (!alertBox) {
            alertBox = document.createElement('div');
            alertBox.className = 'cst-alert cst-alert-success mb-4';
            alertBox.innerHTML = `
                <div class="cst-alert-icon"><i class="icon-check"></i></div>
                <div class="cst-alert-content"></div>
            `;
            const container = document.querySelector('.custom-transfer-wrapper');
            container.insertBefore(alertBox, container.firstChild);
        }
        alertBox.querySelector('.cst-alert-content').innerHTML = '<p>' + message + '</p>';
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    function showModalError(message) {
        const errorDiv = document.querySelector('.js-modal-error');
        if (errorDiv) {
            errorDiv.innerHTML = message;
            errorDiv.style.display = 'block';
        }
    }

    function hideModalError() {
        const errorDiv = document.querySelector('.js-modal-error');
        if (errorDiv) {
            errorDiv.style.display = 'none';
        }
    }

    const filterForm = document.getElementById('cst-filter-form');
    if (filterForm) {
        filterForm.addEventListener('submit', function (e) {
            const qtyMin = filterForm.querySelector('input[name="filter_qty_min"]').value;
            const qtyMax = filterForm.querySelector('input[name="filter_qty_max"]').value;
            const priceMin = filterForm.querySelector('input[name="filter_price_min"]').value;
            const priceMax = filterForm.querySelector('input[name="filter_price_max"]').value;

            if (qtyMin !== '' && qtyMax !== '' && parseInt(qtyMin) > parseInt(qtyMax)) {
                e.preventDefault();
                showCustomError('Minimum quantity cannot be greater than maximum quantity.');
                return;
            }

            if (priceMin !== '' && priceMax !== '' && parseFloat(priceMin) > parseFloat(priceMax)) {
                e.preventDefault();
                showCustomError('Minimum price cannot be greater than maximum price.');
                return;
            }
        });
    }

    // Modal Open/Close Logic
    const cartModal = document.getElementById('cst-cart-modal');
    const btnOpenCart = document.querySelector('.js-view-cart-modal');
    const btnsCloseCart = document.querySelectorAll('.js-close-cart-modal');

    function renderCartItems() {
        const container = document.getElementById('cart-items-container');
        if (!container) return;

        container.innerHTML = '';

        if (window.transferCart.length === 0) {
            container.innerHTML = '<tr><td colspan="2" class="text-center" style="padding: 20px;">Your cart is empty.</td></tr>';
            return;
        }

        window.transferCart.forEach((item, index) => {
            const tr = document.createElement('tr');
            
            let barcodeHtml = '';
            if (item.reference && item.reference !== '0') {
                barcodeHtml = `<div class="mt-2 mb-2">
                    <svg class="cst-barcode" jsbarcode-format="EAN13" jsbarcode-value="${item.reference}" jsbarcode-height="30" jsbarcode-width="1.5" jsbarcode-displayValue="true"></svg>
                </div>`;
            }

            tr.innerHTML = `
                <td>
                    ${item.name} <br>
                    <small class="text-muted">Product ID: ${item.id_product}</small>
                    ${barcodeHtml}
                </td>
                <td>
                    <div class="d-flex align-items-center" style="display: flex !important; align-items: center !important;">
                        <input type="number" class="form-control cst-input cart-item-qty" 
                            data-index="${index}" min="1" max="${item.stock}" value="${item.qty}" style="width: 80px;">
                        <button type="button" class="btn btn-danger btn-sm js-remove-cart-item" data-index="${index}" style="margin-left: 10px;">
                            <i class="icon-trash"></i>
                        </button>
                    </div>
                </td>
            `;
            container.appendChild(tr);
        });

        if (typeof JsBarcode !== 'undefined') {
            // Reminder: Ensure transfer_dashboard.tpl uses <svg class="cst-barcode" jsbarcode-value="{$product.ean13}"></svg>
            JsBarcode(".cst-barcode").init({
                format: "CODE128", 
                width: 2,          
                height: 60,        
                displayValue: true,
                fontSize: 16,      
                textMargin: 5,     
                margin: 10
            });
        }
    }

    if (btnOpenCart && cartModal) {
        btnOpenCart.addEventListener('click', function () {
            renderCartItems();
            cartModal.style.display = 'flex';
        });
    }

    if (btnsCloseCart) {
        btnsCloseCart.forEach(btn => {
            btn.addEventListener('click', function () {
                cartModal.style.display = 'none';
            });
        });
    }

    // Input Validation & Cart State Logic
    window.transferCart = JSON.parse(localStorage.getItem('cst_transfer_cart')) || [];

    function saveCartState() {
        localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
        if (typeof updateCartBadge === 'function') updateCartBadge();
    }

    function updateCartBadge() {
        const badge = document.getElementById('cart-item-count');
        if (badge) {
            badge.innerText = window.transferCart.length;
        }
    }

    updateCartBadge();
    renderCartItems();

    const cartContainer = document.getElementById('cart-items-container');
    if (cartContainer) {
        cartContainer.addEventListener('input', function (e) {
            if (e.target.classList.contains('cart-item-qty')) {
                let val = parseInt(e.target.value, 10);
                let max = parseInt(e.target.getAttribute('max'), 10);
                let min = parseInt(e.target.getAttribute('min'), 10) || 1;

                if (isNaN(val) || val < min) {
                    e.target.value = min;
                } else if (!isNaN(max) && val > max) {
                    e.target.value = max;
                }

                const index = e.target.getAttribute('data-index');
                if (index !== null && window.transferCart[index]) {
                    window.transferCart[index].qty = parseInt(e.target.value, 10);
                    saveCartState();
                }
            }
        });

        cartContainer.addEventListener('click', function (e) {
            const removeBtn = e.target.closest('.js-remove-cart-item');
            if (removeBtn) {
                const index = removeBtn.getAttribute('data-index');
                window.transferCart.splice(index, 1);
                saveCartState();
                updateCartBadge();
                renderCartItems();
            }
        });
    }

    const btnsAddToCart = document.querySelectorAll('.js-add-to-cart');
    btnsAddToCart.forEach(btn => {
        btn.addEventListener('click', function () {
            const productId = parseInt(this.getAttribute('data-product-id'), 10);
            const productAttributeId = parseInt(this.getAttribute('data-product-attribute-id') || 0, 10);
            const productName = this.getAttribute('data-product-name');
            const ean13 = this.getAttribute('data-ean13') || '';
            const maxQty = parseInt(this.getAttribute('data-max-qty') || 0, 10);            
            const imageUrl = this.getAttribute('data-image-url') || '';

            const parentContainer = this.closest('.d-flex') || this.closest('.d-inline-flex');
            let qty = 1;
            if (parentContainer) {
                const qtyInput = parentContainer.querySelector('input[type="number"]');
                if (qtyInput) qty = parseInt(qtyInput.value, 10);
            }

            const existingItemIndex = window.transferCart.findIndex(item =>
                item.id_product === productId && item.id_product_attribute === productAttributeId
            );

            if (existingItemIndex > -1) {
                // OVERWRITE logic: Replace existing quantity with the newly submitted quantity
                let newQty = qty;
                let maxAllowed = maxQty;

                // Still check against the max available stock limit
                if (!isNaN(maxAllowed) && newQty > maxAllowed) {
                    newQty = maxAllowed;
                }
                window.transferCart[existingItemIndex].qty = newQty;
            } else {
                window.transferCart.push({
                    id_product: productId,
                    id_product_attribute: productAttributeId,
                    name: productName,
                    reference: ean13,
                    image_url: imageUrl,
                    qty: qty,
                    stock: maxQty
                });
            }

            // Sync the updated state to localStorage and update the UI counter
            saveCartState();

            const originalHtml = this.innerHTML;
            this.innerHTML = '<i class="icon-check"></i>';
            this.classList.replace('cst-btn-primary', 'cst-btn-success');
            this.classList.replace('btn-primary', 'btn-success');
            setTimeout(() => {
                this.innerHTML = originalHtml;
                this.classList.replace('cst-btn-success', 'cst-btn-primary');
                this.classList.replace('btn-success', 'btn-primary');
            }, 1000);
        });
    });

    // --- Clear Cart ---
    const btnClearCart = document.querySelector('.js-clear-cart');
    if (btnClearCart) {
        btnClearCart.addEventListener('click', function () {
            window.transferCart = [];
            saveCartState();
            updateCartBadge();
            renderCartItems();
        });
    }

    // --- Confirm Transfer AJAX ---
    const btnConfirmTransfer = document.querySelector('.js-confirm-transfer');
    if (btnConfirmTransfer) {
        btnConfirmTransfer.addEventListener('click', function () {
            hideModalError();

            if (window.transferCart.length === 0) {
                showModalError('Your transfer cart is empty.');
                return;
            }

            const sourceStoreId = document.getElementById('modal_source_shop_id').value;
            const destStoreId = document.getElementById('modal_destination_shop_id').value;

            if (!sourceStoreId || !destStoreId) {
                showModalError('Please select both a Source Store and a Destination Store.');
                return;
            }

            if (sourceStoreId === destStoreId) {
                showModalError('Source and destination stores cannot be the same.');
                return;
            }

            const originalBtnText = btnConfirmTransfer.innerHTML;
            btnConfirmTransfer.innerHTML = '<i class="icon-spinner icon-spin"></i> Processing...';
            btnConfirmTransfer.disabled = true;

            $.ajax({
                url: window.cstConfig.ajaxUrl,
                type: 'POST',
                dataType: 'json',
                data: {
                    ajax: true,
                    action: 'confirmCart',
                    source_shop_id: sourceStoreId,
                    destination_shop_id: destStoreId,
                    cart_items: window.transferCart
                },
                success: function (response) {
                    btnConfirmTransfer.innerHTML = originalBtnText;
                    btnConfirmTransfer.disabled = false;

                    if (response && response.success) {
                        window.transferCart = [];
                        localStorage.removeItem('cst_transfer_cart');
                        cartModal.style.display = 'none';
                        showCustomSuccess('Transfer created successfully!');
                        setTimeout(function () {
                            window.location.reload();
                        }, 1000);
                    } else {
                        showModalError('Error: ' + (response ? response.message : 'Failed to create transfer.'));
                    }
                },
                error: function () {
                    btnConfirmTransfer.innerHTML = originalBtnText;
                    btnConfirmTransfer.disabled = false;
                    showModalError('A server error occurred while processing the transfer.');
                }
            });
        });
    }

    // --- Bulk Action Override ---
    const transferForm = document.getElementById('cst-transfer-form');
    if (transferForm) {
        transferForm.addEventListener('submit', function (e) {
            e.preventDefault();

            const checkboxes = document.querySelectorAll('.cst-product-checkbox:checked');
            if (checkboxes.length === 0) {
                showCustomError('Please select at least one product.');
                return;
            }

            checkboxes.forEach(cb => {
                const container = cb.closest('[data-cst-product-item]');
                if (container) {
                    const btnAddToCart = container.querySelector('.js-add-to-cart');
                    if (btnAddToCart) {
                        const productId = parseInt(btnAddToCart.getAttribute('data-product-id'), 10);
                        const productAttributeId = parseInt(btnAddToCart.getAttribute('data-product-attribute-id') || 0, 10);
                        const productName = btnAddToCart.getAttribute('data-product-name');
                        const ean13 = btnAddToCart.getAttribute('data-ean13') || '';
                        const maxQty = parseInt(btnAddToCart.getAttribute('data-max-qty') || 0, 10);
                        const imageUrl = btnAddToCart.getAttribute('data-image-url') || '';

                        const qtyInput = container.querySelector('input[name="bulk_quantities[' + productId + ']"]');
                        let qty = qtyInput ? parseInt(qtyInput.value, 10) : 1;

                        const existingItemIndex = window.transferCart.findIndex(item =>
                            item.id_product === productId && item.id_product_attribute === productAttributeId
                        );

                        if (existingItemIndex > -1) {
                            let newQty = qty;
                            let maxAllowed = maxQty;
                            if (!isNaN(maxAllowed) && newQty > maxAllowed) {
                                newQty = maxAllowed;
                            }
                            window.transferCart[existingItemIndex].qty = newQty;
                        } else {
                            window.transferCart.push({
                                id_product: productId,
                                id_product_attribute: productAttributeId,
                                name: productName,
                                reference: ean13,
                                image_url: imageUrl,
                                qty: qty,
                                stock: maxQty
                            });
                        }

                        cb.checked = false;
                    }
                }
            });

            saveCartState();
            renderCartItems();
            if (cartModal) {
                cartModal.style.display = 'flex';
            }
        });
    }

    // --- Initialize JsBarcode ---
    if (typeof JsBarcode !== 'undefined') {
        // Reminder: Ensure transfer_dashboard.tpl uses <svg class="cst-barcode" jsbarcode-value="{$product.ean13}"></svg>
        JsBarcode(".cst-barcode").init({
            format: "CODE128", // Force CODE128 to avoid EAN checksum crashes
            width: 2,          // Make the bars thick enough to scan
            height: 60,        // Tall enough to be read easily
            displayValue: true,// Show the numbers below
            fontSize: 16,      // Readable font size
            textMargin: 5,     // Space between bars and text
            margin: 10
        });
    }

    // --- Barcode Scanner Logic ---
    const barcodeScanner = document.getElementById('cst-barcode-scanner');
    if (barcodeScanner) {
        barcodeScanner.addEventListener('keydown', function(e) {
            if (e.key === 'Enter' || e.keyCode === 13) {
                e.preventDefault();
                
                const scannedValue = this.value.trim();
                if (!scannedValue) return;

                // Disable input temporarily while scanning
                this.disabled = true;
                
                // Get source store selection
                const sourceStoreElement = document.getElementById('cst-main-source-store');
                const sourceStoreId = sourceStoreElement ? sourceStoreElement.value : 0;

                $.ajax({
                    url: window.cstConfig.ajaxUrl,
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        ajax: true,
                        action: 'ScanBarcode',
                        barcode: scannedValue,
                        source_shop_id: sourceStoreId
                    },
                    success: (response) => {
                        this.disabled = false;
                        
                        if (response && response.success && response.product) {
                            const p = response.product;
                            const productId = parseInt(p.id_product, 10);
                            const productAttributeId = parseInt(p.id_product_attribute || 0, 10);
                            const productName = p.name || '';
                            const maxQty = parseInt(p.stock || p.max_qty || 0, 10);
                            const reference = p.reference || p.ean13 || scannedValue || '';
                            const imageUrl = p.image_url || p.imageUrl || '';

                            const existingItemIndex = window.transferCart.findIndex(item =>
                                item.id_product === productId && item.id_product_attribute === productAttributeId
                            );

                            if (existingItemIndex > -1) {
                                let newQty = window.transferCart[existingItemIndex].qty + 1;
                                let maxAllowed = maxQty;
                                if (!isNaN(maxAllowed) && newQty > maxAllowed) {
                                    newQty = maxAllowed;
                                    showCustomError('Maximum stock reached for ' + productName);
                                } else {
                                    showCustomSuccess('Increased quantity for ' + productName);
                                }
                                window.transferCart[existingItemIndex].qty = newQty;
                            } else {
                                window.transferCart.push({
                                    id_product: productId,
                                    id_product_attribute: productAttributeId,
                                    name: productName,
                                    reference: reference,
                                    image_url: imageUrl,
                                    qty: 1,
                                    stock: maxQty
                                });
                                showCustomSuccess('Added ' + productName + ' to cart');
                            }

                            saveCartState();
                            renderCartItems();
                        } else {
                            showCustomError(response ? response.message : 'Barcode not found.');
                        }

                        this.value = '';
                        this.focus();
                    },
                    error: () => {
                        this.disabled = false;
                        showCustomError('A server error occurred while processing the barcode.');
                        this.value = '';
                        this.focus();
                    }
                });
            }
        });
    }

    // Cross-Tab/Page Synchronization
    window.addEventListener('storage', function(e) {
        if (e.key === 'cst_transfer_cart') {
            window.transferCart = JSON.parse(e.newValue) || [];
            if (typeof renderCartItems === 'function') renderCartItems();
            if (typeof updateCartBadge === 'function') updateCartBadge();
        }
    });

});