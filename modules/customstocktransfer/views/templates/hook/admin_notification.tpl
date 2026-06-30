<div class="component header-right-component">
    <div class="shop-state" id="custom-transfer-notifications">
        <a href="{$approval_link|escape:'htmlall':'UTF-8'}" class="notification-center-icon" title="Pending Stock Transfers" style="position:relative; margin-right: 15px; color: #6c868e; display: inline-flex; align-items: center; text-decoration: none;">
            <i class="material-icons" style="font-size: 24px;">swap_horiz</i>
            <span class="badge rounded-circle" style="position:absolute; top:-5px; right:-10px; background-color:#dc3545; color:white; font-size:10px; padding:3px 6px; border-radius: 50%; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">
                {$pending_transfers_count|intval}
            </span>
        </a>
    </div>
</div>
