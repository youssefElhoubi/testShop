document.addEventListener('DOMContentLoaded', function() {
    
    // Grab the exact containers
    const gridView = document.getElementById('customstocktransfer-grid-view');
    const tableView = document.getElementById('customstocktransfer-table-view');
    const toggleBtns = document.querySelectorAll('.js-stock-view-toggle');

    // 0. Force Initial State: Show Grid, Hide Table immediately on load
    if (gridView && tableView) {
        gridView.style.display = 'block';
        tableView.style.display = 'none';
    }

    // 1. Bulletproof View Toggle
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.js-stock-view-toggle');
        if (!btn) return;

        const targetView = btn.getAttribute('data-view'); // 'grid' or 'table'

        // Swap button active states
        toggleBtns.forEach(b => b.classList.remove('active'));
        btn.classList.add('active');

        // Forcefully toggle displays using inline styles to override any broken CSS
        if (targetView === 'grid') {
            gridView.style.display = 'block';
            tableView.style.display = 'none';
        } else if (targetView === 'table') {
            gridView.style.display = 'none';
            tableView.style.display = 'block';
        }
    });

    // 2. Consolidated Modal Data Injector (Using jQuery)
    $(document).on('click', '.js-open-transfer-modal', function() {
        const productId = $(this).data('product-id');
        const productName = $(this).data('product-name');
        const form = $('#customstocktransfer-transfer-form');
        
        // Clear out the form so old quantities don't get stuck
        if (form.length) {
            form[0].reset();
        }
        
        // Inject ID into the hidden input
        $('input[name="id_product"]').val(productId);
        
        // Change title so you know exactly what you are transferring
        $('.js-transfer-modal-title').text('Transfer: ' + productName);
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
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    const filterForm = document.getElementById('cst-filter-form');
    if (filterForm) {
        filterForm.addEventListener('submit', function(e) {
            // Price and Quantity validations removed
        });
    }

    const transferForm = document.getElementById('cst-transfer-form');
    if (transferForm) {
        transferForm.addEventListener('submit', function(e) {
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
            checkboxes.forEach(function(cb) {
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
    
    $(document).on('click', '.js-open-edit-modal', function() {
        const productId = $(this).data('product-id');
        const productName = $(this).data('product-name');
        const currentQty = $(this).data('current-qty');
        const maxQty = $(this).data('max-qty');
        
        if (editForm) {
            editForm.reset();
            $('#cst-edit-form input[name="id_product"]').val(productId);
            $('#cst-edit-form input[name="max_quantity"]').val(maxQty);
            $('#cst-edit-form input[name="new_quantity"]').val(currentQty);
            $('.js-edit-modal-title').text('Edit Quantity: ' + productName);
            $('.js-edit-modal-error').hide();
        }
        
        if (editModal) {
            editModal.style.display = 'flex';
        }
    });

    $(document).on('click', '.js-close-edit-modal', function(e) {
        if (e.target === this) {
            if (editModal) {
                editModal.style.display = 'none';
            }
        }
    });

    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            const qtyInput = editForm.querySelector('input[name="new_quantity"]');
            const maxInput = editForm.querySelector('input[name="max_quantity"]');
            
            const newQty = parseInt(qtyInput.value);
            const maxQty = parseInt(maxInput.value);
            const errorBox = editForm.querySelector('.js-edit-modal-error');
            const errorText = errorBox.querySelector('.error-text');
            
            if (isNaN(newQty) || newQty < 0) {
                e.preventDefault();
                errorText.innerText = 'Quantity cannot be less than 0.';
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

});