<?php

if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Created by IntelliJ IDEA.
 * User: Administrator
 * Date: 1/2/2015
 * Time: 9:54 AM
 */

class Medias  extends CI_Controller {

    /******************************** GET API Function	*****************************/

    /**
     *API Function name		:	index
     * type					:	get
     * path					:	medias/$get parameter
     * parameters			:	token
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function test()
    {
        $datev = "2014-12-23 11:21:26";
        $user_timezone = 8;
        $date = date( 'Y-m-d H:i:s',strtotime( $datev ) + $user_timezone * 60 * 60 );

        $row = null;
        $date = count( $row );

        $this->_output_json( $date );
    }

    function index()
    {
        $gets = $this->input->get();

        $token         =    $gets['token'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            $medias = $this->tbl_medias->getMediaInfoByUser( "", "", $user['id'], "" );

            if( $medias == null )
            {
                $json           =   [
                    "data"          =>  '',
                    "message"       =>  [
                        "type"          =>  'error',
                        "value"         =>  'error query',
                        "code"          =>  ERROR_QUERY
                    ]
                ];
            }
            else
            {
                for( $i = 0; $i < count( $medias ); $i++ )
                {
                    $user_time = $this->tbl_users->userTime( $user );
                    $medias[$i]['user_time']    =   $user_time;
                }
                $json           =   [
                    "data"          =>  $medias,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'get all medias',
                        "code"          =>  SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json($json);
    }

    /**
 *API Function name		:	media_info
 * type					:	get
 * path					:	medias/media_info
 * parameters			:	token(user), media_id
 * Created Date			:	2015-1-2
 * Creator				:	tiger
 * Update Date			:
 * Updater				:
 */

