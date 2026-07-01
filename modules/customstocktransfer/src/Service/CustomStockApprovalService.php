<?php

namespace PrestaShop\Module\Customstocktransfer\Service;

use Exception;
use Shop;
use StockAvailable;
use StockTransfer;
use Validate;
use PrestaShop\Module\Customstocktransfer\Repository\CustomStockApprovalRepository;

class CustomStockApprovalService
{
    private $repository;

    public function __construct(CustomStockApprovalRepository $repository)
    {
        $this->repository = $repository;
    }

    public function approveTransfer(int $idTransfer, int $idEmployee): void
    {
        $transfer = new StockTransfer($idTransfer);

        if (!Validate::isLoadedObject($transfer) || $transfer->status !== 'pending') {
            throw new Exception('Invalid transfer or already processed.');
        }

        $qty = (int) $transfer->quantity;
        $idProduct = (int) $transfer->id_product;
        $idStoreFrom = (int) $transfer->id_store_from;
        $idStoreTo = (int) $transfer->id_store_to;

        $qtyFrom = StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $idStoreFrom);
        
        if ($qtyFrom < $qty) {
            throw new Exception('Not enough stock in the source store.');
        }

        $originalContext = Shop::getContext();
        $originalShopId = Shop::getContextShopID();
        
        try {
            // Force context to the source store
            Shop::setContext(Shop::CONTEXT_SHOP, $idStoreFrom);
            $currentQtyFrom = StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $idStoreFrom);
            StockAvailable::setQuantity($idProduct, 0, $currentQtyFrom - $qty, $idStoreFrom);
            
            // Force context to the destination store
            Shop::setContext(Shop::CONTEXT_SHOP, $idStoreTo);
            $currentQtyTo = StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $idStoreTo);
            StockAvailable::setQuantity($idProduct, 0, $currentQtyTo + $qty, $idStoreTo);
            
            $transfer->status = 'approved';
            $transfer->approved_by = $idEmployee;
            $transfer->approved_at = date('Y-m-d H:i:s');
            $transfer->date_upd = date('Y-m-d H:i:s');
            
            if (!$transfer->update()) {
                throw new Exception('Failed to update transfer status.');
            }
        } finally {
            // Unconditionally restore original context
            Shop::setContext($originalContext, $originalShopId);
        }
    }

    public function declineTransfer(int $idTransfer, string $reason): void
    {
        $transfer = new StockTransfer($idTransfer);

        if (!Validate::isLoadedObject($transfer) || $transfer->status !== 'pending') {
            throw new Exception('Invalid transfer or already processed.');
        }

        if (empty($reason)) {
            throw new Exception('Decline reason is required.');
        }

        $transfer->status = 'declined';
        $transfer->reason = $reason;
        $transfer->date_upd = date('Y-m-d H:i:s');
        
        if (!$transfer->update()) {
            throw new Exception('Failed to decline transfer.');
        }
    }

    public function markPrepared(int $idTransfer, int $idEmployee): void
    {
        $transfer = new StockTransfer($idTransfer);

        if (!Validate::isLoadedObject($transfer) || $transfer->status !== 'approved') {
            throw new Exception('Invalid transfer or it is not in the approved state.');
        }

        $transfer->status = 'prepared';
        $transfer->prepared_by = $idEmployee;
        $transfer->prepared_at = date('Y-m-d H:i:s');
        $transfer->date_upd = date('Y-m-d H:i:s');

        if (!$transfer->update()) {
            throw new Exception('Failed to mark transfer as prepared.');
        }
    }

    public function markShipped(int $idTransfer, int $idEmployee): void
    {
        $transfer = new StockTransfer($idTransfer);

        if (!Validate::isLoadedObject($transfer) || $transfer->status !== 'prepared') {
            throw new Exception('Invalid transfer or it is not in the prepared state.');
        }

        $transfer->status = 'in_transit';
        $transfer->shipped_by = $idEmployee;
        $transfer->shipped_at = date('Y-m-d H:i:s');
        $transfer->date_upd = date('Y-m-d H:i:s');

        if (!$transfer->update()) {
            throw new Exception('Failed to mark transfer as shipped.');
        }
    }

    public function markCompleted(int $idTransfer, int $idEmployee): void
    {
        $transfer = new StockTransfer($idTransfer);

        if (!Validate::isLoadedObject($transfer) || $transfer->status !== 'in_transit') {
            throw new Exception('Invalid transfer or it is not currently in transit.');
        }

        $transfer->status = 'completed';
        $transfer->received_by = $idEmployee;
        $transfer->received_at = date('Y-m-d H:i:s');
        $transfer->date_upd = date('Y-m-d H:i:s');

        if (!$transfer->update()) {
            throw new Exception('Failed to mark transfer as completed.');
        }
    }
}
