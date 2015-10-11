<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_devices extends CI_Model {

	function registerDevice( $user_id, $dev_id )
	{
		$this->db->where( 'user_id', $user_id );
		$this->db->where( 'dev_id', $dev_id );
		$query = $this->db->get('devices');
		if ( count( $query->result() ) <= 0) {

			$dev_info = array( "platform"=>'ios', "dev_id"=>$dev_id, "user_id"=>$user_id );
			$ret = $this->db->insert( 'devices', $dev_info );
		}
		return $ret;
	}

	function removeDevice( $user_id )
	{
		$this->db->where( 'user_id', $user_id );
		$ret = $this->db->delete( 'devices' );
	}
}
		
?>