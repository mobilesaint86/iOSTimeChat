<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Tbl_barcodes extends CI_Model {
        
        function getData(){
            $this->db->order_by('id','desc');
            $query = $this->db->get('tbl_barcodes');
            return $query->result_array();
        }
        function getDataById($nId){
            $this->db->where('id',$nId);
            $query = $this->db->get('tbl_barcodes');
            return $query->result_array();
        }
		function getDataByBarcode($barcode){
            $this->db->where('barcode',$barcode);
            $query = $this->db->get('tbl_barcodes');
            return $query->result_array();
        }
        function save($data){
            $result = $this->db->update('tbl_barcodes', $data, array('id' => $data['id']));
            return $result;
        }
        function add($data){
            $result = $this->db->insert('tbl_barcodes',$data);
            return $result;
        }
        function delete($id){
            $this->db->where('id', $id);
            $result = $this->db->delete('tbl_barcodes');
            return $result;
        }
}
