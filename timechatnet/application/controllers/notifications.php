<?php

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Created by IntelliJ IDEA.
 * User: Administrator
 * Date: 1/2/2015
 * Time: 9:54 AM
 */

class Notifications  extends CI_Controller {

    /******************************** GET API Function	*****************************/

    function test()
    {
        $datev = "2014-12-23 11:21:26";
        $user_timezone = 8;
        $date = date( 'Y-m-d H:i:s',strtotime( $datev ) + $user_timezone * 60 * 60 );

        $row = null;
        $date = count( $row );


        $this->load->library( 'user_mailer' );
        $user['email']  =   "aaaa@aaaa.com";

        $this->user_mailer->sendWelcomeMail( $user );

        $this->_output_json( BASEPATH );
    }

    /**
     *API Function name		:	index
     * type					:	get
     * path					:	notifications/$get parameter
     * parameters			:	token
     * Created Date			:	2015-1-3
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function index()
    {
        $gets = $this->input->get();

        $token         =    $gets['token'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_notifications' );
        $this->load->model( 'tbl_medias' );

        $user = $this->tbl_users->getUserinfoByFilter( "", "", "", $token );

        if( $user == null )
        {
            $json 	=	[
                "data"		=>	"",
                "message"	=>	[
                    "type"		=>	'error',
                    "value"		=>	'Cannot find this user.',
                    "code"		=>	ERROR_LOGIN
                ]
            ];
        }
        else
        {
            $this->tbl_notifications->setNotificationStatusToReadByUser( $user );
            $notifications = $this->tbl_notifications->getNotificationInfoByFilter( $user );
            if( $notifications != null )
            {
                for( $i = 0; $i < count( $notifications ); $i++ ) {
                    $friend     =   $this->tbl_users->getUserinfoByFilter(  $notifications[$i]['data'], "", "", "" );
                    if( $friend == null )
                    {
                        $json 	=	[
                            "data"		=>	"",
                            "message"	=>	[
                                "type"		=>	'error',
                                "value"		=>	'Cannot find this friend.',
                                "code"		=>  ERROR_FRIEND_NOT_FOUND
                            ]
                        ];
                        $this->_output_json( $json ); exit;
                    }
//                    $this->_output_json( "********".$i . " : " . $notifications[$i]['media_id'] . "----" );
                    if( $notifications[$i]['condition1'] == NOTIFICATION_TYPE5 ||
                        $notifications[$i]['condition1'] == NOTIFICATION_TYPE6 ||
                        $notifications[$i]['condition1'] == NOTIFICATION_TYPE7 ) {
                        $medias = $this->tbl_medias->getMediaInfoByUser($notifications[$i]['media_id'], "", "", "");
                        if ($medias == null) {
                            $json = [
                                "data" => [],
                                "message" => [
                                    "type" => 'error',
                                    "value" => 'Cannot find this media.',
                                    "code" => MEDIA_NOT_FOUND
                                ]
                            ];
                            $this->_output_json($json);
                            exit;
                        }
                        $media = $medias[0];
                    }
//                    $this->_output_json( $media );
                    $local_time     =   $notifications[$i]['date'];
                    $user_timezone  =   $user['time_zone'];
                    $created_at     =   date( 'Y-m-d H:i:s', strtotime($local_time) + $user_timezone * 60 * 60 );     //reference datetime

                    $notifications[$i]['date']                  =   $created_at;
                    $notifications[$i]['friend_avatar']         =   $friend['avatar'];

                    $notifications[$i]['friend_time']           =   $this->tbl_users->userTime( $friend );
                    $notifications[$i]['friend_name']           =   $friend['username'];
                    $notifications[$i]['friend_email']          =   $friend['email'];
                    $notifications[$i]['status_info']           =   'Send notification';
                    $notifications[$i]['friend_id']             =   $friend['id'];
                    $notifications[$i]['user_time']             =   $this->tbl_users->userTime( $user );

                    if( $notifications[$i]['condition1'] == NOTIFICATION_TYPE5 ||
                        $notifications[$i]['condition1'] == NOTIFICATION_TYPE6 ||
                        $notifications[$i]['condition1'] == NOTIFICATION_TYPE7 ) {
                        $media_created = $media['created_at'];
                        $media_created_at = date('Y-m-d H:i:s', strtotime($media_created) + $user_timezone * 60 * 60);     //reference datetime
                        $notifications[$i]['media_created_time'] = $media_created_at;
                    }
                }
                $json   =   [
                    "data"      =>  $notifications,
                    "message"   =>  [
                        "type"      =>  'success',
                        "value"     =>  'notifications',
                        "code"      =>  SUCCESS_QUERY
                    ]
                ];
            }
            else
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'success',
                        "value"		=>	'No notification.',
                        "code"		=>  SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json($json);
    }

    /**
     *API Function name		:	notification_count
     * type					:	get
     * path					:	notifications/notification_count
     * parameters			:	token
     * Created Date			:	2015-1-3
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function notification_count()
    {
        $gets = $this->input->get();

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
                    "code"		=>	ERROR_LOGIN
                ]
            ];
        }
        else
        {
            $count = $this->tbl_users->unreadNotificationsCount( $user['id'] );
            $json 	=	[
                "data"		=>	[
                    "count"     =>  $count
                ],
                "message"	=>	[
                    "type"		=>	'success',
                    "value"		=>	'notifications',
                    "code"		=>  SUCCESS_QUERY
                ]
            ];
        }
        $this->_output_json($json);
    }


    /******************************** POST API Function	*****************************/

    /**
     *API Function name		:	delete
     * type					:	post
     * path					:	notifications/delete
     * parameters			:	token(user), notification_id
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function delete()
    {
        $posts = $this->input->post();

        $token = $posts['token'];
        $notification_id = $posts['notification_id'];

        $this->load->model('tbl_users');
        $this->load->model('tbl_notifications');

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
        }
        else
        {
            $status = $this->tbl_notifications->deleteNotificationByFilter( "", $notification_id );
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'success',
                    "value"		=>	'deleted notifications',
                    "code"		=>  SUCCESS_QUERY
                ]
            ];
        }
        $this->_output_json($json);
    }


    /**
     *API Function name		:	had_read_notification
     * type					:	post
     * path					:	notifications/had_read_notification
     * parameters			:	token(user)
     * Created Date			:	2015-1-3
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function had_read_notification()
    {
        $posts = $this->input->post();

        $token = $posts['token'];

        $this->load->model('tbl_users');
        $this->load->model('tbl_notifications');

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
        }
        else
        {
            $status = $this->tbl_notifications->setNotificationStatusToReadByUser( $user );
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'success',
                    "value"		=>	'read notifications',
                    "code"		=>  SUCCESS_QUERY
                ]
            ];
        }
        $this->_output_json($json);
    }

    /**
     *API Function name		:	remove_all
     * type					:	post
     * path					:	notifications/remove_all
     * parameters			:	token(user)
     * Created Date			:	2015-1-3
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function remove_all()
    {
        $posts = $this->input->post();

        $token = $posts['token'];

        $this->load->model('tbl_users');
        $this->load->model('tbl_notifications');

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
        }
        else
        {
            $status = $this->tbl_notifications->deleteNotificationByFilter( $user, "" );
            $json 	=	[
                "data"		=>	[],
                "message"	=>	[
                    "type"		=>	'success',
                    "value"		=>	'removed all notifications successfully',
                    "code"		=>  SUCCESS_QUERY
                ]
            ];
        }
        $this->_output_json($json);
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