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
    public $approved_by;
    public $approved_at;
    public $prepared_by;
    public $prepared_at;
    public $shipped_by;
    public $shipped_at;
    public $received_by;
    public $received_at;
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
            'status'        => ['type' => self::TYPE_STRING, 'validate' => 'isString', 'required' => true, 'values' => ['pending', 'approved', 'prepared', 'in_transit', 'completed', 'declined']],
            'approved_by'   => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'approved_at'   => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'prepared_by'   => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'prepared_at'   => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'shipped_by'    => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'shipped_at'    => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'received_by'   => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId'],
            'received_at'   => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'reason'        => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml'],
            'notes'         => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml'],
            'date_add'      => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
            'date_upd'      => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
        ],
    ];
}
