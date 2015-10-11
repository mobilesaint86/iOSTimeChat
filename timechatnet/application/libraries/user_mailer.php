<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');


//edit tiger	user_mailer.rb
class User_mailer {

	var $from = 'support@timechat.com.au';
	public $CI;

	/**
	 *	User_mailer constructor
	 */
	public function __construct()
	{
		$this->CI = &get_instance();
		$this->CI->load->library('email');
//		$config['protocol'] = 'sendmail';
		$config['mailpath'] = '/usr/sbin/sendmail';
		$config['mailtype'] = 'html';
		$config['priority'] = 1;
		$config['wordwrap'] = TRUE;

		$this->CI->email->initialize( $config );
	}

	function sendWelcomeMail( $user )
	{
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to($user['email']);
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject('Welcome');
		$this->CI->email->message('Welcome sign up TimeChatNet.');

		if( $this->CI->email->send() )
			return TRUE;
//			echo 'Your email was sent, successfully.';
		else
//			return FALSE;
			echo $this->CI->email->print_debugger();
	}

	/**
	 * @param $user
	 * @return bool
	 */
	public function sendForgotPasswordMail( $user, $new_password )
	{
		$msg = "<p> Everyone maybe forget self password. </p>";
		$msg.= "<p> Timechatnet changed your password to <font color='blue'>" . $new_password."</font>.</p>";
		$msg.= "<p>You signin with thist password again.</p>";
		$msg.= "<p>Ragards.</p>";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $user['email'] );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Forgot Password' );
		$this->CI->email->message( $msg );

		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}

	function sendContactUserMail( $email, $friend )
	{
		$msg = $friend['username'] . " sent contact add request to you.";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $email );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Contact Add' );
		$this->CI->email->message( $msg );
		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}

	function sendInviteFriendMail( $user, $friend )
	{
		$msg = $friend['username'] . " wants to add you in his friends.";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $user['email'] );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Invite Friend' );
		$this->CI->email->message( $msg );
		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}

	function sendAcceptFriendMail( $user, $friend )
	{
		if( $friend['auto_accept_friend'] == 'true' )
			$msg = $friend['username']." accepted your invitation to friends automatically";
		else
			$msg = $friend['username']." accepted your invitation to friend";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $user['email'] );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Accepted Friend' );
		$this->CI->email->message( $msg );
		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}

	function sendDeclineFriendMail( $user, $friend )
	{
		$msg = $friend['username'] . " declined your invitation to friends";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $user['email'] );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Declined Friend' );
		$this->CI->email->message( $msg );
		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}

	function sendIgnoreFriendMail( $user, $friend )
	{
		$msg = $friend['username'] . " ignored your invitation to friends";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $user['email'] );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Ignored Friend' );
		$this->CI->email->message( $msg );
		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}

	function sendRemoveFriendMail( $user, $friend )
	{
		$msg = $friend['username'] . " removed you from friends";
		$this->CI->email->from( $this->from, 'TimeChatNet' );
		$this->CI->email->to( $user['email'] );
//		$this->CI->email->to('malek841013@hotmail.com');
		$this->CI->email->subject( 'Removed Friend' );
		$this->CI->email->message( $msg );
		if( $this->CI->email->send() )
			return TRUE;
		else
			return FALSE;
	}
}