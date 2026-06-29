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
    public $reason;
    public $date_add;

    public static $definition = [
        'table' => 'transfers',
        'primary' => 'id_transfer',
        'fields' => [
            'id_product' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_store_from' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_store_to' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'quantity' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedInt', 'required' => true],
            'reason' => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml'],
            'date_add' => ['type' => self::TYPE_DATE, 'validate' => 'isDate'],
        ],
    ];
}
