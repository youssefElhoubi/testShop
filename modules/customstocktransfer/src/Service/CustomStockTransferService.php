<?php

namespace PrestaShop\Module\Customstocktransfer\Service;

use Configuration;
use Exception;
use Mail;
use PrestaShop\Module\Customstocktransfer\Repository\CustomStockTransferRepository;
use StockAvailable;
use StockTransfer;

class CustomStockTransferService
{
    private $repository;

    public function __construct(CustomStockTransferRepository $repository)
    {
        $this->repository = $repository;
    }

    public function createTransferRequest(int $idProduct, int $newQuantity, int $maxQuantity, int $idStoreFrom, int $idStoreTo, int $idLang): void
    {
        if ($idProduct <= 0 || !$this->repository->productExists($idProduct)) {
            throw new Exception('Invalid product.');
        }

        if ($idStoreFrom <= 0 || $idStoreTo <= 0) {
            throw new Exception('Please select valid stores.');
        }

        if ($idStoreFrom === $idStoreTo) {
            throw new Exception('Store From and Store To cannot be the same.');
        }

        if ($newQuantity <= 0) {
            throw new Exception('Quantity must be greater than 0.');
        }

        $maxLimit = $maxQuantity > 0 ? $maxQuantity : 99999;
        if ($newQuantity > $maxLimit) {
            throw new Exception(sprintf('Quantity cannot exceed the maximum allowed value (%d).', $maxLimit));
        }

        $transfer = new StockTransfer();
        $transfer->id_product = $idProduct;
        $transfer->id_store_from = $idStoreFrom;
        $transfer->id_store_to = $idStoreTo;
        $transfer->quantity = $newQuantity;
        $transfer->status = 'pending';
        $transfer->barcode = 'TRF-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -4));

        if (!$transfer->add()) {
            throw new Exception('An error occurred while saving the transfer request.');
        }

        $this->sendAdminNotification($transfer, $idLang);
    }

    public function processBulkTransfer(int $sourceShopId, int $destinationShopId, array $bulkProductIds, array $bulkQuantities): array
    {
        $successCount = 0;
        $errorCount = 0;

        foreach ($bulkProductIds as $idProduct) {
            $idProduct = (int) $idProduct;
            $quantity = isset($bulkQuantities[$idProduct]) ? (int) $bulkQuantities[$idProduct] : 0;

            if ($quantity <= 0 || !$this->repository->productExists($idProduct)) {
                $errorCount++;
                continue;
            }

            $currentSourceQuantity = (int) StockAvailable::getQuantityAvailableByProduct($idProduct, 0, $sourceShopId);
            if ($currentSourceQuantity < $quantity) {
                $errorCount++;
                continue;
            }

            $transfer = new StockTransfer();
            $transfer->id_product = $idProduct;
            $transfer->id_store_from = $sourceShopId;
            $transfer->id_store_to = $destinationShopId;
            $transfer->quantity = $quantity;
            $transfer->status = 'pending';
            $transfer->barcode = 'TRF-' . date('Ymd') . '-' . strtoupper(substr(uniqid(), -4));

            if ($transfer->add()) {
                $successCount++;
            } else {
                $errorCount++;
            }
        }

        return ['success' => $successCount, 'error' => $errorCount];
    }

    private function sendAdminNotification(StockTransfer $transfer, int $idLang): void
    {
        $adminEmail = Configuration::get('PS_SHOP_EMAIL');
        if ($adminEmail) {
            Mail::Send(
                $idLang,
                'transfer_request',
                'New Stock Transfer Request Pending Approval',
                [
                    '{product_id}'  => (int) $transfer->id_product,
                    '{quantity}'    => (int) $transfer->quantity,
                    '{store_from}'  => (int) $transfer->id_store_from,
                    '{store_to}'    => (int) $transfer->id_store_to,
                ],
                $adminEmail,
                null,
                null,
                null,
                null,
                null,
                _PS_MODULE_DIR_ . 'customstocktransfer/mails/'
            );
        }
    }
}
