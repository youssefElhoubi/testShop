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
                <div class="table-responsive">
                    <table class="table table-striped cst-table">
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Source Store</th>
                                <th>Destination Store</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Barcode</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$grouped_transfers['pending'] item=transfer}
                                <tr>
                                    <td>#{$transfer.id_transfer|intval}</td>
                                    <td>{$transfer.store_from_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_from|intval})</td>
                                    <td>{$transfer.store_to_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_to|intval})</td>
                                    <td><span class="badge badge-warning">Pending</span></td>
                                    <td>{$transfer.date_add|escape:'htmlall':'UTF-8'}</td>
                                    <td>
                                        <svg class="cst-barcode" jsbarcode-format="CODE128" jsbarcode-value="{$transfer.barcode|escape:'htmlall':'UTF-8'}" jsbarcode-height="40" jsbarcode-displayValue="true"></svg>
                                    </td>
                                    <td class="text-right">
                                        <button type="button" class="btn btn-primary js-review-transfer" data-id-transfer="{$transfer.id_transfer|intval}">
                                            <i class="icon-search"></i> Review Transfer
                                        </button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
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
                <div class="table-responsive">
                    <table class="table table-striped cst-table">
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Source Store</th>
                                <th>Destination Store</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Barcode</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$grouped_transfers['approved'] item=transfer}
                                <tr>
                                    <td>#{$transfer.id_transfer|intval}</td>
                                    <td>{$transfer.store_from_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_from|intval})</td>
                                    <td>{$transfer.store_to_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_to|intval})</td>
                                    <td><span class="badge badge-success">Approved</span></td>
                                    <td>{$transfer.date_add|escape:'htmlall':'UTF-8'}</td>
                                    <td>
                                        <svg class="cst-barcode" jsbarcode-format="CODE128" jsbarcode-value="{$transfer.barcode|escape:'htmlall':'UTF-8'}" jsbarcode-height="40" jsbarcode-displayValue="true"></svg>
                                    </td>
                                    <td class="text-right">
                                        <button type="button" class="btn btn-default js-review-transfer" data-id-transfer="{$transfer.id_transfer|intval}">
                                            <i class="icon-eye"></i> View Details
                                        </button>
                                        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" class="js-pipeline-form" style="display:inline-block; margin:0;">
                                            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                            <input type="hidden" name="id_transfer" value="{$transfer.id_transfer|intval}">
                                            <button type="submit" name="submitMarkPrepared" value="1" class="btn btn-info">Mark as Prepared</button>
                                        </form>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
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
                <div class="table-responsive">
                    <table class="table table-striped cst-table">
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Source Store</th>
                                <th>Destination Store</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Barcode</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$grouped_transfers['prepared'] item=transfer}
                                <tr>
                                    <td>#{$transfer.id_transfer|intval}</td>
                                    <td>{$transfer.store_from_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_from|intval})</td>
                                    <td>{$transfer.store_to_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_to|intval})</td>
                                    <td><span class="badge badge-warning">Prepared</span></td>
                                    <td>{$transfer.date_add|escape:'htmlall':'UTF-8'}</td>
                                    <td>
                                        <svg class="cst-barcode" jsbarcode-format="CODE128" jsbarcode-value="{$transfer.barcode|escape:'htmlall':'UTF-8'}" jsbarcode-height="40" jsbarcode-displayValue="true"></svg>
                                    </td>
                                    <td class="text-right">
                                        <button type="button" class="btn btn-default js-review-transfer" data-id-transfer="{$transfer.id_transfer|intval}">
                                            <i class="icon-eye"></i> View Details
                                        </button>
                                        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" class="js-pipeline-form" style="display:inline-block; margin:0;">
                                            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                            <input type="hidden" name="id_transfer" value="{$transfer.id_transfer|intval}">
                                            <button type="submit" name="submitMarkShipped" value="1" class="btn btn-primary" style="background-color: #6f42c1; border-color: #6f42c1;">Mark as Shipped</button>
                                        </form>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">No prepared transfers found.</div>
            {/if}
        </div>

        <!-- IN TRANSIT TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-in_transit">
            {if isset($grouped_transfers['in_transit']) && $grouped_transfers['in_transit']|@count > 0}
                <div class="table-responsive">
                    <table class="table table-striped cst-table">
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Source Store</th>
                                <th>Destination Store</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Barcode</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$grouped_transfers['in_transit'] item=transfer}
                                <tr>
                                    <td>#{$transfer.id_transfer|intval}</td>
                                    <td>{$transfer.store_from_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_from|intval})</td>
                                    <td>{$transfer.store_to_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_to|intval})</td>
                                    <td><span class="badge badge-info">In Transit</span></td>
                                    <td>{$transfer.date_add|escape:'htmlall':'UTF-8'}</td>
                                    <td>
                                        <svg class="cst-barcode" jsbarcode-format="CODE128" jsbarcode-value="{$transfer.barcode|escape:'htmlall':'UTF-8'}" jsbarcode-height="40" jsbarcode-displayValue="true"></svg>
                                    </td>
                                    <td class="text-right">
                                        <button type="button" class="btn btn-default js-review-transfer" data-id-transfer="{$transfer.id_transfer|intval}">
                                            <i class="icon-eye"></i> View Details
                                        </button>
                                        <form method="post" action="{$form_action|escape:'htmlall':'UTF-8'}" class="js-pipeline-form" style="display:inline-block; margin:0;">
                                            <input type="hidden" name="token" value="{$token|escape:'htmlall':'UTF-8'}">
                                            <input type="hidden" name="id_transfer" value="{$transfer.id_transfer|intval}">
                                            <button type="submit" name="submitMarkCompleted" value="1" class="btn btn-success">Mark as Completed</button>
                                        </form>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">No transfers in transit found.</div>
            {/if}
        </div>
        
        <!-- COMPLETED TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-completed">
            {if isset($grouped_transfers['completed']) && $grouped_transfers['completed']|@count > 0}
                <div class="table-responsive">
                    <table class="table table-striped cst-table">
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Source Store</th>
                                <th>Destination Store</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Barcode</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$grouped_transfers['completed'] item=transfer}
                                <tr>
                                    <td>#{$transfer.id_transfer|intval}</td>
                                    <td>{$transfer.store_from_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_from|intval})</td>
                                    <td>{$transfer.store_to_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_to|intval})</td>
                                    <td><span class="badge badge-success">Completed</span></td>
                                    <td>{$transfer.date_add|escape:'htmlall':'UTF-8'}</td>
                                    <td>
                                        <svg class="js-barcode" data-barcode="{$transfer.barcode|escape:'htmlall':'UTF-8'}"></svg>
                                    </td>
                                    <td class="text-right">
                                        <button type="button" class="btn btn-default js-review-transfer" data-id-transfer="{$transfer.id_transfer|intval}">
                                            <i class="icon-eye"></i> View Details
                                        </button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">No completed transfers found.</div>
            {/if}
        </div>

        <!-- DECLINED TAB -->
        <div role="tabpanel" class="tab-pane" id="tab-declined">
            {if isset($grouped_transfers['declined']) && $grouped_transfers['declined']|@count > 0}
                <div class="table-responsive">
                    <table class="table table-striped cst-table">
                        <thead>
                            <tr>
                                <th>Transfer ID</th>
                                <th>Source Store</th>
                                <th>Destination Store</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Reason</th>
                                <th class="text-right">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {foreach from=$grouped_transfers['declined'] item=transfer}
                                <tr>
                                    <td>#{$transfer.id_transfer|intval}</td>
                                    <td>{$transfer.store_from_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_from|intval})</td>
                                    <td>{$transfer.store_to_name|escape:'htmlall':'UTF-8'} (ID: {$transfer.id_store_to|intval})</td>
                                    <td><span class="badge badge-danger">Declined</span></td>
                                    <td>{$transfer.date_add|escape:'htmlall':'UTF-8'}</td>
                                    <td>{$transfer.reason|escape:'htmlall':'UTF-8'}</td>
                                    <td class="text-right">
                                        <button type="button" class="btn btn-default js-review-transfer" data-id-transfer="{$transfer.id_transfer|intval}">
                                            <i class="icon-eye"></i> View Details
                                        </button>
                                    </td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            {else}
                <div class="alert alert-info" style="margin-top: 15px;">
                    No declined transfers found.
                </div>
            {/if}
        </div>
    </div>
</div>

<!-- Review Modal -->
<div id="cst-approval-modal" class="modal fade" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">Review Transfer Request</h4>
                <button type="button" class="close js-modal-close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger js-modal-error" style="display: none;"></div>
                
                <div class="table-responsive">
                    <table class="table table-bordered table-striped">
                        <thead>
                            <tr>
                                <th>Product ID</th>
                                <th>Attribute ID</th>
                                <th>Product Name</th>
                                <th class="text-right">Requested Qty</th>
                            </tr>
                        </thead>
                        <tbody id="approval-items-container">
                            <!-- Items injected here via AJAX -->
                        </tbody>
                    </table>
                </div>
                
                <!-- Hidden decline reason input (toggled via JS if they click decline) -->
                <div class="form-group js-decline-reason-container" style="display: none; margin-top: 15px;">
                    <label for="decline_reason_input">Decline Reason <span class="text-danger">*</span></label>
                    <input type="text" id="decline_reason_input" class="form-control" placeholder="Explain why this transfer is being declined...">
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary js-modal-close" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-danger js-btn-decline-transfer">Decline</button>
                <button type="button" class="btn btn-success js-btn-approve-transfer">Approve</button>
            </div>
        </div>
    </div>
</div>
