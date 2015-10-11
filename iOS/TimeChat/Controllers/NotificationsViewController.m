//
//  NotificationsViewController.m
//  TimeChat
//


#import "NotificationsViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface NotificationsViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    NSMutableArray  *notificationsArray;
    UIScrollView    *messageScrollView;
    NSString        *fileSufix;
    MBProgressHUD   *hub;
}
@end

@implementation NotificationsViewController

- (id)init {

    if(self == [super init]) {
        notificationsArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    NSString *filename;
    UIImage *image;
    CGRect size;
 
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    
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
    UIImageView *titleBackgroundView = [[UIImageView alloc] initWithFrame:size];
    [titleBackgroundView setImage:image];
    titleBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleBackgroundView];
    
    // Title text!
    str = @"Notification";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - size.size.height) / 2;
    UILabel *settingsLabel = [[UILabel alloc] initWithFrame:size];
    settingsLabel.textColor = titleColor;
    settingsLabel.text = str;
    [settingsLabel setBackgroundColor:[UIColor clearColor]];
    [settingsLabel setFont:font1];
    [self.view addSubview:settingsLabel];
    
    // Back button
    widthSpace = 25 * scale;
    filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
    image = [UIImage imageNamed:filename];
    CGRect sizeBackButton;
    sizeBackButton.size.height = image.size.height * scale;
    sizeBackButton.size.width = image.size.width * scale;
    sizeBackButton.origin.x = widthSpace;
    sizeBackButton.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - sizeBackButton.size.height) / 2;
    UIButton *backButton = [[UIButton alloc] initWithFrame:sizeBackButton];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(clickBackButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Remove all Button
    heightSpace = 24 * scale;
    widthSpace = 21 * scale;
    filename = [NSString stringWithFormat:@"notification_removeall%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = screenWidth - widthSpace - size.size.width;
    size.origin.y = statusBarHeight + titleBackgroundView.frame.size.height + heightSpace;
    UIButton *removeallButton = [[UIButton alloc] initWithFrame:size];
    [removeallButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"notification_removeall_down%@", fileSufix];
    [removeallButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [removeallButton setTitle:@"Remove All" forState:UIControlStateNormal];
    [removeallButton setTitleColor:buttonColor forState:UIControlStateNormal];
    removeallButton.backgroundColor = [UIColor clearColor];
    removeallButton.titleLabel.font = font3;
    [removeallButton addTarget:self action:@selector(removeallButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:removeallButton];
    
    // messageScrollView
    size.size.width = screenWidth;
    size.size.height = screenHeight - (removeallButton.frame.origin.y + removeallButton.frame.size.height + heightSpace);
    size.origin.x = 0;
    size.origin.y = removeallButton.frame.origin.y + removeallButton.frame.size.height + heightSpace;
    messageScrollView = [[UIScrollView alloc] initWithFrame:size];
    messageScrollView.scrollEnabled = YES;
    [messageScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:messageScrollView];
    
    hub = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hub];
    
    [self getNotifications];
}

- (void)getNotifications {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@", [UserDataSingleton sharedSingleton].serverURL, @"notifications", [UserDataSingleton sharedSingleton].session]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"notifications" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hub show:YES];
}

-(void)createTableContects:(NSArray *)messageArray {
    NSString *filename = [NSString stringWithFormat:@"notification_item%@", fileSufix];
    UIImage *image = [UIImage imageNamed:filename];
    CGRect size;
    size.size.width = screenWidth;
    size.size.height = image.size.height / image.size.width * screenWidth;
    size.origin.x = 0;
    size.origin.y = 0;
    
    for (UIView *subview in messageScrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    NSLog(@"%@", messageArray);
    for (int i = 0; i <  [messageArray count] ; i++) {
        NSDictionary *messageDictionary = [messageArray objectAtIndex:i];
        MessageCellView *messageCellView = [[MessageCellView alloc] initWithFrame:size andMessageDictionary:messageDictionary andIndex:i];
        messageCellView.delegate = self;
        [messageScrollView addSubview:messageCellView];
        size.origin.y += size.size.height;
        [notificationsArray insertObject:messageCellView atIndex:0];
    }

    [messageScrollView setContentSize:(CGSizeMake(messageScrollView.frame.size.width,  [notificationsArray count] * size.size.height))];
    [hub hide:YES];
}
-(void)hadReadNotification{////UNUSED
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"notifications/had_read_notification"]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"had_read_notification" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)removeallButtonPress {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"notifications/remove_all"]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"remove_all" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(void)showMediaPress{
    FriendTimeDayViewController *subVC;
    if (subVC == nil) subVC = [[FriendTimeDayViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}

-(NSMutableArray*)getLocalNotificationIDs
{
    NSMutableArray *resultAry = [[NSMutableArray alloc] init];
    NSString *str = [[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"localNotification"];
    if (![str isEqualToString:@""]){
        NSArray *foo = [str componentsSeparatedByString: @";"];
        for (int i=0; i<[foo count];i++){
                NSString *nodeString = [foo objectAtIndex:i];
                NSArray *nodeAry = [nodeString componentsSeparatedByString: @","];
                int nodeId = [[nodeAry objectAtIndex:0] intValue];
                NSString *strId = [NSString stringWithFormat:@"%d", nodeId];
                [resultAry addObject:strId];
        }
    }
    
    return resultAry;
    
}

-(void)removeAllLocalNotifications
{
        NSArray *idsAry = [self getLocalNotificationIDs];
        NSError *error = nil;
        NSError *requestError = nil;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                                  inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
        [fetchRequest setEntity:entity];
        NSPredicate *predicate;
    
        NSArray *mediasArray, *mediasdataArray;
        Media *media;
        Mediadata *mediadata;
        for (int i=0;i<[idsAry count];i++)
        {
            predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [idsAry objectAtIndex:i]];
            [fetchRequest setPredicate:predicate];
            mediasArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if([mediasArray count] > 0){
                media = [mediasArray objectAtIndex:[mediasArray count]-1];
                [[CoreDataManager sharedManager].managedObjectContext deleteObject:media];
            }
        }

        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"Mediasdata"
                             inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
        [fetchRequest setEntity:entity];
        requestError = nil;
        for (int i=0;i<[idsAry count];i++)
        {
            predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [idsAry objectAtIndex:i]];
            [fetchRequest setPredicate:predicate];
            mediasdataArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
            if([mediasdataArray count] > 0){
                mediadata = [mediasdataArray objectAtIndex:[mediasdataArray count]-1];
                [[CoreDataManager sharedManager].managedObjectContext deleteObject:mediadata];
            }
        }

        if (![[CoreDataManager sharedManager].managedObjectContext save:&error]) { NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  }
    
        [[UserDataSingleton sharedSingleton].userDefaults setObject:@"" forKey:@"localNotification"];
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
        
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"notifications"]) {
                NSArray *messageArray = [json objectForKey:@"data"];
                NSArray *idsAry = [self getLocalNotificationIDs];
                NSMutableArray *localArray = [[NSMutableArray alloc] init];
            
                NSString *created_time;
                NSError *error = nil;
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                [fetchRequest setEntity:entity];
                NSPredicate *predicate;
                
                NSArray *mediasArray;
                Media *media;

                for (int i=0;i<[idsAry count];i++){
                    predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [idsAry objectAtIndex:i]];
                    [fetchRequest setPredicate:predicate];
                    mediasArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    if([mediasArray count] > 0){
                        media = [mediasArray objectAtIndex:0];
                        created_time = media.time;
                    } else {
                        created_time = @"";
                    }
                    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                    [temp setValue:[idsAry objectAtIndex:i] forKey:@"media_id"];
                    [temp setValue:@"420" forKey:@"type"];
                    [temp setValue:@"Your media was not uploaded. Do you want to try again?" forKey:@"debug"];
                    [temp setValue:[NSString stringWithFormat:@"%@", created_time] forKey:@"media_created_time"];
                    [localArray addObject:temp];
                }
            
                NSMutableSet *set = [NSMutableSet setWithArray:messageArray];
                [set addObjectsFromArray:localArray];
                NSArray *mergeAry =[set allObjects];
                NSLog(@"NOTIFICATIONCOUNT= %lu", (unsigned long)[mergeAry count]);

                if(mergeAry && [mergeAry count] > 0) {
                   
                    [self createTableContects:mergeAry];
                } else {
                    CGRect sizeLabel;
                    sizeLabel.size = [@"There are no notifications" sizeWithAttributes:@{NSFontAttributeName:font1}];
                    sizeLabel.origin.x = (screenWidth - sizeLabel.size.width) / 2;
                    sizeLabel.origin.y = (screenHeight - sizeLabel.size.height) / 2;
                    UILabel *label = [[UILabel alloc] initWithFrame:sizeLabel];
                    label.text          = @"There are no notifications";
                    label.textColor = lightTextColor;
                    label.font          = font1;
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    [self.view addSubview:label];
                    [hub hide:YES];
                }
        } else  if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"had_read_notification"]) {
            
        } else  if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"remove_all"]) {
            [[messageScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [notificationsArray removeAllObjects];
            [self removeAllLocalNotifications];
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [hub hide:YES];
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [hub hide:YES];
}

@end
