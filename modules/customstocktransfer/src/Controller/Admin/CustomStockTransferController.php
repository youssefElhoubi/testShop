<?php

namespace PrestaShop\Module\Customstocktransfer\Controller\Admin;

use Category;
use Db;
use Exception;
use Image;
use Manufacturer;
use PrestaShopBundle\Controller\Admin\FrameworkBundleAdminController;
use Shop;
use StockAvailable;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use PrestaShop\Module\Customstocktransfer\Service\CustomStockTransferService;
use Tools;
use Validate;

class CustomStockTransferController extends FrameworkBundleAdminController
{
    private $transferService;

    public function __construct(CustomStockTransferService $transferService)
    {
        $this->transferService = $transferService;
    }

    public function indexAction(Request $request): Response
    {
        if ($request->isMethod('POST')) {
            return $this->handlePostProcess($request);
        }

        $context = $this->get('prestashop.adapter.legacy.context')->getContext();
        $idLang = (int) $context->language->id;
        $idShopForName = (int) $context->shop->id;

        $repository = $this->get('prestashop.module.customstocktransfer.repository.transfer');

        $page = (int) $request->query->get('page', 1);
        if ($page < 1) {
            $page = 1;
        }

        $limit = (int) $request->query->get('limit', 0);
        if ($limit > 0) {
            $context->cookie->__set('customstocktransfer_limit', $limit);
            $context->cookie->write();
        } else {
            $limit = (int) $context->cookie->__get('customstocktransfer_limit');
        }

        if ($limit < 1) {
            $limit = 10;
        }

        $productSearch = trim($request->query->get('product_search', ''));

        $filter = [
            'category' => (int) $request->query->get('filter_category'),
            'brand'    => $request->query->has('filter_brand') && $request->query->get('filter_brand') !== '' ? (int) $request->query->get('filter_brand') : null,
            'status'   => $request->query->has('filter_status') && $request->query->get('filter_status') !== '' ? (int) $request->query->get('filter_status') : null,
        ];

        $categories = Category::getSimpleCategories($idLang);
        $brands = Manufacturer::getManufacturers(false, $idLang, true);

        $shops = $this->getActiveShops();
        
        if ($idShopForName <= 0 && !empty($shops)) {
            $idShopForName = (int) $shops[0]['id_shop'];
        }

        $totalProducts = $repository->getTotalProductsCount($idLang, $idShopForName, $productSearch, $filter);
        $totalPages = (int) ceil($totalProducts / $limit);

        if ($page > $totalPages && $totalPages > 0) {
            $page = $totalPages;
        }

        $rawProducts = $repository->getProductsDashboardData($idLang, $idShopForName, $page, $limit, $productSearch, $filter);
        $products = [];

        foreach ($rawProducts as $row) {
            $productId = (int) $row['id_product'];
            $shopBreakdown = [];
            $shopQuantities = [];
            $coverUrl = '';

            $cover = Image::getCover($productId);
            if (is_array($cover) && !empty($cover['id_image']) && !empty($row['link_rewrite'])) {
                $coverUrl = $context->link->getImageLink(
                    $row['link_rewrite'],
                    (int) $cover['id_image'],
                    'home_default'
                );
            }

            foreach ($shops as $shop) {
                $shopQuantity = (int) StockAvailable::getQuantityAvailableByProduct($productId, 0, (int) $shop['id_shop']);
                $shopQuantities[] = $shopQuantity;

                $shopBreakdown[] = [
                    'id_shop' => (int) $shop['id_shop'],
                    'shop_name' => $shop['shop_name'],
                    'quantity_in_this_shop' => $shopQuantity,
                    'badge_class' => $this->getStockBadgeClass($shopQuantity),
                ];
            }

            $totalStock = (int) array_sum($shopQuantities);
            $maxStock = !empty($shopQuantities) ? (int) max($shopQuantities) : 0;
            $minStock = !empty($shopQuantities) ? (int) min($shopQuantities) : 0;
            $stockDiff = (int) ($maxStock - $minStock);

            $products[] = [
                'id_product' => $productId,
                'name' => (string) $row['name'],
                'link_rewrite' => (string) $row['link_rewrite'],
                'cover_url' => $coverUrl,
                'total_stock' => $totalStock,
                'max_stock' => $maxStock,
                'min_stock' => $minStock,
                'stock_diff' => $stockDiff,
                'total_quantity' => $totalStock,
                'shops' => $shopBreakdown,
                'is_low_stock' => $totalStock < 5,
            ];
        }

        $transferHistory = $repository->getTransferHistory();

        $flashes = $this->get('session')->getFlashBag()->all();
        $errors = $flashes['error'] ?? [];
        $confirmations = $flashes['success'] ?? [];

        $context->smarty->assign([
            'product_search' => $productSearch,
            'filter' => $filter,
            'categories' => $categories,
            'brands' => $brands,
            'products' => $products,
            'shops' => $shops,
            'form_action' => $this->generateUrl('admin_custom_stock_transfer_dashboard'),
            'token' => Tools::getAdminTokenLite('AdminCustomStockTransfer'),
            'current_page' => $page,
            'limit' => $limit,
            'total_products' => $totalProducts,
            'total_pages' => $totalPages,
            'transfer_history' => $transferHistory,
            'errors' => $errors,
            'confirmations' => $confirmations,
        ]);

        $content = $context->smarty->fetch(_PS_MODULE_DIR_ . 'customstocktransfer/views/templates/admin/transfer_dashboard.tpl');

        return new Response($content);
    }

