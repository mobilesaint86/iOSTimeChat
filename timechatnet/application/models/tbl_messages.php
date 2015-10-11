<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_messages extends CI_Model {
		var $tbl_messages = "tbl_messages";
		var $tbl_users 	= "tbl_users";
		
		//message purchase
        function add_message($userid, $friendid, $content, $msgtype, $notifytype)
        {
            $msgdata['user_id'] = $userid;
            $msgdata['friend_id'] = $friendid;
            $msgdata['content'] = htmlspecialchars($content);
            $msgdata['mdate'] = date("d/m/Y");
            $msgdata['mtime'] = date("H:i:s");
            $msgdata['msgtype'] = $msgtype;
            $msgdata['notifytype'] = $notifytype;
            $msgdata['state'] = 0;
			
            $this->db->insert($this->tbl_messages, $msgdata);
            $id = $this->db->insert_id();
            if ($id)             return 1;
            else                 return 0;
        }
		
		// get incoming new messages 
        function get_incoming_new_message($userid, $friendid){
			if(!$userid)  return false;
			$this->db->where('user_id', $userid);	
			$this->db->where('state<1');	//non read message	
			if($friendid)	$this->db->where('friend_id', $friendid);	
			
			$this->db->order_by('mtime','asc');
            $query = $this->db->get($this->tbl_messages);
            return $query->result_array();
        }        
		// get messages
        function get_messages($userid, $msgtype, $notifytype, $state){
			if(!$userid)  return false;
			
			$this->db->select('m.*, m.user_id as friend_id, m.friend_id as user_id, u.username, u.lastname, u.firstname');
			$this->db->from($this->tbl_messages.' as m');
			$this->db->where('m.friend_id', $userid);	
			if($msgtype) $this->db->where('m.msgtype', $msgtype);
			if($notifytype) $this->db->where('m.notifytype', $notifytype);
			if($state) 	$this->db->where('m.state', $state);
			
			$this->db->join($this->tbl_users.' as u', 'm.user_id = u.id', 'left');
			$this->db->order_by('m.mdate desc, m.mtime desc');
            $query = $this->db->get();
			
            return $query->result_array();
        }        
		
		// get messages with my friend
        function get_messages_friend($userid, $friendid){
			if(!$userid || !$friendid)  return false;
			$this->db->where('(friend_id="'.$userid.'" and user_id="'.$friendid.'") or (user_id="'.$userid.'" and friend_id="'.$friendid.'") ');	
			$this->db->order_by('mdate asc, mtime asc');
	        $query = $this->db->get($this->tbl_messages);
            return $query->result_array();
        }        
		
		//friend info update(category, state)
        function update_status($message_id, $state){
            if(!$message_id) return false;
			if(!$state) $state = '0';
			$update_data["state"] = $state;
			
            $result = $this->db->update($this->tbl_messages, $update_data, array('id' => $message_id));
        }

		// delete message
        function delete_message($message_id){
            $this->db->where('msg_id', $message_id);
            $result = $this->db->delete($this->tbl_messages);
            return $result;
        }				
		function getScore()	{
			
		}
		
		
}