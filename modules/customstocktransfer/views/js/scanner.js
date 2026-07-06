document.addEventListener('DOMContentLoaded', function() {
    // 1. State Management: Initialize Cart
    window.transferCart = JSON.parse(localStorage.getItem('cst_transfer_cart')) || [];
    
    const badge = document.getElementById('scanner-cart-badge');
    const scannerInput = document.getElementById('dedicated-scanner-input');
    const cartContainer = document.getElementById('scanner-cart-items-container');
    const btnViewCart = document.getElementById('btn-view-scanner-cart');

    function updateBadge() {
        if (badge) {
            // Can display total quantity or distinct items. Using unique items (length) for badge.
            let totalQty = 0;
            window.transferCart.forEach(item => {
                totalQty += parseInt(item.quantity || 1);
            });
            badge.innerText = totalQty;
        }
    }
    
    // Initialize badge on load
    updateBadge();

    // 2. The Scanner Listener
    if (scannerInput) {
        scannerInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                let barcode = scannerInput.value.trim();
                
                if (!barcode) return;

                // Send AJAX request
                $.ajax({
                    url: window.cstConfig.ajaxUrl,
                    type: 'POST',
                    dataType: 'json',
                    data: {
                        action: 'ScanBarcode',
                        ajax: true,
                        barcode: barcode
                    },
                    success: function(response) {
                        if (response && response.success && response.product) {
                            let product = response.product;
                            
                            // Check if product already exists in window.transferCart
                            let existingIndex = window.transferCart.findIndex(item => 
                                item.id_product == product.id_product && 
                                item.id_product_attribute == product.id_product_attribute
                            );

                            if (existingIndex > -1) {
                                // Increment quantity if it exists
                                window.transferCart[existingIndex].quantity = parseInt(window.transferCart[existingIndex].quantity) + 1;
                            } else {
                                // Push the new product object
                                product.quantity = 1;
                                window.transferCart.push(product);
                            }

                            // Save to localStorage
                            localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
                            
                            // Update the cart badge
                            updateBadge();
                            
                        } else {
                            // Feedback if product is not found
                            console.error(response.message || 'Product not found.');
                        }
                    },
                    error: function() {
                        console.error('Error communicating with the server.');
                    },
                    complete: function() {
                        // Instantly clear the input field and keep focus
                        scannerInput.value = '';
                        scannerInput.focus();
                    }
                });
            }
        });
    }

    // 3. Cart Modal Rendering
    function renderCart() {
        if (!cartContainer) return;
        
        cartContainer.innerHTML = '';
        
        if (window.transferCart.length === 0) {
            cartContainer.innerHTML = '<tr><td colspan="4" class="text-center text-muted py-4">Your scanner cart is empty. Scan items to add them.</td></tr>';
            return;
        }

        window.transferCart.forEach((item, index) => {
            let tr = document.createElement('tr');
            
            // Handle various image properties that PHP might return
            let imageUrl = item.image_url || item.imageUrl || '';
            let imageHtml = imageUrl ? `<img src="${imageUrl}" width="50" class="img-thumbnail border-0 shadow-sm" style="border-radius: 8px;">` : '<div style="width:50px;height:50px;background:#f8f9fa;border-radius:8px;display:flex;align-items:center;justify-content:center;" class="text-muted"><i class="icon-image"></i></div>';

            let productName = item.name || item.productName || item.product_name || 'Unknown Product';
            let combinationName = item.combinationName || item.attribute_name || '';

            tr.innerHTML = `
                <td class="text-center align-middle">
                    ${imageHtml}
                </td>
                <td class="align-middle">
                    <h6 class="mb-0 text-dark">${productName}</h6>
                    ${combinationName ? `<small class="text-muted">${combinationName}</small><br>` : ''}
                    <small class="text-muted">Barcode: ${item.barcode || item.ean13 || item.reference || 'N/A'}</small>
                </td>
                <td class="text-center align-middle">
                    <div class="input-group input-group-sm mx-auto" style="max-width: 120px;">
                        <div class="input-group-prepend">
                            <button class="btn btn-outline-secondary btn-minus" data-index="${index}" type="button">-</button>
                        </div>
                        <input type="number" class="form-control text-center qty-input" data-index="${index}" value="${item.quantity}" min="1">
                        <div class="input-group-append">
                            <button class="btn btn-outline-secondary btn-plus" data-index="${index}" type="button">+</button>
                        </div>
                    </div>
                </td>
                <td class="text-center align-middle">
                    <button class="btn btn-outline-danger btn-sm btn-remove" data-index="${index}" title="Remove item">
                        <i class="icon-trash"></i>
                    </button>
                </td>
            `;
            cartContainer.appendChild(tr);
        });
    }

    if (btnViewCart) {
        btnViewCart.addEventListener('click', function() {
            renderCart();
        });
    }
    
    // Backup listener: also render on Bootstrap modal show event to be safe
    if (typeof $ !== 'undefined') {
        $('#scannerCartModal').on('show.bs.modal', function () {
            renderCart();
        });
    }

    // 4. Handle interactions inside the cart modal (Event Delegation)
    if (cartContainer) {
        cartContainer.addEventListener('click', function(e) {
            let target = e.target.closest('button');
            if (!target) return;

            let index = target.getAttribute('data-index');
            if (index === null) return;
            index = parseInt(index);

            if (target.classList.contains('btn-remove')) {
                window.transferCart.splice(index, 1);
            } else if (target.classList.contains('btn-plus')) {
                window.transferCart[index].quantity++;
            } else if (target.classList.contains('btn-minus')) {
                if (window.transferCart[index].quantity > 1) {
                    window.transferCart[index].quantity--;
                }
            }

            // Save state, update UI
            localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
            updateBadge();
            renderCart();
        });

        // Handle manual quantity input changes
        cartContainer.addEventListener('change', function(e) {
            if (e.target.classList.contains('qty-input')) {
                let index = parseInt(e.target.getAttribute('data-index'));
                let newQty = parseInt(e.target.value);
                
                if (!isNaN(newQty) && newQty > 0) {
                    window.transferCart[index].quantity = newQty;
                } else {
                    // Revert to old valid quantity
                    e.target.value = window.transferCart[index].quantity;
                }
                
                localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
                updateBadge();
            }
        });
    }
});
