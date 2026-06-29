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

    const transferForm = document.getElementById('cst-transfer-form');
    if (transferForm) {
        transferForm.addEventListener('submit', function (e) {
            const source = transferForm.querySelector('select[name="source_shop_id"]').value;
            const dest = transferForm.querySelector('select[name="destination_shop_id"]').value;

            if (!source) {
                e.preventDefault();
                showCustomError('Please select a source store.');
                return;
            }

            if (!dest) {
                e.preventDefault();
                showCustomError('Please select a destination store.');
                return;
            }

            if (source === dest) {
                e.preventDefault();
                showCustomError('The source and destination stores must be different.');
                return;
            }

            const checkboxes = transferForm.querySelectorAll('input[name="bulk_product_ids[]"]:checked');
            if (checkboxes.length === 0) {
                e.preventDefault();
                showCustomError('Please select at least one product to transfer.');
                return;
            }

            let validQuantity = true;
            checkboxes.forEach(function (cb) {
                const qtyInput = transferForm.querySelector('input[name="bulk_quantities[' + cb.value + ']"]');
                if (qtyInput && (parseInt(qtyInput.value) <= 0 || isNaN(parseInt(qtyInput.value)))) {
                    validQuantity = false;
                }
            });

            if (!validQuantity) {
                e.preventDefault();
                showCustomError('Quantities for selected products must be greater than zero.');
                return;
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