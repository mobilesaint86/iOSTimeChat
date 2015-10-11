<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_friends extends CI_Model {
		var $tbl_friends = "tbl_friends";
		var $tbl_users 	= "tbl_users";
		
		//friend register (invite)
        function friend_register($userid, $friend_username, $friend_email, $state)
        {          
            
			// username, email search
			if($friend_username)       $this->db->where('username', $friend_username);
			if($friend_email)  	 	   $this->db->where('email', $friend_email);			
            $query = $this->db->get($this->tbl_users);			

			if (count($query->result()) > 0) {
                $row = $query->result_array();
				$friend_id = $row[0]['id'];	
				//friend info = my info then
				if($friend_id == $userid)	return -3;
				//already friend register then 
				else if($friend_id)  	   {
					$this->db->where('user_id', $userid);					
					$this->db->where('friend_id', $friend_id);
					$query = $this->db->get($this->tbl_friends);
					if (count($query->result()) > 0) return -2;					
				}
				else	return 0;
			}
			//can't find friend with info then
			else	return -1;
			
			$userdata['user_id'] = $userid;
			$userdata['friend_id'] = $friend_id;
            $userdata['state'] = $state;
			
            $this->db->insert($this->tbl_friends, $userdata);
            $id = $this->db->insert_id();
			if($id)	return $friend_id;
			else	return 0;
        }
		//friend register (accept) by friend_id
        function friend_register_byid($userid, $friend_id, $category_id, $state)
        {          
			$this->db->where('user_id', $friend_id);					
			$this->db->where('friend_id', $userid);
			$query = $this->db->get($this->tbl_friends);
			
			//no exists invite
			if (count($query->result()) == 0) return -1;
			
			$row = $query->result_array();
			//already accept, or reject
			if($row[0]['state']>0)	return -2;
			
			$update_data["state"] = $state;			
            $result = $this->db->update($this->tbl_friends, $update_data, array('id' => $row[0]['id']));
			
			$userdata['user_id'] = $userid;
			$userdata['friend_id'] = $friend_id;
            $userdata['state'] = $state;
            $userdata['category_id'] = $category_id;
			
            $this->db->insert($this->tbl_friends, $userdata);
            $id = $this->db->insert_id();
			if($id)	return 1;
			else	return 0;
        }		
		// friend list by category, state (0-invited, 1- accepted, 2- rejected)
        function get_friends($userid, $category, $state){
			if(!$userid)  return false;
			//friend_id, friend_username, friend_name, awatarid
			$this->db->select('u.*, f.category_id');
			$this->db->from($this->tbl_friends.' as f');
			$this->db->where('f.user_id', $userid);	
			if($category)	$this->db->where('f.category_id',$category);
			if($state)	$this->db->where('f.state', $state);	
			
			$this->db->join($this->tbl_users.' as u', 'f.friend_id = u.id');
			$this->db->order_by('f.id','asc');
            $query = $this->db->get();
			
            return $query->result_array();
        }        
		
		// get invite request of me
        function get_invite_request($userid){
			if(!$userid)  return false;
			$this->db->where('friend_id', $userid);	
			$this->db->where('state<1');	
	        $query = $this->db->get($this->tbl_friends);
            return $query->result_array();
        }        
		
		//friend info update(category, state)
        function update_friends($userid, $friend_id, $category, $state){
            if(!$userid || !$friend_id) return false;
			$this->db->where('user_id',$userid);
            $this->db->where('friend_id',$friend_id);
			$query = $this->db->get($this->tbl_friends);
            $row = $query->result_array();

            if($category) $update_data["category_id"]   = $category;
            if($state)	$update_data["state"]   = $state;
			
            $result = $this->db->update($this->tbl_friends, $update_data, array('id' => $row[0]["id"]));
			return $result;
        }
		
		//friend delete
        function friend_delete($userid, $friendid){
            $this->db->where('user_id', $userid);
            $this->db->where('friend_id', $friendid);
            $result = $this->db->delete($this->tbl_friends);
            return $result;
        }		
		
		
		
}