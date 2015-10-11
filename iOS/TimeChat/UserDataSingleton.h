//
//  UserDataSingleton.h
//  TimeChat
//


#import <Foundation/Foundation.h>

@interface UserDataSingleton : NSObject

@property (nonatomic, strong) NSString *session;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *idUser;
@property (nonatomic, strong) NSString *idFriend;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) UIImage  *userImage;

@property (nonatomic, assign) Boolean   showButtonPressed;
@property (nonatomic, strong) NSString *shareMediaId;
@property (nonatomic, strong) NSString *friendAvatar;
@property (nonatomic, strong) NSString *friendName;
@property (nonatomic, strong) NSString *mediaCreatedTime;
@property (nonatomic, assign) Boolean  userPhotoDone;
@property (nonatomic, strong) NSString *facebookToken;
@property (nonatomic, strong) NSString *googleToken;
@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, assign) int       notificationCount;

@property (nonatomic, strong) NSMutableArray *contactsArray;
@property (nonatomic, strong) NSString  *animation;
@property (nonatomic, assign) int       newMessageContactsCount;
@property (nonatomic, assign) int       newMessageGroupsCount;
@property (nonatomic, strong) NSString  *notificationTone;
@property (nonatomic, strong) NSString  *vibration;
@property (nonatomic, strong) NSString  *serverURL;
@property (nonatomic, strong)  NSUserDefaults  *userDefaults;
@property (nonatomic, strong)  UIImage  *cameraImage;
@property (nonatomic, strong)  NSData   *cameraVideo;
@property (nonatomic, strong)  UIImage  *cameraPreview;
@property (nonatomic, strong)  UIImage  *lastPhotoImage;
@property (nonatomic, strong)  NSString *lastPhotoImageID;
@property (nonatomic, strong)  NSString *selectedMediaID;
@property (nonatomic, strong)  NSString *mediaID;
@property (nonatomic, strong)  NSString *mainMediaID;
@property (nonatomic, strong)  UIImagePickerController *appImagePicker;

//@property (nonatomic, strong) NSString *newMediaIdent;



//@property (nonatomic, assign)  int mediaHoursCounter[];


@property (nonatomic, strong)  UIColor  *InputTextColor;
@property (nonatomic, strong)  UIColor  *TextColor;
@property (nonatomic, strong)  UIColor  *LabelTextColor;

@property (nonatomic, strong)  NSMutableDictionary  *titleColor;
@property (nonatomic, strong)  NSMutableDictionary  *buttonColor;
@property (nonatomic, strong)  NSMutableDictionary  *logoutButtonColor;
@property (nonatomic, strong)  NSMutableDictionary  *lightTextColor;
@property (nonatomic, strong)  NSMutableDictionary  *darkTextColor;
@property (nonatomic, strong)  NSMutableDictionary  *placeTextColor;
@property (nonatomic, strong)  NSMutableDictionary  *loginTextColor;
@property (nonatomic, strong)  NSMutableDictionary  *viewTimedayTextColor;
@property (nonatomic, strong)  UIColor              *avatarChangeTextColor;
@property (nonatomic, strong)  UIColor              *lockedTextColor;

@property (nonatomic, strong) NSString  *Sufix;

@property (nonatomic, assign) int       shift ;
@property (nonatomic, assign) int       sizeText;
@property (nonatomic, assign) int       keyboardHeight;
@property (nonatomic, assign) int       statusBarHeight;

@property (nonatomic, assign) float     titleFont;
@property (nonatomic, assign) float     headFont;
@property (nonatomic, assign) float     menuFont;

@property (nonatomic, assign) float     textSize1;
@property (nonatomic, assign) float     textSize2;
@property (nonatomic, assign) float     textSize3;
@property (nonatomic, assign) float     textSize4;
@property (nonatomic, assign) float     textSize5;
@property (nonatomic, assign) float     textSize6;


@property (nonatomic, assign) NSString  *kGoogleplusClientID;
@property (nonatomic, assign) float     scale;
@property (nonatomic, assign) int       IOSDevice;

@property (nonatomic, assign) int          numOfDesign;
@property (nonatomic, assign) Boolean      pushEnable;
@property (nonatomic, assign) Boolean      soundEnable;
@property (nonatomic, strong) NSString  *notificationSound;
@property (nonatomic, assign) Boolean      autoAcceptFriendEnable;
@property (nonatomic, assign) Boolean      autoNotifyFriendEnable;

