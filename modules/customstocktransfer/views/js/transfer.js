(function ($) {
  $(document).ready(function () {
    var $modal = $('#customstocktransfer-transfer-modal');
    var $form = $('#customstocktransfer-transfer-form');
    var $hiddenProductId = $form.find('input[name="id_product"]');
    var $modalTitle = $modal.find('.js-transfer-modal-title');
    var $search = $('#customstocktransfer-search');
    var $clearSearch = $('#customstocktransfer-search-clear');
    var $resultCount = $('#customstocktransfer-result-count');
    var activeView = 'grid';

    function updateSearchState() {
      var term = ($search.val() || '').toString().trim().toLowerCase();
      var visibleCount = 0;
      var $items = $('[data-cst-product-item][data-stock-view="' + activeView + '"]');

      $items.each(function () {
        var $item = $(this);
        var text = ($item.data('cst-product-text') || '').toString().toLowerCase();
        var isVisible = term === '' || text.indexOf(term) !== -1;

        $item.toggleClass('d-none', !isVisible);

        if (isVisible) {
          visibleCount += 1;
        }
      });

      $resultCount.text(visibleCount);
    }

    function setView(view) {
      activeView = view === 'table' ? 'table' : 'grid';

      $('#customstocktransfer-grid-view').toggleClass('is-active', activeView === 'grid');
      $('#customstocktransfer-table-view').toggleClass('is-active', activeView === 'table');

      $('.js-stock-view-toggle').each(function () {
        var $button = $(this);
        var isActive = $button.data('view') === activeView;

        $button.toggleClass('btn-primary', isActive);
        $button.toggleClass('btn-outline-primary', !isActive);
        $button.toggleClass('active', isActive);
      });

      updateSearchState();
    }

    $('.js-open-transfer-modal').on('click', function () {
      var productId = $(this).data('product-id');
      var productName = $(this).data('product-name') || '';

      $hiddenProductId.val(productId);
      $modalTitle.text('Transfer Stock - #' + productId + ' ' + productName);
    });

    $modal.on('hidden.bs.modal', function () {
      $form[0].reset();
      $hiddenProductId.val('');
      $modalTitle.text('Transfer Stock');
    });

    $('.js-stock-view-toggle').on('click', function () {
      setView($(this).data('view'));
    });

    $search.on('input', updateSearchState);

    $clearSearch.on('click', function () {
      $search.val('');
      updateSearchState();
      $search.trigger('focus');
    });

    setView('grid');
  });
})(jQuery);