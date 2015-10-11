<?php
if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Created by IntelliJ IDEA.
 * User: tiger
 * Date: 12/30/2014
 * Time: 6:56 AM
 */

class Comments  extends CI_Controller {

    /**
     *API Function name		:	index
     * type					:	get
     * path					:	comments/$get parameter
     * parameters			:	media_id, token
     * Created Date			:	2014-12-31
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function index()
    {
        $gets = $this->input->get();

        $media_id      =    $gets['media_id'];
        $token         =    $gets['token'];

        $this->load->model( 'tbl_comments' );
        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_likes' );
        $this->load->model( 'tbl_medias' );

        $user = $this->tbl_users->getUserinfoByFilter("", "", "", $token );

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
            $this->_output_json( $json ); exit;
        }
        else
        {
            $media = $this->tbl_medias->getMediaInfoByFilter( $media_id, "", "" );

            if( $media == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find media.',
                       "code"		=>	'603'
                     ]
                ];
            }
            else
            {
                $comments       =   $this->tbl_comments->getCommentsByFilter( $media_id );
                if( $comments == null )
                {
                    $comments = [];
                }
                else {
                    for ($i = 0; $i < count($comments); $i++) {
                        $comments[$i]['comment_type'] = $comments[$i]['comment'] == '' ? 0 : 1;
                        $comments[$i]['message'] = $comments[$i]['comment'] == '' ? $comments[$i]['audio_comment'] : $comments[$i]['comment'];
                        $comments[$i]['role'] = '502';

                        $us_time = date('h:i:s', time() + $comments[$i]['time_zone'] * 60 * 60);
                        $comments[$i]['user_time'] = $us_time;
                        $comments[$i]['user_name'] = $comments[$i]['username'];
                    }
                }
                $likes = $this->tbl_likes->getLikesByMediaId($media_id);
                $likes_count = count($likes);
                $json       =   [
                    "data"      =>  [
                        "comments"          =>  $comments,
                        "like_count"       =>  $likes_count
                    ],
                    "message"   =>  [
                        "type"              =>  'success',
                        "value"             =>  'get comments',
                        "code"              =>  SUCCESS_QUERY
                    ]
                ];
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	add_comment
     * type					:	post
     * path					:	comments/add_comment
     * parameters			:	media_id, comment, token
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function add_comment()
    {
        date_default_timezone_set( 'Europe/London' );
        $posts = $this->input->post();

        $media_id      =    $posts['media_id'];
        $comment       =    $posts['comment'];
        $token         =    $posts['token'];

        $this->load->model( 'tbl_comments' );
        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_likes' );
        $this->load->model( 'tbl_medias' );

        $user = $this->tbl_users->getUserinfoByFilter("", "", "", $token );

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
            $medias = $this->tbl_medias->getMediaInfoByFilter( $media_id, "", "" );

            if( $medias == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find media.',
                        "code"		=>	'603'
                    ]
                ];
            }
            else
            {
                $media = $medias[0];

                $new_comment['comment']     =   $comment;
                $new_comment['media_id']    =   $media_id;
                $new_comment['user_id']     =   $user['id'];
                $new_comment['created_at']  =   date( 'Y-m-d H:i:s' );

                $media_user = $this->tbl_users->getUserinfoByFilter( $media['user_id'], "", "", "" );

                if( $media_user == null )
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

                $status = $this->tbl_comments->addNewComment( $new_comment );
                if( $media_user['id'] != $user['id'] )
                    $this->tbl_users->sendNotificationCommentYourMedia( $media_user, $user, $media, '1' );
                if( $status <= 0 )
                {
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	'Cannot insert comment.',
                            "code"		=>	MEDIA_NOT_FOUND
                        ]
                    ];
                }
                else
                {
                    $comments       =   $this->tbl_comments->getCommentsByFilter( $media_id );
                    for( $i = 0; $i < count( $comments ); $i++  )
                    {
                        $comments[$i]['comment_type']   =  $comments[$i]['comment'] == '' ? 0 : 1;
                        $comments[$i]['message']        =  $comments[$i]['comment'] == '' ? $comments[$i]['audio_comment'] : $comments[$i]['comment'];
                        $comments[$i]['role']           =  '502';

                        $us_time                        =   date('h:i:s', time() + $comments[$i]['time_zone'] * 60 * 60 );
                        $comments[$i]['user_time']      =   $us_time;
                        $comments[$i]['user_name']      =   $comments[$i]['username'];
                    }

                    $likes          =   $this->tbl_likes->getLikesByMediaId( $media_id );
                    $likes_count    =   count( $likes );
                    $json       =   [
                        "data"      =>  [
                            "comments"          =>  $comments,
                            "like_count"       =>  $likes_count
                        ],
                        "message"   =>  [
                            "type"              =>  'success',
                            "value"             =>  'Added new comment successfully',
                            "code"              =>  SUCCESS_QUERY
                        ]
                    ];
                }
            }
        }
        $this->_output_json( $json );
    }

    /**
     *API Function name		:	add_audio_comment
     * type					:	post
     * path					:	comments/add_audio_comment
     * parameters			:	media_id, audio_comment, token
     * Created Date			:	2014-12-30
     * Creator				:	tiger
     * Update Date			:
     * Updater				:
     */

