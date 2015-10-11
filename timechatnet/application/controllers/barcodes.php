<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Barcodes extends CI_Controller {

		function index()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
                $data['title'] = "Barcodes";
                $data['header'] = "barcodes";
                $data['page'] = "barcodes";
                $data["base_url"] = $this->config->item("base_url");//config data

                $this->load->model('tbl_barcodes');
                $barcodes = $this->tbl_barcodes->getData();
				$data['barcodes'] = $barcodes;
				
                $this->load->view('header',$data);
                $this->load->view('barcodes/content', $data);
                $this->load->view('footer');
            }
		}
        function details()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
                $id = $_GET['id'];
                $data['title'] = "Details - Barcodes";
                $data['header'] = "barcodes";
                $data['page'] = "barcodes_details";
                $data["base_url"] = $this->config->item("base_url");//config data
                
                $this->load->model('tbl_barcodes');
                $barcodes = $this->tbl_barcodes->getDataById($id);
                $data['barcodes'] = $barcodes[0];

                $this->load->view('header',$data);
                $this->load->view('barcodes/content', $data);
                $this->load->view('footer');
            }
		}
        function edit()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
                $id = $_GET['id'];
                $data['title'] = "Edit - Barcodes";
                $data['header'] = "barcodes";
                $data['page'] = "barcodes_edit";
                $data["base_url"] = $this->config->item("base_url");//config data
                
                $this->load->model('tbl_barcodes');
                $barcodes = $this->tbl_barcodes->getDataById($id);				
                $data['barcodes'] = $barcodes[0];

                $this->load->view('header',$data);
                $this->load->view('barcodes/content', $data);
                $this->load->view('footer');
            }
		}
		
        function add_diag(){
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
                $data['title'] = "Add - Barcodes";
                $data['header'] = "barcodes";
                $data['page'] = "barcodes_add";
                $data["base_url"] = $this->config->item("base_url");//config data                
                
                $this->load->view('header',$data);
                $this->load->view('barcodes/content', $data);
                $this->load->view('footer');
            }
        }
        function add(){
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "0";
            } else{
	            $posts = $this->input->post();
	            if (isset($posts) && !empty($posts)){
        	        $this->load->model('tbl_barcodes');
                	$result = $this->tbl_barcodes->add($posts);
	            } else {
        	        $result = 0;
	            }
        	    if ($result == 0) echo 0;
	            else echo 1;
			}
        }
        function save(){
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "0";
            } else{
	            $posts = $this->input->post();
        	    if (isset($posts) && !empty($posts)){
	                $this->load->model('tbl_barcodes');
	                $result = $this->tbl_barcodes->save($posts);
        	    } else {
	                $result = 0;
        	    }
	            if ($result == 0) echo 0;
	            else echo 1;
			}
        }
		function deleteCheck(){
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                    echo "0";
            } else{
	            $posts = $this->input->post();
        	    if (isset($posts) && !empty($posts)){
                        $this->load->model('tbl_items');
                        $orders = $this->tbl_items->getDataByBarcode_id($posts['id']);
                        if (count($orders) > 0) echo 0;
                        else echo 1;
	            } else {
                        echo 0;
	            }
			}
        }
        function delete(){
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "0";
            } else{
	            $posts = $this->input->post();
        	    if (isset($posts) && !empty($posts)){
	                $this->load->model('tbl_barcodes');
	                $result = $this->tbl_barcodes->delete($posts['id']);
	            } else {
	                $result = 0;
	            }
	            if ($result == 0) echo 0;
        	    else echo 1;
			}
		}
}
