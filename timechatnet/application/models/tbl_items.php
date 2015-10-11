<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_items extends CI_Model {
        
        function getData(){
            $this->db->order_by('id','desc');
            $query = $this->db->get('tbl_items');
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
            $query = $this->db->get('tbl_items');
            return $query->result_array();
        }
		function getDataByBarcode_id($nId){
            $this->db->where('barcode_id',$nId);
            $query = $this->db->get('tbl_items');
            return $query->result_array();
        }
		function getDataByBarcode($barcode){
            $this->db->where('barcode',$barcode);
            $query = $this->db->get('tbl_items');
            return $query->result_array();
        }
		
        function getDataByOrder_id($order_id){
            $this->db->where('order_id',$order_id);
            $query = $this->db->get('tbl_items');
            return $query->result_array();
        }        
        function save($data){
            $result = $this->db->update('tbl_items', $data, array('id' => $data['id']));
            return $result;
        }
        function add($data){
            $result = $this->db->insert('tbl_items',$data);
            return $result;
        }
        function delete($id){
            $this->db->where('id', $id);
            $result = $this->db->delete('tbl_items');
            return $result;
        }
}