    function add_audio_comment()
    {
        date_default_timezone_set( 'Europe/London' );
        $posts = $this->input->post();

        $media_id           =    $posts['media_id'];
        $token              =    $posts['token'];

        $test_json = [
            "data"  => "here1"
        ];

        $this->load->model( 'tbl_comments' );
        $this->load->model( 'tbl_users' );
        $this->load->model( 'tbl_likes' );
        $this->load->model( 'tbl_medias' );

        $user = $this->tbl_users->getUserinfoByFilter("", "", "", $token );

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
            $this->_output_json( $json ); exit;
        }
        else
        {
            $medias = $this->tbl_medias->getMediaInfoByFilter( $media_id, "", "" );

            if( $medias == null )
            {
                $json 	=	[
                    "data"		=>	[],
                    "message"	=>	[
                        "type"		=>	'error',
                        "value"		=>	'Cannot find media.',
                        "code"		=>	'603'
                    ]
                ];
            }
            else
            {
                $media = $medias[0];
                if( isset( $_FILES['audio_comment']['tmp_name'] ) ) {                 //if audio_comment is not null
                    $audio_comment_path = AUDIO_COMMENT_ROOT_PATH .$user['id']."/";
                    $dirCreated=(!is_dir($audio_comment_path)) ? @mkdir($audio_comment_path, 0777):TRUE;
                    $audio_name = $_FILES['audio_comment']['name'];
                    $ext = end( ( explode( ".", $audio_name ) ) );
                    $audio_name = rand(1,99999) . '.' .$ext;
                    $audio_comment_url = $audio_comment_path.$audio_name;

                    if( !move_uploaded_file($_FILES['audio_comment']['tmp_name'], $audio_comment_url) ) {
                        $json 	=	[
                            "data"		=>	[],
                            "message"	=>	[
                                "type"		=>	'error',
                                "value"		=>	'Cannot upload audio comment file to server.',
                                "code"		=>	'603'
                            ]
                        ];
                        $this->_output_json( $json ); exit;
                    }

                    $new_comment['audio_comment'] = SERVER_URL . $audio_comment_url;
                    $new_comment['media_id']    =   $media_id;
                    $new_comment['user_id']     =   $user['id'];
                    $new_comment['created_at']  =   date( 'Y-m-d H:i:s' );

                    $media_user = $this->tbl_users->getUserinfoByFilter( $media['user_id'], "", "", "" );

                    if( $media_user == null )
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
                    $status = $this->tbl_comments->addNewComment( $new_comment );
                    if( $media_user['id'] != $user['id'] )
                        $this->tbl_users->sendNotificationCommentYourMedia( $media_user, $user, $media, '2' );

                    if( $status <= 0 )
                    {
                        $json 	=	[
                            "data"		=>	[],
                            "message"	=>	[
                                "type"		=>	'error',
                                "value"		=>	'Cannot insert comment.',
                                "code"		=>	'603'
                            ]
                        ];
                        $this->_output_json( $json ); exit;
                    }
                    else
                    {
                        $comments       =   $this->tbl_comments->getCommentsByFilter( $media_id );
                        for( $i = 0; $i < count( $comments ); $i++  )
                        {
                            $comments[$i]['comment_type']   =  $comments[$i]['comment'] == '' ? 0 : 1;
                            $comments[$i]['message']        =  $comments[$i]['comment'] == '' ? $comments[$i]['audio_comment'] : $comments[$i]['comment'];
                            $comments[$i]['role']           =  '502';

                            $us_time                        =   date('h:i:s', time() + $comments[$i]['time_zone'] * 60 * 60 );
                            $comments[$i]['user_time']      =   $us_time;
                            $comments[$i]['user_name']      =   $comments[$i]['username'];
                        }

                        $likes          =   $this->tbl_likes->getLikesByMediaId( $media_id );
                        $likes_count    =   count( $likes );
                        $json       =   [
                            "data"      =>  [
                                "comments"          =>  $comments,
                                "like_count"       =>  $likes_count
                            ],
                            "message"   =>  [
                                "type"              =>  'success',
                                "value"             =>  'Added new comment successfully',
                                "code"              =>  SUCCESS_QUERY
                            ]
                        ];
                    }
                }
                else
                {
                    $json 	=	[
                        "data"		=>	[],
                        "message"	=>	[
                            "type"		=>	'error',
                            "value"		=>	'Empty audio comment file',
                            "code"		=>	'603'
                        ]
                    ];
                }
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

?>