    function media_info()
    {
        $gets = $this->input->get();

        $token         =    $gets['token'];
        $media_id      =    $gets['media_id'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            $medias = $this->tbl_medias->getMediaInfoByUser( $media_id, "", "" );

            if( $medias == null )
            {
                $json           =   [
                    "data"          =>  '',
                    "message"       =>  [
                        "type"          =>  'error',
                        "value"         =>  'error query',
                        "code"          =>  ERROR_QUERY
                    ]
                ];
            }
            else
            {
                for( $i = 0; $i < count( $medias ); $i++ )
                {
                    $user_time = $this->tbl_users->userTime( $user );
                    $medias[$i]['user_time']    =   $user_time;
                }
                $json           =   [
                    "data"          =>  $medias,
                    "message"       =>  [
                        "type"          =>  'success',
                        "value"         =>  'get all medias',
                        "code"          =>  SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json($json);
    }

    /**
     *API Function name		:	medias_for_friend
     * type					:	get
     * path					:	medias/medias_for_friend
     * parameters			:	token(user), friend_id(friend)
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function medias_for_friend()                            //require edit friend media clear
    {
        $gets = $this->input->get();

        $token         =    $gets['token'];
        $friend_id      =   $gets['friend_id'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            $friend = $this->tbl_users->getUserinfoByFilter( $friend_id, "", "", "" );
            if( $friend == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find this user.',
                        "code"		=>	ERROR_REGISTERED
                    ]
                ];
            }
            else
            {
                $medias = $this->tbl_medias->getMediaInfoByUser( "", "", $friend['id'], "2" );
                if( $medias == null )
                {
                    $json           =   [
                        "data"          =>  [],
                        "message"       =>  [
                            "type"          =>  'success',
                            "value"         =>  'no medias',
                            "code"          =>  SUCCESS_QUERY
                        ]
                    ];
                }
                else
                {
                    for( $i = 0; $i < count( $medias ); $i++ )
                    {
                        $user_time = $this->tbl_users->userTime( $user );
                        $medias[$i]['user_time']    =   $user_time;
                    }
                    $json           =   [
                        "data"          =>  $medias,
                        "message"       =>  [
                            "type"          =>  'success',
                            "value"         =>  'get all medias',
                            "code"          =>  SUCCESS_QUERY
                        ]
                    ];
                }
            }
        }
        $this->_output_json($json);
    }


    /******************************** POST API Function	*****************************/

    /**
     *API Function name		:	share_medias
     * type					:	post
     * path					:	medias/share_medias
     * parameters			:	token(user), friend_ids(friend ids format( 'id1,id2,id3'...)), media_id
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function share_medias()
    {
        $posts = $this->input->post();

        $token              =   $posts['token'];
        $media_id           =   $posts['media_id'];
        $friend_ids         =   $posts['friend_ids'];
        $friend_id_array    =   mbsplit( ',', $friend_ids );

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            $j = 0;
            for( $i = 0; $i < count( $friend_id_array ); $i++ )
            {
                $tmp_friend = $this->tbl_users->getUserinfoByFilter( $friend_id_array[$i], "", "", "" );
                if( $tmp_friend != null ) {
                    $friends[$j] = $tmp_friend;
                    $j++;
                }
            }

            if( count( $friends ) <= 0 )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find friends.',
                        "code"		=>	USER_UNREGISTERED
                    ]
                ];
                $this->_output_json( $json ); exit;
            }

            $medias = $this->tbl_medias->getMediaInfoByUser( $media_id, "", "", "" );

            if( $medias == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find media.',
                        "code"		=>	MEDIA_NOT_FOUND
                    ]
                ];
            }
            else
            {
                $media = $medias[0];

                $status = $this->tbl_medias->shareFriends( $media, $user, $friends );
                if( $status )
                {
                    $json 	=	[
                        "data"		=>	[
                            "id"        =>  $media['id'],
                            "media"     =>  $media['filename']
                        ],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'Shared media',
                            "code"		=>	SUCCESS_UPLOAD
                        ]
                    ];
                }
                else
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	'Cannot share media.',
                            "code"		=>	ERROR_QUERY
                        ]
                    ];
            }
        }
        $this->_output_json($json);
    }

    /**
     *API Function name		:	like
     * type					:	post
     * path					:	medias/like
     * parameters			:	token(user), media_id
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function like()
    {
        $posts = $this->input->post();

        $token              =   $posts['token'];
        $media_id           =   $posts['media_id'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            $medias = $this->tbl_medias->getMediaInfoByUser( $media_id, "", "", "" );
            if( $medias == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find media.',
                        "code"		=>	MEDIA_NOT_FOUND
                    ]
                ];
            }
            else
            {
                $media      =   $medias[0];
                $media_user = $this->tbl_users->getUserinfoByFilter( $media['user_id'], "", "", "" );

                $status     =   $this->tbl_medias->likeMedia( $media, $user );
                if( $user['id'] != $media_user['id'] )
                    $this->tbl_users->sendNotificationLikeYourMedia( $media_user, $user, $media );
                $likes      =   $this->tbl_medias->likeCountByMedia( $media );
                if( $status )
                {
                    $json 	=	[
                        "data"		=>	[
                            "like_count"        =>  $likes
                        ],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'added like',
                            "code"		=>	SUCCESS_QUERY
                        ]
                    ];
                }
                else
                    $json 	=	[
                        "data"		=>	[
                            "like_count"     =>    $likes
                        ],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	'failed like media.',
                            "code"		=>	ERROR_QUERY
                        ]
                    ];
            }
        }
        $this->_output_json($json);
    }
    /**
     *API Function name		:	main_page_info
     * type					:	post
     * path					:	medias/main_page_info
     * parameters			:	token(user), media_id, media_exist, media_type, video_thumb, media
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function main_page_info()
    {
        $posts = $this->input->post();

        $token          =   $posts['token'];
        $media_exist    =   $posts['media_exist'];
        $media_type     =   $posts['media_type'];
//        $video_thumb    =   $posts['video_thumb'];
        $json 	=	[
            "data"		=>	"main_page_info"
        ];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            if( $media_exist == '1' )
            {
                $rand       =	mt_rand( 0, 100000 );

                if( isset( $_FILES['media']['tmp_name'] ) ) {                 //if media is not null
                    $media_path = MEDIA_ROOT_PATH . $user['id'] . "/";
                    $dirCreated = ( !is_dir( $media_path ) ) ? @mkdir( $media_path, 0777 ) : TRUE;
                    $media_name = $_FILES['media']['name'];
                    $ext = end( ( explode( ".", $media_name ) ) );
                    $media_name = $rand . '.' .$ext;
                    $media_url = $media_path . $media_name;
                    if( file_exists( $media_url ) ) unlink( $media_url );
                    if ( !move_uploaded_file( $_FILES['media']['tmp_name'], $media_url ) ) {
                        $json = [
                            "data" => [],
                            "message" => [
                                "type" => 'error',
                                "value" => 'Cannot upload media file to server.',
                                "code" => MEDIA_NOT_FOUND
                            ]
                        ];
                        $this->_output_json($json);
                        exit;
                    }
                    $new_media['media_url']     = SERVER_URL . $media_url;
                }

                if( $media_type == '0' )
                {
                    if( isset( $_FILES['video_thumb']['tmp_name'] ) ) {                 //if video_thumb is not null
                        $thumb_path = MEDIA_ROOT_PATH . $user['id'] . "/";
                        $dirCreated = ( !is_dir( $thumb_path ) ) ? @mkdir( $thumb_path, 0777 ) : TRUE;
                        $thumb_name = $_FILES['video_thumb']['name'];
                        $ext = end( ( explode( ".", $thumb_name ) ) );
                        $thumb_name = "thumb" . $rand . '.' .$ext;
                        $thumb_url = $thumb_path . $thumb_name;
                        if( file_exists( $thumb_url ) ) unlink( $thumb_url );
                        if ( !move_uploaded_file( $_FILES['video_thumb']['tmp_name'], $thumb_url ) ) {
                            $json = [
                                "data" => [],
                                "message" => [
                                    "type" => 'error',
                                    "value" => 'Cannot upload thumb file to server.',
                                    "code" => MEDIA_NOT_FOUND
                                ]
                            ];
                            $this->_output_json($json);
                            exit;
                        }
                    }
                    $new_media['thumb_url']     =    SERVER_URL . $thumb_url;
                }

                $new_media['media_type']        =   $media_type;

                $inserted_id = $this->tbl_medias->registerMedia( $new_media, $user );

                if( $inserted_id )
                {
                    $media = $this->tbl_medias->getMediaInfoByUser( $inserted_id, "", "", "" );
                    if( $media == null )
                    {
                        $json = [
                            "data" => [],
                            "message" => [
                                "type" => 'error',
                                "value" => 'Cannot find media.',
                                "code" => MEDIA_NOT_FOUND
                            ]
                        ];
                        $this->_output_json( $json ); exit;
                    }
                    $media = $media[0];
                    $local_time = $media['created_at'];
                    $user_timezone = $user['time_zone'];
                    $created_at = date( 'Y-m-d H:i:s', strtotime($local_time) + $user_timezone * 60 * 60 );     //reference datetime

                    $data   =   [
                        "id"                    =>  $media['id'],
                        "filename"              =>  $media['filename'],
                        "created_at"            =>  $created_at,
                        "like_count"            =>  '0',
                        "comment_count"         =>  '0',
                        "notification_count"    =>  $this->tbl_users->unreadNotificationsCount( $user['id'] )
                    ];

                    $json   =   [
                        "data"              =>  $data,
                        "message"           =>  [
                            "type"                  =>  'success',
                            "value"                 =>  'success uploaded',
                            "code"                  =>  SUCCESS_UPLOAD
                        ]
                    ];
                }
            }
            else
            {
                $media_id       =   $posts['media_id'];
                $media          =   $this->tbl_medias->getMediaInfoByUser( $media_id, "", "", "" );
                if( $media == null )
                {
                    $json = [
                        "data" => [],
                        "message" => [
                            "type" => 'error',
                            "value" => 'Cannot find media.',
                            "code" => MEDIA_NOT_FOUND
                        ]
                    ];
                    $this->_output_json( $json ); exit;
                }
                $media           =      $media[0];
                $like_count      =      $this->tbl_medias->likeCountByMedia( $media );
                $comment_count   =      $this->tbl_medias->commentCountByMedia( $media );
                $filename        =      $media_type == '1' ? $media['filename'] : $media['thumb'];
                $local_time = $media['created_at'];
                $user_timezone = $user['time_zone'];
                $created_at = date( 'Y-m-d H:i:s', strtotime($local_time) + $user_timezone * 60 * 60 );     //reference datetime
                $data            =  [
                    "id"                        =>  $media['id'],
                    "filename"                  =>  $filename,
                    "created_at"                =>  $created_at,
                    "like_count"                =>  $like_count,
                    "comment_count"             =>  $comment_count,
                    "notification_count"        =>  $this->tbl_users->unreadNotificationsCount( $user['id'] )
                ];
                $json            =   [
                    "data"                      =>  $data,
                    "message"                   =>  [
                        "type"                      =>  'success',
                        "value"                     =>  'success query',
                        "code"                      =>  SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json($json);
    }

    /**
     *API Function name		:	destroy_media
     * type					:	post
     * path					:	medias/destroy_media
     * parameters			:	token(user), media_id
     * Created Date			:	2015-1-2
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function destroy_media()
    {
        $posts          =   $this->input->post();
        $token          =   $posts['token'];
        $media_id       =   $posts['media_id'];

        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_medias' );

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
            $medias          =   $this->tbl_medias->getMediaInfoByUser( $media_id, "", "", "" );
            if( $medias == null ) {
                $json = [
                    "data" => [],
                    "message" => [
                        "type" => 'error',
                        "value" => 'Cannot find media.',
                        "code" => MEDIA_NOT_FOUND
                    ]
                ];
            }
            else {
                $media = $medias[0];

                $destroy_status = $this->tbl_medias->destroyMedia( $media );
                if( $destroy_status )
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'success',
                            "value"		=>	'Destroyed media.',
                            "code"		=>	SUCCESS_QUERY
                        ]
                    ];
                else
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	'Cannot destroy this media.',
                            "code"		=>	ERROR_QUERY
                        ]
                    ];
            }
        }
        $this->_output_json( $json );
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

// $.post( "http://192.168.0.208/timechatnet/index.php/medias/set_offline",{token:"tigertiger"}, function(data) {	console.log(data);})