<div class="panel">
    <div class="panel-heading">
        <i class="icon-clock-o"></i> Pending Approvals
    </div>
    
    {if isset($grouped_transfers['pending']) && $grouped_transfers['pending']|@count > 0}
        <div class="cst-card-grid">
            {foreach from=$grouped_transfers['pending'] item=transfer}
                <div class="cst-card">
                    <div class="cst-card-img-area">
                        <span class="cst-card-tab">Store From: {$transfer.id_store_from|escape:'htmlall':'UTF-8'}</span>
                        {if $transfer.image_url}
                            <img src="{$transfer.image_url|escape:'htmlall':'UTF-8'}" alt="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                        {else}
                            <div style="height: 150px; background: #f5f5f5; display: flex; align-items: center; justify-content: center;">
                                <span class="text-muted"><i class="icon-picture-o fa-3x"></i></span>
                            </div>
                        {/if}
                    </div>
                    
                    <div class="cst-card-body">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                            <h3 style="margin: 0; font-size: 16px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                                {$transfer.product_name|escape:'htmlall':'UTF-8'}
                            </h3>
                            <span class="cst-qty-badge badge badge-primary" style="border-radius: 20px;">Qty: {$transfer.quantity|intval}</span>
                        </div>
                        
                        <p style="color: #6c757d; font-size: 14px; margin-bottom: 15px;">Transfer to Store ID: {$transfer.id_store_to|intval}</p>
                        
                        <div class="cst-card-tags" style="display: flex; gap: 8px; margin-bottom: 20px;">
                            <span class="badge badge-warning" style="border-radius: 20px; font-weight: 500;">Pending</span>
                            <span class="badge badge-secondary" style="border-radius: 20px; font-weight: 500;">{$transfer.date_add|escape:'htmlall':'UTF-8'}</span>
                        </div>
                        
                        <button class="cst-action-btn btn btn-primary js-open-action-modal" style="width: 100%; border-radius: 6px; font-weight: 600; text-transform: uppercase; padding: 10px;" data-transfer-id="{$transfer.id_transfer|escape:'htmlall':'UTF-8'}">
                            Take Action
                        </button>
                    </div>
                </div>
            {/foreach}
        </div>
    {else}
        <div class="alert alert-info" style="margin-top: 15px;">
            There are no pending stock transfers awaiting approval.
        </div>
    {/if}
</div>