@property (nonatomic, assign)  Boolean  isLogOut;
@property (nonatomic, assign)  Boolean  isAgree;
@property (nonatomic, assign)  Boolean  photoView;
@property (nonatomic, assign)  Boolean  changed;
@property (nonatomic, assign)  Boolean  themeChanged;

@property (nonatomic, assign) int       selectTcPrivate;

@property (nonatomic, assign)  UIViewController *mainViewController;
+ (UserDataSingleton *)sharedSingleton;

- (BOOL)notificationEnabled;
- (void)setNotificationEnabled:(BOOL)notificationEnabled;

- (BOOL)notificationSoundEnabled;
- (void)setNotificationSoundEnabled:(BOOL)notificationSoundEnabled;

- (BOOL)autoAcceptFriendEnabled;
- (void)setAutoAcceptFriendEnabled:(BOOL)autoAcceptFriendEnabled;

- (BOOL)autoNotifyFriendEnabled;
- (void)setAutoNotifyFriendEnabled:(BOOL)autoNotifyFriendEnabled;


- (NSString *)notificationSound;
- (void)setNotificationSound:(NSString *)notificationSound;

@end

#define ERROR_LOGIN  0
#define SUCCESS_LOGIN  1
#define SUCCESS_LOGOUT  6
#define SUCCESS_QUERY  7
#define NOT_LOGIN  2
#define ERROR_REGISTERED 3
#define ERROR_QUERY  4
#define ERROR_INVALID_FIELD  5
#define LOGINED  8
#define API_DEFAULT  9
#define SUCCESS_REGISTERED  10
#define ERROR_FIELD_EXIST  11
#define ERROR_PASSWORD_NOT_MATCH 12
#define ERROR_RECORD_NOT_EXIST  13
#define ERROR_CHANGE_PASSWORD  14
#define SUCCESS_CHANGE_PASSWORD  15
#define SUCCESS_REGISTERED_PLEASE_CONFIRM_YOUR_EMAIL  16
#define SUCCESS_CONFIRM  17
#define ERROR_CHANGE_EMAIL  18
#define COMMENT_NOT_FIND  19
#define ACCESS_DENIED  20
#define ERROR_FIELD_NOT_SET  21
#define ERROR_DONT_SUPPORT  22
#define SUCCESS_CHANGE_USERNAME  27
#define SUCCESS_CHANGE_EMAIL  28

// user invited status
#define USER_REGISTERED  201
#define USER_UNREGISTERED  202
#define USER_INVITED_IN_SYSTEM  203
#define USER_INVITED_IN_FRIEND  204
#define USER_ALREADY_FRIEND  205

// friends status
#define FRIEND_ACCEPT  301
#define FRIEND_INVITED  302
#define FRIEND_DECLINE  303
#define FRIEND_IGNORE  304

// type notification
#define NOTIFICATION_NEW_COMMENT  401
#define NOTIFICATION_INVITE_IN_FRIEND  402
#define NOTIFICATION_ACCEPT_FRIEND  403
#define NOTIFICATION_REGISTERED_FRIEND  404
#define NOTIFICATION_REMOVED_FRIEND  405
#define NOTIFICATION_DECLINE_FRIEND  406
#define NOTIFICATION_FRIEND_ADDED_NEW_PHOTO  407
#define NOTIFICATION_FRIEND_ADDED_NEW_VIDEO  408
#define NOTIFICATION_FRIEND_COMMENTED_YOUR_PHOTO  409
#define NOTIFICATION_FRIEND_COMMENTED_YOUR_VIDEO  410
#define NOTIFICATION_FRIEND_LIKE_YOUR_PHOTO  411
#define NOTIFICATION_FRIEND_LIKE_YOUR_VIDEO  412
#define NOTIFICATION_SETTINGS_ENABLE  413
#define NOTIFICATION_SETTINGS_DISABLE  414
#define NOTIFICATION_ACCESS_MEDIA_USER 416
#define NOTIFICATION_LOCAL_NOTIFICATION 420
//media_user_id
// role
#define NOT_CONFIRM_USER  501
#define CONFIRM_USER  502

// media
#define ERROR_MEDIA_TYPE_FILE  601
#define SUCCESS_UPLOADED  602


