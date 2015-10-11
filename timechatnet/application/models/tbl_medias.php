<?php
/**
 * Created by IntelliJ IDEA.
 * User: tiger
 * Date: 12/30/2014
 * Time: 7:30 AM
 */

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_medias  extends CI_Model {


    function registerMedia( $media, $user )
    {
        date_default_timezone_set( 'Europe/London' );
        $media['user_id']      =    $user['id'];
        $media['created_at']   =    date( 'Y-m-d H:i:s');

        $this->db->insert( 'medias', $media );
        $inserted_id = $this->db->insert_id();

        return $inserted_id;
    }

    function destroyMedia( $media )
    {
        $media_url  =   $media['filename'];
        $thumb_url  =   $media['thumb'];
        if(file_exists( $media_url )) unlink( $media_url );
        if(file_exists( $thumb_url )) unlink( $thumb_url );
        $this->db->where( 'id', $media['id'] );
        $destroy_status = $this->db->delete( 'medias' );

        return $destroy_status;
    }

    /**
     * Function name		:	getMediaInfoByFilter
     * parameters			:	id, media_type, user_id
     * return               :   medias array
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */
    function getMediaInfoByFilter( $id, $media_type, $user_id )					//edit tiger 1.2
    {
        if( $id )			$this->db->where( 'id', $id );
        if( $media_type )	$this->db->where( 'media_type', $media_type );
        if( $user_id )		$this->db->where( 'user_id', $user_id );

        $query = $this->db->get('medias');

        $rows = $query->result_array();
        if( $rows )
            return $rows;
        else
            return null;
    }

    function getMediaInfoByUser( $id, $media_type, $user_id, $days_ago )
    {
        $this->db->select( "medias.id,
                            medias.media_url as filename,
                            medias.thumb_url as thumb,
                            medias.media_type as type,
                            medias.shared_ids,
                            medias.created_at,
                            users.id as user_id" );
        if( $id )           $this->db->where( 'medias.id', $id );
        if( $user_id )      $this->db->where( 'medias.user_id', $user_id );
        if( $days_ago )
        {
            date_default_timezone_set( 'Europe/London' );
            $user_time =   date( 'Y-m-d H:i:s', time() + $days_ago * 24 * 60 * 60 );
            $time = date( 'Y-m-d', time() - 60 * 60 * $days_ago * 24 );
            $this->db->where( 'medias.created_at >=', $time );
        }
        $this->db->join( 'users', 'medias.user_id = users.id', 'left' );
        $this->db->order_by( 'medias.created_at asc' );
        $query = $this->db->get( 'medias' );

        $row_array = $query->result_array();

        if( $row_array )
            return $row_array;
        else
            return null;
    }

    function shareFriends( $media, $user, $friends )
    {
        $shared_ids = $media['shared_ids'];
        $id_array = array();

        if( $shared_ids != null && $shared_ids != '' )
            $id_array       =   mbsplit( ',', $media['shared_ids'] );
        $this->load->model( 'tbl_users' );

        for( $i = 0; $i < count( $friends ); $i++ )
        {
            if( $media['shared_ids'] == '' || $media['shared_ids'] == null )
                array_push( $id_array, $friends[$i]['id'] );
            else {
                array_push( $id_array, $friends[$i]['id'] );
            }

            $this->db->where( 'media_id', $media['id'] );
            $this->db->where( 'user_id', $friends[$i]['id'] );
            $query          =   $this->db->get( 'notifications' );
            $notifications  =   $query->result_array();

//            $this->_output_json( count( $notifications ) ); exit;

//            if( count( $notifications ) <= 0 )
//            {
                if( $media['type'] == "1" )
                {
                    $type = $this->tbl_users->isFriend( $user, $friends[$i] ) ?  NOTIFICATION_FRIEND_ADDED_NEW_PHOTO : NOTIFICATION_ACCESS_MEDIA_USER;
                    $this->tbl_users->sendMediaSharedFriendNotification( $friends[$i], $user, $media, $type );
                }
                else
                {
                    $type = $this->tbl_users->isFriend( $user, $friends[$i] ) ?  NOTIFICATION_FRIEND_ADDED_NEW_VIDEO : NOTIFICATION_ACCESS_MEDIA_USER;
                    $this->tbl_users->sendMediaSharedFriendNotification( $friends[$i], $user, $media, $type );
                }
//            }
        }

        $update_media['shared_ids'] = implode(',', $id_array );

        $this->db->where( 'id', $media['id'] );
        $updated_status     =   $this->db->update( 'medias', $update_media );

        return $updated_status;
    }

    function likeMedia( $media, $user )
    {
        date_default_timezone_set( 'Europe/London' );
        $like['user_id']        =   $user['id'];
        $like['media_id']       =   $media['id'];
        $like['created_at']     =   date( 'Y-m-d H:i:s');

        $insert_status          =   $this->db->insert( 'likes', $like );

        return $insert_status;
    }

    function likeCountByMedia( $media )
    {
        $this->db->where( 'media_id', $media['id'] );
        $query = $this->db->get( 'likes' );
        $rows = $query->result_array();

        return count( $rows );
    }

    function commentCountByMedia( $media )
    {
        $this->db->where( 'media_id', $media['id'] );
        $query = $this->db->get( 'comments' );
        $rows = $query->result_array();

        return count( $rows );
    }

    function _output_json( $data )						//edit tiger	12.29
    {
        header('Access-Control-Allow-Origin: *');
        header('Content-Type: application/json');
        echo json_encode( $data );
    }
}