<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Orders extends CI_Controller {

		function index()
        {
            session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
                $data['title'] = "Orders";
                $data['header'] = "orders";
                $data['page'] = "orders";
                $data["base_url"] = $this->config->item("base_url");//config data

                $this->load->model('tbl_orders');
                $orders = $this->tbl_orders->getData();
				$this->load->model('users');				                
				
				for ($i=0;$i<count($orders);$i++){
                    $user = $this->users->getDataById($orders[$i]['user_id']);
					if (count($user) > 0)
						$orders[$i]['username'] = $user[0]['username'];
					else
						$orders[$i]['username'] = '';
                }
				
				$data['orders'] = $orders;
				
                $this->load->view('header',$data);
                $this->load->view('orders/content', $data);
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
                $data['title'] = "Details - Orders";
                $data['header'] = "orders";
                $data['page'] = "orders_details";
                $data["base_url"] = $this->config->item("base_url");//config data
                
                $this->load->model('tbl_orders');
                $orders = $this->tbl_orders->getDataById($id);
				
				$this->load->model('users');				                				
				$user = $this->users->getDataById($orders[0]['user_id']);
                if (count($user) > 0)
					$orders[0]['username'] = $user[0]['username'];
				else
					$orders[0]['username'] = '';					
					
                $data['orders'] = $orders[0];

                $this->load->view('header',$data);
                $this->load->view('orders/content', $data);
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
                $data['title'] = "Edit - Orders";
                $data['header'] = "orders";
                $data['page'] = "orders_edit";
                $data["base_url"] = $this->config->item("base_url");//config data
                
                $this->load->model('tbl_orders');
                $orders = $this->tbl_orders->getDataById($id);
				
				$this->load->model('users');				                				
				$user = $this->users->getDataById($orders[0]['user_id']);
                if (count($user) > 0)
					$orders[0]['username'] = $user[0]['username'];
				else
					$orders[0]['username'] = '';
				
                $data['orders'] = $orders[0];

                $this->load->view('header',$data);
                $this->load->view('orders/content', $data);
                $this->load->view('footer');
            }
		}
		
        function add_diag(){
            if(!isset($_SESSION))
				session_start();

            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "This page is available.";
            } else{
                $data['title'] = "Add - Orders";
                $data['header'] = "orders";
                $data['page'] = "orders_add";
                $data["base_url"] = $this->config->item("base_url");//config data                
                
                $this->load->view('header',$data);
                $this->load->view('orders/content', $data);
                $this->load->view('footer');
            }
        }
        function add(){
            if(!isset($_SESSION))
				session_start();

            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "0";
            } else{
	            $posts = $this->input->post();
	            if (isset($posts) && !empty($posts)){
        	        $this->load->model('tbl_orders');
                	$result = $this->tbl_orders->add($posts);
	            } else {
        	        $result = 0;
	            }
        	    if ($result == 0) echo 0;
	            else echo 1;
			}
        }
        function save(){
            if(!isset($_SESSION))
				session_start();

            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "0";
            } else{
	            $posts = $this->input->post();
        	    if (isset($posts) && !empty($posts)){
	                $this->load->model('tbl_orders');
	                $result = $this->tbl_orders->save($posts);
        	    } else {
	                $result = 0;
        	    }
	            if ($result == 0) echo 0;
	            else echo 1;
			}
        }
        function deleteCheck(){
            if(!isset($_SESSION))
				session_start();

            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                    echo "0";
            } else{
	            $posts = $this->input->post();
        	    if (isset($posts) && !empty($posts)){
                        $this->load->model('tbl_items');
                        $items = $this->tbl_items->getDataByOrder_id($posts['id']);
                        if (count($items) > 0) echo 0;
                        else echo 1;
	            } else {
                        echo 0;
	            }
			}
        }
        function delete(){
           if(!isset($_SESSION))
				session_start();
            if (!isset($_SESSION["password"]) && empty($_SESSION["password"])) {
                echo "0";
            } else{
	            $posts = $this->input->post();
        	    if (isset($posts) && !empty($posts)){
	                $this->load->model('tbl_orders');
	                $result = $this->tbl_orders->delete($posts['id']);
	            } else {
	                $result = 0;
	            }
	            if ($result == 0) echo 0;
        	    else echo 1;
			}
		}
}
