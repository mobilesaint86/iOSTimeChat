<?php
if ( ! defined('BASEPATH')) exit('No direct script access allowed');
//				echo json_encode( "here" ); exit;
class Accounts extends CI_Controller {

	function stdToArray($obj){
	  $reaged = (array)$obj;
	  foreach($reaged as $key => &$field){
		if(is_object($field))$field = stdToArray($field);
	  }
	  return $reaged;
	}

	function test()
	{
		$this->load->library('apn');
		$status = $this->apn->sendMessage( $deviceToken, "please sended", 5,  '', '', false );
		$this->_output_json("sended status : " . $status );
	}

	/**
	 *API Function name		:	check_token
	 * type					:	post
	 * path					:	accounts/check_token
	 * parameters			:	old_password, new_password, token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function check_token()
	{
		$posts = $this->input->post();
		
		$this->load->model('tbl_users');
		$token = $posts['token'];

		$user = $this->tbl_users->getUserinfoByFilter("", "", "", $token );
		if( $user )
		{
			$user_info 	=	[
				"id"		=>	$user['id'],
				"username"	=>	$user['username'],
				"email"		=>	$user['email'],
				"token"		=>	$user['authentication_token'],
				"avatar"	=>	$user['avatar']
			];
			$setting 	= 	[
				"push_enable"			=>	$user['push_enable'],
				"sound_enable"			=>	$user['sound_enable'],
				"auto_accept_friend"	=>	$user['auto_accept_friend'],
				"auto_notify_friend"	=>	$user['auto_notify_friend'],
				"theme_type"			=>	$user['theme_type'],
				"push_sound"			=>	$user['push_sound']
			];
			$json		=	[
				"data"		=>	[
					"user_info"		=>	$user_info,
					"setting"		=>	$setting
				],
				"message"		=>	[
					"type"	=>	'success',
					"value"	=>	'login success',
					"code"	=>	SUCCESS_LOGIN
				]
			];
		}
		else
			$json 		= 	[
				"message"	=>	[
					"type"		=>	'error', 
					"value"		=>	'Can not find this user',
					"code"		=>	ERROR_LOGIN
				]
			];
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	sign_up
	 * type					:	post
	 * path					:	accounts/sign_up
	 * parameters			:	email, password, user_id, username, dev_id, social_type, avatar, timezone
	 * Created Date			:	2014-12-28
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */

	function sign_up()										//home_controller.rb sign_up	require edit
	{
		$test_json = [
			"data"	=> "here"
		];

		$posts = $this->input->post();

		$email				=	"";
		if( isset( $posts['email'] ) )
			$email				=	$posts['email'];
		$user_name			=	$posts['username'];
		$dev_id				=	$posts['dev_id'];
		$social_type		=	$posts['social_type'];
		$time_zone			=	$posts['time_zone'];
		$status				=	false;
		$user_id			=	"";

		if( isset( $email) )
			$email = mb_strtolower( $email, 'UTF-8' );

		if( $social_type != 'twitter' && empty( $email ) )						//if emails or user_id is not valid
		{
			$data = array( 
				"failed"	=>	'please check again account information',
				"status"	=>	"401"
			);
			$this->_output_json( $data );
			exit;
		}

		$user_info['email']			=	$email;
		$user_info['username']		=	$user_name;
		$user_info['social_type']	=	$social_type;
		$user_info['time_zone']		=	$time_zone;

		$this->load->model('tbl_users');

		switch ($social_type) {
			case "email":			//if social_type is email
				if( isset( $posts['password'] ) )
					$password	=	hash( 'md4', $posts['password'] );
				$user_info['password']	=	$password;
				$user_info['avatar']	=	SERVER_URL . AVATAR_ROOT_PATH . 'avatar.png';
				$user_id	=	$this->tbl_users->register( $user_info );
				$status		=	$user_id;
				break;

			case "facebook":			//if socialtype is facebook
				$user_id = $posts['user_id'];
				if( isset( $posts['avatar'] ) )
					$avatar = $posts['avatar'];
				$user = $this->tbl_users->getUserinfoByFilter( "", "", $email, "" );
				if( $user )
				{
					$faceuser['social_id']	=	$user_id;
					$faceuser['time_zone']	=	$time_zone;
//					$faceuser['avatar']		=	$remote_avatar_url;
					$status					=	$this->tbl_users->updateUserData( $faceuser, $user['id'] );
				}
				else
				{
					$random					=	chr(mt_rand(0, 1000));
					$password				=	hash('md4', $user_info['username'].$random);
					$user_info['social_id']	=	$user_id;
					$user_info['password']	=	$password;
					$user_info['avatar']	=	$avatar;
					$user_id				=	$this->tbl_users->register( $user_info );
					$status					=	$user_id;
				}
				$user_id = $user['id'];
				break;

			case "twitter":			//if social_type is twitter
				$user_id = $posts['user_id'];
				$email	=	$user_id."@timechat.com";
				$user	=	$this->tbl_users->getUserinfoByFilter( "", "", $email, "" );
				if( $user )
				{
					$twitteruser['social_id']	=	$user_id;
					$status						=	$this->tbl_users->updateUserData( $twitteruser, $user['id'] );
				}
				else
				{
					$user_info['email']		=	$email;
					$user_info['social_id']	=	$user_id;
					$random					=	chr(mt_rand(0, 1000));
					$password				=	hash('md4', $user_info['username'].$random);
					$user_info['password']	=	$password;
					$user_id				=	$this->tbl_users->register( $user_info );
					$status					=	$user_id;
				}
				$user_id = $user['id'];
				break;

			case "google":			//if social_type is google
				$user_id = $posts['user_id'];
				if( isset( $posts['avatar'] ) )
					$avatar = $posts['avatar'];
				$user = $this->tbl_users->getUserinfoByFilter( "", "", $email, "" );
				if( $user )
				{
					$googleuser['social_id']	=	$user_id;
					$status						=	$this->tbl_users->updateUserData( $googleuser, $user['id'] );
				}
				else
				{
					$user_info['social_id']		=	$user_id;
					$random						=	chr( mt_rand( 0, 1000 ) );
					$password					=	hash( 'md4', $user_info['username'].$random );
					$user_info['password']		=	$password;
					$user_info['avatar']		=	$avatar;
					$user_id					=	$this->tbl_users->register( $user_info );
					$status						=	$user_id;
				}
				$user_id = $user['id'];
				break;
		}

		if( $status <= 0 )
		{
			$msg		=	"This account has been already registered";
			$message	=	array(
				"type"		=>	'error',
				"value"		=>	$msg,
				"code"		=>	ERROR_LOGIN
			);

			$json		=	array(
				"data"		=>	"", 
				"message"	=>	$message
			);
			$this->_output_json( $json ); exit;
		}
		else
		{
			$this->load->model('tbl_devices');
			$this->tbl_devices->removeDevice( $user_id );
			$this->tbl_devices->registerDevice( $user_id, $dev_id );

//			UserTempNotification
		}

		$user_info = $this->tbl_users->getUserinfoByFilter( $user_id, "", "", "" );

		if( $user_info == null )
		{
			$msg		=	"Can not find user.";
			$message	=	array(
				"type"		=>	'error', 
				"value"		=>	$msg,
				"code"		=>	ERROR_LOGIN
			);
			$json		=	array(
				"data"		=>	"",
				"message"	=>	$message
			);
			$this->_output_json( $json ); exit;
		}

		$user_info_data	=	array(
			"id"		=>	$user_info['id'],
			"username"	=>	$user_info['username'],
			"email"		=>	$user_info['email'],
			"token"		=>	$user_info['authentication_token'],
			"avatar"	=>	$user_info['avatar']
		);

		$setting	=	array(
			"push_enable"			=>	$user_info['push_enable'],
			"sound_enable"			=>	$user_info['sound_enable'],
			"auto_accept_friend"	=>	$user_info['auto_accept_friend'],
			"auto_notify_friend"	=>	$user_info['auto_notify_friend'],
			"theme_type"			=>	$user_info['theme_type'],
			"push_sound"			=>	$user_info['push_sound']
		);

		if( $social_type == "email" )					//mail send
		{
			$this->load->library( 'user_mailer' );
			$send_status = $this->user_mailer->sendWelcomeMail( $user_info );

			if( $send_status )
				$mail_status = "mail send";
			else
				$mail_status = "mail failed";
		}

		$json = array(
			"data"		=>	array(
				"user_info"	=>	$user_info_data,
				"setting"	=>	$setting
			),
			"message"	=>	array(
				"type"		=>	'success',
				"value"		=>	'Signed up successfully',
				"code"		=>	SUCCESS_LOGIN
			)
		);
		$this->_output_json( $json );
	}

