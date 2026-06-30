<div class="panel">
    <div class="panel-heading">
        <i class="icon-clock-o"></i> Pending Approvals
    </div>
    
    <!-- Nav tabs -->
    <ul class="nav nav-tabs cst-tabs" role="tablist" style="margin-bottom: 20px;">
        <li role="presentation" class="active">
            <a href="#tab-pending" aria-controls="tab-pending" role="tab" data-toggle="tab">Pending</a>
        </li>
        <li role="presentation">
            <a href="#tab-approved" aria-controls="tab-approved" role="tab" data-toggle="tab">Approved</a>
        </li>
        <li role="presentation">
            <a href="#tab-prepared" aria-controls="tab-prepared" role="tab" data-toggle="tab">Prepared</a>
        </li>
        <li role="presentation">
            <a href="#tab-in_transit" aria-controls="tab-in_transit" role="tab" data-toggle="tab">In Transit</a>
        </li>
        <li role="presentation">
            <a href="#tab-completed" aria-controls="tab-completed" role="tab" data-toggle="tab">Completed</a>
        </li>
        <li role="presentation">
            <a href="#tab-declined" aria-controls="tab-declined" role="tab" data-toggle="tab">Declined</a>
        </li>
    </ul>

    <!-- Tab panes -->
    <div class="tab-content">
        <!-- PENDING TAB -->
        <div role="tabpanel" class="tab-pane active" id="tab-pending">
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
                                
                                <div class="cst-barcode-wrapper">
                                    <strong>Barcode:</strong> <span>{$transfer.barcode|escape:'htmlall':'UTF-8'}</span>
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

        <!-- APPROVED TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-approved">
            {if isset($grouped_transfers['approved']) && $grouped_transfers['approved']|@count > 0}
                <div class="cst-card-grid">
                    {foreach from=$grouped_transfers['approved'] item=transfer}
                        <div class="cst-card" style="opacity: 0.9;">
                            <div class="cst-card-img-area">
                                <span class="cst-card-tab" style="background: #e6f4ea; color: #137333;">Approved</span>
                                {if $transfer.image_url}
                                    <img src="{$transfer.image_url|escape:'htmlall':'UTF-8'}" alt="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                                {else}
                                    <div style="height: 150px; background: #f5f5f5; display: flex; align-items: center; justify-content: center;">
                                        <span class="text-muted"><i class="icon-picture-o fa-3x"></i></span>
                                    </div>
                                {/if}
                            </div>
                            
                            <div class="cst-card-body" style="padding: 1.5rem;">
                                <h3 style="margin: 0 0 10px 0; font-size: 16px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                    {$transfer.product_name|escape:'htmlall':'UTF-8'}
                                </h3>
                                <p style="margin: 0; color: #555;"><strong>Qty Transferred:</strong> {$transfer.quantity|intval}</p>
                                <p style="margin: 0; color: #555;"><strong>Destination Store:</strong> {$transfer.id_store_to|intval}</p>
                                
                                <div class="cst-barcode-wrapper">
                                    <strong>Barcode:</strong> <span>{$transfer.barcode|escape:'htmlall':'UTF-8'}</span>
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">
                    No approved transfers found.
                </div>
            {/if}
        </div>
        
        <!-- PREPARED TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-prepared">
            {if isset($grouped_transfers['prepared']) && $grouped_transfers['prepared']|@count > 0}
                <div class="cst-card-grid">
                    {foreach from=$grouped_transfers['prepared'] item=transfer}
                        <div class="cst-card">
                            <div class="cst-card-img-area">
                                {if $transfer.image_url}
                                    <img src="{$transfer.image_url|escape:'htmlall':'UTF-8'}" alt="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                                {else}
                                    <div style="height: 150px; background: #f5f5f5; display: flex; align-items: center; justify-content: center;"><span class="text-muted"><i class="icon-picture-o fa-3x"></i></span></div>
                                {/if}
                            </div>
                            <div class="cst-card-body" style="padding: 1.5rem;">
                                <h3 style="margin: 0 0 10px 0; font-size: 16px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">{$transfer.product_name|escape:'htmlall':'UTF-8'}</h3>
                                <span class="badge badge-warning" style="border-radius: 20px;">Prepared</span>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">No prepared transfers found.</div>
            {/if}
        </div>

        <!-- IN TRANSIT TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-in_transit">
            {if isset($grouped_transfers['in_transit']) && $grouped_transfers['in_transit']|@count > 0}
                <div class="cst-card-grid">
                    {foreach from=$grouped_transfers['in_transit'] item=transfer}
                        <div class="cst-card">
                            <div class="cst-card-img-area">
                                {if $transfer.image_url}
                                    <img src="{$transfer.image_url|escape:'htmlall':'UTF-8'}" alt="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                                {else}
                                    <div style="height: 150px; background: #f5f5f5; display: flex; align-items: center; justify-content: center;"><span class="text-muted"><i class="icon-picture-o fa-3x"></i></span></div>
                                {/if}
                            </div>
                            <div class="cst-card-body" style="padding: 1.5rem;">
                                <h3 style="margin: 0 0 10px 0; font-size: 16px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">{$transfer.product_name|escape:'htmlall':'UTF-8'}</h3>
                                <span class="badge badge-info" style="border-radius: 20px;">In Transit</span>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">No transfers in transit found.</div>
            {/if}
        </div>
        
        <!-- COMPLETED TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-completed">
            {if isset($grouped_transfers['completed']) && $grouped_transfers['completed']|@count > 0}
                <div class="cst-card-grid">
                    {foreach from=$grouped_transfers['completed'] item=transfer}
                        <div class="cst-card">
                            <div class="cst-card-img-area">
                                {if $transfer.image_url}
                                    <img src="{$transfer.image_url|escape:'htmlall':'UTF-8'}" alt="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                                {else}
                                    <div style="height: 150px; background: #f5f5f5; display: flex; align-items: center; justify-content: center;"><span class="text-muted"><i class="icon-picture-o fa-3x"></i></span></div>
                                {/if}
                            </div>
                            <div class="cst-card-body" style="padding: 1.5rem;">
                                <h3 style="margin: 0 0 10px 0; font-size: 16px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">{$transfer.product_name|escape:'htmlall':'UTF-8'}</h3>
                                <span class="badge badge-success" style="border-radius: 20px;">Completed</span>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">No completed transfers found.</div>
            {/if}
        </div>

        <!-- DECLINED TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-declined">
            {if isset($grouped_transfers['declined']) && $grouped_transfers['declined']|@count > 0}
                <div class="cst-card-grid">
                    {foreach from=$grouped_transfers['declined'] item=transfer}
                        <div class="cst-card" style="opacity: 0.8; background: #fffaf9;">
                            <div class="cst-card-body">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                                    <h3 style="margin: 0; font-size: 16px; font-weight: bold; color: #333;">
                                        {$transfer.product_name|escape:'htmlall':'UTF-8'}
                                    </h3>
                                    <span class="badge badge-danger" style="background-color: #dc3545; padding: 5px 10px; border-radius: 12px; color: #fff;">Declined</span>
                                </div>
                                
                                <p style="color: #666; margin-bottom: 10px;"><strong>From:</strong> {$transfer.id_store_from|intval} | <strong>To:</strong> {$transfer.id_store_to|intval}</p>
                                <div style="background: #fdf2f2; padding: 12px; border-left: 4px solid #dc3545; border-radius: 4px;">
                                    <strong>Reason:</strong> {$transfer.reason|escape:'htmlall':'UTF-8'}
                                </div>
                            </div>
                        </div>
                    {/foreach}
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">
                    No declined transfers found.
                </div>
            {/if}
        </div>
    </div>
