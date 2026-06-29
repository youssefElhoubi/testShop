document.addEventListener('DOMContentLoaded', function () {

    // === UNIFIED EVENT DELEGATION ===
    document.addEventListener('click', function (e) {
        
        // 1. Approve Button Handler
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

        // 2. Decline Button Handler
        const declineBtn = e.target.closest('button[name="submitDeclineTransfer"]');
        if (declineBtn) {
            const form = declineBtn.closest('form');
            const reasonInput = form.querySelector('input[name="decline_reason"]');
            
            if (reasonInput) {
                // Check if the input is empty or just whitespace
                if (reasonInput.value.trim() === '') {
                    // Stop the form submission
                    e.preventDefault();
                    
                    // Alert the admin natively
                    window.alert('You must provide a reason for declining this stock transfer.');
                    
                    // Highlight the input in red and focus it for UX
                    reasonInput.style.borderColor = '#dc3545';
                    reasonInput.style.boxShadow = '0 0 0 0.2rem rgba(220, 53, 69, 0.25)';
                    reasonInput.focus();
                }
            }
            return;
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
