<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//edit tiger	user.rb
class Tbl_users extends CI_Model {

	public function __construct()
	{
		date_default_timezone_set( 'Europe/London' );
		$this->load->library( 'apn' );
	}

	//backend processing
	function loginCheck($username, $password){
		$this->db->where('username', $username);
		$query = $this->db->get('users');

		//user exist
		if (count($query->result()) > 0) {
			$row = $query->result_array();
			//password right
			if($row[0]['password'] == $password)	return $row[0];
			else	return -2;
		}
		else {
			return -1;
		}

	}

	function register($userdata)
	{
		date_default_timezone_set( 'Europe/London' );
		//userid exist
		$this->db->where('username', $userdata['username']);
		$query = $this->db->get('users');


		if (count($query->result()) > 0) {
			return -1;
		}

		//email exist
		$this->db->where('email', $userdata['email']);
		$query = $this->db->get('users');

		if (count($query->result()) > 0) {
			return -2;
		}

		//$userdata['password'] = md5($userdata['password']);
		$userdata['created_at']		=	date( 'Y-m-d H:i:s' );
		$this->db->insert('users', $userdata);
		$id = $this->db->insert_id();

		if ( $id > 0 )
		{
			$this->bGetToken( $id );						//12.28
			return $id;
		}
		else
			return 0;
	}


	// user filter by search items 
	function getUserFilter($username, $name, $email, $age_down, $age_up){
		if($age_down)	$this->db->where('TIMESTAMPDIFF(YEAR, birthday, CURDATE()) >=',$age_down);
		if($age_up)		$this->db->where('TIMESTAMPDIFF(YEAR, birthday, CURDATE()) <=',$age_up);
		if($username)	$this->db->where(' username like "%'.$username.'%" ');
		///if($username)	$this->db->where(' INSTR(username,"'.$username.'") > 0 ');
		if($name)	$this->db->where(' concat(firstname, lastname) like "%'.$name.'%" ');
		//if($name)	$this->db->where(' INSTR(concat(firstname, lastname) ,"'.$name.'") > 0 ');		
		if($email)	$this->db->where('email', $email);

		$this->db->order_by('username','asc');
		$this->db->select('users.*, users.id as password');

		$query = $this->db->get('users');
		return $query->result_array();
	}


	// Site Adminarea use function
	function getData(){
		//$this->db->where('usergrade',0);
		$this->db->order_by('id','desc');
		$query = $this->db->get('users');
		return $query->result_array();
	}

	function getDataById($nId){
		$this->db->where('id',$nId);
		$query = $this->db->get('users');
		return $query->result_array();
	}
	function getDataByToken($token){
		$this->db->where('token',$token);
		$query = $this->db->get('users');
		return $query->result_array();
	}
	function save($data){
		$result = $this->db->update('users', $data, array('id' => $data['id']));
		return $result;
	}
	function add($data){
		$result = $this->db->insert('users',$data);
		return $result;
	}
	function delete($id){
		$this->db->where('id', $id);
		$result = $this->db->delete('users');
		return $result;
	}
	function bLoginCheck($userdata){
		//$userdata['password'] = md5($userdata['password']);

		$this->db->where($userdata);
		$query = $this->db->get('users');
		if (count($query->result()) > 0) {
			return 1;
		}
		else return 0;
	}

	function bExistByToken($token){
		$this->db->where('token',$token);
		$query = $this->db->get('users');
		if (count($query->result()) > 0) {
			return 1;
		}
		else {
			return 0;
		}
	}
	function bGetId($userdata){
		$this->db->where($userdata);
		$query = $this->db->get('users');
		$row = $query->result_array();
		return $row[0]['id'];
	}
	function bGetToken( $nId ){
		$this->db->where( 'id',$nId );
		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
		{
			$random = chr(mt_rand(0, 1000));
			$new_token = hash('md4', $row[0]['email'].$random);
			$data['authentication_token'] = $new_token;
			$result = $this->db->update('users', $data, array('id' => $nId));
			return $new_token;
		}
		else
			return null;
	}

	//edit tiger				//user.rb find_by_auth_token token
	function findByAuthToken($token)
	{
//		$this->db->select('user_id, m.friend_id as user_id, u.username, u.lastname, u.firstname');


		$this->db->where('authentication_token', $token);
		$query = $this->db->get('users');
		$row = $query->result_array();
		return $row;
	}

	function getAuthenticationTokenById( $token )					//edit tiger 12.29 
	{
		$this->db->where( $userid );
		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
			return $row[0]['authentication_token'];
		else
			return '';
	}

	function getUserInfoById( $userid )								//edit tiger 12.28
	{
//		print_r( json_encode( $userid ) ); exit;
		$this->db->where( 'id', $userid );
		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
			return $row[0];
		else
			return null;
	}

	function getUserInfoByEmail( $email )								//edit tiger 12.28
	{
		$this->db->where('email', $email);
		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
			return $row[0];
		else
			return null;
	}

	function getUserInfoByName( $username )							//edit tiger 12.29
	{
		$this->db->where('username', $username);
		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
			return $row[0];
		else
			return null;
	}

	function getUserInfoByToken( $token )
	{
		$this->db->where('authentication_token', $token);
		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
			return $row[0];
		else
			return null;
	}

	function getUserinfoByFilter( $id, $username, $email, $token )					//edit tiger 12.29
	{
		if( $id )			$this->db->where( 'id', $id );
		if( $username )		$this->db->where( 'username', $username );
		if( $email )		$this->db->where( 'email', $email );
		if( $token )		$this->db->where( 'authentication_token', $token );

		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
			return $row[0];
		else
			return null;
	}

	function updateUserData( $userinfo, $id )
	{
		$this->db->where( 'id', $id );
		$ret = $this->db->update( 'users', $userinfo );
		return $ret;
	}

	function updateSignInData( $userinfo, $status )
	{

	}