</div>

<!-- Action Modal -->
<div id="cst-action-modal" class="cst-modal" style="display:none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 10000; align-items: center; justify-content: center;">
    <div class="cst-modal-overlay js-close-modal" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"></div>
    <div class="cst-modal-content" style="position: relative; background: #fff; padding: 25px; border-radius: 12px; width: 400px; max-width: 90%; z-index: 10001; box-shadow: 0 10px 30px rgba(0,0,0,0.2);">
        
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
            <h3 style="margin: 0; font-size: 1.25rem; font-weight: bold; color: #333;">Take Action</h3>
            <button type="button" class="js-close-modal" style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #999; padding: 0; line-height: 1;">&times;</button>
        </div>
        
        <div style="display: flex; flex-direction: column; gap: 20px;">
            <!-- Approve Form -->
            <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" style="margin: 0;">
                <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                <!-- Using class instead of duplicate IDs for validity -->
                <input type="hidden" name="id_transfer" class="modal-transfer-id" value="">
                <button type="submit" name="submitApproveTransfer" value="1" class="btn btn-success" style="width: 100%; padding: 12px; font-size: 1.1rem; border-radius: 8px;">
                    <i class="icon-check"></i> Approve Transfer
                </button>
            </form>
            
            <div style="text-align: center; color: #999; font-size: 0.9rem; position: relative;">
                <span style="background: #fff; padding: 0 10px; position: relative; z-index: 1;">OR</span>
                <hr style="position: absolute; top: 50%; left: 0; right: 0; margin: 0; border-top: 1px solid #eee; z-index: 0;">
            </div>
            
            <!-- Decline Form -->
            <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" class="js-decline-form" style="margin: 0; display: flex; flex-direction: column; gap: 10px;">
                <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                <input type="hidden" name="id_transfer" class="modal-transfer-id" value="">
                
                <div>
                    <label style="font-weight: 600; font-size: 0.95rem; color: #333; margin-bottom: 5px; display: block;">Decline Reason <span style="color: #dc3545;">*</span></label>
                    <input type="text" name="decline_reason" class="form-control cst-input" placeholder="Explain why..." required style="width: 100%;">
                </div>
                
                <button type="submit" name="submitDeclineTransfer" value="1" class="btn btn-danger" style="width: 100%; padding: 12px; font-size: 1.1rem; border-radius: 8px;">
                    <i class="icon-times"></i> Decline Transfer
                </button>
            </form>
        </div>
        
    </div>
</div>
