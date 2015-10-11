//
// FriendTimeDayViewController.m
//
//  TimeChat
//


#import "FriendTimeDayViewController.h"
#import "AppDelegate.h"
#import "FullPhotoViewController.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "POVoiceHUD.h"

@interface FriendTimeDayViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor, *logoutTextColor;
    UIImageView     *fotoImage;
    UIControl       *viewControl;
    UIFont          *headFont,*menuFont,*titleFont;
    NSMutableData   *userData;
    UIScrollView    *dayScrollView,*hourScrollView,*photoScrollView;
    UIView          *dayFormViewHolder,*hourFormViewHolder,*photoFormViewHolder,*commentFormViewHolder;
    UIView          *formView;
    UIColor         *textColor;
    UIColor         *labelTextColor;
    NSString        *fileSufix;
    PAImageView     *userImage;
    MPMoviePlayerController *moviePlayer;
    UIButton        *playButton;
    ALAssetsLibrary *assetsLibrary;
    int             serverRequestType;
    NSString        *zoomMediaID;

    NSArray         *mediasArray;
    NSArray         *mediasdataArray;
    Media           *media;
    Mediadata       *mediadata;
    NSURL           *urlVideo;
    int             currentHour;
    float           titleHight;
    UIImageView     *titleBackground;
    UILabel         *titleLabel,*titleLabel1;
    UIImageView     *iconImage;
    Boolean         fullImageShown;
    
    UIButton        *shareButton,*likeButton,*commentButton,*cancelButton, *commentTextFieldButton, *recordButton;
    int             nLikes,nComments;
    UILabel         *likeLabel,*commentLabel;
    NSArray         *commentsArray;
    UITextView      *commentTextView;
    CGRect          sizeTextField;
    CGRect          sizeCommentSend;
    UIColor         *InputTextColor;
    UIImageView     *imageViewFull;
    UIImage         *photoImage;
    PAImageView     *photoPAImageView;
    UIImageView*    photoImageView;
    
    NSMutableArray  *zoomButtonArray;
    NSMutableArray  *usernameLabelArray;
    NSMutableArray  *messageLabelArray;
    NSMutableArray *audioButtonArray;
    
    MBProgressHUD   *hud;
    POVoiceHUD *voiceHud;
}
@end

@implementation FriendTimeDayViewController

@synthesize audioPlayer;

#pragma mark - Default Functions
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userData = [[NSMutableData alloc] init];
    zoomButtonArray = [[NSMutableArray alloc] init];
    usernameLabelArray = [[NSMutableArray alloc] init];
    messageLabelArray = [[NSMutableArray alloc] init];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self create];
    if ([UserDataSingleton sharedSingleton].showButtonPressed){
        [self loadMedia];
    } else {
        [self loadMedias];
    }
}

- (void) dealloc {

    userImage =nil;
    fotoImage=nil;
    viewControl=nil;
    headFont=nil,menuFont=nil,titleFont=nil;
    userData=nil;
    dayScrollView=nil,hourScrollView=nil,photoScrollView=nil;
    dayFormViewHolder=nil,hourFormViewHolder=nil,photoFormViewHolder=nil, commentFormViewHolder=nil;
    formView=nil;
    textColor=nil;
    labelTextColor=nil;
    fileSufix=nil;
    userImage=nil;
    moviePlayer=nil;
    playButton=nil;
    assetsLibrary=nil;
    zoomMediaID=nil;
    urlVideo=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self update];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - User Functions
- (void)create {
    
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    scale = [UserDataSingleton sharedSingleton].scale;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    statusBarHeight = [UserDataSingleton sharedSingleton].statusBarHeight;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
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
    logoutTextColor = [[UserDataSingleton sharedSingleton].logoutButtonColor objectForKey:str];
    
    fullImageShown=false;
    serverRequestType=0;

    labelTextColor = [UserDataSingleton sharedSingleton].LabelTextColor;
    textColor      = [UIColor colorWithRed:50/255.0f green:50/255.0f  blue:50/255.0f alpha:1.0f];
    
    titleFont       = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].titleFont];
    headFont        = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].headFont];
    menuFont        = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].menuFont];
    titleHight      = self.view.frame.size.height/6;
    
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
    titleBackground = [[UIImageView alloc] initWithImage:image];
    [titleBackground setFrame: size];
    [self.view addSubview:titleBackground];
    
    // Back button
    widthSpace = 25 * scale;
    filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = widthSpace;
    size.origin.y = statusBarHeight + (titleBackground.frame.size.height - size.size.height) / 2;
    UIButton *backButton = [[UIButton alloc] initWithFrame:size];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // userAvatarImage
    widthSpace = 155 * scale;
    NSLog(@"%@",[UserDataSingleton sharedSingleton].friendAvatar );
    NSURL  *url = [NSURL URLWithString:[UserDataSingleton sharedSingleton].friendAvatar];
    NSData *userAvatarData = [NSData dataWithContentsOfURL:url];
    UIImage *friendAvatarImg = [UIImage imageWithData:userAvatarData];
    
    image = friendAvatarImg;
    if([UserDataSingleton sharedSingleton].friendAvatar==nil){
        filename=[NSString stringWithFormat:@"blank_user%@",   fileSufix];
        image = [UIImage imageNamed:filename];
    }
    
    size.size.width = 80 * scale;
    size.size.height = 80 * scale;
    size.origin.x  = widthSpace;
    size.origin.y = statusBarHeight + (titleBackground.frame.size.height - size.size.height) / 2;
    userImage = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
    [userImage setImage:image];
    [self.view  addSubview:userImage];
    
    // Title label
    widthSpace = 245 * scale;
    str = [NSString stringWithFormat:@"%@'s ",[UserDataSingleton sharedSingleton].friendName];
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = widthSpace;
    size.origin.y = titleBackground.frame.origin.y + (titleBackground.frame.size.height - size.size.height) / 2;
    titleLabel = [[UILabel alloc] initWithFrame: size];
    titleLabel.text             = str;
    titleLabel.textColor        = titleColor;
    titleLabel.font             = font1;
    titleLabel.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    // Title label1
    size.size = [@"Time Day" sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = titleLabel.frame.origin.x +titleLabel.frame.size.width;
    titleLabel1 = [[UILabel alloc] initWithFrame: size];
    titleLabel1.text             = @"Time Day";
    titleLabel1.textColor        = titleColor;
    titleLabel1.font             = font1;
    titleLabel1.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:titleLabel1];
    
    // scrollView
    titleHight = titleBackground.frame.origin.y + titleBackground.frame.size.height;
    dayScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,titleHight,self.view.frame.size.width,self.view.frame.size.height-titleHight)];
    dayScrollView.scrollEnabled = YES;
    hourScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,titleHight,self.view.frame.size.width,self.view.frame.size.height-titleHight)];
    hourScrollView.scrollEnabled = YES;
    photoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,titleHight,self.view.frame.size.width,self.view.frame.size.height-titleHight)];
    photoScrollView.scrollEnabled = YES;
    
    formView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHight, self.view.frame.size.width, self.view.frame.size.height-titleHight)];
    dayFormViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formView.frame.size.width,formView.frame.size.height+700)];
    [dayScrollView addSubview:dayFormViewHolder];
    
    hourFormViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formView.frame.size.width,formView.frame.size.height+700)];
    [hourScrollView addSubview:hourFormViewHolder];
    
    photoFormViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formView.frame.size.width,formView.frame.size.height + 900)];
    photoScrollView.userInteractionEnabled=YES;
    [photoScrollView addSubview:photoFormViewHolder];
    
    //commentFormViewHolder
    commentFormViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, statusBarHeight, self.view.frame.size.width,self.view.frame.size.height)];
    commentFormViewHolder.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:commentFormViewHolder];
    [self.view addSubview:dayScrollView];
    [self.view addSubview:hourScrollView];
    [self.view addSubview:photoScrollView];
    
    if ([UserDataSingleton sharedSingleton].showButtonPressed){
        dayScrollView.hidden = true;
        hourScrollView.hidden = true;
    }else {
        hourScrollView.hidden = true;
        photoScrollView.hidden = true;
    }
}

