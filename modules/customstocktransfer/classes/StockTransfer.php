<?php

if (!defined('_PS_VERSION_')) {
    exit;
}

class StockTransfer extends ObjectModel
{
    public $id_store_from;
    public $id_store_to;
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
            // Stores
            'id_store_from' => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],
            'id_store_to'   => ['type' => self::TYPE_INT, 'validate' => 'isUnsignedId', 'required' => true],

            // Barcode & Status
            'barcode'       => ['type' => self::TYPE_STRING, 'validate' => 'isString', 'required' => true, 'size' => 100],
            'status'        => ['type' => self::TYPE_STRING, 'required' => true],

            // Notes
            'reason'        => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml'],
            'notes'         => ['type' => self::TYPE_HTML, 'validate' => 'isCleanHtml'],

            // Timestamps
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
