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

});