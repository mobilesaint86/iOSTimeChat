<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_orders extends CI_Model {        
			
		//admin panel
        function getData(){
            $this->db->order_by('id','desc');
            $query = $this->db->get('tbl_orders');
            return $query->result_array();
        }
        function getDataFuture(){
            $today = date("Y-m-d");
            $this->db->where('date >',$today);
            $query = $this->db->get('tbl_podcasts');
            return $query->result_array();
        }
        function getDataById($nId){
            $this->db->where('id',$nId);
            $query = $this->db->get('tbl_orders');
            return $query->result_array();
        }
        function getDataByUser_id($user_id){
            $this->db->where('user_id',$user_id);
            $query = $this->db->get('tbl_orders');			
            return $query->result_array();
        } //backend        
        function save($data){
            $result = $this->db->update('tbl_orders', $data, array('id' => $data['id']));
            return $result;
        }
        function add($data){
            $result = $this->db->insert('tbl_orders',$data);
            return $this->db->insert_id();
        }
        function delete($id){
            $this->db->where('id', $id);
            $result = $this->db->delete('tbl_orders');
            return $result;
        }
}