<?php

namespace PrestaShop\Module\Customstocktransfer\Controller\Admin;

use Exception;
use PrestaShopBundle\Controller\Admin\FrameworkBundleAdminController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use PrestaShop\Module\Customstocktransfer\Service\CustomStockApprovalService;
use Tools;
use Image;
use ImageType;

class CustomStockApprovalController extends FrameworkBundleAdminController
{
    private $approvalService;

    public function __construct(CustomStockApprovalService $approvalService)
    {
        $this->approvalService = $approvalService;
    }

    public function indexAction(Request $request): Response
    {
        // Handle POST requests logic here
        if ($request->isMethod('POST')) {
            return $this->handlePostProcess($request);
        }

        $context = $this->get('prestashop.adapter.legacy.context')->getContext();
        $idLang = (int) $context->language->id;
        $idShop = (int) $context->shop->id;

        $repository = $this->get('prestashop.module.customstocktransfer.repository.approval');
        $rawTransfers = $repository->getTransfersWithProducts($idLang, $idShop);

        $groupedTransfers = [
            'pending'    => [],
            'approved'   => [],
            'prepared'   => [],
            'in_transit' => [],
            'completed'  => [],
            'declined'   => []
        ];

        foreach ($rawTransfers as &$transfer) {
            $coverUrl = '';
            $cover = Image::getCover($transfer['id_product']);
            if (is_array($cover) && !empty($cover['id_image']) && !empty($transfer['link_rewrite'])) {
                $coverUrl = $context->link->getImageLink(
                    $transfer['link_rewrite'],
                    (int) $cover['id_image'],
                    ImageType::getFormattedName('home')
                );
            }
            $transfer['image_url'] = $coverUrl;

            $status = isset($transfer['status']) && !empty($transfer['status']) ? strtolower($transfer['status']) : 'pending';
            if (!isset($groupedTransfers[$status])) {
                $groupedTransfers[$status] = [];
            }
            $groupedTransfers[$status][] = $transfer;
        }

        $flashes = $this->get('session')->getFlashBag()->all();
        $errors = $flashes['error'] ?? [];
        $confirmations = $flashes['success'] ?? [];

        // Render the legacy smarty template
        $context->smarty->assign([
            'grouped_transfers' => $groupedTransfers,
            'approval_link' => $this->generateUrl('admin_custom_stock_approval_dashboard'),
            'form_action' => $this->generateUrl('admin_custom_stock_approval_dashboard'),
            'token' => Tools::getAdminTokenLite('AdminCustomStockApproval'), // Legacy token if needed by template
            'errors' => $errors,
            'confirmations' => $confirmations,
        ]);

        $content = $context->smarty->fetch(_PS_MODULE_DIR_ . 'customstocktransfer/views/templates/admin/approval_dashboard.tpl');

        return new Response($content);
    }

    private function handlePostProcess(Request $request): Response
    {
        $employeeId = (int) $this->get('prestashop.adapter.legacy.context')->getContext()->employee->id;
        $idTransfer = (int) $request->request->get('id_transfer');
        
        try {
            if ($request->request->has('submitApproveTransfer')) {
                $this->approvalService->approveTransfer($idTransfer, $employeeId);
                $this->addFlash('success', $this->trans('Transfer approved successfully and stock updated.', 'Modules.Customstocktransfer.Admin'));
            } elseif ($request->request->has('submitDeclineTransfer')) {
                $reason = (string) $request->request->get('decline_reason');
                $this->approvalService->declineTransfer($idTransfer, $reason);
                $this->addFlash('success', $this->trans('Transfer declined successfully.', 'Modules.Customstocktransfer.Admin'));
            } elseif ($request->request->has('submitMarkPrepared')) {
                $this->approvalService->markPrepared($idTransfer, $employeeId);
                $this->addFlash('success', $this->trans('Transfer marked as prepared.', 'Modules.Customstocktransfer.Admin'));
            } elseif ($request->request->has('submitMarkShipped')) {
                $this->approvalService->markShipped($idTransfer, $employeeId);
                $this->addFlash('success', $this->trans('Transfer marked as shipped (in transit).', 'Modules.Customstocktransfer.Admin'));
            } elseif ($request->request->has('submitMarkCompleted')) {
                $this->approvalService->markCompleted($idTransfer, $employeeId);
                $this->addFlash('success', $this->trans('Transfer successfully marked as completed.', 'Modules.Customstocktransfer.Admin'));
            }
        } catch (Exception $e) {
            $this->addFlash('error', $e->getMessage());
        }

        return $this->redirectToRoute('admin_custom_stock_approval_dashboard');
    }
}