- (void)update{
    if([UserDataSingleton sharedSingleton].showButtonPressed){
        dayFormViewHolder.hidden=true;
        hourFormViewHolder.hidden=true;
        photoFormViewHolder.hidden=false;
        commentFormViewHolder.hidden=true;
        [self photoView:[UserDataSingleton sharedSingleton].shareMediaId];
    }else{
        if ([UserDataSingleton sharedSingleton].photoView){
            dayFormViewHolder.hidden=true;
            hourFormViewHolder.hidden=true;
            commentFormViewHolder.hidden=true;
            photoFormViewHolder.hidden=false;
            [self photoView:[UserDataSingleton sharedSingleton].selectedMediaID];
        } else {
            dayFormViewHolder.hidden=false;
            hourFormViewHolder.hidden=true;
            commentFormViewHolder.hidden=true;
            photoFormViewHolder.hidden=true;
            [self dayView];
        }
    }
}

- (void)playVideo {
    
    FullPhotoViewController *subVC;
    if(subVC==nil)    subVC = [[FullPhotoViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}
- (void)showKeyboard{
    [commentTextView becomeFirstResponder];
}
- (void)zoomImage:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    zoomMediaID = [zoomButtonArray objectAtIndex:button.tag];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
    NSError *error = nil;
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"media_id==%@", zoomMediaID];
    [request setPredicate:predicate];
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Mediasdata" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
    error = nil;
    
    predicate = [NSPredicate predicateWithFormat:@"media_id==%@", zoomMediaID];
    [request setPredicate:predicate];
    mediasdataArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
    
    if ([mediasArray count]>0){
        media  = [mediasArray objectAtIndex:0];
        
        if ([mediasdataArray count]>0){
            mediadata  = [mediasdataArray objectAtIndex:0];
        }
        
        if ([media.type isEqualToString:@"1"] && mediadata.data==nil) {
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            NSBlockOperation *fetchStreamOperation = [[NSBlockOperation alloc] init];
            [fetchStreamOperation addExecutionBlock:^{
                NSURL *url = [NSURL URLWithString:media.name];
                NSData *nsdata = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:nsdata];
                mediadata.data = UIImagePNGRepresentation(image);
                
                mediadata.media_id =  zoomMediaID;
                NSError *error = nil;
                if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                photoFormViewHolder.hidden=false;
                
                [self photoView:zoomMediaID];
            }];
            [queue addOperation:fetchStreamOperation];
        }
        
        if (![media.type isEqualToString:@"1"] && mediadata.video_data==nil) {
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            NSBlockOperation *fetchStreamOperation = [[NSBlockOperation alloc] init];
            [fetchStreamOperation addExecutionBlock:^{
                
                NSURL *url = [NSURL URLWithString:media.name];
                NSData *nsdata = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:nsdata];
                mediadata.video_data = UIImagePNGRepresentation(image);
                
                mediadata.media_id =  zoomMediaID;
                NSError *error = nil;
                if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                [self photoView:zoomMediaID];
            }];
            [queue addOperation:fetchStreamOperation];
        }
        if (mediadata.video_data!=nil||mediadata.data!=nil)     [self photoView:zoomMediaID];
    }else{
        NSLog(@"==>>>> !not found in db media id %@",zoomMediaID);
    }
}

#pragma mark - Views

