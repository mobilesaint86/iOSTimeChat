//
//  MainViewController.m
//  TimeChat
//


#import "MainViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <UIKit/UIKit.h>


#import "MBProgressHUD.h"

@interface MainViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    int             countNewMessageGroup;
    int             countNewMessageUsers;

    AVAudioPlayer   *audioPlayer;
    UITextField     *encryptionKeyTextField;
    UITextField     *nameTextField,*userNameTextField;
    UITextField     *passwordTextField,*confirmPasswordTextField;
    UIImageView     *fotoImage;
    UIControl       *viewControl;
    NSString        *fileSufix;
    int             mediaHourCount[12];
    UIImageView     *newNotificationsView;
    UILabel         *newNotificationsLabel;

    NSArray         *mediasArray;
    NSArray         *mediasdataArray;
    Media           *media;
    Mediadata       *mediadata;
    
    
    UIButton *shareButton,*likeButton,*commentButton;
    int nLikes,nComments;
    UILabel *likeLabel,*commentLabel;
    NSArray *commentsArray;
    UILabel *timeLabel;
    
    Boolean MediaTypePhoto;
    Boolean media_exist;
    
    UIActivityIndicatorView *activity;
    MBProgressHUD * hud;
    
    NSData *photoData, *previewData, *videoData;
    NSTimer *timer;
    
    NSMutableDictionary  *mainInfo;
}

@end

@implementation MainViewController

#pragma mark - Default Functions
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UserDataSingleton sharedSingleton].mainViewController = self;
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
//    [[UserDataSingleton sharedSingleton].userDefaults setObject:@"true" forKey:@"unlocked"];
    
    [self create];
    [self loadMedias];
}

- (void) dealloc {
    [UserDataSingleton sharedSingleton].mainViewController = nil;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [UserDataSingleton sharedSingleton].photoView = false;
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    
    if ([UserDataSingleton sharedSingleton].changed){
        [UserDataSingleton sharedSingleton].changed = false;
        [self Update];
    }
    else if ([UserDataSingleton sharedSingleton].themeChanged){
        [UserDataSingleton sharedSingleton].themeChanged = false;
        [self create];
        [self showMainPageInfo];
    } else {
//        [self getNotificationCount];
    }
}

#pragma mark - User Functions
- (void)Update {
    
    if([UserDataSingleton sharedSingleton].cameraImage!=nil || [UserDataSingleton sharedSingleton].cameraVideo!=nil){
        if([UserDataSingleton sharedSingleton].cameraVideo != nil){
            MediaTypePhoto = false;
            photoData = UIImagePNGRepresentation([UserDataSingleton sharedSingleton].cameraPreview);
            videoData = [UserDataSingleton sharedSingleton].cameraVideo;
            previewData = photoData;
        }else{
            MediaTypePhoto = true;
            photoData = UIImagePNGRepresentation([UserDataSingleton sharedSingleton].cameraImage);
            videoData = nil;
            previewData = UIImagePNGRepresentation([UserDataSingleton sharedSingleton].cameraPreview);
        }
        
        [UserDataSingleton sharedSingleton].cameraVideo = nil;
        [UserDataSingleton sharedSingleton].cameraImage = nil;
        
        media_exist = 1;

    } else {
        media_exist = 0;
    }
    
    if (media_exist == 0 && [UserDataSingleton sharedSingleton].lastPhotoImageID == nil) return;
    
    [self getMainPageInfo];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)create
{
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    scale = [UserDataSingleton sharedSingleton].scale;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    statusBarHeight = [UserDataSingleton sharedSingleton].statusBarHeight;
    font1 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize1];
    font2 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize2];
    font3 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize3];
    font4 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize4];
    font5 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize5];
    font6 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize6];
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
//    UIColor *labelTextColor = [UserDataSingleton sharedSingleton].LabelTextColor;
//    UIColor *textColor1      = [UIColor colorWithRed:123/255.0f green:150/255.0f  blue:199/255.0f alpha:1.0f];
    
    NSString *filename;
    UIImage *image;
    CGRect size;

    // Statubar
    [self setNeedsStatusBarAppearanceUpdate];
    
    // background
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,statusBarHeight, self.view.frame.size.width, self.view.frame.size.height)];
    if([UserDataSingleton sharedSingleton].IOSDevice!=5){
        filename=[NSString stringWithFormat:@"background%@",   fileSufix];
    }else{
        filename=[NSString stringWithFormat:@"background%@",   fileSufix];
    }
    image=[UIImage imageNamed:filename];
    [background setImage:image];
    background.backgroundColor = [UIColor clearColor];
    [self.view addSubview:background];

    // Title Background
    filename=[NSString stringWithFormat:@"title_background%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = screenWidth;
    size.size.height = image.size.height / image.size.width * size.size.width;
    size.origin.x = 0;
    size.origin.y = statusBarHeight;
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:size];
    [titleView setImage:image];
    titleView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleView];
    
    // Title text!
    str = [NSString stringWithFormat:@"Welcome %@", [UserDataSingleton sharedSingleton].userName];
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = statusBarHeight + (titleView.frame.size.height - size.size.height) / 2;
    UILabel *descriptionBeginForgotLabel = [[UILabel alloc] initWithFrame:size];
    descriptionBeginForgotLabel.textColor = titleColor;
    descriptionBeginForgotLabel.text = str;
    [descriptionBeginForgotLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionBeginForgotLabel setFont:font1];
    [self.view addSubview:descriptionBeginForgotLabel];
    
    // lastPhotoImage
    heightSpace = 65 * scale;
    filename = [NSString stringWithFormat:@"main_thumb%@",  fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x  = (screenWidth - size.size.width) / 2;
    size.origin.y = titleView.frame.origin.y + titleView.frame.size.height + heightSpace;
    lastPhotoImageView = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
    [lastPhotoImageView setImage:image];
    [lastPhotoImageView.layer setBorderWidth:10.f];
    [lastPhotoImageView.layer setBorderColor:[UIColor colorWithRed:231/255.0f green:231/255.0f  blue:231/255.0f alpha:1.0f].CGColor];
    [self.view addSubview:lastPhotoImageView];
    
    // lastPhotoImage Button
    UIButton *zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zoomButton.frame = lastPhotoImageView.frame;
    zoomButton.tag = [media.media_id intValue];
    [zoomButton addTarget:self action:@selector(showFullImage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zoomButton];
  
    // description background
    heightSpace = 40 * scale;
    filename=[NSString stringWithFormat:@"main_description%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = lastPhotoImageView.frame.origin.y + lastPhotoImageView.frame.size.height + heightSpace;
    UIImageView *descirptionImageView = [[UIImageView alloc] initWithFrame:size];
    [descirptionImageView setImage:image];
    descirptionImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:descirptionImageView];
    
    // time label
    widthSpace = 20 * scale;
	size.size = [@"12:56 AM" sizeWithAttributes:@{NSFontAttributeName:font4}];
    size.origin.x = descirptionImageView.frame.origin.x + widthSpace;
    size.origin.y = descirptionImageView.frame.origin.y + (descirptionImageView.frame.size.height - size.size.height) / 2;
    timeLabel =[[UILabel alloc] initWithFrame: size];
    timeLabel.textColor        = lightTextColor;
    timeLabel.text = @"";
    timeLabel.font             = font4;
    timeLabel.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:timeLabel];
    
    // like Image
    widthSpace = 170 * scale;
    filename = [NSString stringWithFormat:@"main_like%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width  = image.size.width * scale;
    size.origin.x = descirptionImageView.frame.origin.x + widthSpace;
    size.origin.y = descirptionImageView.frame.origin.y + (descirptionImageView.frame.size.height - size.size.height) / 2;
    UIImageView *likeImageView = [[UIImageView alloc] initWithFrame:size];
    [likeImageView setImage:image];
    likeImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:likeImageView];
    
    // like label
    widthSpace = 10 * scale;
    str = [NSString stringWithFormat:@"%d ", nLikes];
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font4}];
    size.size.width = 80 * scale;
    size.origin.x = likeImageView.frame.origin.x + likeImageView.frame.size.width + widthSpace;
    size.origin.y = descirptionImageView.frame.origin.y + (descirptionImageView.frame.size.height - size.size.height) / 2;
    likeLabel =[[UILabel alloc] initWithFrame: size];
    likeLabel.text             = str;
    likeLabel.textColor        = lightTextColor;
    likeLabel.font             = font4;
    likeLabel.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:likeLabel];
    
    // Comments Image
    widthSpace = 304 * scale;
    filename = [NSString stringWithFormat:@"main_comment%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width  = image.size.width * scale;
    size.origin.x = descirptionImageView.frame.origin.x + widthSpace;
    size.origin.y = descirptionImageView.frame.origin.y + (descirptionImageView.frame.size.height - size.size.height) / 2;
    UIImageView *commentImageView = [[UIImageView alloc] initWithFrame:size];
    [commentImageView setImage:image];
    commentImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:commentImageView];
    
    // comment label
    widthSpace = 10 * scale;
    str = [NSString stringWithFormat:@"%d", nComments];
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font4}];
    size.size.width = 58 * scale;
    size.origin.x = commentImageView.frame.origin.x + commentImageView.frame.size.width + widthSpace;
    size.origin.y = descirptionImageView.frame.origin.y + (descirptionImageView.frame.size.height - size.size.height) / 2;
    commentLabel =[[UILabel alloc] initWithFrame: size];
    commentLabel.text             = str;
    commentLabel.textColor        = lightTextColor;
    commentLabel.font             = font4;
    commentLabel.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:commentLabel];
    
    // take Photo Button
    heightSpace = 34 * scale;
    filename=[NSString stringWithFormat:@"main_photo%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width  = image.size.width * scale;
    widthSpace = (screenWidth - size.size.width * 6) / 7;
    size.origin.x = widthSpace;
    size.origin.y = descirptionImageView.frame.origin.y + descirptionImageView.frame.size.height + heightSpace;
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoButton setBackgroundImage:image   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_photo_down%@",   fileSufix];
    [takePhotoButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [takePhotoButton setFrame:size];
    takePhotoButton.backgroundColor = [UIColor clearColor];
    [takePhotoButton addTarget:self action:@selector(pressTakePhotoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePhotoButton];
    
    // take Camera Button
    filename=[NSString stringWithFormat:@"main_video%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.origin.x = takePhotoButton.frame.origin.x + takePhotoButton.frame.size.width + widthSpace;
    UIButton *takeCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takeCameraButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_video_down%@",   fileSufix];
    [takeCameraButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [takeCameraButton setFrame:size];
    takeCameraButton.backgroundColor = [UIColor clearColor];
    [takeCameraButton addTarget:self action:@selector(pressTakeCameraButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takeCameraButton];
    
    // Add friends Button
    filename=[NSString stringWithFormat:@"main_invite%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.origin.x = takeCameraButton.frame.origin.x + takeCameraButton.frame.size.width + widthSpace;
    UIButton *addFriendsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendsButton setBackgroundImage:image   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_invite_down%@",   fileSufix];
    [addFriendsButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [addFriendsButton setFrame:size];
    addFriendsButton.backgroundColor = [UIColor clearColor];
    [addFriendsButton addTarget:self action:@selector(pressAddFriendsButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addFriendsButton];

    // Settings Button
    filename=[NSString stringWithFormat:@"main_settings%@",   fileSufix];
    size.origin.x = addFriendsButton.frame.origin.x + addFriendsButton.frame.size.width + widthSpace;
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_settings_down%@",   fileSufix];
    [settingsButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [settingsButton setFrame:size];
    settingsButton.backgroundColor = [UIColor clearColor];
    [settingsButton addTarget:self action:@selector(pressSettingsButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];
    
    // Notifications Button
    filename=[NSString stringWithFormat:@"main_notification%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.origin.x = settingsButton.frame.origin.x + settingsButton.frame.size.width + widthSpace;
    UIButton *notificationsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [notificationsButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_notification_down%@",   fileSufix];
    [notificationsButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [notificationsButton setFrame:size];
    notificationsButton.backgroundColor = [UIColor clearColor];
    [notificationsButton addTarget:self action:@selector(pressNotificationsButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:notificationsButton];
    
    // Profile Button
    filename=[NSString stringWithFormat:@"main_profile%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.origin.x = notificationsButton.frame.origin.x + notificationsButton.frame.size.width + widthSpace;
    UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [profileButton setBackgroundImage:image   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_profile_down%@",   fileSufix];
    [profileButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [profileButton setFrame:size];
    profileButton.backgroundColor = [UIColor clearColor];
    [profileButton addTarget:self action:@selector(pressProfileButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:profileButton];
    
    // Notification Badge
    filename = [NSString stringWithFormat:@"main_badge%@",  fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale * 1.7;
    size.size.width  = image.size.width * scale * 1.7;
    size.origin.x = notificationsButton.frame.size.width *3 / 4;
    size.origin.y = 0- notificationsButton.frame.size.height / 4;
    newNotificationsView = [[UIImageView alloc] initWithImage:image];
    [newNotificationsView setFrame:size];
    
    newNotificationsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.size.width, size.size.height)];
    [newNotificationsLabel setTextAlignment:NSTextAlignmentCenter];
    [newNotificationsLabel setTextColor:[UIColor whiteColor]];
    [newNotificationsLabel setBackgroundColor:[UIColor clearColor]];

    [newNotificationsView addSubview:newNotificationsLabel];
    [notificationsButton addSubview:newNotificationsView];
    [newNotificationsView setHidden:true];
    
    // friends time day Button
    heightSpace = 72 * scale;
    widthSpace = 10 * scale;
    filename=[NSString stringWithFormat:@"main_friends%@",   fileSufix];
    image=[UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width * 2 - widthSpace) / 2;
    size.origin.y = screenHeight - heightSpace - size.size.height;
    UIButton *friendsTimeDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [friendsTimeDayButton setBackgroundImage:image   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_friends_down%@",   fileSufix];
    [friendsTimeDayButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [friendsTimeDayButton setFrame:size];
    [friendsTimeDayButton setTitle:@"Friend's Day" forState:UIControlStateNormal];
    [friendsTimeDayButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [friendsTimeDayButton.titleLabel setFont:font3];
    friendsTimeDayButton.backgroundColor = [UIColor clearColor];
    [friendsTimeDayButton addTarget:self action:@selector(pressFriendsTimeDayButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendsTimeDayButton];
    
    // my time day Button
    filename=[NSString stringWithFormat:@"main_my%@",   fileSufix];
    image=[UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = screenWidth - friendsTimeDayButton.frame.origin.x -  size.size.width;
    size.origin.y = friendsTimeDayButton.frame.origin.y;
    UIButton *myTimeDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [myTimeDayButton setBackgroundImage:image   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"main_my_down%@",   fileSufix];
    [myTimeDayButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [myTimeDayButton setFrame:size];
    myTimeDayButton.backgroundColor = [UIColor clearColor];
    [myTimeDayButton setTitle:@"My Day" forState:UIControlStateNormal];
    [myTimeDayButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [myTimeDayButton.titleLabel setFont:font3];
    [myTimeDayButton addTarget:self action:@selector(pressMyTimeDayButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myTimeDayButton];

    
    [self.view addSubview:hud];
}

- (void)getMediaTime:(NSString *)time{
    [self getTimeFormat:time];
}

-(void) getTimeFormat:(NSString *)strTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *myDate = [df dateFromString: strTime];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar * cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:unitFlags fromDate:myDate];
    
    int hour = (int)[comps hour];
    NSString *time;
    NSString *sMinute;
    if([comps minute]<10){
        sMinute =[NSString stringWithFormat:@"0%ld", (long)[comps minute]];
    }else{
        sMinute =[NSString stringWithFormat:@"%ld" , (long)[comps minute]];
    }
    if(hour< 12){  time  = [NSString stringWithFormat:@"%d:%@am",   hour    ,sMinute]; }
    if(hour==12){  time  = [NSString stringWithFormat:@"%d:%@pm",   12      ,sMinute]; }
    if(hour> 12){  time  = [NSString stringWithFormat:@"%d:%@pm",   hour-12 ,sMinute]; }
    
    timeLabel.text             = time;
}

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//==============================   BUTTONS   ========================================

- (void)showFullImage {
 
    if ([UserDataSingleton sharedSingleton].lastPhotoImageID != nil && ![[UserDataSingleton sharedSingleton].lastPhotoImageID isEqualToString:@""]) {
        [UserDataSingleton sharedSingleton].mainMediaID = [UserDataSingleton sharedSingleton].lastPhotoImageID;
        MyTimeDayViewController *subVC;
        if(subVC == nil)    subVC = [[MyTimeDayViewController alloc] init];
        [self presentViewController:subVC animated:YES completion:nil];
    }
}

- (void) showMainPageInfo
{
    [self setNotificationCount];
    
    likeLabel.text = [NSString stringWithFormat:@"%d", nLikes];
    commentLabel.text = [NSString stringWithFormat:@"%d", nComments];
    
    // LastPhoto
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@",[UserDataSingleton sharedSingleton].lastPhotoImageID];
    [fetchRequest setPredicate:predicate];
    NSError *requestError = nil;
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext
                   executeFetchRequest:fetchRequest error:&requestError];
    
    UIImage *image;
    if ([mediasArray count]>0) {
        media = [mediasArray objectAtIndex:[mediasArray count]-1];
        image = [UIImage imageWithData:media.preview_data];
        [UserDataSingleton sharedSingleton].lastPhotoImage = image;
        [self getMediaTime:media.time];
    }else{
        NSString *filename = [NSString stringWithFormat:@"main_no_photo%@",  fileSufix];
        image = [UIImage imageNamed:filename];
    }
    
    mediasArray = [NSArray arrayWithObjects:  nil];
    
    [lastPhotoImageView setImage:image];
    
//    likeLabel.text = [mainInfo objectForKey:@"like_count"];
//    commentLabel.text = [mainInfo objectForKey:@"comment_count"];
    NSString *imgStr = [mainInfo objectForKey:@"filename"];
    NSURL *url = [NSURL URLWithString:imgStr];
    NSData *userAvatarData = [NSData dataWithContentsOfURL:url];
    UIImage *lastImg = [UIImage imageWithData:userAvatarData];
    [lastPhotoImageView setImage:lastImg];
    [self getMediaTime:[mainInfo objectForKey:@"created_at"]];
}

- (void)setNotificationCount{
    if ([UserDataSingleton sharedSingleton].notificationCount > 0) {
        if ([UserDataSingleton sharedSingleton].notificationCount > 99) {
            [newNotificationsLabel setFont:font4];
        } else {
            [newNotificationsLabel setFont:font3];
        }
        [newNotificationsView setHidden:false];
        newNotificationsLabel.text = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].notificationCount];
    } else {
        [newNotificationsView setHidden:true];
    }
    
}

- (void)clearNotifications
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSString *str = [[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"localNotification"];
    
    NSString *newStr = @"";
    NSLog(@"locolnotificationlist = %@", str);
    if (![str isEqualToString:@""]){
        NSArray *foo = [str componentsSeparatedByString: @";"];
        for (int i=0;i<[foo count];i++){
                NSString *nodeString = [foo objectAtIndex:i];
                NSArray *nodeAry = [nodeString componentsSeparatedByString: @","];
                if (![newStr isEqualToString:@""]){
                    newStr = [NSString stringWithFormat:@"%@;%@,1", newStr, [nodeAry objectAtIndex:0]];//0:unread, 1:read
                } else {
                    newStr = [NSString stringWithFormat:@"%@,1", [nodeAry objectAtIndex:0]];//0:unread, 1:read
                }
        }
    }
    [[UserDataSingleton sharedSingleton].userDefaults setObject:newStr forKey:@"localNotification"];
    [[UserDataSingleton sharedSingleton].userDefaults synchronize];
}

- (int)getLocalNotificationCount
{
    NSString *str = [[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"localNotification"];
//    NSLog(@"local_str = %@", str);
    int count = 0;
    if (![str isEqualToString:@""] && str != nil){
        NSArray *foo = [str componentsSeparatedByString: @";"];
        for (int i=0;i<[foo count];i++){
            NSString *nodeString = [foo objectAtIndex:i];
            NSArray *nodeAry = [nodeString componentsSeparatedByString: @","];
            if ([[nodeAry objectAtIndex:1] intValue] == 0) count++;
        }
    }
    return count;
}

#pragma mark - Main Buttons
- (void)pressAddFriendsButton {
    
    FindFriendsViewController *subVC;
    if(subVC==nil)      subVC = [[FindFriendsViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)pressSettingsButton {
    
    SettingsViewController *subVC;
    if(subVC==nil)  subVC = [[SettingsViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)pressNotificationsButton {
    
    NotificationsViewController *subVC;
    if(subVC==nil)    subVC = [[NotificationsViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];

    [self clearNotifications];
    [UserDataSingleton sharedSingleton].notificationCount = 0;
    [newNotificationsView setHidden:true];
}
- (void)pressTakePhotoButton {
    
    ViewController *subVC;
    if(subVC==nil)    subVC = [[ViewController alloc] init:1];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)pressTakeCameraButton {
    
    ViewController *subVC;
    if(subVC==nil)    subVC = [[ViewController alloc] init:0];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)pressMyTimeDayButton {
    
    [UserDataSingleton sharedSingleton].mainMediaID = nil;
    MyTimeDayViewController *subVC;
    if(subVC==nil)    subVC = [[MyTimeDayViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)pressFriendsTimeDayButton {
    
    FriendsViewController *subVC;
    if(subVC==nil) subVC = [[FriendsViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)pressProfileButton {
    
    ProfileViewController *subVC;
    if(subVC==nil)  subVC = [[ProfileViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}
#pragma mark - Server Request
-(void)loadMedias
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@&friend_id=%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/medias_for_friend", [UserDataSingleton sharedSingleton].session, [UserDataSingleton sharedSingleton].idUser]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"medias_for_friend" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}
- (void)getNotificationCount
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@", [UserDataSingleton sharedSingleton].serverURL, @"notifications/notification_count", [UserDataSingleton sharedSingleton].session]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"notification_count" forKey:@"type"];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

-(void) getMainPageInfo{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/main_page_info"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"main_page_info" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:[NSString stringWithFormat:@"%d",media_exist] forKey:@"media_exist"];
    
    if (media_exist){
        if (MediaTypePhoto){
            [request setPostValue:@"1" forKey:@"media_type"];
            [request setData:photoData withFileName:@"new.png" andContentType:@"image/png" forKey:@"media"];
        }
        else{
            [request setPostValue:@"0" forKey:@"media_type"];
            [request setData:previewData withFileName:@"video_thumb.png" andContentType:@"image/png" forKey:@"video_thumb"];
            [request setData:videoData withFileName:@"new.mp4" andContentType:@"multipart/form-data" forKey:@"media"];
        }
    } else {
        [request setPostValue:[UserDataSingleton sharedSingleton].lastPhotoImageID forKey:@"media_id"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

#pragma mark - Callback Functions
- (void) mediaForFriend_callback:(ASIHTTPRequest *)request_param
{
    NSLog(@"+++++++++++++++++++++call back++++++++++++++++++");
    NSLog(@"callback= %@",request_param);
    NSLog(@"*************************************************");
    NSString *mediaId;

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
    NSError *error = nil;
    NSPredicate *predicate;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:[[request_param responseString] dataUsingEncoding:NSUTF8StringEncoding]
                          options: NSJSONReadingMutableContainers
                          error: &error];
    
    NSDictionary *message = [json objectForKey:@"message"];
    NSArray *data = [json objectForKey:@"data"];
    [UserDataSingleton sharedSingleton].status=[message objectForKey:@"value"];
    
    int dataCount=0;
    @try {
        dataCount=(int)[data count];
    } @catch (NSException *e) {
        dataCount=0;
    }
    
    if (data!=nil && dataCount>0 ){
        
        [UserDataSingleton sharedSingleton].lastPhotoImageID = [[data objectAtIndex:dataCount-1] objectForKey:@"id"];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
        error = nil;
        mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
        for(int j = 0; j < [mediasArray count]; j++) {
            media  = [mediasArray objectAtIndex:j];
        }
        
        for(int i = 0; i < dataCount; i++) {
            mediaId             =   [[data objectAtIndex:i] objectForKey:@"id"];
            NSString *filename  =   [[data objectAtIndex:i] objectForKey:@"filename"];
            NSString *type      =   [[data objectAtIndex:i] objectForKey:@"type"];
            NSString *created_at =   [[data objectAtIndex:i] objectForKey:@"created_at"];
            NSString *thumb     = [[data objectAtIndex:i] objectForKey:@"thumb"];
            
            predicate = [NSPredicate predicateWithFormat:@"media_id==%@", mediaId];
            [request setPredicate:predicate];
            mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
            
            if ([mediasArray count]>0){
                media  = [mediasArray objectAtIndex:0];
            }else{
                // add server media to DB
                media = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                                      inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                mediadata = [NSEntityDescription insertNewObjectForEntityForName:@"Mediasdata"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                if(media != nil) {
                    
                    media.media_id  = mediaId;
                    media.user_id   = [UserDataSingleton sharedSingleton].idUser;
                    media.name      = filename;
                    media.time      = created_at;
                    media.type      = type;
                    
                    if (![type isEqualToString:@"1"])
                        media.thumb     = thumb;
                    media.preview_data = nil;
                    
                    NSURL *url;
                    if([type isEqualToString:@"1"]){
                        url = [NSURL URLWithString:media.name];
                    } else {
                        url = [NSURL URLWithString:media.thumb];
                    }
                    NSData *nsdata = [NSData dataWithContentsOfURL:url];
                    UIImage *image = [UIImage imageWithData:nsdata];
                    media.preview_data = UIImagePNGRepresentation(image);
                    
                    NSError *error = nil;
                    if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                    {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                    
                } else {
                    NSLog(@"new media failed to create");
                }
                
                if(mediadata != nil) {
                    mediadata.media_id   = mediaId;
                    mediadata.data = nil;
                    mediadata.video_data = nil;
                    mediadata.data = media.preview_data;
                    
                    if([type isEqualToString:@"0"]){
                        NSURL *url = [NSURL URLWithString:media.name];
                        NSData *nsdata = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:nsdata];
                        mediadata.video_data = UIImagePNGRepresentation(image);
                    }
                    NSError *error = nil;
                    if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                    {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                } else {
                    NSLog(@"new media data failed to create");
                }
                
            }
        }
        
        [self deleteOldMedia];
        [hud hide:YES];
        
        [self Update];
    } else {
        [UserDataSingleton sharedSingleton].lastPhotoImageID = nil;
        [self deleteOldMedia];
        [hud hide:YES];
        [self getNotificationCount];
    }
}

-(void)deleteOldMedia{
    NSError *error = nil;
    NSError *requestError = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@", [UserDataSingleton sharedSingleton].idUser];
    [fetchRequest setPredicate:predicate];
    
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext
                   executeFetchRequest:fetchRequest error:&requestError];
    NSString *mediaid=nil;
    for(int k = 0; k < [mediasArray count]; k++) {
        media  = [mediasArray objectAtIndex:k];
        if (media != nil){
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
                NSCalendar * cal = [NSCalendar currentCalendar];
                NSDate *myDate = [df dateFromString: media.time];
                mediaid = media.media_id;
                
                NSDateComponents *comps = [cal components:unitFlags fromDate:myDate];
                int day = (int)[comps day];
                
                NSDate *currDate = [NSDate date];
                comps = [cal components:unitFlags fromDate:currDate];
                int currday = (int)[comps day];
                
                if(day!=currday || media.preview_data == nil){
                    for (int i=0; i<[mediasArray count]; i++){
                        Media *temp = [mediasArray objectAtIndex:i];
                        if ([mediaid isEqualToString:temp.thumb] ){
                            [[CoreDataManager sharedManager].managedObjectContext deleteObject:temp];
                        }
                    }
                    
                    [[CoreDataManager sharedManager].managedObjectContext deleteObject:media];
                    
                    fetchRequest = [[NSFetchRequest alloc] init];
                    entity = [NSEntityDescription entityForName:@"Mediasdata"
                                         inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    [fetchRequest setEntity:entity];
                    requestError = nil;
                    NSError *error = nil;
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@", mediaid];
                    [fetchRequest setPredicate:predicate];
                    mediasdataArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    if([mediasdataArray count] > 0){
                        mediadata = [mediasdataArray objectAtIndex:[mediasdataArray count]-1];
                        [[CoreDataManager sharedManager].managedObjectContext deleteObject:mediadata];
                    }
                }
        }
    }
    mediasArray = [NSArray arrayWithObjects:  nil];
    if (![[CoreDataManager sharedManager].managedObjectContext save:&error]) { NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if(!error) {
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
                              options: NSJSONReadingMutableContainers
                              error: &error];
        NSDictionary    *data      = [json objectForKey:@"data"];
        NSDictionary *message = [json objectForKey:@"message"];
        
        
        
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"main_page_info"]) {
            NSLog(@"=== main_page_info ===");
            NSLog(@"received_info= %@", json);
            NSLog(@"=================================");
            mainInfo = [[NSMutableDictionary alloc]init];
            mainInfo = [json objectForKey:@"data"];
                if([[message objectForKey:@"code"] intValue] == SUCCESS_UPLOADED) {
                    
                    NSString *mediaId = [data objectForKey:@"id"];
                    
                    // add new media to DB
                    media     = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    mediadata = [NSEntityDescription insertNewObjectForEntityForName:@"Mediasdata"
                                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    
                    if(media != nil) {
                        media.media_id  = mediaId;
                        media.user_id   = [UserDataSingleton sharedSingleton].idUser;
                        media.name      = [data objectForKey:@"filename"];
                        media.time      = [data objectForKey:@"created_at"];
                        media.type      = MediaTypePhoto?@"1":@"0";
                        media.preview_data = previewData;
                        
                        NSError *error = nil;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                    } else {
                        NSLog(@"new media failed to create");
                    }
                    
                    if(mediadata != nil) {
                        
                        mediadata.media_id  = mediaId;
                        mediadata.data      = photoData;
                        mediadata.time      = [data objectForKey:@"created_at"];
                        if(videoData != nil)
                            mediadata.video_data = videoData;
                        else
                            mediadata.video_data = nil;
                        NSError *error = nil;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                        {   NSLog(@"Unresolved error for media Data db write %@, %@", error, [error userInfo]);}
                        else {
                            [lastPhotoImageView setImage:[UserDataSingleton sharedSingleton].cameraPreview];
                            [UserDataSingleton sharedSingleton].lastPhotoImageID = mediaId;
                            [self getTimeFormat:[data objectForKey:@"created_at"]];
                        }
                    } else {
                        NSLog(@"!!!new media data failed to create");
                    }
                    
                     [UserDataSingleton sharedSingleton].notificationCount = [[data objectForKey:@"notification_count"] intValue] + [self getLocalNotificationCount];
                     nLikes = 0;
                     nComments = 0;
                     [self showMainPageInfo];
                 }
                else if([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
                     [UserDataSingleton sharedSingleton].notificationCount = [[data objectForKey:@"notification_count"] intValue] + [self getLocalNotificationCount];
                    
                     nLikes = [[data objectForKey:@"like_count"] intValue];
                     nComments = [[data objectForKey:@"comment_count"] intValue];
                     [self showMainPageInfo];
                 }
                [hud hide:YES];
        }
        else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"notification_count"]) {
            NSLog(@"notification_count= %@", json);
            if([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
                [UserDataSingleton sharedSingleton].notificationCount = [[data objectForKey:@"count"] intValue] + [self getLocalNotificationCount];
                [self setNotificationCount];
            }
            [hud hide:YES];
        } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"medias_for_friend"]) {
            NSLog(@"=== madias for friend ===");
            NSLog(@"received_info= %@", json);
            NSLog(@"==================================");
            if([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
                [self mediaForFriend_callback:request];
            } else {
                [hud hide:YES];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Medias weren't loaded from server" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
            }
        }
    } else {
        [hud hide:YES];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

-(void)fireLocalNotification{
    
    UILocalNotification *noti = [[UILocalNotification alloc]init];
    noti.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    noti.timeZone = [NSTimeZone systemTimeZone];
    noti.alertBody = @"Your photo has saved to draft.";
    noti.alertAction = @"Try again";
    noti.applicationIconBadgeNumber = 1;
    noti.soundName = [UserDataSingleton sharedSingleton].notificationSound;
    noti.userInfo = [NSDictionary dictionaryWithObject:@"My User Info" forKey:@"User Info"];
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

-(void)saveUnuploadedMedia:(int)newId andTime:(NSString *)strTime{
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
    error = nil;

    media     = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    mediadata = [NSEntityDescription insertNewObjectForEntityForName:@"Mediasdata"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    
    if(media != nil) {
        media.media_id  = [NSString stringWithFormat:@"%d", newId];
        media.time      = strTime;
        media.user_id   = [UserDataSingleton sharedSingleton].idUser;
        media.type      = MediaTypePhoto?@"1":@"0";
        media.preview_data = previewData;
        
        NSError *error = nil;
        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
    } else {
        NSLog(@"new media failed to create");
    }
    
    if(mediadata != nil) {
        
        mediadata.media_id  = [NSString stringWithFormat:@"%d", newId];
        mediadata.data      = photoData;
        if(videoData != nil)
            mediadata.video_data = videoData;
        else
            mediadata.video_data = nil;
        NSError *error = nil;
        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
        {   NSLog(@"Unresolved error for media Data db write %@, %@", error, [error userInfo]);}
        else {
            
        }
    } else {
        NSLog(@"!!!new media data failed to create");
    }
}
-(void)saveInUserDefault
{
    NSString *str = [[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"localNotification"];
    int lastId = 0;
    if (![str isEqualToString:@""] && str != nil){
        NSArray *foo = [str componentsSeparatedByString: @";"];
        NSString *lastString = [foo objectAtIndex:([foo count]-1)];
        NSArray *lastStringAry = [lastString componentsSeparatedByString: @","];
        lastId = [[lastStringAry objectAtIndex:0] intValue];
    }
    
    NSDate *currentDateTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    if (![str isEqualToString:@""] && str != nil){
        str = [NSString stringWithFormat:@"%@;%d,0", str, lastId+1];
    } else {
        str = [NSString stringWithFormat:@"%d,0", 1];
    }
    
    [[UserDataSingleton sharedSingleton].userDefaults   setObject:str forKey:@"localNotification"];
    [[UserDataSingleton sharedSingleton].userDefaults synchronize];
    
    [self saveUnuploadedMedia:lastId + 1 andTime:dateInStringFormated];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"main_page_info"] && media_exist) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:@"Your photo was not uploaded.\n You may have lost connection. " delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [self fireLocalNotification];
        [self saveInUserDefault];
        [UserDataSingleton sharedSingleton].notificationCount += 1;
        [self setNotificationCount];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    [hud hide:YES];
}

@end