    private function handlePostProcess(Request $request): Response
    {
        $idLang = (int) $this->get('prestashop.adapter.legacy.context')->getContext()->language->id;

        try {
            if ($request->request->has('submitEditQuantity')) {
                $idProduct = (int) $request->request->get('id_product');
                $newQuantity = (int) $request->request->get('new_quantity');
                $maxQuantity = (int) $request->request->get('max_quantity');
                $idStoreFrom = (int) $request->request->get('id_store_from');
                $idStoreTo = (int) $request->request->get('id_store_to');

                $this->transferService->createTransferRequest($idProduct, $newQuantity, $maxQuantity, $idStoreFrom, $idStoreTo, $idLang);
                $this->addFlash('success', $this->trans('Transfer request submitted successfully and is pending admin approval.', 'Modules.Customstocktransfer.Admin'));

            } elseif ($request->request->has('submitCustomStockTransfer')) {
                $sourceShopId = (int) $request->request->get('source_shop_id');
                $destinationShopId = (int) $request->request->get('destination_shop_id');
                $bulkProductIds = $request->request->get('bulk_product_ids');
                $bulkQuantities = $request->request->get('bulk_quantities');

                if (!Validate::isUnsignedId($sourceShopId)) {
                    throw new Exception($this->trans('Please select a valid source store.', 'Modules.Customstocktransfer.Admin'));
                }
                if (!Validate::isUnsignedId($destinationShopId)) {
                    throw new Exception($this->trans('Please select a valid destination store.', 'Modules.Customstocktransfer.Admin'));
                }
                if ($sourceShopId === $destinationShopId) {
                    throw new Exception($this->trans('The source and destination stores must be different.', 'Modules.Customstocktransfer.Admin'));
                }
                if (!is_array($bulkProductIds) || empty($bulkProductIds)) {
                    throw new Exception($this->trans('Please select at least one product to transfer.', 'Modules.Customstocktransfer.Admin'));
                }

                $availableShopIds = array_map(static function (array $shop) {
                    return (int) $shop['id_shop'];
                }, Shop::getShops(true, null, false));

                if (!in_array($sourceShopId, $availableShopIds, true) || !in_array($destinationShopId, $availableShopIds, true)) {
                    throw new Exception($this->trans('The selected stores are not available.', 'Modules.Customstocktransfer.Admin'));
                }

                $result = $this->transferService->processBulkTransfer($sourceShopId, $destinationShopId, $bulkProductIds, $bulkQuantities);

                if ($result['success'] > 0) {
                    $message = sprintf($this->trans('Successfully submitted %d transfer request(s) for admin approval.', 'Modules.Customstocktransfer.Admin'), $result['success']);
                    if ($result['error'] > 0) {
                        $message .= ' ' . sprintf($this->trans('Failed for %d product(s).', 'Modules.Customstocktransfer.Admin'), $result['error']);
                    }
                    $this->addFlash('success', $message);
                } else {
                    throw new Exception($this->trans('Failed to transfer products. Check quantities and stock availability.', 'Modules.Customstocktransfer.Admin'));
                }
            }
        } catch (Exception $e) {
            $this->addFlash('error', $e->getMessage());
        }

        return $this->redirectToRoute('admin_custom_stock_transfer_dashboard');
    }

    protected function getActiveShops(): array
    {
        $shops = [];
        foreach (Shop::getShops(true, null, false) as $shop) {
            $shops[] = [
                'id_shop' => (int) $shop['id_shop'],
                'shop_name' => (string) $shop['name'],
            ];
        }
        return $shops;
    }

    protected function getStockBadgeClass(int $quantity): string
    {
        if ($quantity === 0) {
            return 'badge-danger';
        }
        if ($quantity <= 5) {
            return 'badge-warning';
        }
        return 'badge-success';
    }
}