- (void)dayView{

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@",  [UserDataSingleton sharedSingleton].idFriend];
    [fetchRequest setPredicate:predicate];
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSString *filename=[NSString stringWithFormat:@"myday_hour%@",   fileSufix];
    UIImage *imageIcon=[UIImage imageNamed:filename];
    
    filename=[NSString stringWithFormat:@"my_timeday_icon_photo%@",  fileSufix];
    UIImage *imagePhoto=[UIImage imageNamed:filename];
    
    filename=[NSString stringWithFormat:@"myday_count%@", fileSufix];
    UIImage *imageCounter=[UIImage imageNamed:filename];
    
    // Clear the subviews
    for (UIView *subview in dayFormViewHolder.subviews) {
        [subview removeFromSuperview];
    }
    
    int row = 0, column = 0;
    int cellSize = 285 * scale;
    int l=0, NumOfMedia=0;
    
    NSString *serverCounter;
    CGRect size;
    NSString *str;
    
    for (int i = 0; i < 24; i++) {
        
        row = floor(l / 2);
        column = floor (l % 2);
        
        photoImage=nil;
        int mediaCounter=0;
        for(int k = 0; k < [mediasArray count]; k++) {
            
            media  = [mediasArray objectAtIndex:k];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *myDate = [df dateFromString: media.time];

            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
            NSCalendar * cal = [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:unitFlags fromDate:myDate];

            int hour = [comps hour];
            if(hour==i){
                serverCounter = media.counter;
                photoImage=[UIImage imageWithData:media.preview_data];
                if(mediaCounter==0 && photoImage!=nil)  l++;
                mediaCounter++;
            }
        }
        if(mediaCounter){
            NumOfMedia++;
            if (photoImage == nil)     photoImage=imagePhoto;
            if ([serverCounter intValue] > mediaCounter)       mediaCounter=[serverCounter intValue];
            
            // PhotoImageView
            widthSpace = (screenWidth - cellSize * 2) / 3;
            heightSpace = (screenWidth - cellSize * 2) / 3;
            size.size.width = cellSize;
            size.size.height = cellSize;
            size.origin.x = column * cellSize + (column + 1) * widthSpace;
            size.origin.y = row * cellSize + (row + 1) * heightSpace;
            photoPAImageView = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
            [photoPAImageView setImage:photoImage];
            UIButton *zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            zoomButton.frame = photoPAImageView.frame;
            zoomButton.tag = i;
            [zoomButton addTarget:self action:@selector(zoomHourButton:) forControlEvents:UIControlEventTouchUpInside];
            [dayFormViewHolder addSubview:photoPAImageView];
            [dayFormViewHolder addSubview:zoomButton];
            
            // Time icon
            size.size.width = imageIcon.size.width * scale;
            size.size.height = imageIcon.size.height * scale;
            size.origin.x = photoPAImageView.frame.origin.x + photoPAImageView.frame.size.width - size.size.width;
            size.origin.y = photoPAImageView.frame.origin.y;
            
            PAImageView* imageViewIcon = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
            [imageViewIcon setImage:imageIcon];
            [dayFormViewHolder addSubview:imageViewIcon];
            
            // Time label
            heightSpace = 36 * scale;
            widthSpace = 18 * scale;
            if(i< 12){    str = [NSString stringWithFormat:@"%d am",   i];          }
            if(i==12){    str = [NSString stringWithFormat:@"%d pm",   12];         }
            if(i> 12){    str = [NSString stringWithFormat:@"%d pm",   i-12];       }
            size.size = [str sizeWithAttributes:@{NSFontAttributeName:font4}];
            size.origin.x = widthSpace;
            size.origin.y = heightSpace;
            UILabel *timeLabel =[[UILabel alloc] initWithFrame:size];
            timeLabel.text = str;
            timeLabel.textColor        = buttonColor;
            timeLabel.font             = font4;
            timeLabel.backgroundColor  = [UIColor clearColor];
            [imageViewIcon addSubview:timeLabel];
            
            // counter icon
            widthSpace = 14 * scale;
            heightSpace = 5 * scale;
            size.size.width = imageCounter.size.width * scale;
            size.size.height = imageCounter.size.height * scale;
            size.origin.x = photoPAImageView.frame.origin.x + widthSpace;
            size.origin.y = photoPAImageView.frame.origin.y + photoPAImageView.frame.size.height - heightSpace - size.size.height;
            
            UIImageView* imageViewCounter = [[UIImageView alloc] initWithImage:imageCounter];
            imageViewCounter.frame = size;
            [dayFormViewHolder addSubview:imageViewCounter];
            
            // counter label
            heightSpace = 20 * scale;
            widthSpace = 43 * scale;
            str = [NSString stringWithFormat:@"%d",   mediaCounter];
            size.size = [str sizeWithAttributes:@{NSFontAttributeName:font4}];
            size.origin.x = widthSpace;
            size.origin.y = heightSpace;
            
            UILabel *counterLabel;
            counterLabel =[[UILabel alloc] initWithFrame:size];
            counterLabel.text             = str;
            counterLabel.textColor        = buttonColor;
            counterLabel.font             = font4;
            counterLabel.backgroundColor  = [UIColor clearColor];
            [imageViewCounter addSubview:counterLabel];
        }
    }
    
    if(NumOfMedia==0) {
        CGRect sizeLabel;
        sizeLabel.size = [@"THERE ARE NO ACTIONS TODAY" sizeWithAttributes:@{NSFontAttributeName:font1}];
        sizeLabel.origin.x = (screenWidth - sizeLabel.size.width) / 2;
        sizeLabel.origin.y = (screenHeight - sizeLabel.size.height) / 2;
        UILabel *label = [[UILabel alloc] initWithFrame:sizeLabel];
        label.text          = @"There are no actions today";
        label.textColor = lightTextColor;
        label.font          = font1;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
    }
    
    [dayScrollView setContentSize:(CGSizeMake(self.view.frame.size.width, cellSize*row*4))];
    
    dayFormViewHolder.hidden=false;
    dayScrollView.hidden=false;
}

- (void)hourView:(int)selectedHour{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@",  [UserDataSingleton sharedSingleton].idFriend];
    [fetchRequest setPredicate:predicate];
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    NSString *filename;
    filename=[NSString stringWithFormat:@"myday_hour%@", fileSufix];
    UIImage *imageIcon=[UIImage imageNamed:filename];
    filename=[NSString stringWithFormat:@"my_timeday_icon_video_prev%@",   fileSufix];
    UIImage *imageVideo=[UIImage imageNamed:filename];
    
    // Clear the subviews
    for (UIView *subview in hourFormViewHolder.subviews) {
        [subview removeFromSuperview];
    }
    
    int titleHight1=titleHight/1.5;
    
    // Time label
    UILabel *hourLabel;
    hourLabel =[[UILabel alloc] initWithFrame: CGRectMake(self.view.frame.size.width*0.45,titleHight1*0.3, 40,20)];
    NSString *time;
    
    if(selectedHour<12){
        time  = [NSString stringWithFormat:@"%dam",   selectedHour];
    } else if(selectedHour==12){
        time  = [NSString stringWithFormat:@"%dpm",   12];
    } else {
        time  = [NSString stringWithFormat:@"%dpm",   selectedHour-12];
    }
    hourLabel.text             = time;
    hourLabel.textColor        = buttonColor;
    hourLabel.font             = font4;
    hourLabel.backgroundColor  = [UIColor clearColor];
    
    //[hourFormViewHolder addSubview:hourLabel];
    titleLabel1.text = time;
    
    int row = 0,column = 0;
    int cellSize=self.view.frame.size.width/2;
    int k=0;
    
    for (int i = 0; i < [mediasArray count]; i++) {
        [zoomButtonArray insertObject:@"" atIndex:i];
        photoImage=nil;
        
        media  = [mediasArray objectAtIndex:i];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *myDate = [df dateFromString: media.time];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
        NSCalendar * cal = [NSCalendar currentCalendar];
        NSDateComponents *comps = [cal components:unitFlags fromDate:myDate];
        
        int hour = [comps hour];
        if(hour==selectedHour){
            photoImage=[UIImage imageWithData:media.preview_data];
            NSString *sMinute;
            if([comps minute]<10){
                sMinute =[NSString stringWithFormat:@"0%d", [comps minute]];
            }else{
                sMinute =[NSString stringWithFormat:@"%d" , [comps minute]];
            }
            if(hour< 12){  time  = [NSString stringWithFormat:@"%d:%@am",   hour    ,sMinute]; }
            if(hour==12){  time  = [NSString stringWithFormat:@"%d:%@pm",   12      ,sMinute]; }
            if(hour> 12){  time  = [NSString stringWithFormat:@"%d:%@pm",   hour-12 ,sMinute]; }
        }
        
        if(photoImage!=nil){
            row     = floor (k / 2);
            column  = floor (k % 2);
            k++;
            
            photoImageView = [[UIImageView alloc] initWithImage:photoImage];
            photoImageView.frame = CGRectMake((column * cellSize), (row * cellSize), cellSize, cellSize);
            
            UIButton *zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            zoomButton.frame = photoImageView.frame;
            zoomButton.tag = i;
            [zoomButtonArray insertObject:[NSString stringWithFormat:@"%@", media.media_id] atIndex:i];
            zoomButton.titleLabel.text = time;
            [zoomButton addTarget:self action:@selector(zoomImage:) forControlEvents:UIControlEventTouchUpInside];
            [hourFormViewHolder addSubview:zoomButton];
            [hourFormViewHolder addSubview:photoImageView];
            
            UIImageView* imageViewIcon = [[UIImageView alloc] initWithImage:imageIcon];
            imageViewIcon.frame = CGRectMake((column * cellSize)+cellSize*0.05, (row * cellSize)+cellSize*0.05, cellSize/3, cellSize/3);
            [hourFormViewHolder addSubview:imageViewIcon];
            
            // Time label
            UILabel *timeLabel;
            timeLabel =[[UILabel alloc] initWithFrame: CGRectMake((column * cellSize)+cellSize*0.09,
                                                                  (row * cellSize)+cellSize*0.05,cellSize/3, cellSize/3)];
            timeLabel.text             = time;
            timeLabel.textColor        = buttonColor;
            timeLabel.font             = font4;
            timeLabel.backgroundColor  = [UIColor clearColor];
            [hourFormViewHolder addSubview:timeLabel];
            if(![media.type isEqualToString:@"1"]){
                UIImageView* imageVideoIcon = [[UIImageView alloc] initWithImage:imageVideo];
                imageVideoIcon.frame = CGRectMake((column * cellSize)+cellSize*0.3, (row * cellSize)+cellSize*0.35, cellSize/3, cellSize/3);
            }
        }
    }
    
    [hourScrollView setContentSize:(CGSizeMake(self.view.frame.size.width, cellSize*(row+1)))];
    
    dayFormViewHolder.hidden = true;
    hourFormViewHolder.hidden = false;
    dayScrollView.hidden = true;
    hourScrollView.hidden = false;
}

- (void)photoView:(NSString *)photoNum{
    
    [UserDataSingleton sharedSingleton].photoView = true;
    [UserDataSingleton sharedSingleton].selectedMediaID = [NSString stringWithFormat:@"%@", photoNum];
    zoomMediaID = [UserDataSingleton sharedSingleton].selectedMediaID;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@", photoNum ];
    
    [fetchRequest setPredicate:predicate];
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Mediasdata"
                         inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    requestError = nil;
    error = nil;
    predicate = [NSPredicate predicateWithFormat:@"media_id==%@", photoNum ];
    [fetchRequest setPredicate:predicate];
    mediasdataArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    int cellSize=self.view.frame.size.width;
    
    // Clear the subviews
    for (UIView *subview in photoFormViewHolder.subviews) {
        [subview removeFromSuperview];
    }
    if([mediasArray count]>0) {
        media = [mediasArray objectAtIndex:0];
        mediadata = [mediasdataArray objectAtIndex:0];
        
        if ([photoNum isEqualToString:media.media_id] && mediadata.data!=nil) {
            
            NSString *filename, *str;
            UIImage *image;
            CGRect size;
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            NSDate *myDate = [df dateFromString: media.time];
            
            unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
            NSCalendar * cal = [NSCalendar currentCalendar];
            NSDateComponents *comps = [cal components:unitFlags fromDate:myDate];
            
            int hour = [comps hour];
            int minute = [comps minute];
            NSString *sMinute, *titleTime;
            
            if([comps minute]<10){
                sMinute =[NSString stringWithFormat:@"0%d", minute];
            }else{
                sMinute =[NSString stringWithFormat:@"%d" , minute];
            }
            if(hour< 12){  titleTime  = [NSString stringWithFormat:@"%d:%@am",   hour    ,sMinute]; }
            if(hour==12){  titleTime  = [NSString stringWithFormat:@"%d:%@pm",   12      ,sMinute]; }
            if(hour> 12){  titleTime  = [NSString stringWithFormat:@"%d:%@pm",   hour-12 ,sMinute]; }
            titleLabel1.text = titleTime;
            
            
            photoImage=[UIImage imageWithData:mediadata.data];
            photoImageView = [[UIImageView alloc] initWithImage:photoImage];
            
            photoImageView.frame = CGRectMake(0, 0,
                                              cellSize, cellSize / photoImage.size.width * photoImage.size.height);
            
            imageViewFull = [[UIImageView alloc] initWithImage:photoImage];
            imageViewFull.frame = CGRectMake(0, 0,
                                             (cellSize/photoImage.size.width)* photoImage.size.width, (cellSize/photoImage.size.width)*photoImage.size.height);
            
            UIButton *zoomButton = [UIButton buttonWithType:UIButtonTypeCustom];
            zoomButton.frame = photoImageView.frame;
            zoomButton.tag = [media.media_id intValue];
            [zoomButton addTarget:self action:@selector(showFullImage:) forControlEvents:UIControlEventTouchUpInside];
            [photoFormViewHolder addSubview:zoomButton];
            [photoFormViewHolder addSubview:photoImageView];
            
            // Info Title Background
            filename=[NSString stringWithFormat:@"comments_title_background%@", fileSufix];
            image = [UIImage imageNamed:filename];
            size.size.width = screenWidth;
            size.size.height = image.size.height / image.size.width * size.size.width;
            size.origin.x = 0;
            size.origin.y = photoImageView.frame.origin.y + photoImageView.frame.size.height;
            UIImageView *infoBackgroundView = [[UIImageView alloc] initWithFrame:size];
            [infoBackgroundView setImage:image];
            infoBackgroundView.backgroundColor = [UIColor clearColor];
            [photoFormViewHolder addSubview:infoBackgroundView];
            
            // Share
            widthSpace = 360 * scale;
            filename = [NSString stringWithFormat:@"comments_share%@", fileSufix];
            UIImage *shareImage = [UIImage imageNamed:filename];
            CGRect sizeShareButton;
            sizeShareButton.size.height = shareImage.size.height * scale;
            sizeShareButton.size.width  = shareImage.size.width * scale;
            sizeShareButton.origin.y    = infoBackgroundView.frame.origin.y + (infoBackgroundView.frame.size.height - sizeShareButton.size.height) / 2;
            sizeShareButton.origin.x    = widthSpace;
            shareButton = [[UIButton alloc] initWithFrame:sizeShareButton];
            [shareButton setBackgroundColor:[UIColor clearColor]];
            [shareButton setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"comments_share_down%@", fileSufix];
            [shareButton setImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            if (![media.type isEqualToString:@"1"])   shareButton.tag = 408;
            else     shareButton.tag = 407;
            [shareButton addTarget:self action:@selector(shareButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [photoFormViewHolder addSubview:shareButton];
            
            // share label
            widthSpace = 20 * scale;
            size.size = [@"Share" sizeWithAttributes:@{NSFontAttributeName:font5}];
            size.origin.x = shareButton.frame.origin.x + shareButton.frame.size.width + widthSpace;
            size.origin.y = infoBackgroundView.frame.origin.y + (infoBackgroundView.frame.size.height - size.size.height) / 2;
            UILabel *shareLabel =[[UILabel alloc] initWithFrame: size];
            shareLabel.text             = @"Share";
            shareLabel.textColor        = lightTextColor;
            shareLabel.font             = font5;
            shareLabel.backgroundColor  = [UIColor clearColor];
            [photoFormViewHolder addSubview:shareLabel];
            
            //Like
            widthSpace = 184 * scale;
            filename = [NSString stringWithFormat:@"comments_like%@", fileSufix];
            UIImage *likeImage = [UIImage imageNamed:filename];
            CGRect sizeLikeButton;
            sizeLikeButton.size.height = likeImage.size.height * scale;
            sizeLikeButton.size.width  = likeImage.size.width * scale;
            sizeLikeButton.origin.y    = sizeShareButton.origin.y;
            sizeLikeButton.origin.x    = screenWidth -  widthSpace;
            likeButton = [[UIButton alloc] initWithFrame:sizeLikeButton];
            [likeButton setBackgroundColor:[UIColor clearColor]];
            [likeButton setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"comments_like_down%@", fileSufix];
            [likeButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            if (![media.type isEqualToString:@"1"]) { likeButton.tag = 408;
            } else {                             likeButton.tag = 407;            }
            [likeButton addTarget:self action:@selector(likeButtonPress) forControlEvents:UIControlEventTouchUpInside];
            [photoFormViewHolder addSubview:likeButton];
            
            // like label
            widthSpace = 20 * scale;
            str = [NSString stringWithFormat:@"%d ", nLikes];
            size.size = [str sizeWithAttributes:@{NSFontAttributeName:font5}];
            size.origin.x = likeButton.frame.origin.x + likeButton.frame.size.width + widthSpace;
            size.origin.y = infoBackgroundView.frame.origin.y + (infoBackgroundView.frame.size.height - size.size.height) / 2;
            likeLabel =[[UILabel alloc] initWithFrame: size];
            likeLabel.text             = str;
            likeLabel.textColor        = lightTextColor;
            likeLabel.font             = font5;
            likeLabel.backgroundColor  = [UIColor clearColor];
            [photoFormViewHolder addSubview:likeLabel];
            
            // Comments
            widthSpace = 108 * scale;
            filename = [NSString stringWithFormat:@"comments_comment%@", fileSufix];
            UIImage *commentImage = [UIImage imageNamed:filename];
            CGRect sizeCommentButton;
            sizeCommentButton.size.width = commentImage.size.width * scale;
            sizeCommentButton.size.height = commentImage.size.height * scale;
            sizeCommentButton.origin.y    = sizeShareButton.origin.y;
            sizeCommentButton.origin.x    = widthSpace;
            commentButton = [[UIButton alloc] initWithFrame:sizeCommentButton];
            [commentButton setBackgroundColor:[UIColor clearColor]];
            [commentButton setImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"comments_comment_down%@", fileSufix];
            [commentButton setImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            if (![media.type isEqualToString:@"1"]) {  commentButton.tag = 408;
            } else {                              commentButton.tag = 407;            }
            [commentButton addTarget:self action:@selector(commentButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            [photoFormViewHolder addSubview:commentButton];
            
            // comment label
            widthSpace = 20 * scale;
            str = [NSString stringWithFormat:@"%d ", nComments];
            size.size = [str sizeWithAttributes:@{NSFontAttributeName:font5}];
            size.origin.x = commentButton.frame.origin.x + commentButton.frame.size.width + widthSpace;
            size.origin.y = infoBackgroundView.frame.origin.y + (infoBackgroundView.frame.size.height - size.size.height) / 2;
            commentLabel =[[UILabel alloc] initWithFrame: size];
            commentLabel.text             = str;
            commentLabel.textColor        = lightTextColor;
            commentLabel.font             = font5;
            commentLabel.backgroundColor  = [UIColor clearColor];
            [photoFormViewHolder addSubview:commentLabel];
            
            // comment input button
            widthSpace = 30 * scale;
            heightSpace = 40 * scale;
            filename=[NSString stringWithFormat:@"comments_input%@",  fileSufix];
            image = [UIImage imageNamed:filename];
            sizeTextField.size.width = image.size.width * scale;
            sizeTextField.size.height = image.size.height * scale;
            sizeTextField.origin.x = widthSpace;
            sizeTextField.origin.y = infoBackgroundView.frame.origin.y + infoBackgroundView.frame.size.height + heightSpace;
            commentTextFieldButton = [[UIButton alloc] initWithFrame:sizeTextField];
            [commentTextFieldButton setImage:image forState:UIControlStateNormal];
            [commentTextFieldButton addTarget:self action:@selector(commentView) forControlEvents:UIControlEventTouchUpInside];
            [photoFormViewHolder addSubview:commentTextFieldButton];
            
            // audio record button
            widthSpace = 27 * scale;
            filename=[NSString stringWithFormat:@"comments_record%@",  fileSufix];
            image = [UIImage imageNamed:filename];
            size.size.width = image.size.width * scale;
            size.size.height = image.size.height * scale;
            size.origin.x = screenWidth - widthSpace - size.size.width;
            size.origin.y = commentTextFieldButton.frame.origin.y;
            
            recordButton = [[UIButton alloc] initWithFrame:size];
            [recordButton setImage:image forState:UIControlStateNormal];
            filename=[NSString stringWithFormat:@"comments_record_down%@",  fileSufix];
            [recordButton setImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            [recordButton addTarget:self action:@selector(audioRecordView) forControlEvents:UIControlEventTouchUpInside];
            [photoFormViewHolder addSubview:recordButton];
            
            voiceHud = [[POVoiceHUD alloc] initWithParentView:self.view];
            voiceHud.title = @"Speak Now";
            
            [voiceHud setDelegate:self];
            [self.view addSubview:voiceHud];
        }
    }
    [photoScrollView setContentSize:(CGSizeMake(self.view.frame.size.width, commentTextFieldButton.frame.origin.y + commentTextFieldButton.frame.size.height + titleHight))];
    
    hourFormViewHolder.hidden = true;
    photoFormViewHolder.hidden = false;
    hourScrollView.hidden = true;
    photoScrollView.hidden = false;
    
    [self.view addSubview:hud];
    
    [self getComments];
}

-(void)audioRecordView
{
    [voiceHud startForFilePath:[NSString stringWithFormat:@"%@/Documents/MySound.caf", NSHomeDirectory()]];
    
}
-(void)commentView
{
    photoScrollView.hidden = true;
    
    photoFormViewHolder.hidden = true;
    commentFormViewHolder.hidden = false;
    
    NSString *filename;
    UIImage *image;
    CGRect size;
    
    // background
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    if([UserDataSingleton sharedSingleton].IOSDevice!=5){
        filename=[NSString stringWithFormat:@"background%@",   fileSufix];
    }else{
        filename=[NSString stringWithFormat:@"background%@",   fileSufix];
    }
    image=[UIImage imageNamed:filename];
    [background setImage:image];
    [commentFormViewHolder addSubview:background];
    
    // Title Background
    filename=[NSString stringWithFormat:@"title_background%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = screenWidth;
    size.size.height = image.size.height / image.size.width * size.size.width;
    size.origin.x = 0;
    size.origin.y = 0;
    UIImageView *titleBackgroundView = [[UIImageView alloc] initWithFrame:size];
    [titleBackgroundView setImage:image];
    titleBackgroundView.backgroundColor = [UIColor clearColor];
    [commentFormViewHolder addSubview:titleBackgroundView];
    
    // close button
    filename=[NSString stringWithFormat:@"comments_input_close%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width  = image.size.width * scale;
    size.origin.y    = (titleBackgroundView.frame.size.height - size.size.height) / 2;
    size.origin.x    = 0;
    cancelButton = [[UIButton alloc] initWithFrame:size];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    [cancelButton setImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"comments_input_close_down%@",   fileSufix];
    [cancelButton setImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(commentCancelPress) forControlEvents:UIControlEventTouchUpInside];
    [commentFormViewHolder addSubview:cancelButton];
    
    // send button
    widthSpace = 34 * scale;
    filename=[NSString stringWithFormat:@"comments_input_send%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    sizeCommentSend.size.height = image.size.height * scale;
    sizeCommentSend.size.width  = image.size.width * scale;
    sizeCommentSend.origin.y    = (titleBackgroundView.frame.size.height - sizeCommentSend.size.height) / 2;
    sizeCommentSend.origin.x    = screenWidth - widthSpace - sizeCommentSend.size.width;
    
    commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setFrame:sizeCommentSend];
    [commentButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"comments_input_send_down%@",   fileSufix];
    [commentButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [commentButton setBackgroundColor:[UIColor clearColor]];
    [commentButton setTitle:@"Send" forState:UIControlStateNormal];
    [commentButton setTitleColor:logoutTextColor forState:UIControlStateNormal];
    commentButton.titleLabel.font = font3;
    [commentButton addTarget:self action:@selector(commentSendPress:) forControlEvents:UIControlEventTouchUpInside];
    [commentFormViewHolder addSubview:commentButton];
    
    // comment background
    heightSpace = 18 * scale;
    filename=[NSString stringWithFormat:@"comments_input_input%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = titleBackgroundView.frame.size.height + heightSpace;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:size];
    [imageView setImage:image];
    imageView.backgroundColor = [UIColor clearColor];
    [commentFormViewHolder addSubview:imageView];
    
    // comment input
    filename=[NSString stringWithFormat:@"comments_input_input%@",   fileSufix];
    image = [UIImage imageNamed:filename];
    sizeTextField.size.height = image.size.height * scale;
    sizeTextField.size.width = image.size.width * scale;
    sizeTextField.origin.x = (screenWidth - sizeTextField.size.width) / 2;
    sizeTextField.origin.y = titleBackgroundView.frame.size.height + heightSpace;
    
    InputTextColor = [UIColor colorWithRed:96.0f/255.0f green:206.0f/255.0f blue:244.0f/255.0f alpha:1];
    commentTextView = [[UITextView alloc] initWithFrame:sizeTextField];
    commentTextView.backgroundColor = [UIColor clearColor];
    commentTextView.textColor = InputTextColor;
    commentTextView.font = font3;
    commentTextView.returnKeyType = UIReturnKeyNext;
    commentTextView.delegate = self;
    commentTextView.text = @"";
    commentTextView.textAlignment = NSTextAlignmentLeft;
    commentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    [self showKeyboard];
    
    [commentFormViewHolder addSubview:commentTextView];
}

#pragma mark - POVoiceHUD Delegate

- (IBAction)btnPlayTapped:(id)sender
{
//    for (int i=0;i<[audioButtonArray count];i++){
//        UIButton *btn = [audioButtonArray objectAtIndex:i];
//        btn.selected  = false;
//    }
//    [audioPlayer stop];
    UIButton *button = (UIButton *)sender;
    if (button.selected == false) {
        button.selected = true;
        NSDictionary *commentsDictionary = [commentsArray objectAtIndex:button.tag];
        NSString *media_id     = [commentsDictionary objectForKey:@"id"];
        
        NSError *requestError = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                                  inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@", media_id];
        [fetchRequest setPredicate:predicate];
        
        mediasArray = [[CoreDataManager sharedManager].managedObjectContext
                       executeFetchRequest:fetchRequest error:&requestError];
        if ([mediasArray count] > 0){
            media  = [mediasArray objectAtIndex:0];
            
            audioPlayer = [[AVAudioPlayer alloc] initWithData:media.preview_data  error:NULL];
            self.audioPlayer.delegate = self;
            [audioPlayer play];
        }
        
        mediasArray = [NSArray arrayWithObjects:  nil];
    } else {
        button.selected = false;
        [audioPlayer stop];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag==YES) {
        for (int i=0;i<[audioButtonArray count];i++){
            UIButton *btn = [audioButtonArray objectAtIndex:i];
            btn.selected  = false;
        }
    }
}

- (void)POVoiceHUD:(POVoiceHUD *)voiceHUD voiceRecorded:(NSString *)recordPath length:(float)recordLength {
    NSLog(@"Sound recorded with file %@ for %.2f seconds", [recordPath lastPathComponent], recordLength);
    [self audioSendPress];
    
}

- (void)voiceRecordCancelledByUser:(POVoiceHUD *)voiceHUD {
    NSLog(@"Voice recording cancelled for HUD: %@", voiceHUD);
}

- (void)audioSendPress{
    
    NSURL *audio_url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Documents/MySound.caf", NSHomeDirectory()]];
    NSData *audioData = [NSData dataWithContentsOfURL:audio_url options:0 error:NULL];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"comments/add_audio_comment"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"add_audio_comment" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:zoomMediaID forKey:@"media_id"];
    [request setData:audioData withFileName:@"audio.caf" andContentType:@"multipart/form-data" forKey:@"audio_comment"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

#pragma mark - Server Request


-(void)loadMedia
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@&media_id=%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/media_info", [UserDataSingleton sharedSingleton].session, [UserDataSingleton sharedSingleton].shareMediaId]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"media_info" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

-(void)loadMedias
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@&friend_id=%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/medias_for_friend", [UserDataSingleton sharedSingleton].session, [UserDataSingleton sharedSingleton].idFriend]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"medias_for_friend" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)sendLike {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/like"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"send_like" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:zoomMediaID forKey:@"media_id"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)getComments {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?media_id=%@&token=%@", [UserDataSingleton sharedSingleton].serverURL, @"comments", zoomMediaID, [UserDataSingleton sharedSingleton].session]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"comments" forKey:@"type"];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

#pragma mark - Button Presss
- (void)backButtonPress {
    
    if ([UserDataSingleton sharedSingleton].showButtonPressed) {
        [UserDataSingleton sharedSingleton].showButtonPressed = false;
        // Clear the subviews
        for (UIView *subview in photoFormViewHolder.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in hourFormViewHolder.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in dayFormViewHolder.subviews) {
            [subview removeFromSuperview];
        }
        for (UIView *subview in commentFormViewHolder.subviews) {
            [subview removeFromSuperview];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
        
    }
    if(!dayFormViewHolder.hidden)  {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    if(!hourFormViewHolder.hidden){
        dayFormViewHolder.hidden=false;
        hourFormViewHolder.hidden=true;
        photoFormViewHolder.hidden=true;
        commentFormViewHolder.hidden = true;
        
        dayScrollView.hidden=false;
        hourScrollView.hidden=true;
        photoScrollView.hidden=true;
        
        [self dayView];
        return;
    }
    if(!photoFormViewHolder.hidden){
        
        [UserDataSingleton sharedSingleton].photoView = false;
        
        dayFormViewHolder.hidden=true;
        hourFormViewHolder.hidden=false;
        photoFormViewHolder.hidden=true;
        commentFormViewHolder.hidden = true;
        
        dayScrollView.hidden=true;
        hourScrollView.hidden=false;
        photoScrollView.hidden=true;
        
        fullImageShown=false;
        titleBackground.hidden=false;
        userImage.hidden=false;
        titleLabel.hidden=false;
        iconImage.hidden=false;
        
        [self hourView:currentHour];
        return;
    }
    if(!commentFormViewHolder.hidden){
        dayFormViewHolder.hidden = true;
        hourFormViewHolder.hidden = true;
        photoFormViewHolder.hidden = false;
        commentFormViewHolder.hidden = true;
        
        dayScrollView.hidden = true;
        hourScrollView.hidden = true;
        photoScrollView.hidden = false;
        
        [commentTextView resignFirstResponder];
        [self photoView:[UserDataSingleton sharedSingleton].selectedMediaID];
        return;
    }
}

- (void)zoomHourButton:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    currentHour = button.tag;
    dayFormViewHolder.hidden = true;
    photoFormViewHolder.hidden = true;
    hourFormViewHolder.hidden = false;
    commentFormViewHolder.hidden = true;
    
    dayScrollView.hidden = true;
    photoScrollView.hidden = true;
    hourScrollView.hidden = false;
    [self hourView:currentHour];
}

- (void)showFullImage:(id)sender{
    
    FullPhotoViewController *subVC;
    if(subVC==nil)    subVC = [[FullPhotoViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}

-(void)shareButtonPress:(UIButton*)button {
    
    if (![zoomMediaID isEqualToString:@"0"]) {
        ShareViewController *subVC;
        if (subVC == nil) subVC = [[ShareViewController alloc] init];
        subVC.numberMedia = zoomMediaID;
        subVC.typeMedia = [NSString stringWithFormat:@"%i", button.tag];
        [self presentViewController:subVC animated:YES completion:nil];
    }
}

-(void)likeButtonPress {
    
    if (![zoomMediaID isEqualToString:@"0"]) {
        [self sendLike];
    }
}

- (void)commentCancelPress{
    photoScrollView.hidden = false;
    
    dayFormViewHolder.hidden = true;
    hourFormViewHolder.hidden = true;
    photoFormViewHolder.hidden = false;
    commentFormViewHolder.hidden = true;
    
    [commentTextView resignFirstResponder];
}

- (void)commentSendPress:(id)sender{
    if (![commentTextView.text isEqualToString:@""]){
        NSString *subString;
        if (commentTextView.text.length > 500)
            subString = [commentTextView.text substringToIndex:500];
        subString = commentTextView.text;
        
        [commentTextView resignFirstResponder];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"comments/add_comment"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"add_comment" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:zoomMediaID forKey:@"media_id"];
        [request setPostValue:subString forKey:@"comment"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    }
}

-(void)commentButtonPress:(UIButton*)button {

    if (![zoomMediaID isEqualToString:@"0"]) {
        //[self showComments];
    }
}

#pragma mark - Callback Functions

-(void)saveToMedia:(NSDictionary *)data
{
    NSLog(@"%@", data);
    commentsArray = [data objectForKey:@"comments"];
    NSDictionary *commentsDictionary = [commentsArray objectAtIndex:0];
    
    media = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    
    if(media != nil) {
        media.media_id  = [commentsDictionary objectForKey:@"id"];
        media.user_id   = [UserDataSingleton sharedSingleton].idUser;
        media.thumb   = [commentsDictionary objectForKey:@"media_id"];
        media.type      = @"2";
        
        NSURL *url =  [NSURL URLWithString:[commentsDictionary objectForKey:@"message"]];
        NSData *soundData = [NSData dataWithContentsOfURL:url];
        media.preview_data = soundData;
        
        NSError *error = nil;
        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
    } else {
        NSLog(@"new media failed to create");
    }
}

- (void)func:(NSDictionary *)data
{
    NSString *str;
    CGRect size;
    nComments=0;
    commentsArray = [data objectForKey:@"comments"];
    nLikes = [[data objectForKey:@"like_count"] intValue];
    likeLabel.text = [NSString stringWithFormat:@"%d", nLikes];
    
    if(commentsArray && [commentsArray count] > 0) {
        nComments=[commentsArray count];
        commentLabel.text = [NSString stringWithFormat:@"%d comments", nComments];
        
        for (UILabel *item in usernameLabelArray){
            [item removeFromSuperview];
        }
        
        for (UILabel *item in messageLabelArray){
            [item removeFromSuperview];
        }
        for (UILabel *item in audioButtonArray){
            [item removeFromSuperview];
        }
        usernameLabelArray = [[NSMutableArray alloc] init];
        messageLabelArray = [[NSMutableArray alloc] init];
        audioButtonArray = [[NSMutableArray alloc] init];
        
        int rowY=commentTextFieldButton.frame.origin.y + commentTextFieldButton.frame.size.height + 10;
        
        UILabel *usernameLabel;
        UITextView *messageTextView;
        UIButton *audioButton;
        UIImage *audioImage, *audioImageSelected;
        NSString *filename;
        CGRect newFrame = self.view.frame;
        
        filename=[NSString stringWithFormat:@"comments_stop%@",   fileSufix];
        audioImage=[UIImage imageNamed:filename];
        
        filename=[NSString stringWithFormat:@"comments_play%@",   fileSufix];
        audioImageSelected=[UIImage imageNamed:filename];
        
        for (int i = 0; i < [commentsArray count]; i++) {
            
            NSDictionary *commentsDictionary = [commentsArray objectAtIndex:i];
            NSString *name     = [commentsDictionary objectForKey:@"user_name"];
            NSString *message  = [commentsDictionary objectForKey:@"message"];
            int comment_type  = [[commentsDictionary objectForKey:@"comment_type"] intValue];
//            NSString *avatar   = [commentsDictionary objectForKey:@"avatar"];
//            
//            NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL, avatar];
//            NSURL  *url = [NSURL URLWithString:stringUrl];
//            NSData *userAvatarData = [NSData dataWithContentsOfURL:url];
//            
//            UIImage *image=[UIImage imageWithData:userAvatarData];
//            UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
//            imageView.frame= CGRectMake(10, rowY, 50, 50);
//            [photoFormViewHolder addSubview:imageView];
            
            // username
            widthSpace = 38 * scale;
            str = [NSString stringWithFormat:@"%@",  name];
            size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y = rowY;
            usernameLabel =[[UILabel alloc] initWithFrame: size];
            usernameLabel.text             = str;
            usernameLabel.textColor        = darkTextColor;
            usernameLabel.font             = font3;
            usernameLabel.backgroundColor  = [UIColor clearColor];
            [photoFormViewHolder addSubview:usernameLabel];
            [usernameLabelArray addObject:usernameLabel];
            
            heightSpace = 6 * scale;
            rowY = rowY + usernameLabel.frame.size.height + heightSpace;
            
            // message
            if (comment_type == 1){
                widthSpace = 168 * scale;
                size.size.height = 40 * scale;
                size.size.width = 400 * scale;
                size.origin.x = widthSpace;
                size.origin.y = rowY;
                messageTextView =[[UITextView alloc] initWithFrame: size];
                messageTextView.text             = message;
                messageTextView.textColor        = lightTextColor;
                messageTextView.font             = font3;
                messageTextView.editable         = false;
                messageTextView.backgroundColor  = [UIColor clearColor];
                messageTextView.scrollEnabled = NO;
                [messageTextView sizeToFit];
                
                [photoFormViewHolder addSubview:messageTextView];
                [messageLabelArray addObject:messageTextView];
                
                heightSpace = 0 * scale;
                rowY = rowY + messageTextView.frame.size.height + heightSpace;
            } else {
                
                NSError *requestError = nil;
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [commentsDictionary objectForKey:@"id"]];
                [fetchRequest setPredicate:predicate];
                
                mediasArray = [[CoreDataManager sharedManager].managedObjectContext
                               executeFetchRequest:fetchRequest error:&requestError];
                if ([mediasArray count] == 0){
                    
                    media = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    
                    if(media != nil) {
                        media.media_id  = [commentsDictionary objectForKey:@"id"];
                        media.user_id   = [UserDataSingleton sharedSingleton].idUser;
                        media.type      = @"2";
                        
                        NSURL *url =  [NSURL URLWithString:[commentsDictionary objectForKey:@"message"]];
                        NSData *soundData = [NSData dataWithContentsOfURL:url];
                        media.preview_data = soundData;
                        
                        NSError *error = nil;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                    } else {
                        NSLog(@"new media failed to create");
                    }
                    
                }
                
                mediasArray = [NSArray arrayWithObjects:  nil];
                
                CGRect audioField;
                widthSpace = 168 * scale;
                audioField.size.width = audioImage.size.width * scale;
                audioField.size.height = audioImage.size.height * scale;
                audioField.origin.x = widthSpace;
                audioField.origin.y = rowY;
                
                audioButton = [[UIButton alloc] initWithFrame:audioField];
                [audioButton setImage:audioImage forState:UIControlStateNormal];
                filename=[NSString stringWithFormat:@"comments_play_down%@",   fileSufix];
                [audioButton setImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
                [audioButton setImage:audioImageSelected forState:UIControlStateSelected];
                [audioButton addTarget:self action:@selector(btnPlayTapped:) forControlEvents:UIControlEventTouchUpInside];
                audioButton.tag = i;
                [photoFormViewHolder addSubview:audioButton];
                
                [audioButtonArray addObject:audioButton];
                
                heightSpace = 6 * scale;
                rowY = rowY + audioButton.frame.size.height + heightSpace;
            }
            
        }
        
        newFrame.size.width  = self.view.frame.size.width;
        newFrame.size.height = rowY + titleHight;
        [photoFormViewHolder setFrame:newFrame];
        [photoScrollView setContentSize:(CGSizeMake(self.view.frame.size.width,newFrame.size.height))];
    }
}

- (void) mediaForFriend_callback:(ASIHTTPRequest *)request_param
{
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
        dataCount=[data count];
    } @catch (NSException *e) {
        dataCount=0;
    }
    
    if (data!=nil && dataCount>0 ){
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
        error = nil;
        mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
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
                    media.user_id   = [UserDataSingleton sharedSingleton].idFriend;
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
        
        [self update];
    } else {
        [self deleteOldMedia];
    }
}

-(void)deleteOldMedia
{
    NSError *error = nil;
    NSError *requestError = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@", [UserDataSingleton sharedSingleton].idFriend];
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
                int day = [comps day];
                
                NSDate *currDate = [NSDate date];
                comps = [cal components:unitFlags fromDate:currDate];
                int currday = [comps day];
                
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
    if (![[CoreDataManager sharedManager].managedObjectContext save:&error]) { NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  }
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
            NSDictionary *message = [json objectForKey:@"message"];
            NSDictionary *data = [json objectForKey:@"data"];
            if ([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY){
                if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"send_like"]) {
                        nLikes = [[data objectForKey:@"like_count"] intValue];
                        likeLabel.text = [NSString stringWithFormat:@"%d", nLikes];
                } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"comments"]) {
                        [self func:data];
                } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"add_comment"]) {
                        [self func:data];
                        photoScrollView.hidden = false;
                        commentFormViewHolder.hidden = true;
                        photoFormViewHolder.hidden = false;
                } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"medias_for_friend"]) {
                        [self mediaForFriend_callback:request];
                } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"media_info"]) {
                    [self mediaForFriend_callback:request];
                } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"add_audio_comment"]) {
                    [self saveToMedia:data];
                    [self func:data];
                }
            }
    } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
    }
    [hud hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [hud hide:YES];
}

@end
