jQuery.migrateMute = true;
document.addEventListener('DOMContentLoaded', function () {
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
                totalQty += parseInt(item.qty || 1, 10);
            });
            badge.innerText = totalQty;
        }
    }

    updateBadge();
    renderCart(); // Initial render for live cart

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
        scannerInput.addEventListener('keydown', function (e) {
            console.log('Scanner input found');
            if (e.key === 'Enter') {
                e.preventDefault(); // CRITICAL: Stop browser submit/refresh
                console.log('Enter key pressed');
                
                const barcode = scannerInput.value.trim();
                if (!barcode) return;

                // Lock input and show loading state
                scannerInput.disabled = true;
                const originalPlaceholder = scannerInput.placeholder;
                scannerInput.placeholder = "Searching...";

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
                    success: function (response) {
                        if (response && response.success && response.product) {
                            let product = response.product;
                            let maxStock = product.stock !== undefined ? parseInt(product.stock) : Infinity;

                            // Check if product already exists in window.transferCart
                            let existingIndex = window.transferCart.findIndex(item =>
                                parseInt(item.id_product, 10) === parseInt(product.id_product, 10) &&
                                parseInt(item.id_product_attribute || 0, 10) === parseInt(product.id_product_attribute || 0, 10)
                            );

                            if (existingIndex > -1) {
                                // Increment quantity if it exists
                                let currentQty = parseInt(window.transferCart[existingIndex].qty, 10);
                                if (currentQty < maxStock) {
                                    window.transferCart[existingIndex].qty = currentQty + 1;
                                } else {
                                    Swal.fire({
                                        icon: 'warning',
                                        title: 'Stock Limit Reached',
                                        text: 'Cannot exceed available stock (' + maxStock + ')'
                                    });
                                }
                            } else {
                                // Add the new item
                                if (maxStock < 1) {
                                    Swal.fire({
                                        icon: 'error',
                                        title: 'Out of Stock',
                                        text: 'Cannot scan: Product has zero stock.'
                                    });
                                } else {
                                    window.transferCart.push({
                                        id_product: parseInt(product.id_product, 10),
                                        id_product_attribute: parseInt(product.id_product_attribute || 0, 10),
                                        name: product.name || '',
                                        reference: product.reference || product.ean13 || product.barcode || '',
                                        image_url: product.image_url || product.imageUrl || '',
                                        qty: 1,
                                        stock: parseInt(product.stock || maxStock, 10)
                                    });
                                }
                            }

                            // Save to localStorage and update UI
                            localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
                            updateBadge();
                            renderCart(); // Call renderCart immediately

                            // Trigger Visual Success State
                            scannerInput.classList.add('is-successful');
                            let feedbackMsg = document.getElementById('scanner-feedback-msg');
                            
                            if (feedbackMsg) {
                                feedbackMsg.textContent = 'Well done! ' + (product.name || 'Product') + ' added.';
                                feedbackMsg.classList.add('is-successful');
                            }

                            // Remove visual state after delay
                            setTimeout(() => {
                                scannerInput.classList.remove('is-successful');
                                if (feedbackMsg) {
                                    feedbackMsg.textContent = '';
                                    feedbackMsg.classList.remove('is-successful');
                                }
                            }, 1500);

                        } else {
                            if (typeof flashInputError === 'function') flashInputError(scannerInput);
                        }
                    },
                    error: function () {
                        if (typeof flashInputError === 'function') flashInputError(scannerInput);
                    },
                    complete: function () {
                        // Cleanup/Reset: unlock input and clean up
                        scannerInput.disabled = false;
                        if (originalPlaceholder !== undefined) {
                            scannerInput.placeholder = originalPlaceholder;
                        }
                        scannerInput.value = '';
                        scannerInput.focus();
                    }
                });
            }
        });
    }

    // 3. Cart Modal Rendering
    // const liveCartWrapper = document.getElementById('live-scanner-cart-container');

    function renderCart() {
        if (!cartContainer) return;

        

        let tableHtml = `
            <table class="table scanner-live-table mb-0">
                <thead>
                    <tr>
                        <th style="width: 80px;">Image</th>
                        <th>Product Details</th>
                        <th class="text-center" style="width: 150px;">Quantity</th>
                        <th class="text-center" style="width: 60px;">Action</th>
                    </tr>
                </thead>
                <tbody>
        `;

        window.transferCart.forEach((item, index) => {
            let imageUrl = item.image_url || '';
            let imageHtml = imageUrl ? `<img src="${imageUrl}" class="cst-cart-item-img">` : `<div class="cst-cart-item-img d-flex align-items-center justify-content-center text-muted"><i class="icon-image"></i></div>`;

            let productName = item.name || 'Unknown Product';
            let combinationName = item.combinationName || item.attribute_name || '';

            tableHtml += `
                <tr>
                    <td class="align-middle">${imageHtml}</td>
                    <td class="align-middle">
                        <div class="cst-cart-item-title">${productName}</div>
                        ${combinationName ? `<div class="cst-cart-item-meta">${combinationName}</div>` : ''}
                        <div class="cst-cart-item-meta">Barcode: ${item.reference || 'N/A'}</div>
                    </td>
                    <td class="align-middle text-center">
                        <div class="cst-cart-item-qty justify-content-center">
                            <button class="cst-btn-qty btn-minus" data-index="${index}" type="button"><i class="icon-minus"></i></button>
                            <input type="number" class="cst-qty-input qty-input mx-2" data-index="${index}" value="${item.qty}" min="1">
                            <button class="cst-btn-qty btn-plus" data-index="${index}" type="button"><i class="icon-plus"></i></button>
                        </div>
                    </td>
                    <td class="align-middle text-center">
                        <button class="cst-cart-item-remove btn-remove" data-index="${index}" title="Remove item">
                            <i class="icon-trash"></i>
                        </button>
                    </td>
                </tr>
            `;
        });

        tableHtml += `
                </tbody>
            </table>
        `;
        cartContainer.innerHTML = tableHtml;
    }


    // 4. Handle interactions inside the cart modal (Event Delegation)
    if (cartContainer) {
        cartContainer.addEventListener('click', function (e) {
            let target = e.target.closest('button');
            if (!target) return;

            let index = target.getAttribute('data-index');
            if (index === null) return;
            index = parseInt(index);

            let maxStock = window.transferCart[index].stock !== undefined ? parseInt(window.transferCart[index].stock) : Infinity;

            if (target.classList.contains('btn-remove')) {
                window.transferCart.splice(index, 1);
            } else if (target.classList.contains('btn-plus')) {
                if (window.transferCart[index].qty < maxStock) {
                    window.transferCart[index].qty++;
                } else {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Stock Limit Reached',
                        text: 'Cannot exceed available stock (' + maxStock + ')'
                    });
                }
            } else if (target.classList.contains('btn-minus')) {
                if (window.transferCart[index].qty > 1) {
                    window.transferCart[index].qty--;
                }
            }

            localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
            updateBadge();
            renderCart();
        });

        // Handle manual quantity input changes with Stock Limit Validation
        cartContainer.addEventListener('change', function (e) {
            if (e.target.classList.contains('qty-input')) {
                let index = parseInt(e.target.getAttribute('data-index'));
                let newQty = parseInt(e.target.value);
                let maxStock = window.transferCart[index].stock !== undefined ? parseInt(window.transferCart[index].stock) : Infinity;

                if (isNaN(newQty) || newQty < 1) {
                    // Revert to old valid quantity
                    e.target.value = window.transferCart[index].qty;
                    return;
                }

                if (newQty > maxStock) {
                    // Revert input to maximum available stock and show warning
                    window.transferCart[index].qty = maxStock;
                    e.target.value = maxStock;

                    // Show brief warning using alert or temporary UI change
                    let originalBg = e.target.style.backgroundColor;
                    e.target.style.backgroundColor = '#fff3cd'; // Bootstrap warning color
                    setTimeout(() => e.target.style.backgroundColor = originalBg, 1000);

                    Swal.fire({
                        icon: 'warning',
                        title: 'Stock Adjusted',
                        text: 'Quantity reduced to maximum available stock (' + maxStock + ')'
                    });
                } else {
                    window.transferCart[index].qty = newQty;
                }

                localStorage.setItem('cst_transfer_cart', JSON.stringify(window.transferCart));
                updateBadge();
            }
        });
    }

    // 5. Checkout Submission
    const btnConfirmTransfer = document.getElementById('btn-confirm-scanner-transfer');
    if (btnConfirmTransfer) {
        btnConfirmTransfer.addEventListener('click', function (e) {
            if (window.transferCart.length === 0) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Empty Cart',
                    text: 'Your transfer cart is empty. Scan some items first!',
                    confirmButtonColor: '#3085d6'
                });
                return;
            }
            const warehouseFromEl = document.getElementById('id_warehouse_from');
            const warehouseToEl = document.getElementById('id_warehouse_to');
            const idWarehouseFrom = warehouseFromEl ? warehouseFromEl.value : "0";
            const idWarehouseTo = warehouseToEl ? warehouseToEl.value : "0";

            if (idWarehouseFrom === "0" || idWarehouseFrom === "" || idWarehouseTo === "0" || idWarehouseTo === "") {
                Swal.fire({
                    icon: 'error',
                    title: 'Missing Stores',
                    text: 'You must select both a Source and Destination warehouse before confirming.'
                });
                return;
            }

            if (idWarehouseFrom === idWarehouseTo) {
                Swal.fire({
                    icon: 'warning',
                    title: 'Invalid Route',
                    text: 'The Source and Destination warehouses cannot be the same.'
                });
                return;
            }

            let originalText = btnConfirmTransfer.innerHTML;
            btnConfirmTransfer.disabled = true;
            btnConfirmTransfer.innerHTML = 'Processing...';

            $.ajax({
                url: window.cstConfig.ajaxUrl,
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'SubmitTransfer',
                    ajax: true,
                    id_warehouse_from: idWarehouseFrom,
                    id_warehouse_to: idWarehouseTo,
                    cartData: JSON.stringify(window.transferCart)
                },
                success: function (response) {
                    if (response && response.success) {
                        window.transferCart = [];
                        localStorage.removeItem('cst_transfer_cart');
                        updateBadge();
                        renderCart();
                        Swal.fire({
                            icon: 'success',
                            title: 'Success!',
                            text: response.message || 'Transfer submitted successfully!',
                            timer: 2000,
                            showConfirmButton: false
                        });
                    } else {
                        Swal.fire({
                            icon: 'error',
                            title: 'Server Error',
                            text: 'Something went wrong on the server. Please try again.'
                        });
                    }
                },
                error: function (xhr, status, error) {
                    Swal.fire({
                        icon: 'error',
                        title: 'Server Error',
                        text: 'Something went wrong on the server. Please try again.'
                    });
                },
                complete: function () {
                    btnConfirmTransfer.disabled = false;
                    btnConfirmTransfer.innerHTML = originalText;
                }
            });
        });
    }


    // Cross-Tab/Page Synchronization
    
    window.addEventListener('storage', function (e) {
            if (e.key === 'cst_transfer_cart') {
                window.transferCart = JSON.parse(e.newValue) || [];
                if (typeof renderCart === 'function') renderCart();
                if (typeof updateBadge === 'function') updateBadge();
            }
        });
    });
