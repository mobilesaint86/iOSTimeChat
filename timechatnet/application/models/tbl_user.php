<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_user extends CI_Model {

        function getData(){
            $query = $this->db->get('users');
            return $query->result_array();
        }
        
        function register($userdata)
        {
//            $userdata['password'] = md5($userdata['password']);
            $this->db->insert('users', $userdata);
            $id = $this->db->insert_id();
            if ($id)             return true;
            else                 return false;
        }
        
        function loginCheck( $username, $password ){
            $this->db->where( 'username', $username );
            $this->db->where( 'password', $password );

            $query = $this->db->get('users');

            if (count($query->result()) > 0) {
				return 1;
            }
            else {
                return 0;
            }
        }
        
        /*return manager data in users*/
        function getManager(){
            $this->db->where('usergrade', 1);
            $query = $this->db->get('users');
            return $query->result_array();
        }
        
        function changePassword($userdata){
        	$this->db->where('username',$userdata["username"]);
        	$result = $this->db->update('users',array("password"=>$userdata["password"]));
        	return $result;
        }
        
        function getUsers(){
            $this->db->select('id, username, usergrade');
            $query = $this->db->get('users');
            return $query->result_array();
        }
        function delete($id){
            $this->db->where('id', $id);
            $result = $this->db->delete('users'); 
            return $result;
        }
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */