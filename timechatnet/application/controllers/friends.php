<?php

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Created by IntelliJ IDEA.
 * User: tiger
 * Date: 12/31/2014
 * Time: 1:38 AM
 */

class Friends  extends CI_Controller {

    /******************************** GET API Function	*****************************/

    /**
     *API Function name		:	index
     * type					:	get
     * path					:	friends/$get parameter
     * parameters			:	friend_id, token
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function index()
    {
        $gets = $this->input->get();

        if( isset( $gets['friend_id'] ) )
            $friend_id     =    $gets['friend_id'] ;
        $token         =    $gets['token'];

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	'0'
                ]
            ];
        }
        else
        {
            if( isset( $friend_id ) )
            {
                $friend_info = $this->tbl_users->getFriendsInfo( $user['id'], $friend_id );
                $json           =   [
                    "data"          =>  $friend_info,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'Success query',
                        "code"          =>  '7'
                    ]
                ];
            }
            else
            {
                $friends_info   =   $this->tbl_users->getFriendsInfo( $user['id'], "" );
                $json           =   [
                    "data"          =>  $friends_info == null ? [] : $friends_info,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'Success query',
                        "code"          =>  '7'
                    ]
                ];
            }
        }
        $this->_output_json($json);
    }

    /**
     *API Function name		:	facebook_users
     * type					:	get
     * path					:	friends/facebook_users
     * parameters			:	token
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function facebook_users()
    {
        $gets = $this->input->get();
        $token         =    $gets['token'];
        $this->_output_json( $this->_get_users_by_social_type( "facebook", $token ) );

    }

    /**
     *API Function name		:	google_users
     * type					:	get
     * path					:	friends/google_users
     * parameters			:	token
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function google_users()
    {
        $gets = $this->input->get();
        $token         =    $gets['token'];
        $this->_output_json( $this->_get_users_by_social_type( "google", $token ) );
    }

    /**
     *API Function name		:	phonebook_users
     * type					:	get
     * path					:	friends/phonebook_users
     * parameters			:	token, emails
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function phonebook_users()                              //require edit
    {
        $gets          =    $this->input->get();
        $token         =    $gets['token'];
        $email_array   =    mbsplit(',', $gets['emails'] );

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
        $friend_id_array = mbsplit( ',', $user['friend_ids'], -1 );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	'0'
                ]
            ];
        }
        else
        {
            $pb_users = $this->tbl_users->getPhoneBookUsers( $email_array, $friend_id_array );

            if( $fb_users == null )
            {
                $json           =   [
                    "data"          =>  '',
                    "message"       =>  [
                        "type"          =>  'error',
                        "value"         =>  'Cannot find this users',
                        "code"          =>  '0'
                    ]
                ];
            }
            else
            {
                $json           =   [
                    "data"          =>  $fb_users,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'Success query',
                        "code"          =>  '7'
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	search_friends
     * type					:	get
     * path					:	friends/search_friends
     * parameters			:	token
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function search_friends()                                  //require edit
    {
        $gets          =    $this->input->get();
        $token         =    $gets['token'];
        $email_array   =    mbsplit(',', $gets['emails'] );

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
        $friend_id_array = mbsplit( ',', $user['friend_ids'], -1 );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	'0'
                ]
            ];
        }
        else
        {
            $pb_users = $this->tbl_users->getPhoneBookUsers( $email_array, $friend_id_array );

            if( $fb_users == null )
            {
                $json           =   [
                    "data"          =>  '',
                    "message"       =>  [
                        "type"          =>  'error',
                        "value"         =>  'Cannot find this users',
                        "code"          =>  '0'
                    ]
                ];
            }
            else
            {
                $json           =   [
                    "data"          =>  $fb_users,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'Success query',
                        "code"          =>  '7'
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }


    /******************************** POST API Function	*****************************/

    /**
     *API Function name		:	add_friend
     * type					:	post
     * path					:	friends/add_friend
     * parameters			:	token(user), email(friend)
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function add_friend()
    {
        $posts          =   $this->input->post();
        $token          =   $posts['token'];
        $email          =   $posts['email'];

        $this->load->model( 'tbl_users' );
        $this->load->library( 'user_mailer' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( "", "", $email, "" );
            if( $friend == null )
            {
                $status = $this->user_mailer->sendContactUserMail( $email, $user );

                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Sent invite email to '.$email,
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                if( $user['id'] == $friend['id'] )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	$email.' is your email',
                            "code"		=>	USER_UNREGISTERED
                        ]
                    ];
                elseif( $this->tbl_users->isFriend( $user, $friend ) )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	$email.' is your friend now',
                            "code"		=>	USER_UNREGISTERED
                        ]
                    ];
                elseif(  $this->tbl_users->isInvited( $user, $friend )  )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	$email.' is already invited',
                            "code"		=>	USER_UNREGISTERED
                        ]
                    ];
                else
                {

                    $ret_user = $this->tbl_users->addNewFriend( $user, $friend );
//                    $this->_output_json( "here" ); exit;
                    if( $ret_user == null )
                        $json 	=	[
                            "data"		=>	[],
                            "message"	=>	[
                                "type"		=>	'error',
                                "value"		=>	'Add friend failed',
                                "code"		=>	ERROR_QUERY
                            ]
                        ];
                    else {
                        $status = $this->user_mailer->sendInviteFriendMail( $friend, $user );
                        $data = $this->tbl_users->userDetail( $friend, $user );
                        $json = [
                            "data"      => $data,
                            "message"   => [
                                "type"      => 'success',
                                "value"     => 'Added new friend',
                                "code"      => SUCCESS_QUERY
                            ]
                        ];
                    }
                }
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	add_friend_by_username
     * type					:	post
     * path					:	friends/add_friends_by_username
     * parameters			:	token(user), username(friend)
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function add_friend_by_username()
    {
        $posts          =   $this->input->post();
        $token          =   $posts['token'];
        $username       =   $posts['username'];

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( "", $username, "", "" );
            if( $friend == null )
            {
//                mail send
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	$username." doesn't exist" ,
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                if( $user['id'] == $friend['id'] )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	$username.' is your name',
                            "code"		=>	USER_UNREGISTERED
                        ]
                    ];
                elseif( $this->tbl_users->isFriend( $user, $friend ) )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	$username.' is your friend now',
                            "code"		=>	USER_UNREGISTERED
                        ]
                    ];
                elseif( $this->tbl_users->isInvited( $user, $friend ) )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	$username.' is already invited',
                            "code"		=>	USER_UNREGISTERED
                        ]
                    ];
                else
                {
                    $ret_user = $this->tbl_users->addNewFriend( $user, $friend );
                    if( $ret_user == null )
                        $json 	=	[
                            "data"		=>	[],
                            "message"	=>	[
                                "type"		=>	'error',
                                "value"		=>	'Add friend failed',
                                "code"		=>	ERROR_QUERY
                            ]
                        ];
                    else {
//                        mail send
                        $data = $this->tbl_users->userDetail( $friend, $user );
                        $json = [
                            "data"      => $data,
                            "message"   => [
                                "type"      => 'success',
                                "value"     => 'Added new friend',
                                "code"      => SUCCESS_QUERY
                            ]
                        ];
                    }
                }
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	add_friends
     * type					:	post
     * path					:	friends/add_friends
     * parameters			:	token(user), user ids(friend)
     * Created Date			:	2015-1-1
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function add_friends()
    {
        $posts              =   $this->input->post();
        $token              =   $posts['token'];
        $friend_ids         =   $posts['user_ids'];
        $friend_id_array   =   mbsplit( ',', $friend_ids );

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $j = 0;
            for( $i = 0; $i < count( $friend_id_array ); $i++ )
            {
                $tmp_friend = $this->tbl_users->getUserinfoByFilter( $friend_id_array[$i], "", "", "" );
                if( $tmp_friend != null ) {
                    $friends[$j] = $tmp_friend;
                    $j++;
                }
            }

            if( count( $friends ) > 0 )
            {
                $added_friends_count = 0;
                for( $i = 0; $i < count( $friends ); $i++ )
                {
                    if( $this->tbl_users->isFriend( $user, $friends[$i] ) == false && $user['id'] != $friends[$i]['id'] )
                    {
                        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
                        $ret = $this->tbl_users->addNewFriend( $user, $friends[$i] );
                        if( $ret )
                            $added_friends_count++;
                    }
                }

                if( $added_friends_count > 1 )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'Added new '.$added_friends_count.' friends',
                            "code"		=>	SUCCESS_QUERY
                        ]
                    ];
                else if( $added_friends_count == 1)
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'Added a new friend',
                            "code"		=>	SUCCESS_QUERY
                        ]
                    ];
                else
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'failed',
                            "value"		=>	'Cannot add friends',
                            "code"		=>	ERROR_QUERY
                        ]
                    ];
            }
            else
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find friends.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	add_friends_by_phone_book
     * type					:	post
     * path					:	friends/add_friends_by_phone_book
     * parameters			:	token(user), emails(friend)
     * Created Date			:	2015-1-1
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function add_friends_by_phone_book()                        //require edit  mail send
    {
        $posts              =   $this->input->post();
        $token              =   $posts['token'];
        $emails             =   $posts['emails'];
        $email_array        =   mbsplit( ',', $emails );

        $this->load->model( 'tbl_users' );
        $this->load->library( 'user_mailer' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $j = 0;
            $friends = array();
            for( $i = 0; $i < count( $email_array ); $i++ )
            {
                $tmp_friend = $this->tbl_users->getUserinfoByFilter( "", "", $email_array[$i], "" );
                if( $tmp_friend != null ) {
                    $friends[$j] = $tmp_friend;
                    $j++;
                }
                else
                {
                    $status = $this->user_mailer->sendContactUserMail( $email_array[$i], $user );
                }
            }


            if( count( $friends ) > 0 )
            {
                $this->_output_json( "here"); exit;
                $added_friends_count = 0;
                for( $i = 0; $i < count( $friends ); $i++ )
                {
                    if( $this->tbl_users->isFriend( $user, $friends[$i] ) == false && $user['id'] != $friends[$i]['id'] )
                    {
                        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
                        $ret = $this->tbl_users->addNewFriend( $user, $friends[$i] );
                        if( $ret )
                            $added_friends_count++;
                    }
                }

                if( count( $email_array ) > 1 )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'Invited new friends.',
                            "code"		=>	SUCCESS_QUERY
                        ]
                    ];
                else
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'Invited a new friend',
                            "code"		=>	SUCCESS_QUERY
                        ]
                    ];
            }
            else
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'success',
                        "value"		=>	'Invited new friends.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	accept_friend
     * type					:	post
     * path					:	friends/accept_friend
     * parameters			:	token(user), friend_id(friend), notification_id
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function accept_friend()
    {
        $posts              =   $this->input->post();
        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];
        $notification_id    =   $posts['notification_id'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_notifications' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
//                mail send
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                $this->tbl_users->acceptFriend( $user, $friend );

                $notification = $this->tbl_notifications->getNotificationInfoById( $notification_id );

                $reti = $this->tbl_notifications->setNotificationStatusToRead( $notification );
                $data = $this->tbl_users->userDetail( $friend, $user );
                $json = [
                    "data"      => $data,
                    "message"   => [
                        "type"      => 'success',
                        "value"     => 'accept new friend',
                        "code"      => SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
 *API Function name		:	decline_friend
 * type					:	post
 * path					:	friends/decline_friend
 * parameters			:	token(user), friend_id(friend), notification_id
 * Created Date			:	2014-12-31
 * Creator				:	tiger
 * Update Date			:
 * Updater				:
 */

