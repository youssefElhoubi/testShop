document.addEventListener('DOMContentLoaded', function () {
    // Global variable to track which transfer is being reviewed
    window.currentApprovalId = null;

    const modal = $('#cst-approval-modal');
    const itemsContainer = document.getElementById('approval-items-container');
    const errorAlert = document.querySelector('.js-modal-error');
    
    const declineContainer = document.querySelector('.js-decline-reason-container');
    const declineInput = document.getElementById('decline_reason_input');

    function showModalError(msg) {
        if (errorAlert) {
            errorAlert.innerHTML = msg;
            errorAlert.style.display = 'block';
        }
    }
    
    function hideModalError() {
        if (errorAlert) {
            errorAlert.style.display = 'none';
            errorAlert.innerHTML = '';
        }
    }

    function showCustomSuccess(message) {
        // Use PrestaShop's native growl if available
        if (typeof $.growl !== 'undefined' && $.growl.notice) {
            $.growl.notice({ title: '', message: message });
        } else {
            const container = document.querySelector('.panel');
            if (container) {
                const alertBox = document.createElement('div');
                alertBox.className = 'alert alert-success';
                alertBox.innerHTML = message;
                container.parentNode.insertBefore(alertBox, container);
            }
        }
    }

    // === 1. EVENT DELEGATION FOR REVIEW BUTTONS ===
    document.addEventListener('click', function (e) {
        const reviewBtn = e.target.closest('.js-review-transfer');
        if (reviewBtn) {
            e.preventDefault();
            const transferId = reviewBtn.getAttribute('data-id-transfer');
            
            if (!transferId) return;
            
            // Store ID globally
            window.currentApprovalId = transferId;
            hideModalError();
            
            // Reset modal UI states
            if (declineContainer) declineContainer.style.display = 'none';
            if (declineInput) declineInput.value = '';
            
            const originalHtml = reviewBtn.innerHTML;
            reviewBtn.innerHTML = '<i class="icon-spinner icon-spin"></i>';
            reviewBtn.disabled = true;

            // Fetch Transfer Details via AJAX
            $.ajax({
                url: window.location.href, // Sends to the current controller
                type: 'POST',
                dataType: 'json',
                data: {
                    ajax: true,
                    action: 'getTransferDetails',
                    id_transfer: transferId
                },
                success: function(response) {
                    reviewBtn.innerHTML = originalHtml;
                    reviewBtn.disabled = false;
                    
                    if (response && response.success) {
                        itemsContainer.innerHTML = '';
                        
                        if (response.details && response.details.length > 0) {
                            response.details.forEach(function(item) {
                                const tr = document.createElement('tr');
                                tr.innerHTML = `
                                    <td>${item.id_product}</td>
                                    <td>${item.id_product_attribute}</td>
                                    <td>${item.product_name}</td>
                                    <td class="text-right"><strong>${item.quantity}</strong></td>
                                `;
                                itemsContainer.appendChild(tr);
                            });
                        } else {
                            itemsContainer.innerHTML = '<tr><td colspan="4" class="text-center">No items found for this transfer.</td></tr>';
                        }
                        
                        // Check if the current row is in the "Pending" tab by looking for approve/decline actions.
                        // If it's already approved/shipped, we should hide the approve/decline buttons in the modal.
                        const isPending = reviewBtn.closest('#tab-pending') !== null;
                        const btnApprove = document.querySelector('.js-btn-approve-transfer');
                        const btnDecline = document.querySelector('.js-btn-decline-transfer');
                        
                        if (btnApprove) btnApprove.style.display = isPending ? 'inline-block' : 'none';
                        if (btnDecline) btnDecline.style.display = isPending ? 'inline-block' : 'none';
                        
                        // Open the modal
                        modal.modal('show');
                        
                        if (typeof JsBarcode !== 'undefined') { JsBarcode(".cst-barcode").init(); }
                    } else {
                        showCustomSuccess('Failed to fetch details: ' + (response.message || 'Unknown error'));
                    }
                },
                error: function() {
                    reviewBtn.innerHTML = originalHtml;
                    reviewBtn.disabled = false;
                    showCustomSuccess('A server error occurred while fetching details.');
                }
            });
        }

        // Handle native confirmations for the other workflow stages (Complete)
        const advanceBtn = e.target.closest('button[name="submitMarkCompleted"]');
        if (advanceBtn) {
            if (!window.confirm('Are you sure you want to advance this transfer to the next stage?')) {
                e.preventDefault();
            }
        }
    });

    // === 2. APPROVE BUTTON CLICK ===
    const btnApprove = document.querySelector('.js-btn-approve-transfer');
    if (btnApprove) {
        btnApprove.addEventListener('click', function() {
            if (!window.currentApprovalId) {
                showModalError('No transfer ID selected.');
                return;
            }

            hideModalError();
            const originalHtml = btnApprove.innerHTML;
            btnApprove.innerHTML = '<i class="icon-spinner icon-spin"></i> Approving...';
            btnApprove.disabled = true;

            // Submit approve via AJAX POST to the native postProcess logic
            $.ajax({
                url: window.location.href,
                type: 'POST',
                data: {
                    id_transfer: window.currentApprovalId,
                    submitApproveTransfer: 1
                },
                success: function() {
                    modal.modal('hide');
                    showCustomSuccess('Transfer approved successfully.');
                    setTimeout(() => window.location.reload(), 1000);
                },
                error: function() {
                    btnApprove.innerHTML = originalHtml;
                    btnApprove.disabled = false;
                    showModalError('A server error occurred while processing the approval.');
                }
            });
        });
    }

    // === 3. DECLINE BUTTON CLICK ===
    const btnDecline = document.querySelector('.js-btn-decline-transfer');
    if (btnDecline) {
        btnDecline.addEventListener('click', function() {
            if (!window.currentApprovalId) {
                showModalError('No transfer ID selected.');
                return;
            }

            // Step 1: Reveal the reason input if it's hidden
            if (declineContainer && declineContainer.style.display === 'none') {
                declineContainer.style.display = 'block';
                declineInput.focus();
                return;
            }
            
            // Step 2: Validate the reason if it is visible
            if (declineInput && declineInput.value.trim() === '') {
                showModalError('Please provide a reason for declining this request.');
                declineInput.style.borderColor = '#dc3545';
                return;
            }

            hideModalError();
            const originalHtml = btnDecline.innerHTML;
            btnDecline.innerHTML = '<i class="icon-spinner icon-spin"></i> Declining...';
            btnDecline.disabled = true;

            // Submit decline via AJAX POST
            $.ajax({
                url: window.location.href,
                type: 'POST',
                data: {
                    id_transfer: window.currentApprovalId,
                    decline_reason: declineInput.value.trim(),
                    submitDeclineTransfer: 1
                },
                success: function() {
                    modal.modal('hide');
                    showCustomSuccess('Transfer declined successfully.');
                    setTimeout(() => window.location.reload(), 1000);
                },
                error: function() {
                    btnDecline.innerHTML = originalHtml;
                    btnDecline.disabled = false;
                    showModalError('A server error occurred while declining the transfer.');
                }
            });
        });
    }

    // Cleanup error styles on typing
    if (declineInput) {
        declineInput.addEventListener('input', function() {
            this.style.borderColor = '';
            hideModalError();
        });
    }

    // === 4. INITIALIZE JSBARCODE ===
    if (typeof JsBarcode !== 'undefined') { JsBarcode(".cst-barcode").init(); }
});
