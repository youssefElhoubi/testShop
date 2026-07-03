<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class StockTransfer extends ObjectModel
{
    public $id_product;
    public $id_store_from;
    public $id_store_to;
    public $quantity;
    public $barcode;
    public $status;
    public $reason;
    public $notes;
    public $date_add;
    public $date_upd;

    public static $definition = [
        'table' => 'transfers',
        'primary' => 'id_transfer',
        'fields' => [
            'id_product'    => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_store_from' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_store_to'   => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'quantity'      => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'barcode'       => ['type' => self::TYPE_STRING, 'validate' => 'isString', 'required' => true, 'size' => 100],
            'status'        => ['type' => self::TYPE_STRING, 'validate' => 'isString', 'required' => true, 'values' => ['pending', 'approved', 'completed', 'declined']],
            'reason'        => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml', 'allow_null' => true],
            'notes'         => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml', 'allow_null' => true],
            'date_add'      => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'date_upd'      => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
        ],
    ];

    public function validateFields($die = true, $error_return = false)
    {
        foreach ($this->def['fields'] as $field => $data) {
            if ($data['type'] == self::TYPE_DATE && $this->$field == '0000-00-00 00:00:00') {
                $this->$field = null;
            }
        }
        return parent::validateFields($die, $error_return);
    }
}
