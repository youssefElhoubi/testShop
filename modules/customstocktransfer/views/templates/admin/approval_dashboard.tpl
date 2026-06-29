<div class="panel">
    <div class="panel-heading">
        <i class="icon-clock-o"></i> Pending Approvals
    </div>
    
    <div class="row">
        {if isset($grouped_transfers['pending']) && $grouped_transfers['pending']|@count > 0}
            {foreach from=$grouped_transfers['pending'] item=transfer}
                <div class="col-md-4">
                    <div class="card" style="margin-bottom: 20px; border: 1px solid #dbe6e9; border-radius: 5px; box-shadow: 0 1px 3px rgba(0,0,0,0.05); background: #fff;">
                        
                        <div class="card-body" style="padding: 15px;">
                            {* Product Image *}
                            <div class="text-center" style="margin-bottom: 15px; height: 150px; display: flex; align-items: center; justify-content: center; background-color: #f9f9f9; border: 1px solid #f0f0f0;">
                                {if $transfer.image_url}
                                    <img src="{$transfer.image_url|escape:'htmlall':'UTF-8'}" alt="{$transfer.product_name|escape:'htmlall':'UTF-8'}" class="img-responsive" style="max-height: 140px;">
                                {else}
                                    <span class="text-muted"><i class="icon-picture-o fa-3x"></i><br>No Image</span>
                                {/if}
                            </div>
                            
                            {* Product Title *}
                            <h4 class="card-title text-center" style="margin-top: 0; font-size: 15px; font-weight: bold; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;" title="{$transfer.product_name|escape:'htmlall':'UTF-8'}">
                                {$transfer.product_name|escape:'htmlall':'UTF-8'}
                            </h4>
                            
                            {* Transfer Details *}
                            <ul class="list-group list-group-flush" style="margin-bottom: 0;">
                                <li class="list-group-item" style="padding: 8px 0; border-top: 1px solid #eee; border-bottom: none;">
                                    <strong>From Store:</strong> {$transfer.id_store_from|intval}
                                </li>
                                <li class="list-group-item" style="padding: 8px 0; border-top: 1px solid #eee; border-bottom: none;">
                                    <strong>To Store:</strong> {$transfer.id_store_to|intval}
                                </li>
                                <li class="list-group-item" style="padding: 8px 0; border-top: 1px solid #eee; border-bottom: none;">
                                    <strong>Quantity:</strong> <span class="badge badge-primary" style="font-size: 14px;">{$transfer.quantity|intval}</span>
                                </li>
                                <li class="list-group-item" style="padding: 8px 0; border-top: 1px solid #eee; border-bottom: none;">
                                    <strong>Date:</strong> {$transfer.date_add|escape:'htmlall':'UTF-8'}
                                </li>
                            </ul>
                        </div>
                        
                        <div class="card-footer" style="background-color: #fcfcfc; border-top: 1px solid #dbe6e9; padding: 15px;">
                            {* Exactly as designed for history table, adapted to flex row to fit card nicely *}
                            <div style="display: flex; gap: 5px; align-items: center; justify-content: center; flex-wrap: wrap;">
                                <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" style="margin:0;">
                                    <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                    <input type="hidden" name="id_transfer" value="{$transfer.id_transfer|escape:'htmlall':'UTF-8'}">
                                    <button type="submit" name="submitApproveTransfer" value="1" class="btn btn-success btn-sm">Approve</button>
                                </form>
                                <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" style="margin:0; display:flex; gap:5px; flex: 1;">
                                    <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                    <input type="hidden" name="id_transfer" value="{$transfer.id_transfer|escape:'htmlall':'UTF-8'}">
                                    <input type="text" name="decline_reason" class="form-control cst-input input-sm" style="flex: 1; min-width: 100px;" placeholder="Reason..." required>
                                    <button type="submit" name="submitDeclineTransfer" value="1" class="btn btn-danger btn-sm">Decline</button>
                                </form>
                            </div>
                        </div>

                    </div>
                </div>
            {/foreach}
        {else}
            <div class="col-md-12">
                <div class="alert alert-info">
                    There are no pending stock transfers awaiting approval.
                </div>
            </div>
        {/if}
    </div>
</div>
