<?php
/**
 * Created by IntelliJ IDEA.
 * User: tiger
 * Date: 12/30/2014
 * Time: 7:30 AM
 */

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_comments extends CI_Model {

    /**
     * Function name		:	addNewComment
     * parameters			:	comment data
     * return               :   status
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */
    function addNewComment( $comment_data )
    {
        $this->db->insert( 'comments', $comment_data );
        $id = $this->db->insert_id();
        return $id;
    }

    /**
     * Function name		:	addAudioComment
     * parameters			:	audio_comment data
     * return               :   status
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */
    function addAudioComment( $audio_comment )
    {
        $this->db->insert( 'comments', $audio_comment );
        $id = $this->db->insert_id();
        return $id;
    }

    /**
     * Function name		:	getCommentsByFilter
     * parameters			:	media_id(required)
     * return               :   comments array
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */
    function getCommentsByFilter( $media_id )					//edit tiger 12.29      multiple join
    {
//        header('Access-Control-Allow-Origin: *');
//        header('Content-Type: application/json');

        $this->db->select( "comments.id,
                            comments.comment,
                            comments.audio_comment,
                            comments.user_id,
                            comments.media_id,
                            comments.created_at as created_time,
                            users.avatar,
                            users.username,
                            users.time_zone" );
        $this->db->where( 'media_id', $media_id );
        $this->db->join( 'medias', 'comments.media_id = medias.id' );
        $this->db->join( 'users', 'comments.user_id = users.id' );
        $query = $this->db->get( 'comments' );

        $rows = $query->result_array();

        if( $rows )
            return $rows;
        else
            return null;
    }
}