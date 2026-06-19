$(document).ready(function () {
    $(document).on('click', '.js-btn-ph-insta-refresh-token', function () {
        var $this = $(this);
        $.ajax({
            url: PH_INSTA_LINK_AJAX,
            type: 'POST',
            dataType: 'json',
            data: {
                phInstaCheckTokenLiveTime: 1
            },
            beforeSend: function () {
                $this.addClass('loading');
                $this.prop('disabled', true);
            },
            success: function (res) {
                if(res.success){
                    $('#PH_INSTAGRAM_ACCESS_TOKEN').val(res.new_token);
                    showSuccessMessage(res.message || 'Success');
                }
                else
                    showErrorMessage(res.message || 'Error');
            },
            complete: function () {
                $this.removeClass('loading');
                $this.prop('disabled', false);
            }
        });
        return false;
    });
});