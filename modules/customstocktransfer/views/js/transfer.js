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

        // 2. Open Transfer Modal (Legacy)
        const openTransferBtn = e.target.closest('.js-open-transfer-modal');
        if (openTransferBtn) {
            e.preventDefault();
            const productId = openTransferBtn.getAttribute('data-product-id');
            const productName = openTransferBtn.getAttribute('data-product-name');
            const form = document.getElementById('customstocktransfer-transfer-form');
            if (form) form.reset();
            const idProductInput = document.querySelector('input[name="id_product"]');
            if (idProductInput) idProductInput.value = productId;
            const titleElement = document.querySelector('.js-transfer-modal-title');
            if (titleElement) titleElement.textContent = 'Transfer: ' + productName;
            return;
        }

        // 3. Open Edit/Transfer Modal
        const openEditBtn = e.target.closest('.js-open-edit-modal');
        if (openEditBtn) {
            e.preventDefault();
            const productId = openEditBtn.getAttribute('data-product-id');
            const productName = openEditBtn.getAttribute('data-product-name');
            const currentQty = openEditBtn.getAttribute('data-current-qty');
            const maxQty = openEditBtn.getAttribute('data-max-qty');
            
            if (editForm) {
                editForm.reset();
                const idProductInput = editForm.querySelector('input[name="id_product"]');
                if (idProductInput) idProductInput.value = productId;
                const maxQuantityInput = editForm.querySelector('input[name="max_quantity"]');
                if (maxQuantityInput) maxQuantityInput.value = maxQty;
                const newQuantityInput = editForm.querySelector('input[name="new_quantity"]');
                if (newQuantityInput) newQuantityInput.value = currentQty;
                
                const titleElement = document.querySelector('.js-edit-modal-title');
                if (titleElement) titleElement.textContent = 'Transfer Stock: ' + productName;
                const errorElement = document.querySelector('.js-edit-modal-error');
                if (errorElement) errorElement.style.display = 'none';
            }
            if (editModal) {
                editModal.style.display = 'flex';
            }
            return;
        }

        // 4. Close Edit Modal
        if (e.target.matches('.js-close-edit-modal') || (e.target.closest('.cst-modal-close') && e.target.closest('#cst-edit-modal'))) {
            e.preventDefault();
            if (editModal) editModal.style.display = 'none';
            return;
        }

        // 5. Open History Modal
        const openHistoryBtn = e.target.closest('.js-open-history-modal');
        if (openHistoryBtn) {
            e.preventDefault();
            console.log("button clicked ");
            if (historyModal) historyModal.style.display = 'flex';
            return;
        }

        // 6. Close History Modal
        if (e.target.matches('.js-close-history-modal') || (e.target.closest('.cst-modal-close') && e.target.closest('#cst-history-modal'))) {
            e.preventDefault();
            if (historyModal) historyModal.style.display = 'none';
            return;
        }

    });

    // 3. Form Validation logic for Filter Form and Transfer Form

    function showCustomError(message) {
        let alertBox = document.querySelector('.cst-alert-danger');
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
            tr.innerHTML = `
                <td>${item.productName} <br><small class="text-muted">Product ID: ${item.productId}</small></td>
                <td>
                    <div class="d-flex align-items-center" style="display: flex !important; align-items: center !important;">
                        <input type="number" class="form-control cst-input cart-item-qty" 
                            data-index="${index}" min="1" max="${item.maxQty}" value="${item.qty}" style="width: 80px;">
                        <button type="button" class="btn btn-danger btn-sm js-remove-cart-item" data-index="${index}" style="margin-left: 10px;">
                            <i class="icon-trash"></i>
                        </button>
                    </div>
                </td>
            `;
            container.appendChild(tr);
        });
    }

    if (btnOpenCart && cartModal) {
        btnOpenCart.addEventListener('click', function() {
            renderCartItems();
            cartModal.style.display = 'flex';
        });
    }

    if (btnsCloseCart) {
        btnsCloseCart.forEach(btn => {
            btn.addEventListener('click', function() {
                cartModal.style.display = 'none';
            });
        });
    }

    // Input Validation & Cart State Logic
    window.transferCart = [];

    function updateCartBadge() {
        const badge = document.getElementById('cart-item-count');
        if (badge) {
            badge.innerText = window.transferCart.length;
        }
    }

    const cartContainer = document.getElementById('cart-items-container');
    if (cartContainer) {
        cartContainer.addEventListener('input', function(e) {
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
                }
            }
        });

        cartContainer.addEventListener('click', function(e) {
            const removeBtn = e.target.closest('.js-remove-cart-item');
            if (removeBtn) {
                const index = removeBtn.getAttribute('data-index');
                window.transferCart.splice(index, 1);
                updateCartBadge();
                renderCartItems();
            }
        });
    }

    const btnsAddToCart = document.querySelectorAll('.js-add-to-cart');
    btnsAddToCart.forEach(btn => {
        btn.addEventListener('click', function() {
            const productId = this.getAttribute('data-product-id');
            const productAttributeId = this.getAttribute('data-product-attribute-id') || 0;
            const productName = this.getAttribute('data-product-name');
            const maxQty = this.getAttribute('data-max-qty');
            
            const parentContainer = this.closest('.d-flex') || this.closest('.d-inline-flex');
            let qty = 1;
            if (parentContainer) {
                const qtyInput = parentContainer.querySelector('input[type="number"]');
                if (qtyInput) qty = parseInt(qtyInput.value, 10);
            }

            const existingItemIndex = window.transferCart.findIndex(item => 
                item.productId === productId && item.productAttributeId === productAttributeId
            );
            
            if (existingItemIndex > -1) {
                let newQty = window.transferCart[existingItemIndex].qty + qty;
                let maxAllowed = parseInt(maxQty, 10);
                if (!isNaN(maxAllowed) && newQty > maxAllowed) {
                    newQty = maxAllowed;
                }
                window.transferCart[existingItemIndex].qty = newQty;
            } else {
                window.transferCart.push({
                    productId: productId,
                    productAttributeId: productAttributeId,
                    productName: productName,
                    maxQty: maxQty,
                    qty: qty
                });
            }

            updateCartBadge();
            
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
        btnClearCart.addEventListener('click', function() {
            window.transferCart = [];
            updateCartBadge();
            renderCartItems();
        });
    }

    // --- Confirm Transfer AJAX ---
    const btnConfirmTransfer = document.querySelector('.js-confirm-transfer');
    if (btnConfirmTransfer) {
        btnConfirmTransfer.addEventListener('click', function() {
            if (window.transferCart.length === 0) {
                alert('Your transfer cart is empty.');
                return;
            }

            const sourceStoreId = document.querySelector('select[name="source_shop_id"]').value;
            const destStoreId = document.querySelector('select[name="destination_shop_id"]').value;

            if (!sourceStoreId || !destStoreId) {
                alert('Please select both a Source Store and a Destination Store in the bulk actions area.');
                return;
            }

            if (sourceStoreId === destStoreId) {
                alert('Source and destination stores cannot be the same.');
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
                success: function(response) {
                    btnConfirmTransfer.innerHTML = originalBtnText;
                    btnConfirmTransfer.disabled = false;

                    if (response && response.success) {
                        alert('Transfer created successfully!');
                        window.transferCart = [];
                        updateCartBadge();
                        cartModal.style.display = 'none';
                        window.location.reload();
                    } else {
                        alert('Error: ' + (response ? response.message : 'Failed to create transfer.'));
                    }
                },
                error: function() {
                    btnConfirmTransfer.innerHTML = originalBtnText;
                    btnConfirmTransfer.disabled = false;
                    alert('A server error occurred while processing the transfer.');
                }
            });
        });
    }

    // --- Bulk Action Override ---
    const transferForm = document.getElementById('cst-transfer-form');
    if (transferForm) {
        transferForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const checkboxes = document.querySelectorAll('.cst-product-checkbox:checked');
            if (checkboxes.length === 0) {
                alert('Please select at least one product.');
                return;
            }

            checkboxes.forEach(cb => {
                const container = cb.closest('[data-cst-product-item]');
                if (container) {
                    const btnAddToCart = container.querySelector('.js-add-to-cart');
                    if (btnAddToCart) {
                        const productId = btnAddToCart.getAttribute('data-product-id');
                        const productAttributeId = btnAddToCart.getAttribute('data-product-attribute-id') || 0;
                        const productName = btnAddToCart.getAttribute('data-product-name');
                        const maxQty = btnAddToCart.getAttribute('data-max-qty');
                        
                        const qtyInput = container.querySelector('input[name="bulk_quantities[' + productId + ']"]');
                        let qty = qtyInput ? parseInt(qtyInput.value, 10) : 1;
                        
                        const existingItemIndex = window.transferCart.findIndex(item => 
                            item.productId === productId && item.productAttributeId === productAttributeId
                        );
                        
                        if (existingItemIndex > -1) {
                            let newQty = window.transferCart[existingItemIndex].qty + qty;
                            let maxAllowed = parseInt(maxQty, 10);
                            if (!isNaN(maxAllowed) && newQty > maxAllowed) {
                                newQty = maxAllowed;
                            }
                            window.transferCart[existingItemIndex].qty = newQty;
                        } else {
                            window.transferCart.push({
                                productId: productId,
                                productAttributeId: productAttributeId,
                                productName: productName,
                                maxQty: maxQty,
                                qty: qty
                            });
                        }
                        
                        cb.checked = false;
                    }
                }
            });

            updateCartBadge();
            renderCartItems();
            if (cartModal) {
                cartModal.style.display = 'flex';
            }
        });
    }

    // 4. Edit Quantity Modal Logic
    const editModal = document.getElementById('cst-edit-modal');
    const editForm = document.getElementById('cst-edit-form');




    if (editForm) {
        editForm.addEventListener('submit', function (e) {
            const qtyInput = editForm.querySelector('input[name="new_quantity"]');
            const maxInput = editForm.querySelector('input[name="max_quantity"]');
            const storeFromInput = editForm.querySelector('select[name="id_store_from"]');
            const storeToInput = editForm.querySelector('select[name="id_store_to"]');

            const newQty = parseInt(qtyInput.value);
            const maxQty = parseInt(maxInput.value);
            const storeFrom = storeFromInput ? storeFromInput.value : '';
            const storeTo = storeToInput ? storeToInput.value : '';
            
            const errorBox = editForm.querySelector('.js-edit-modal-error');
            const errorText = errorBox.querySelector('.error-text');

            if (!storeFrom || !storeTo) {
                e.preventDefault();
                errorText.innerText = 'Please select both Store From and Store To.';
                errorBox.style.display = 'flex';
                return;
            }

            if (storeFrom === storeTo) {
                e.preventDefault();
                errorText.innerText = 'Store From and Store To cannot be the same.';
                errorBox.style.display = 'flex';
                return;
            }

            if (isNaN(newQty) || newQty <= 0) {
                e.preventDefault();
                errorText.innerText = 'Quantity must be greater than 0.';
                errorBox.style.display = 'flex';
                return;
            }

            if (newQty > maxQty) {
                e.preventDefault();
                errorText.innerText = 'Quantity cannot exceed the maximum allowed value (' + maxQty + ').';
                errorBox.style.display = 'flex';
                return;
            }
        });
    }

    // 5. History Modal Logic
    const historyModal = document.getElementById('cst-history-modal');
    


});