	function getFriendsInfo( $user_id, $friend_id )					//edit tiger 12.31
	{
		if ( $user_id ) $this->db->where('id', $user_id );

		$query = $this->db->get('users');
		$row = $query->result_array();
		if( $row )
		{
			$friend_ids_str = $row[0]['friend_ids'];
			if( $friend_id )
				$friend_id_array = [ $friend_id ];
			else
				$friend_id_array = mbsplit( ',', $friend_ids_str, -1 );
			$friend_block_array = mbsplit( ',', $row[0]['ignored_friend_ids'], -1 );

			for( $i = 0; $i < count($friend_id_array); $i++)
			{
				$this->db->select( "users.id,
									users.email,
									users.avatar,
									users.time_zone,
									users.username,
									users.user_status as is_online" );
				$this->db->where( 'users.id', $friend_id_array[$i] );
				$query = $this->db->get( 'users' );
				$row1 = $query->result_array();
				if( $row1 )
				{
					$row1[0]['avatar_status']	=	$this->getAvatarStatus( $row1[0]['id'] );
					$row1[0]['debug']			=	'Friend List';
					$row1[0]['is_favorite']		=	$this->isFavorite( $user_id, $row1[0]['id'] );
					if( in_array( $row1[0]['id'], $friend_block_array ) )
						$row1[0]['friend_status'] = FRIEND_IGNORE;
					else
						$row1[0]['friend_status'] = FRIEND_DISABLE_FRIEND;
					$friends_info[$i] = $row1[0];
				}
				else
					return null;
			}
			return $friends_info;
		}
		else
			return null;
	}

	function getUsersBySocialType( $social_type, $friend_id_array, $is_friend )					//edit tiger 12.31
	{
		if( $social_type ) $this->db->where( 'social_type', $social_type );
		$query = $this->db->get('users');
		$rows = $query->result_array();

		$users = [];
		if( $rows )
		{
			$j = 0;
			for( $i = 0; $i < count( $rows ); $i++ )
			{
				if( !in_array( $rows[$i]['id'], $friend_id_array )) {
					$users[$j]['id'] = $rows[$i]['id'];
					$users[$j]['email'] = $rows[$i]['email'];
					$users[$j]['debug'] = 'Friend List';
					$users[$j]['username'] = $rows[$i]['username'];
					$users[$j]['avatar'] = $rows[$i]['avatar'];
					$j++;
				}
			}
			return $users;
		}
		else
			return null;
	}

	function getPhoneBookUsers( $email_array, $friend_id_array )					//edit tiger 12.31
	{
		if( $social_type ) $this->db->where( 'social_type', $social_type );

		$users = [];
		$j = 0;

		for( $i = 0 ; $i < count( $email_array ); $i++ )
		{
			$this->db->where( 'email', $email_array[$i] );
			$query = $this->db->get('users');
			$rows = $query->result_array();

			if( $rows )
			{
				$j = 0;
				for( $i = 0; $i < count( $rows ); $i++ )
				{
					if( !in_array( $rows[$i]['id'], $friend_id_array )) {
						$users[$j]['id'] = $rows[$i]['id'];
						$users[$j]['email'] = $rows[$i]['email'];
						$users[$j]['debug'] = 'Friend List';
						$users[$j]['username'] = $rows[$i]['username'];
						$users[$j]['avatar'] = $rows[$i]['avatar'];
						$j++;
					}
				}
			}
			$j++;
		}
		return $users;
	}

	function addNewFriend( $user, $friend )					//user.rb add_friend(user)
	{
//		$friend_id_array		=	mbsplit( ',', $user['friend_ids']);
		$invited_id_array 		= 	mbsplit( ',', $user['invited_friend_ids'] );
//		if( $user['friend_ids'] == '' )
//			$user['friend_ids']	= $friend['id'];
//		else {
//			array_push($friend_id_array, $friend['id']);
//			$user['friend_ids'] = implode(',', $friend_id_array);
//		}
		if( $user['invited_friend_ids'] == '' )
			$user['invited_friend_ids']	= $friend['id'];
		else {
			array_push($invited_id_array, $friend['id']);
			$user['invited_friend_ids'] = implode(',', $invited_id_array);
		}

		if( $friend['auto_accept_friend'] == 'true' )
		{
			$ret = $this->acceptFriend( $friend, $user );
		}
		else
		{
			$ret = $this->sendInviteFriendNotification($friend, $user);
		}
		$this->updateUserData( $user, $user['id'] );
		if( $ret )
			return $user;
		else
			return null;
	}

	function acceptFriend( $user, $friend )
	{
		$friend_id_array		=	mbsplit( ',', $user['friend_ids']);
//		return "ids : ".$user['friend_ids']." count : ".count( $friend_id_array );
		if( $user['friend_ids'] == '' )
			$user['friend_ids']	= $friend['id'];
		else {
			array_push($friend_id_array, $friend['id']);
			$user['friend_ids'] = implode(',', $friend_id_array);
		}
		$ret = $this->updateUserData( $user, $user['id'] );
		$ret1 = $this->sendAcceptFriendNotification( $friend, $user );

		//friend data update
		$friend_invited_id_array 		=	mbsplit( ',', $friend['invited_friend_ids'] );
		$remove_invited_id_array 		=	array( $user['id'] );
		$friend_invited_id_array 		=	array_diff( $friend_invited_id_array, $remove_invited_id_array );
		$friend['invited_friend_ids']	=	implode( ',', $friend_invited_id_array );

		$friend_friend_id_array			=	mbsplit( ',', $friend['friend_ids'] );
		if( $friend['friend_ids'] == '' )
			$friend['friend_ids']	= $user['id'];
		else {
			array_push( $friend_friend_id_array, $user['id'] );
			$friend['friend_ids'] = implode(',', $friend_friend_id_array);
		}
		$this->updateUserData( $friend, $friend['id'] );

		return $ret1;
	}

	function declineFriend( $user, $friend )
	{
		$ret1 = $this->sendDeclineFriendNotification( $friend, $user );
		return $ret1;
	}

	function ignoreFriend( $user, $friend )
	{
		$ignored_f_id_array		=	mbsplit(',', $user['ignored_friend_ids']);
		if( $user['ignored_friend_ids'] == '' )
			$user['ignored_friend_ids']	= $friend['id'];
		else {
			array_push($ignored_f_id_array, $friend['id']);
			$user['ignored_friend_ids'] = implode(',', $ignored_f_id_array);
		}
		$ret = $this->updateUserData( $user, $user['id'] );
		$ret1 = $this->sendIgnoreFriendNotification( $friend, $user );
		return $ret1;
	}

	function removeIgnoreFriend( $user, $friend )
	{
		$ignored_f_id_array		=	mbsplit(',', $user['ignored_friend_ids']);
		$remove_id_array		=	array( $friend['id'] );
		$ignored_f_id_array		=	array_diff( $ignored_f_id_array, $remove_id_array );
		$user['ignored_friend_ids'] = implode( ',', $ignored_f_id_array);
		$ret = $this->updateUserData( $user, $user['id'] );
		$ret1 = $this->sendRemoveIgnoreFriendNotification( $friend, $user );
		return $ret1;
	}

	function removeFriend( $user, $friend )
	{
		$friend_id_array		=	mbsplit(',', $user['friend_ids']);
		$remove_id_array		=	array( $friend['id'] );
		$friend_id_array		=	array_diff( $friend_id_array, $remove_id_array );
		$user['friend_ids'] = implode( ',', $friend_id_array );

		$ignored_f_id_array		=	mbsplit(',', $user['ignored_friend_ids']);
		$ignored_f_id_array		=	array_diff( $ignored_f_id_array, $remove_id_array );
		$user['ignored_friend_ids'] = implode( ',', $ignored_f_id_array);

		$ret = $this->updateUserData( $user, $user['id'] );
		$ret1 = $this->sendRemoveFriendNotification( $friend, $user );
		return $ret1;
	}

	function favoriteFriend( $user, $friend )
	{
		$favorite['user_id']	=	$user['id'];
		$favorite['friend_id']	=	$friend['id'];
		$favorite['status']		=	1;

		$insert_status			=	$this->db->insert( 'favorites', $favorite );

		return $insert_status;
	}

	function removeFavoriteFriend( $user, $friend )
	{
		if( $user['id'] )	$this->db->where( 'user_id', $user['id'] );
		if( $friend['id'] )	$this->db->where( 'friend_id', $friend['id'] );

		$remove_status 		=	$this->db->delete( 'favorites' );

		return $remove_status;
	}

	function sendInviteFriendNotification( $user, $friend )					//edit notification
	{
		$msg = $friend['username']." wants to add you in his friends";
		$notification['user_id']	=	$user['id'];
		$notification['message']	=	$friend['username']." wants to add you in his friends";
		$notification['data']		=	$friend['id'];
		$notification['type']		=	NOTIFICATION_TYPE0;
		$notification['status']		=	NOTIFICATION_INVITE_IN_FRIEND;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );
		$inserted_id = $this->db->insert( 'notifications', $notification );
		$count = $this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $friend );		//push notification
		return $inserted_id;
	}

	function sendAcceptFriendNotification( $user, $friend )					//edit notification
	{
		$this->load->library( 'user_mailer' );

		$invited_id_array		=	mbsplit( ',', $user['invited_friend_ids']);
		$remove_id_array		=	array( $friend['id'] );
		$invited_id_array		=	array_diff( $invited_id_array, $remove_id_array );
		$user['invited_friend_ids'] = implode( ',', $invited_id_array);
		$ret = $this->updateUserData( $user, $user['id'] );

		if( $friend['auto_accept_friend'] == 'true' )
		{
			$msg = $friend['username']." accepted your invitation to friends automatically";
		}
		else
		{
			$msg = $friend['username']." accepted your invitation to friend";
		}

		$notification['user_id']	=	$user['id'];
		$notification['message']	=	$msg;
		$notification['data']		=	$friend['id'];
		$notification['type']		=	NOTIFICATION_TYPE2;
		$notification['status']		=	NOTIFICATION_ACCEPT_FRIEND;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );

		$status = $this->user_mailer->sendAcceptFriendMail( $user, $friend );

		$inserted_id = $this->db->insert( 'notifications', $notification );
		$count =  $this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $friend );		//push notification

		return $inserted_id;
	}

	function sendDeclineFriendNotification( $user, $friend )					//edit notification
	{
		$friend_id_array		=	mbsplit(',', $user['friend_ids']);
		$remove_f_id_array		=	array( $friend['id'] );
		$friend_id_array		=	array_diff( $friend_id_array, $remove_f_id_array );
		$user['friend_ids']		=	implode(',', $friend_id_array );

		$invited_id_array		=	mbsplit( ',', $user['invited_friend_ids']);
		$remove_i_id_array		=	array( $friend['id'] );
		$invited_id_array		=	array_diff( $invited_id_array, $remove_i_id_array );
		$user['invited_friend_ids'] = implode( ',', $invited_id_array);
		$ret = $this->updateUserData( $user, $user['id'] );

		$msg = $friend['username']." declined your invitation to friends";

		$notification['user_id']	=	$user['id'];
		$notification['message']	=	$msg;
		$notification['data']		=	$friend['id'];
		$notification['type']		=	NOTIFICATION_TYPE1;
		$notification['status']		=	NOTIFICATION_DECLINED_FRIEND;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );

		$inserted_id = $this->db->insert( 'notifications', $notification );
		$count =  $this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $friend );		//push notification

		return $inserted_id;
	}

	function sendIgnoreFriendNotification( $user, $friend )
	{
	}

	function sendRemoveIgnoreFriendNotification( $user, $friend )
	{
	}

	function sendRemoveFriendNotification( $user, $friend )
	{
		$friend_id_array		=	mbsplit(',', $user['friend_ids']);
		$remove_f_id_array		=	array( $friend['id'] );
		$friend_id_array		=	array_diff( $friend_id_array, $remove_f_id_array );
		$user['friend_ids']		=	implode(',', $friend_id_array );

		$ignored_f_id_array		=	mbsplit(',', $user['ignored_friend_ids']);
		$ignored_f_id_array		=	array_diff( $ignored_f_id_array, $remove_f_id_array );
		$user['ignored_friend_ids'] = implode( ',', $ignored_f_id_array);
		$ret = $this->updateUserData( $user, $user['id'] );

		$msg = $friend['username']." removed you from friends";

		$notification['user_id']	=	$user['id'];
		$notification['message']	=	$msg;
		$notification['data']		=	$friend['id'];
		$notification['type']		=	NOTIFICATION_TYPE4;
		$notification['status']		=	NOTIFICATION_REMOVED_FRIEND;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );

		$inserted_id = $this->db->insert( 'notifications', $notification );
		$count =  $this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $friend );		//push notification

		return $inserted_id;
	}

	function sendMediaSharedFriendNotification( $user, $share_user, $media, $type )
	{
		$username 		=	$this->mediaUserName( $media );
		$media_type		=	$media['type'] == '1' ? "photo" : "video";
		if( $this->isFriend( $user, $share_user ) )
			$msg = $share_user['username']." shared ".$media_type;
		else
			$msg = $share_user['username']." shared ".$username."'s ".$media_type.". \n Will you add ".$username." in your friend's list?";
		$notification['user_id']			=	$user['id'];
		$notification['message']			=	$msg;
		$notification['data']				=	$share_user['id'];
		$notification['media_id']			=	$media['id'];
		$notification['media_user_id']		=	$media['user_id'];
		$notification['media_user_name']	=	$username;
		$notification['type']				=	NOTIFICATION_TYPE5;
		$notification['status']				=	$type;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );

		$insert_status	=	$this->db->insert( 'notifications', $notification );
		$count			=	$this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $share_user );		//push notification
		return $insert_status;
	}

	function sendNotificationCommentYourMedia( $user, $comment_user, $media, $comment_type )
	{
		if( $comment_type == '1')
			$msg = $comment_user['username']." added new comment";
		else
			$msg = $comment_user['username']." added new audio comment";
		$status = $media['media_type'] == '1' ? NOTIFICATION_FRIEND_COMMENTED_YOUR_PHOTO : NOTIFICATION_FRIEND_COMMENTED_YOUR_VIDEO;

		$notification['user_id']			=	$user['id'];
		$notification['data']				=	$comment_user['id'];
		$notification['media_id']			=	$media['id'];
		$notification['message']			=	$msg;
		$notification['media_user_id']		=	$media['user_id'];
		$notification['media_user_name']	=	$this->mediaUserName( $media );
		$notification['type']				=	NOTIFICATION_TYPE6;
		$notification['status']				=	$status;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );

		$insert_status = $this->db->insert( 'notifications', $notification );
		$count			=	$this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $comment_user );		//push notification
	}

	function sendNotificationLikeYourMedia( $user, $liked_user, $media )
	{
		$msg = $liked_user['username']." liked media";
		$status = $media['type'] == '1' ? NOTIFICATION_FRIEND_LIKE_YOUR_PHOTO : NOTIFICATION_FRIEND_LIKE_YOUR_VIDEO;

		$notification['user_id']		=	$user['id'];
		$notification['data']			=	$liked_user['id'];
		$notification['media_id']		=	$media['id'];
		$notification['message']		=	$msg;
		$notification['media_user_id']		=	$media['user_id'];
		$notification['media_user_name']	=	$this->mediaUserName( $media );
		$notification['type']			=	$media['type'] == '1' ? NOTIFICATION_TYPE7 : NOTIFICATION_TYPE8;
		$notification['status']			=	$status;
		$notification['created_at']			=	date( 'Y-m-d H:i:s' );

		$insert_status = $this->db->insert( 'notifications', $notification );
		$count			=	$this->unreadNotificationsCount( $user['id'] );
		$this->sendPush( $user, $msg, $count, $liked_user );		//push notification
	}

	function unreadNotificationsCount( $user_id )
	{
		$this->db->where( 'user_id', $user_id );
		$this->db->where( 'is_read', '0' );
		$query = $this->db->get( 'notifications' );
		$rows = $query->result_array();
		if( $rows )
			return count( $rows );
		else
			return 0;
	}

	function getAvatarStatus( $user_id )
	{
		if ( $user_id ) $this->db->where('user_id', $user_id );
		$query = $this->db->get( 'avatar_status' );
		$row = $query->result_array();
		if( $row )
			return $row[0]['status'];
		else
			return 0;
	}

	function isFavorite( $user_id, $friend_id )
	{
		if ( $user_id ) $this->db->where('user_id', $user_id );
		if ( $user_id ) $this->db->where('friend_id', $friend_id );
		$query = $this->db->get( 'favorites' );
		$row = $query->result_array();
		if( $row )
			return $row[0]['status'];
		else
			return 0;
	}

	function isFriend( $user, $friend )
	{
		$friend_id_arrays = mbsplit( ',', $user['friend_ids'] );
		if( in_array( $friend['id'], $friend_id_arrays ) )
			return true;
		else
			return false;
	}

	function isInvited( $user, $friend )
	{
		$invited_id_arrays = mbsplit( ',', $user['invited_friend_ids'] );
		if( in_array( $friend['id'], $invited_id_arrays ) )
			return true;
		else
			return false;
	}

	function userDetail( $user, $friend )							//friend_api_detail
	{
		$data['id']					=	$user['id'];
		$data['username']			=	$user['username'];
		$data['avatar']				=	$user['avatar'];
		$data['email']				=	$user['email'];
		$data['code']				=	USER_REGISTERED;
		$data['debug']				=	'User registered in system';
		$friend_block_array			=	mbsplit(',', $user['ignored_friend_ids']);
		if( in_array( $friend['id'], $friend_block_array ) )
			$data['friend_status']	=	FRIEND_IGNORE;
		else
			$data['friend_status']	=	FRIEND_DISABLE_FRIEND;
		$data['time_zone']			=	$user['time_zone'];

		return $data;
	}

	function mediaUserName( $media )
	{
		$user = $this->getUserInfoById( $media['user_id'] );

		if( $user )
			return $user['username'];
		else
			return null;
	}

	function userTime( $user )
	{
		date_default_timezone_set( 'Europe/London' );
		$user_time =   date( 'Y-m-d H:i:s', time() + $user['time_zone'] * 60 * 60 );
//		$user_time = date( 'Y-m-d h:i:s', time() );
		return $user_time;
	}

	function getDateTimeByUser( $date, $user )
	{
		date_default_timezone_set( 'Europe/London' );
	}

	function setResetPasswordToken( $user )
	{
		$token = $this->bGetToken( $user['id'] );
		$user['reset_password_token']		=	$token;
		$user['reset_password_sent_at']		=	date( 'Y-m-d H:i:s' );
		$this->db->where( 'id', $user['id'] );
		$this->db->update( 'users', $user );

		return $user;
	}

	function sendPush( $user, $message, $badge_count, $friend )
	{
		$this->load->library( 'apn' );

		$this->db->where( 'user_id', $user['id'] );
		$query = $this->db->get( 'devices' );
		$rows = $query->result_array();
		if( count( $rows ) > 0 )
		{
			$row = $rows[0];
			if( $row['platform'] == "ios" ) {
				$deviceToken = $row['dev_id'];
				$sound = '';
				$this->apn->sendMessage( $deviceToken, $message, $badge_count,  $sound, $expiry = '', false );
			}
		}
		else
			return FALSE;
	}

	function _output_json( $data )						//edit tiger	12.29
	{
		header('Access-Control-Allow-Origin: *');
		header('Content-Type: application/json');
		echo json_encode( $data );
	}

}