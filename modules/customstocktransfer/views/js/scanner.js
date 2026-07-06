document.addEventListener('DOMContentLoaded', function() {
    // 1. State Management: Initialize Cart
    window.transferCart = JSON.parse(localStorage.getItem('cst_transfer_cart')) || [];
    
    const badge = document.getElementById('scanner-cart-badge');
    const scannerInput = document.getElementById('dedicated-scanner-input');
    const cartContainer = document.getElementById('scanner-cart-items-container');
    const btnViewCart = document.getElementById('btn-view-scanner-cart');

    function updateBadge() {
        if (badge) {
            let totalQty = 0;
            window.transferCart.forEach(item => {
                totalQty += parseInt(item.quantity || 1);
            });
            badge.innerText = totalQty;
        }
    }
    
    updateBadge();

    // Utility for HTML5 Beep
    function playErrorBeep() {
        try {
            const ctx = new (window.AudioContext || window.webkitAudioContext)();
            const osc = ctx.createOscillator();
            const gain = ctx.createGain();
            osc.connect(gain);
            gain.connect(ctx.destination);
            osc.type = 'square';
            osc.frequency.value = 150; // Low frequency for error buzz
            gain.gain.setValueAtTime(0.1, ctx.currentTime);
            osc.start(ctx.currentTime);
            osc.stop(ctx.currentTime + 0.2);
        } catch (e) {
            console.warn("AudioContext not supported, skipping beep");
        }
    }

    // Utility for Error Flash
    function flashInputError(inputEl) {
        inputEl.value = '';
        inputEl.style.backgroundColor = '#ffcccc';
        inputEl.style.borderColor = '#dc3545';
        playErrorBeep();
        
        setTimeout(() => {
            inputEl.style.backgroundColor = '';
            inputEl.style.borderColor = '';
            inputEl.focus();
        }, 400);
    }

    // 2. The Scanner Listener (Debounced & Validated)
    if (scannerInput) {
        scannerInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                let barcode = scannerInput.value.trim();
                
                if (!barcode) return;

                // EAN-13 Validation: exactly 13 digits
                if (!/^\d{13}$/.test(barcode)) {
                    flashInputError(scannerInput);
                    return;
                }

                // Debounce/Locking: Lock input to prevent double scan
                scannerInput.disabled = true;

                // Show loading spinner next to input
                let spinner = document.createElement('div');
                spinner.className = 'spinner-border text-success position-absolute';
                spinner.style.right = '20px';
                spinner.style.top = '50%';
                spinner.style.transform = 'translateY(-50%)';
                spinner.style.width = '2rem';
                spinner.style.height = '2rem';
                spinner.id = 'scanner-loading-spinner';
                
                let parentGroup = scannerInput.closest('.form-group');
                if (parentGroup) {
                    parentGroup.style.position = 'relative';
                    parentGroup.appendChild(spinner);
                }

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
                            let maxStock = product.stock !== undefined ? parseInt(product.stock) : Infinity;
                            
                            // Check if product already exists in window.transferCart
                            let existingIndex = window.transferCart.findIndex(item => 
                                item.id_product == product.id_product && 
                                item.id_product_attribute == product.id_product_attribute
                            );

                            if (existingIndex > -1) {
                                // Increment quantity if it exists, respecting max stock
                                let currentQty = parseInt(window.transferCart[existingIndex].quantity);
                                if (currentQty < maxStock) {
                                    window.transferCart[existingIndex].quantity = currentQty + 1;
                                } else {
                                    alert('Cannot exceed available stock (' + maxStock + ')');
                                }
                            } else {
                                // Push the new product object if there is stock
                                if (maxStock < 1) {
                                    alert('Cannot scan: Product has zero stock.');
                                } else {
                                    product.quantity = 1;
                                    window.transferCart.push(product);
                                }
                            }

                            // Save to localStorage and update UI
                            localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
                            updateBadge();
                            renderCart();
                        } else {
                            flashInputError(scannerInput);
                        }
                    },
                    error: function() {
                        flashInputError(scannerInput);
                    },
                    complete: function() {
                        // Success/Error Reset: Unlock input and clean up
                        scannerInput.disabled = false;
                        scannerInput.value = '';
                        scannerInput.focus();
                        
                        let loadingSpinner = document.getElementById('scanner-loading-spinner');
                        if (loadingSpinner) {
                            loadingSpinner.remove();
                        }
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

            let maxStock = window.transferCart[index].stock !== undefined ? parseInt(window.transferCart[index].stock) : Infinity;

            if (target.classList.contains('btn-remove')) {
                window.transferCart.splice(index, 1);
            } else if (target.classList.contains('btn-plus')) {
                if (window.transferCart[index].quantity < maxStock) {
                    window.transferCart[index].quantity++;
                } else {
                    alert('Cannot exceed available stock (' + maxStock + ')');
                }
            } else if (target.classList.contains('btn-minus')) {
                if (window.transferCart[index].quantity > 1) {
                    window.transferCart[index].quantity--;
                }
            }

            localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
            updateBadge();
            renderCart();
        });

        // Handle manual quantity input changes with Stock Limit Validation
        cartContainer.addEventListener('change', function(e) {
            if (e.target.classList.contains('qty-input')) {
                let index = parseInt(e.target.getAttribute('data-index'));
                let newQty = parseInt(e.target.value);
                let maxStock = window.transferCart[index].stock !== undefined ? parseInt(window.transferCart[index].stock) : Infinity;
                
                if (isNaN(newQty) || newQty < 1) {
                    // Revert to old valid quantity
                    e.target.value = window.transferCart[index].quantity;
                    return;
                }

                if (newQty > maxStock) {
                    // Revert input to maximum available stock and show warning
                    window.transferCart[index].quantity = maxStock;
                    e.target.value = maxStock;
                    
                    // Show brief warning using alert or temporary UI change
                    let originalBg = e.target.style.backgroundColor;
                    e.target.style.backgroundColor = '#fff3cd'; // Bootstrap warning color
                    setTimeout(() => e.target.style.backgroundColor = originalBg, 1000);
                    
                    alert('Quantity reduced to maximum available stock (' + maxStock + ')');
                } else {
                    window.transferCart[index].quantity = newQty;
                }
                
                localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
                updateBadge();
            }
        });
    }
});
