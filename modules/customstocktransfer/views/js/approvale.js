document.addEventListener('DOMContentLoaded', function () {

    // === UNIFIED EVENT DELEGATION ===
    document.addEventListener('click', function (e) {
        
        // --- 0. Modal Toggle Logic ---
        
        // Open Modal
        const openActionBtn = e.target.closest('.js-open-action-modal');
        if (openActionBtn) {
            e.preventDefault();
            const transferId = openActionBtn.getAttribute('data-transfer-id');
            const modal = document.getElementById('cst-action-modal');
            
            if (modal) {
                // Populate all hidden transfer ID inputs in the modal forms
                const hiddenInputs = modal.querySelectorAll('.modal-transfer-id');
                hiddenInputs.forEach(input => {
                    input.value = transferId;
                });
                
                // Clear any previous validation errors or input values
                const reasonInput = modal.querySelector('input[name="decline_reason"]');
                if (reasonInput) {
                    reasonInput.value = '';
                    reasonInput.style.borderColor = '';
                    reasonInput.style.boxShadow = '';
                }
                
                // Show modal (we use flex for centering)
                modal.style.display = 'flex';
            }
            return;
        }

        // Close Modal
        if (e.target.matches('.js-close-modal') || e.target.closest('.js-close-modal')) {
            e.preventDefault();
            const modal = document.getElementById('cst-action-modal');
            if (modal) {
                modal.style.display = 'none';
            }
            return;
        }

        // --- 1. Approve Button Handler ---
        const approveBtn = e.target.closest('button[name="submitApproveTransfer"]');
        if (approveBtn) {
            // Show native confirmation prompt
            const confirmApprove = window.confirm('Are you sure you want to approve this stock transfer? This action will immediately adjust inventory quantities.');
            
            // If the user clicks "Cancel", prevent the form submission.
            // If they click "OK", we do nothing and let the native submit proceed.
            // This ensures $_POST['submitApproveTransfer'] is correctly sent to the backend.
            if (!confirmApprove) {
                e.preventDefault();
            }
            return;
        }

    });

    // === FORM SUBMIT INTERCEPTION ===
    document.addEventListener('submit', function (e) {
        if (e.target.matches('.js-decline-form')) {
            const reasonInput = e.target.querySelector('input[name="decline_reason"]');
            
            if (reasonInput && reasonInput.value.trim() === '') {
                e.preventDefault(); // Stop form submission
                
                // Show warning using showToast if available, otherwise fallback to native alert
                if (typeof showToast === 'function') {
                    showToast('You must provide a reason to decline this request.', 'error');
                } else {
                }
                
                // Highlight the input in red and focus it for UX
                reasonInput.style.borderColor = '#dc3545';
                reasonInput.style.boxShadow = '0 0 0 0.2rem rgba(220, 53, 69, 0.25)';
                reasonInput.focus();
            }
        }
    });

    // === UX IMPROVEMENT: Reset error styles on typing ===
    document.addEventListener('input', function (e) {
        if (e.target.matches('input[name="decline_reason"]')) {
            if (e.target.value.trim() !== '') {
                // Revert to original CSS when the user types
                e.target.style.borderColor = '';
                e.target.style.boxShadow = '';
            }
        }
    });

});
