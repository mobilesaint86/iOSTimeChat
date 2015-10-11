<?php 
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Server extends CI_Controller {

		function connect_test() {
			header('Access-Control-Allow-Origin: *');
            header('Content-Type: application/json');
			$json = json_encode("1");
			echo $json;			
		}
		
		function stdToArray($obj){
		  $reaged = (array)$obj;
		  foreach($reaged as $key => &$field){
			if(is_object($field))$field = stdToArray($field);
		  }
		  return $reaged;
		}		
		
		//login
        function login(){			
			header('Access-Control-Allow-Origin: *');
			//header('Access-Control-Allow-Headers: Content-Type');
            header('Content-Type: application/json');
			
			$posts = $this->input->post();
			
			//for android
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
            $this->load->model('tbl_users');
			$stat_val = $this->tbl_users->loginCheck($posts['username'],$posts['password']);		
			if(is_array($stat_val)) {
				$json['result'] = $stat_val;
				$json['data'] =  1;
			}
			else {
				$json['result'] = '';
				$json['data'] =  $stat_val;
			}
			
			$json = json_encode($json);
			echo $json;
        }
		
		//signup (error_data - -1: user exist, -2: email exist)
		function signup(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_users');
			
			$userinfo = $posts;

			$stat_val = $this->tbl_users->register($userinfo);
			//$stat_val = 9;
			$json['data'] = $stat_val;
			$json = json_encode($json);
			echo $json;
		}

		//upload photo, change password (user_id, img_data)
		function change_profile(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_users');
			
			if($_FILES['avatar_img']['tmp_name']) {
				$photo_dir="uploads";
				$dirCreated=(!is_dir($photo_dir)) ? @mkdir($photo_dir, 0777):TRUE; 
				
				$photo_dir.="/".$posts['user_id']."/";
				$dirCreated=(!is_dir($photo_dir)) ? @mkdir($photo_dir, 0777):TRUE; 

				$img_name = $_FILES['avatar_img']['name'];
				//$ext=pathinfo($img_name, PATHINFO_EXTENSION);
			
				// upload photo
				move_uploaded_file($_FILES['avatar_img']['tmp_name'], $photo_dir.$img_name);
			
				$updateinfo['avatar'] = $photo_dir.$img_name;
			}
			$updateinfo['id'] = $posts['user_id'];
			if($posts['password'])	$updateinfo['password'] = $posts['password'];

			$stat_val = $this->tbl_users->save($updateinfo);
			
			if($stat_val)	$data = 1;
			else $data = 0;
			$json['data'] = $data;
			$json = json_encode($json);
			echo $json;
		}
		
		// user filter by search items ( username, name, email, age..)
		function search_user(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}

			$this->load->model('tbl_users');
			$users = $this->tbl_users->getUserFilter($posts['username'],$posts['name'],$posts['email'],$posts['age_down'],$posts['age_up']);
			$json['data'] = $users;
			$json = json_encode($json);
			echo $json;		
		
		}
		//friend invite
		function friend_invite(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_friends');		
			$this->load->model('tbl_users');		
			$this->load->model('tbl_messages');		
			
			$stat_val = $this->tbl_friends->friend_register($posts['user_id'],$posts['friend_username'], $posts['friend_email'], 0);
			//set invite msg
			if($stat_val>0) 	{
				$userinfo = $this->tbl_users->getDataById($posts['user_id']);
				$content = "invite requested from ".$userinfo[0]['username'].'('.$userinfo[0]['firstname'].' '.$userinfo[0]['lastname'].')';
				$this->tbl_messages->add_message($posts['user_id'], $stat_val, $content, 2, 1 );				
			}
			
			$json['data'] = $stat_val;
			$json = json_encode($json);
			echo $json;
		}		
		
		//get invited request (user_id) 			
		function get_invite_request(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_friends');
			$this->load->model('tbl_users');
			
			$friend = $this->tbl_friends->get_invite_request($posts['user_id']);
			if($friend)
			{							
				$inviter_id = $friend[0]['user_id'];
				$inviter_info = $this->tbl_users->getDataById($inviter_id);
				$data = $inviter_info;
				
			} else {	
				$data = 0;
			}
			$json['data'] = $data;
			$json = json_encode($json);
			echo $json;
        }		
		
		//get friend list (category_id, state) 			
		function friend_list (){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_friends');

			$friends = $this->tbl_friends->get_friends($posts['user_id'],$posts['category_id'],$posts['state']);
			$json['data'] = $friends;
			$json = json_encode($json);
			echo $json;
        }
		
		//delete friend (user_id, friend_id) 			
		function friend_delete(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_friends');

			$result = $this->tbl_friends->friend_delete($posts['user_id'],$posts['friend_id']);
			if($result)
			{							
				$data = 1;
			} else {	
				$data = 0;
			}
			$json['data'] = $data;
			$json = json_encode($json);
			echo $json;
        }		
		
		//grouping friend by category_id(user_id, friend_id, category_id) 			
		function friend_grouping(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_friends');

			$result = $this->tbl_friends->update_friends($posts['user_id'],$posts['friend_id'],$posts['category_id'],'');
			if($result)
			{		
				$data = 1;
			} else {	
				$data = 0;
			}
			$json['data'] = $data;
			$json = json_encode($json);
			echo $json;
        }	
		
		//accept friend invite 			
		function friend_accept(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_friends');
			$this->load->model('tbl_users');
			$this->load->model('tbl_messages');
			
			//add friend to me
			$stat_val = $this->tbl_friends->friend_register_byid($posts['user_id'],$posts['friend_id'],$posts['category_id'],1);		
			
			if($stat_val>0)
			{					
			
				//set message accepted
				$userinfo = $this->tbl_users->getDataById($posts['user_id']);
				$content = $userinfo[0]['username'].'('.$userinfo[0]['firstname'].' '.$userinfo[0]['lastname'].')'." accepted your invite request ";
				$this->tbl_messages->add_message($posts['user_id'], $posts['friend_id'], $content, 2, 2);				

			} 
			
			$data = $stat_val;
			$json['data'] = $data;
			$json = json_encode($json);
			echo $json;
        }						
		//reject friend invite 			
		function friend_reject(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}

			$this->load->model('tbl_friends');
			$this->load->model('tbl_users');
			$this->load->model('tbl_messages');

			// check if now state = 0 ?
			
			//reject invite
			$result = $this->tbl_friends->update_friends($posts['friend_id'], $posts['user_id'], '', 2);
			if($result)
			{							
				//set message rejected
				$userinfo = $this->tbl_users->getDataById($posts['user_id']);
				$content = $userinfo[0]['username'].'('.$userinfo[0]['firstname'].' '.$userinfo[0]['lastname'].')'." rejected your invite request ";
				$this->tbl_messages->add_message($posts['user_id'], $posts['friend_id'], $content, 2, 3);				
				$data = 1;
			} 
			else $data=0;
			$json['data'] = $data;
			$json = json_encode($json);
			echo $json;
        }						
		
		//message send
		function msg_send(){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_messages');
			
			$result = $this->tbl_messages->add_message($posts['user_id'], $posts['friend_id'], $posts['content'], $posts['msgtype'], $posts['notifytype'] );
			$json['data'] = $result;
			$json = json_encode($json);
			echo $json;
        }				
		
		//get message list (user_id, msgtype, notifytype, state) 			return: msg info
		function msg_receive (){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_messages');

			$messages = $this->tbl_messages->get_messages($posts['user_id'],$posts['msgtype'], $posts['notifytype'], $posts['state']);
			$json['data'] = $messages;
			$json = json_encode($json);
			echo $json;
        }
		
		//delete message (msg_id) 		 return: 1 / 0	
		function msg_delete (){
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			$this->load->model('tbl_messages');

			$stat = $this->tbl_messages->delete_message($posts['msg_id']);
			if($stat) $data_val = 1;
			else	$data_val = 0;
			
			$json['data'] = $data_val;
			$json = json_encode($json);
			echo $json;
        }
		
		//Descript:	 wish register 
		//Param: 	(user_id, wish_option,descript, product_code, price, event_date, event_time, visable_all, visable_friend_ids)
		//Return:	successful 1, failed 0;
		
		function wish_register() {
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_wish');
			
			$wishinfo = $posts;

			$stat_val = $this->tbl_wish->register_wish($wishinfo);
			if($stat_val)	$stat_val =1;
			else $stat_val = 0;
			
			$json['data'] = $stat_val;
			$json = json_encode($json);
			echo $json;
		
		}

		//Descript:	 wish info update
		//Param: 	set variable only for update(wish_id, wish_option,descript, product_code, price, event_date, event_time, visable_all, visable_friend_ids)
		//Return:	successful 1, failed 0;
		
		function wish_update() {
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_wish');
			
			$wishinfo = $posts;

			$stat_val = $this->tbl_wish->update_wish($wishinfo);
			if($stat_val)	$stat_val =1;
			else $stat_val = 0;
			
			$json['data'] = $stat_val;
			$json = json_encode($json);
			echo $json;
		
		}

		//Descript:	wish delete
		//Param: 	wish_id
		//Return:	successful 1, failed 0;
		
		function wish_delete() {
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_wish');
			
			$wishinfo['wish_id'] = $posts['wish_id'];
			$wishinfo['deleted'] = 1;
			
			$stat_val = $this->tbl_wish->update_wish($wishinfo);
			if($stat_val)	$stat_val =1;
			else $stat_val = 0;
			
			$json['data'] = $stat_val;
			$json = json_encode($json);
			echo $json;		
		}
		//Descript:	wish pickup
		//Param: 	wish_id, visable_all, visable_friend_ids
		//Return:	successful 1, failed 0;
		
		function wish_pickup() {
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_wish');
			
			$wishinfo['wish_id'] = $posts['wish_id'];
			$wishinfo['visable_all'] = $posts['visable_all'];
			$wishinfo['visable_friend_ids'] = $posts['visable_friend_ids'];
			$wishinfo['picked'] = 1;
			$stat_val = $this->tbl_wish->update_wish($wishinfo);
			
			if($stat_val) {
				$friend_array = explode(",", $wishinfo['visable_friend_ids']);			
				$wish_data = $this->tbl_wish->getDataById($wishinfo['wish_id']);
				$userinfo = $this->tbl_users->getDataById($wish_data['user_id']);
				$content = $userinfo[0]['username'].'('.$userinfo[0]['firstname'].' '.$userinfo[0]['lastname'].')'." share with you pickup wish ";
				foreach($friend_array as $friend_id) {
					//set message pickup
					if($friend_id) {
						$this->tbl_messages->add_message($wish_data['user_id'], $friend_id, $content, 2, 4);	
					}
				}
				$stat_val = 1;
			}
			else $stat_val = 0;
			
			$json['data'] = $stat_val;
			$json = json_encode($json);
			echo $json;		
		}
		//Descript:	get my wish list
		//Param: 	user_id, picked, deleted
		//Return:	data - successful 1, failed 0, result- array
		
		function wish_get_my_list() {
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_wish');
			
			$result = $this->tbl_wish->get_my_wish_list($posts['wish_id'], $posts['picked'], $posts['deleted']);
			if($result)	 $json['data'] = 1;
			else $json['data'] = 0;
			
			$json['result'] = $result;
			$json = json_encode($json);
			echo $json;		
		}
		
		//Descript:	get friend's wish list
		//Param: 	user_id
		//Return:	data - successful 1, failed 0, result- array
		
		function wish_get_friends_list() {
			header('Access-Control-Allow-Origin: *');
			header('Content-Type: application/json');
			$posts = $this->input->post();
			if(!$posts)	{
				$posts = json_decode(file_get_contents("php://input"));
				$posts = $this->stdToArray($posts);
			}
			
			$this->load->model('tbl_wish');
			
			$result = $this->tbl_wish->get_friends_wish_list($posts['user_id']);
			if($result)	 $json['data'] = 1;
			else $json['data'] = 0;
			
			$json['result'] = $result;
			$json = json_encode($json);
			echo $json;		
		}

}