    function decline_friend()
    {
        $posts              =   $this->input->post();

        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];
        $notification_id    =   $posts['notification_id'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_notifications' );
        $this->load->library( 'user_mailer' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
//                mail send
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                $this->tbl_users->declineFriend( $user, $friend );
                $status = $this->user_mailer->sendDeclineFriendMail( $friend, $user );
                $notification = $this->tbl_notifications->getNotificationInfoById( $notification_id );
                $reti = $this->tbl_notifications->setNotificationStatusToRead( $notification );
                $data = $this->tbl_users->userDetail( $friend, $user );
                $json = [
                    "data"      => $data,
                    "message"   => [
                        "type"      => 'success',
                        "value"     => 'decline friend',
                        "code"      => SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	ignore_friend
     * type					:	post
     * path					:	friends/ignore_friend
     * parameters			:	token(user), friend_id(friend)
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function ignore_friend()                                    //require requirement
    {
        $posts              =   $this->input->post();

        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                $this->tbl_users->ignoreFriend( $user, $friend );
//                $notification = $this->tbl_notifications->getNotificationInfoByFilter( $notification_id );
//                $reti = $this->tbl_notifications->setNotificationStatusToRead( $notification );
                $data = $this->tbl_users->userDetail( $friend, $user );
                $json = [
                    "data"      => $data,
                    "message"   => [
                        "type"      => 'success',
                        "value"     => 'ignore friend',
                        "code"      => SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	remove_ignore_friend
     * type					:	post
     * path					:	friends/remove_ignore_friend
     * parameters			:	token(user), friend_id(friend)
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function remove_ignore_friend()                             //require requirement
    {
        $posts              =   $this->input->post();

        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                $this->tbl_users->removeIgnoreFriend( $user, $friend );
//                $notification = $this->tbl_notifications->getNotificationInfoByFilter( $notification_id );
//                $reti = $this->tbl_notifications->setNotificationStatusToRead( $notification );
                $data = $this->tbl_users->userDetail( $friend, $user );
                $json = [
                    "data"      => $data,
                    "message"   => [
                        "type"      => 'success',
                        "value"     => 'remove ignore friend',
                        "code"      => SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	remove_friend
     * type					:	post
     * path					:	friends/remove_friend
     * parameters			:	token(user), friend_id(friend)
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function remove_friend()
    {
        $posts              =   $this->input->post();

        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];

        $this->load->model( 'tbl_users' );
        $this->load->library( 'user_mailer' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                $this->tbl_users->removeFriend( $user, $friend );
                $status = $this->user_mailer->sendRemoveFriendMail( $friend, $user );
                $data = $this->tbl_users->userDetail( $friend, $user );
                $json = [
                    "data"      => $data,
                    "message"   => [
                        "type"      => 'success',
                        "value"     => 'remove friend',
                        "code"      => SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	favorite_friend
     * type					:	post
     * path					:	friends/favorite_friend
     * parameters			:	token(user), friend_id(friend)
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function favorite_friend()
    {
        $posts              =   $this->input->post();

        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                $status = $this->tbl_users->favoriteFriend( $user, $friend );
                if( $status )
                    $json = [
                        "data"      => '',
                        "message"   => [
                            "type"      => 'success',
                            "value"     => 'Added favorite friend',
                            "code"      => SUCCESS_QUERY
                        ]
                    ];
                else
                    $json = [
                        "data"      => '',
                        "message"   => [
                            "type"      => 'error',
                            "value"     => 'Favorite friend failed',
                            "code"      => '0'
                        ]
                    ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	remove_favorite_friend
     * type					:	post
     * path					:	friends/remove_favorite_friend
     * parameters			:	token(user), friend_id(friend)
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function remove_favorite_friend()
    {
        $posts              =   $this->input->post();

        $token              =   $posts['token'];
        $friend_id          =   $posts['friend_id'];

        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	USER_UNREGISTERED
                ]
            ];
        }
        else
        {
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
            }
            else
            {
                if( $this->tbl_users->isFavorite( $user['id'], $friend['id'] ) ) {
                    $status = $this->tbl_users->removeFavoriteFriend( $user, $friend );
                    if ($status)
                        $json = [
                            "data" => '',
                            "message" => [
                                "type" => 'success',
                                "value" => 'Removed favorite friend',
                                "code" => SUCCESS_QUERY
                            ]
                        ];
                    else
                        $json = [
                            "data" => '',
                            "message" => [
                                "type" => 'error',
                                "value" => 'Remove favorite friend failed',
                                "code" => '0'
                            ]
                        ];
                }
            }
        }
        $this->_output_json( $json );
    }

    /******************************** Private Function	*****************************/

    function _get_users_by_social_type( $social_type, $token )
    {
        $this->load->model( 'tbl_users' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );
        $friend_id_array = mbsplit( ',', $user['friend_ids'], -1 );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	'0'
                ]
            ];
        }
        else
        {
            $fb_users = $this->tbl_users->getUsersBySocialType( $social_type, $friend_id_array, false );

            if( $fb_users == null )
            {
                $json           =   [
                    "data"          =>  '',
                    "message"       =>  [
                        "type"          =>  'error',
                        "value"         =>  'Cannot find this users',
                        "code"          =>  '0'
                    ]
                ];
            }
            else
            {
                $json           =   [
                    "data"          =>  $fb_users,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'Success query',
                        "code"          =>  '7'
                    ]
                ];
            }
        }
        return $json;
    }
    /**
     * Private Function Name		:	_output_json
     * @param $data					:	data to be written
     * Created Date					:	2014-12-31
     * Creator						:	tiger
     * Update Date
     * Updater
     */
    function _output_json( $data )						//edit tiger	12.31
    {
        header('Access-Control-Allow-Origin: *');
        header('Content-Type: application/json');
        echo json_encode( $data );
    }
}

//$.post( "http://192.168.0.208/timechatnet/index.php/friends/add_friends",{token:"tigertiger", user_ids:"4,5,6"}, function(data) {	console.log(data);})