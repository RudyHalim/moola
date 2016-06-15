<?php

class Countries extends \Phalcon\Mvc\Model
{

    /**
     *
     * @var integer
     */
    public $country_id;

    /**
     *
     * @var string
     */
    public $country_name;

    /**
     *
     * @var string
     */
    public $country_currency;

    /**
     *
     * @var string
     */
    public $country_trade;

    /**
     *
     * @var double
     */
    public $markup_value;

    /**
     * Returns table name mapped in the model.
     *
     * @return string
     */
    public function getSource()
    {
        return 'countries';
    }

    /**
     * Allows to query a set of records that match the specified conditions
     *
     * @param mixed $parameters
     * @return Countries[]
     */
    public static function find($parameters = null)
    {
        return parent::find($parameters);
    }

    /**
     * Allows to query the first record that match the specified conditions
     *
     * @param mixed $parameters
     * @return Countries
     */
    public static function findFirst($parameters = null)
    {
        return parent::findFirst($parameters);
    }

}
