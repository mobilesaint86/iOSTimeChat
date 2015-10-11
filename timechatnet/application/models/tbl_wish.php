<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_wish extends CI_Model {
		var $tbl_anniversary_days 	= "tbl_anniversary_days";
		var $tbl_wish_list 			= "tbl_wish_list";
		var $tbl_wish_option 		= "tbl_wish_option";
		var $tbl_friends 			= "tbl_friends";
		
		//get anniversary day info 
        function get_anniversary_info($gdate){
			if(!$gdate)  $gdate = date("Y-m-d");
			$this->db->where('mdate', $gdate);	
            $query = $this->db->get($this->tbl_anniversary_days);
            $result = $query->result_array();
			if($result) 	return $result[0]["descript"];
			else return false;
        }        
		
		
		//wish register 
        function register_wish($wishdata)
        {
			//$wishdata['event_date'] = date("d/m/Y");
			//$wishdata['event_time'] = date("H:i:s");
			
            $this->db->insert($this->tbl_wish_list, $wishdata);
            $result = $this->db->insert_id();
			return $result;
		}
        function update_wish($wishdata){
			//$wishdata['event_date'] = date("d/m/Y");
			//$wishdata['event_time'] = date("H:i:s");
            $result = $this->db->update($this->tbl_wish_list, $wishdata, array('id' => $wishdata['wish_id']));
            return $result;
        }
		// get wish option
        function get_wish_option_list($option_id){
			if($option_id)	$this->db->where('option_id', $option_id);	
	        $query = $this->db->get($this->tbl_wish_option);
            return $query->result_array();
        }        
		
		// get my wish list
        function get_my_wish_list($user_id, $picked = '', $deleted = ''){
			if($picked!='') 	$this->db->where('l.picked', $picked);	
			if($deleted!='') 	$this->db->where('l.deleted', $deleted);	
			$this->db->where('l.user_id', $user_id);	

			$this->db->select('l.*, o.option_name');
			$this->db->from($this->tbl_wish_list.' as l');
			
			$this->db->join($this->tbl_wish_option.' as o', 'o.option_id = l.wish_option');
			$this->db->order_by('l.event_date','asc');
            $query = $this->db->get();
			
            return $query->result_array();
        }        
		// get friend's wish list
        function get_friends_wish_list($user_id){
			//no deleted and picked
			$this->db->where('l.picked', 1);	
			$this->db->where('l.deleted', 0);	
			$this->db->select('l.*, o.option_name');
			$this->db->from($this->tbl_wish_list.' as l');
			
			$this->db->where('l.visable_friend_ids like "%,'.$user_id.',%" or (l.visable_all=0 and f.user_id='.$user_id.')');	

			$this->db->join($this->tbl_friends.' as f', 'f.friend_id=l.user_id', 'left');
			$this->db->join($this->tbl_wish_option.' as o', 'o.option_id = l.wish_option', 'left');
			$this->db->order_by('l.event_date','asc');
            $query = $this->db->get();
			//die($this->db->last_query());

            return $query->result_array();
        }        
		
        function getDataById($wish_id){
            $this->db->where('wish_id',$wish_id);
            $query = $this->db->get($this->tbl_wish_list);
            return $query->result_array();
        }
		
		
		
}