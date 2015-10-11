<?php
/**
 * Created by IntelliJ IDEA.
 * User: tiger
 * Date: 12/30/2014
 * Time: 2:50 PM
 */
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_likes extends CI_Model
{
    /**
     * Function name		:	getCommentsByFilter
     * parameters			:	media_id(required)
     * return               :   likes array
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */
    function getLikesByMediaId( $media_id )					//edit tiger 12.30
    {
        $this->db->where( 'media_id', $media_id );
        $query = $this->db->get( 'likes' );
        $rows = $query->result_array();

        if( $rows )
            return $rows;
        else
            return null;
    }
}