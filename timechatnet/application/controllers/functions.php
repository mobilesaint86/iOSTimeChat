<?php
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Functions {

	public function __construct($params)
    {
        // Do something with $params
    }

	function stdToArray($obj){
	  $reaged = (array)$obj;
	  foreach($reaged as $key => &$field){
		if(is_object($field))$field = stdToArray($field);
	  }
	  return $reaged;
	}
}

?>