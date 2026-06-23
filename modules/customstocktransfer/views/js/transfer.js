document.addEventListener('DOMContentLoaded', function() {
    
    // 1. Grid/Table Toggle (Using Event Delegation)
    document.addEventListener('click', function(e) {
        // Find if we clicked a toggle button
        const btn = e.target.closest('.js-stock-view-toggle');
        if (!btn) return;

        const targetView = btn.getAttribute('data-view'); // 'grid' or 'table'
        const allBtns = document.querySelectorAll('.js-stock-view-toggle');
        const allViews = document.querySelectorAll('.cst-view');

        // Reset all buttons
        allBtns.forEach(b => {
            b.classList.remove('active', 'btn-primary');
            b.classList.add('btn-outline-primary');
        });

        // Activate clicked button
        btn.classList.remove('btn-outline-primary');
        btn.classList.add('active', 'btn-primary');

        // Swap the views
        allViews.forEach(v => v.classList.remove('is-active'));
        document.getElementById('customstocktransfer-' + targetView + '-view').classList.add('is-active');
    });

    // 2. Transfer Modal Data Injector (Using jQuery for PrestaShop BO compatibility)
    $(document).on('click', '.js-open-transfer-modal', function() {
        const productId = $(this).data('product-id');
        const productName = $(this).data('product-name');
        
        // Inject ID into the hidden input
        $('input[name="id_product"]').val(productId);
        
        // Change title so you know what you're moving
        $('.js-transfer-modal-title').text('Transfer: ' + productName);
    });

});