	function sendMail()								//temp code
	{
//		$this->load->model('mailer');
//		$this->mailer->sendWelcomeMail( "" );
	}

	/**
	 *
     */
	function sign_in()
	{
		date_default_timezone_set( 'Europe/London' );
		$posts		=	$this->input->post();

		$email		=	$posts['email'];
		$email		=	mb_strtolower( $email, 'UTF-8' );
		$password	=	$posts['password'];
		$dev_id		=	$posts['dev_id'];
		$time_zone	=	$posts['timezone'];
		
		$this->load->model('tbl_users');
		if( !strpos( $email, '@' ) )					//if invalid email
		{
			$user = $this->tbl_users->getUserinfoByFilter( "", $email, "", "" );
		}
		else											//if valid email
		{
			$user = $this->tbl_users->getUserinfoByFilter( "", "", $email, "" );
		}

		if( $user == null )								//if not exist user
		{
			$json = [
				"data"		=>	[],
				"message"	=>	array( 
					"type"		=>	'error', 
					"value"		=>	$email." doesn't exist. Please register.",
					"code"		=>	ERROR_LOGIN
				)
			];
		}
		else											//if exist user
		{
			$password	=	hash( 'md4', $password );
			if( $password == $user['password'] )		//if password is equal
			{
				$this->load->model('tbl_devices');
				$this->tbl_devices->removeDevice( $user['id'] );
				$this->tbl_devices->registerDevice( $user['id'], $dev_id );
				$loginuser['time_zone']			=	$time_zone;
				$loginuser['last_sign_in_at']	=	date( 'Y-m-d H:i:s' );
				$loginuser['user_status']		=	'1';
				$status = $this->tbl_users->updateUserData( $loginuser, $user['id'] );

				$user_info	=	array( 
					"id"			=>		$user['id'],
					"username"		=>		$user['username'],
					"email"			=>		$user['email'],
					"token"			=>		$user['authentication_token'],
					"avatar"		=>		$user['avatar']
				);
				$setting	=	array(
					"push_enable"			=>	$user['push_enable'],
					"sound_enable"			=>	$user['sound_enable'],
					"auto_accept_friend"	=>	$user['auto_accept_friend'],
					"auto_notify_friend"	=>	$user['auto_notify_friend'],
					"theme_type"			=>	$user['theme_type'],
					"push_sound"			=>	$user['push_sound']
				);
				$json		=	[
					"data"			=>	[
						"user_info"		=>	$user_info,
						"setting"		=>	$setting
					],
					"message"		=>	[
						"type"			=>	'success',
						"value"			=>	'login success',
						"code"			=>	SUCCESS_LOGIN
					]
				];
			}
			else
			{
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'error', 
						"value"		=>	"Password is incorrect",
						"code"		=>	ERROR_LOGIN
					]
				];
			}
		}
		$this->_output_json( $json );
	}

	/**
	 *
     */
	function sign_out()
	{
		$posts	=	$this->input->post();

		$token	=	$posts['token'];
		
		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

		if( $user == null )								//if not exist user
		{
			$json = [
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'No Such User',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json );
		}
		else											//if exist user
		{
			$logout_user['user_status']	=	"1";
			$status						=	$this->tbl_users->updateUserData( $logout_user, $user['id'] );
			$json						=	array (
											"data"		=>	[],
											"message"	=>	array(
												"type"		=>	'success',
												"value"		=>	'Success sign out', 
												"code"		=>	SUCCESS_LOGOUT
											)
			);
			$this->_output_json( $json );
		}
	}

	/**
	 *API Function name		:	forgot_password
	 * type					:	post
	 * path					:	accounts/forgot_password
	 * parameters			:	email, token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
     */

	function forgot_password()			//require edit
	{
		$posts	=	$this->input->post();
		$email	=	$posts['email'];

		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", $email, "" );



		if( $user == null )								//if not exist user
		{
			$json = [
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'failed',
					"value"		=>	'Cannot find this email',
					"code"		=>	ERROR_QUERY
				]
			];
		}
		else
		{
			$this->load->library( 'user_mailer' );
			$rand = rand( 1, 100000000 );
			$rand = '12345678';
			$new_password = hash( 'md4', $rand );
			$user['password']	=	$new_password;
			$reset_user = $this->tbl_users->setResetPasswordToken( $user );
//			$this->_output_json( $reset_user ); exit;
			$status = $this->user_mailer->sendForgotPasswordMail( $user, $rand );
			if( $status )
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'success',
						"value"		=>	'Please confirm your email address.',
						"code"		=>	SUCCESS_QUERY
					]
				];
			else
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'success',
						"value"		=>	'Cannot connect mailer server',
						"code"		=>	ERROR_QUERY
					]
				];
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	change_profile
	 * type					:	post
	 * path					:	accounts/change_profile
	 * parameters			:	old_password, new_password, user_name, new_email, avatar, token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:	2014-12-31
	 * Updater				:	tiger
     */
	function change_profile()									//require test(avatar)
	{
		$posts	=	$this->input->post();

		if( isset( $posts['old_password'] ) )
			$old_password	=	$posts['old_password'];
		if( isset( $posts['new_password'] ) )
			$new_password	=	$posts['new_password'];
		if( isset( $posts['user_name'] ) )
			$user_name		=	$posts['user_name'];
		if( isset( $posts['new_email'] ) )
			$new_email		=	$posts['new_email'];

//		$avatar			=	$posts['avatar'];
		$token			=	$posts['token'];
		$is_changed		=	FALSE;
		$new_user = array();

		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json		=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user',
					"code"		=>	'14'
				]
			];
		}
		else
		{
			if( isset( $new_password ) && !empty( $new_password ) )		//if password is changed
			{
				$old_enc_password = hash('md4', $old_password );
				if( $user['password'] == $old_enc_password )				//if old password is correct
					$new_user['password']	=	hash('md4', $new_password);
				else
				{
					$json = [
						"data"		=>	[],
						"message"	=>	[
							"type"		=>	'error',
							"value"		=>	'Current password is incorrect. Please confirm current password.',
							"code"		=>	ERROR_CHANGE_PASSWORD
						]
					];
					$this->_output_json( $json ); exit;
				}
			}
			else if( isset( $user_name ) && !empty( $user_name ) )			//if username is changed
				$new_user['username'] 	=	$user_name;
			else if( isset( $new_email ) && !empty( $new_email ) )		//if email is changed
				$new_user['email'] 		=	$new_email;

			if( isset( $_FILES['avatar']['tmp_name']) ) {                 //if avatar is not null
				$avatar_path = AVATAR_ROOT_PATH . $user['id'] . "/";
				$dirCreated = (!is_dir($avatar_path)) ? @mkdir($avatar_path, 0777) : TRUE;
				$avatar_name = $_FILES['avatar']['name'];
				$avatar_url = $avatar_path . $avatar_name;
				if(file_exists( $avatar_url )) unlink( $avatar_url );
				if (!move_uploaded_file($_FILES['avatar']['tmp_name'], $avatar_url)) {
					$json = [
						"data" => [],
						"message" => [
							"type" => 'error',
							"value" => 'Cannot upload avatar file to server.',
							"code" => MEDIA_NOT_FOUND
						]
					];
					$this->_output_json($json);
					exit;
				}
				$new_user['avatar'] = SERVER_URL . $avatar_url;
			}
			if( count( $new_user ) > 0 )

				$is_changed				=	$this->tbl_users->updateUserData( $new_user, $user['id'] );

			if( $is_changed )
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'success',
						"value"		=>	'Changed profile successfully',
						"code"		=>	SUCCESS_QUERY
					]
				];
			else
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'failed',
						"value"		=>	'Cannot changed profile',
						"code"		=>	ERROR_QUERY
					]
				];
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	push_setting
	 * type					:	post
	 * path					:	accounts/push_setting
	 * parameters			:	token, push_enable, sound_enable
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function push_setting()
	{
		$posts = $this->input->post();

		$push_enable = $posts['push_enable'];
		$sound_enable = $posts['sound_enable'];
		$token = $posts['token'];

		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['push_enable'] 	=	$push_enable;
			$update_user['sound_enable'] 	= 	$sound_enable;
			$is_changed						=	$this->tbl_users->updateUserData( $update_user, $user['id'] );

			if( $is_changed )
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'success',
						"value"		=>	'Push setting',
						"code"		=>	SUCCESS_QUERY
					]
				];
			else
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'failed',
						"value"		=>	'Cannot push setting',
						"code"		=>	ERROR_QUERY
					]
				];
		}
		$this->_output_json( $json );
	}

	/**
 *API Function name		:	privacy_setting
 * type					:	post
 * path					:	accounts/privacy_setting
 * parameters			:	token, auto_accept_friend, auto_notify_friend
 * Created Date			:	2014-12-29
 * Creator				:	tiger
 * Update Date			:
 * Updater				:
 */
	function privacy_setting()
	{
		$posts = $this->input->post();

		$auto_accept_friend 	= 	$posts['auto_accept_friend'];
		$auto_notify_friend 	= 	$posts['auto_notify_friend'];
		$token = $posts['token'];

		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['auto_accept_friend'] 	=	$auto_accept_friend;
			$update_user['auto_notify_friend'] 	= 	$auto_notify_friend;
			$is_changed						=	$this->tbl_users->updateUserData( $update_user, $user['id'] );

			if( $is_changed )
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'success',
						"value"		=>	'Privacy setting',
						"code"		=>	SUCCESS_QUERY
					]
				];
			else
				$json = [
					"data"		=>	[],
					"message"	=>	[
						"type"		=>	'failed',
						"value"		=>	'Cannot privacy setting',
						"code"		=>	ERROR_QUERY
					]
				];
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	theme_setting
	 * type					:	post
	 * path					:	accounts/theme_setting
	 * parameters			:	theme_type, token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function theme_setting()
	{
		$posts = $this->input->post();

		$theme_type 	= 	$posts['theme_type'];
		$token 			=	$posts['token'];


		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['theme_type'] 	=	$theme_type;
			$is_changed					=	$this->tbl_users->updateUserData( $update_user, $user['id'] );
			if( $is_changed ) {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'success',
						"value" => 'Theme type',
						"code" => SUCCESS_QUERY
					]
				];
			}
			else {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'failed',
						"value" => 'Cannot theme type setting',
						"code" => ERROR_QUERY
					]
				];
			}
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	sound_setting
	 * type					:	post
	 * path					:	accounts/sound_setting
	 * parameters			:	push_sound, token
	 * Created Date			:	2014-12-30
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function sound_setting()
	{
		$posts = $this->input->post();

		$push_sound 	= 	$posts['push_sound'];
		$token 			=	$posts['token'];


		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['push_sound'] 	=	$push_sound;
			$is_changed					=	$this->tbl_users->updateUserData( $update_user, $user['id'] );
			if( $is_changed ) {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'success',
						"value" => 'Push sound',
						"code" => SUCCESS_QUERY
					]
				];
			}
			else {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'failed',
						"value" => 'Cannot set push sound',
						"code" => ERROR_QUERY
					]
				];
			}
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	read_avatar
	 * type					:	post
	 * path					:	accounts/read_avatar
	 * parameters			:	push_sound, friend_id
	 * Created Date			:	2014-12-30
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function read_avatar()								//require edit(unrecognize)
	{
		$posts = $this->input->post();

		$friend_id 	= 	$posts['friend_id'];
		$token 			=	$posts['token'];

		$this->load->model('tbl_users');
		$user		=	$this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		$friend 	=	$this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['push_sound'] 	=	$push_sound;
			$is_changed					=	$this->tbl_users->updateUserData( $update_user, $user['id'] );
			if( $is_changed ) {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'success',
						"value" => 'Push sound',
						"code" => SUCCESS_QUERY
					]
				];
			}
			else {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'failed',
						"value" => 'Cannot set push sound',
						"code" => ERROR_QUERY
					]
				];
			}
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	set_online
	 * type					:	post
	 * path					:	accounts/set_online
	 * parameters			:	token
	 * Created Date			:	2014-12-30
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function set_online()
	{
		$posts = $this->input->post();

		$token 			=	$posts['token'];

		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['user_status'] 	=	1;
			$is_changed					=	$this->tbl_users->updateUserData( $update_user, $user['id'] );
			if( $is_changed ) {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'success',
						"value" => 'Changed user status to online',
						"code" => SUCCESS_QUERY
					]
				];
			}
			else {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'failed',
						"value" => 'Cannot change user status',
						"code" => ERROR_QUERY
					]
				];
			}
		}
		$this->_output_json( $json );
	}

	/**
	 *API Function name		:	set_offline
	 * type					:	post
	 * path					:	accounts/set_offline
	 * parameters			:	token
	 * Created Date			:	2014-12-30
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function set_offline()
	{
		$posts = $this->input->post();

		$token 			=	$posts['token'];

		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
		if( $user == null )
		{
			$json 	=	[
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user.',
					"code"		=>	ERROR_LOGIN
				]
			];
			$this->_output_json( $json ); exit;
		}
		else
		{
			$update_user['user_status'] 	=	0;
			$is_changed					=	$this->tbl_users->updateUserData( $update_user, $user['id'] );
			if( $is_changed ) {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'success',
						"value" => 'Changed user status to offline',
						"code" => SUCCESS_QUERY
					]
				];
			}
			else {
				$json = [
					"data" => [],
					"message" => [
						"type" => 'failed',
						"value" => 'Cannot change user status',
						"code" => ERROR_QUERY
					]
				];
			}
		}
		$this->_output_json( $json );
	}


	/******************************** GET API Function	*****************************/

	/**
	 *API Function name		:	setting
	 * type					:	get
	 * path					:	accounts/setting
	 * parameters			:	token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
     */
	function setting()							//required edit
	{
		$gets	=	$this->input->get();

		$token	=	$gets['token'];
		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

		if( $user == null )
		{
			$json = [
				"data"		=>	[
					"push_enable"			=>	$user['push_enable'],
					"sound_enable"			=>	$user['sound_enable'],
					"auto_accept_friend"	=>	$user['auto_accept_friend'],
					"auto_notify_friend"	=>	$user['auto_notify_friend'],
					"theme_type"			=>	$user['theme_type']
				],
				"message"	=>	[
					"type"					=>	'success',
					"value"					=>	'account setting',
					"code"					=>	SUCCESS_QUERY
				]
			];
			$this->_output_json( $json );
		}
		else
		{
			$json = [
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user',
					"code"		=>	ERROR_LOGIN
				]
			];
		}
	}

	/**
	 *API Function name		:	push_getting
	 * type					:	get
	 * path					:	accounts/push_getting
	 * parameters			:	token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function push_getting()							//required edit(and app)
	{
		$gets	=	$this->input->get();

		$token	=	$gets['token'];
		$this->load->model('tbl_users');
		$user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

		if( $user == null )
		{
			$json = [
				"data"		=>	[
					"push_enable"			=>	$user['push_enable'],
					"sound_enable"			=>	$user['sound_enable']
				],
				"message"	=>	[
					"type"					=>	'success',
					"value"					=>	'Push setting',
					"code"					=>	SUCCESS_QUERY
				]
			];
			$this->_output_json( $json );
		}
		else
		{
			$json = [
				"data"		=>	[],
				"message"	=>	[
					"type"		=>	'error',
					"value"		=>	'Cannot find this user',
					"code"		=>	ERROR_LOGIN
				]
			];
		}
	}

	/**
	 *API Function name		:	privacy_getting
	 * type					:	get
	 * path					:	accounts/privacy_getting
	 * parameters			:	token
	 * Created Date			:	2014-12-29
	 * Creator				:	tiger
	 * Update Date			:
	 * Updater				:
	 */
	function privacy_getting()						//required edit
	{
	}
	/**
	 * Private Function Name		:	_output_json
	 * @param $data					:	data to be written
	 * Created Date					:	2014-12-29
	 * Creator						:	tiger
	 * Update Date
	 * Updater
     */
	function _output_json( $data )						//edit tiger	12.29
	{
		header('Access-Control-Allow-Origin: *');
		header('Content-Type: application/json');
		echo json_encode( $data );
	}
}

//$.post( "http://192.168.0.208/timechatnet/index.php/accounts/set_offline",{token:"tigertiger"}, function(data) {	console.log(data);})
?>