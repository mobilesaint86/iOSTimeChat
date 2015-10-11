<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_usertempnotifications extends CI_Model {

	function getUserIdsTempNotificationByEmail( $email )			//return userid array
	{
		$this->db->where( 'email', $email );
		$query = $this->db->get('usertempnotifications');
		if ( count( $query->result() ) > 0) {
		}
		return $ret;
	}

	function insertTempUserNotification()
	{
	}

	function removeUserTempNotification( $user_id )
	{
		$this->db->where( 'user_id', $user_id );
		$this->db->delete( 'devices' );
	}
}
		
?>