<?php
/**
 * Created by IntelliJ IDEA.
 * User: tiger
 * Date: 12/31/2014
 * Time: 7:30 AM
 */

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_notifications extends CI_Model {

    function getNotificationInfoById( $id )
    {
        if( $id )			$this->db->where( 'id', $id );

        $query = $this->db->get( 'notifications' );
        $row = $query->result_array();
        if( $row )
            return $row[0];
        else
            return null;
    }

    function getNotificationInfoByFilter( $user )
    {
        $this->db->select( "notifications.id,
                            notifications.created_at as date,
                            notifications.data,
                            notifications.type as condition1,
                            notifications.message as debug,
                            notifications.is_read as status,
                            notifications.status as type,
                            notifications.media_id,
                            notifications.media_user_id,
                            notifications.media_user_name
                            " );
        $this->db->where( 'users.id', $user['id'] );
        $this->db->join( 'users', 'notifications.user_id = users.id' );
        $query = $this->db->get( 'notifications' );

        $rows = $query->result_array();

        if( $rows )
            return $rows;
        else
            return null;

        if( $user )		$this->db->where( 'user_id', $user['id'] );

    }

    function  setNotificationStatusToRead( $notification )
    {
        $update_notification['is_read']    =   1;
        $this->db->where( 'id', $notification['id'] );
        $ret = $this->db->update( 'notifications', $update_notification );
        return $ret;
    }

    function  setNotificationStatusToReadByUser( $user )
    {
        $update_notification['is_read'] =   1;
        $this->db->where( 'user_id', $user['id'] );
        $ret = $this->db->update( 'notifications', $update_notification );

        return $ret;
    }

    function deleteNotificationByFilter( $user, $notification_id )
    {
        if( $user )             $this->db->where( 'user_id', $user['id'] );
        if( $notification_id )  $this->db->where( 'id', $notification_id );
        $delete_status = $this->db->delete( 'notifications' );

        return $delete_status;
    }
}
