////
//  AppDelegate.m
//  TimeChat


#import "AppDelegate.h"
#import <AdSupport/ASIdentifierManager.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CoreDataManager.h"
#import "ASIFormDataRequest.h"
#import "IMOBIAPHelper.h"

#define FACEBOOK_SCHEME @"fb278873602299013"

@interface AppDelegate () <GPPDeepLinkDelegate>

@end

@implementation AppDelegate

@synthesize navController=navController_;

- (void)applicationDidBecomeActive:(UIApplication *)application{
    MainViewController *subVC = (MainViewController *)[UserDataSingleton sharedSingleton].mainViewController;
    if (subVC != nil)
        [subVC getNotificationCount];
}
//- (void)clearNotifications{
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
//}

- (void)viewDidDisappear:(UIApplication *)application{
//    if (timer != nil){
//        [timer invalidate];
//        timer = nil;
//    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

//    StatusBar.backgroundColorByHexString('#bb0000');
//    StatusBar.styleLightContent();
    
    [IMOBIAPHelper sharedInstance];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    SplashViewController *vc = [[SplashViewController alloc] init];
    self.window.rootViewController = vc;
    userData = [[NSMutableData alloc] init];
    [CoreDataManager sharedManager];
    [UIApplication sharedApplication].statusBarHidden = YES;
//    [UserDataSingleton sharedSingleton].serverURL = //@"http://ec2-54-69-59-169.us-west-2.compute.amazonaws.com/index.php/";//@"http://timechatnet.herokuapp.com";
//    [UserDataSingleton sharedSingleton].serverURL = @"http://ec2-54-69-59-169.us-west-2.compute.amazonaws.com/index.php/";
    [UserDataSingleton sharedSingleton].serverURL = @"http://192.168.0.208/timechatnet/index.php/";
    [UserDataSingleton sharedSingleton].isLogOut = true;
    
    //IOSDevice
    //1 iphone4;
    //2 iphone4 retina;
    //3 ipad;
    //4 ipad retina;
    //5 iphone5 retina;
    [UserDataSingleton sharedSingleton].IOSDevice=[self getDevice];
    
    // SETINGS
    [UserDataSingleton sharedSingleton].numOfDesign=1;
    
//    NSString *struniqueIdentifier = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    [UserDataSingleton sharedSingleton].deviceId = struniqueIdentifier;
//    NSLog(@"udid = %@",struniqueIdentifier);
    
    UIDevice *thisDevice = [UIDevice currentDevice];
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [UserDataSingleton sharedSingleton].shift = 30;
        [UserDataSingleton sharedSingleton].sizeText = 20;
        [UserDataSingleton sharedSingleton].keyboardHeight = 480-216;
        
        [UserDataSingleton sharedSingleton].titleFont = 20.0f;
        [UserDataSingleton sharedSingleton].headFont = 12.0f;
        [UserDataSingleton sharedSingleton].menuFont = 15.0f;

        [UserDataSingleton sharedSingleton].textSize1 = 20.0f;
        [UserDataSingleton sharedSingleton].textSize2 = 18.0f;
        [UserDataSingleton sharedSingleton].textSize3 = 15.0f;
        [UserDataSingleton sharedSingleton].textSize4 = 12.0f;
        [UserDataSingleton sharedSingleton].textSize5 = 10.0f;
        [UserDataSingleton sharedSingleton].textSize6 = 8.0f;
        
        [UserDataSingleton sharedSingleton].scale = 0.41;
    }
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        [UserDataSingleton sharedSingleton].shift = 60;
        [UserDataSingleton sharedSingleton].sizeText = 40;
        [UserDataSingleton sharedSingleton].keyboardHeight = 1024 - 264;

        [UserDataSingleton sharedSingleton].titleFont = 40.0f;
        [UserDataSingleton sharedSingleton].headFont = 24.0f;
        [UserDataSingleton sharedSingleton].menuFont = 30.0f;
 
        [UserDataSingleton sharedSingleton].textSize1 = 40.0f;
        [UserDataSingleton sharedSingleton].textSize2 = 36.0f;
        [UserDataSingleton sharedSingleton].textSize3 = 30.0f;
        [UserDataSingleton sharedSingleton].textSize4 = 24.0f;
        [UserDataSingleton sharedSingleton].textSize5 = 20.0f;
        [UserDataSingleton sharedSingleton].textSize6 = 16.0f;
        
        [UserDataSingleton sharedSingleton].scale = 1.0;
    }
    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
    [UserDataSingleton sharedSingleton].statusBarHeight = statusBarFrame.size.height;
    [UserDataSingleton sharedSingleton].userDefaults= [NSUserDefaults standardUserDefaults];
    [UserDataSingleton sharedSingleton].status=@"";
    [UserDataSingleton sharedSingleton].userPhotoDone=false;
    
    if([UserDataSingleton sharedSingleton].numOfDesign==1){
        [UserDataSingleton sharedSingleton].InputTextColor =[UIColor colorWithRed: 232.0f/255.0f green: 232.0f/255.0f blue: 232.0f/255.0f alpha:1.0f];
        [UserDataSingleton sharedSingleton].TextColor      =[UIColor colorWithRed: 232.0f/255.0f green: 232.0f/255.0f blue: 232.0f/255.0f alpha:1.0f];
        [UserDataSingleton sharedSingleton].LabelTextColor =[UIColor colorWithRed: 232.0f/255.0f green: 232.0f/255.0f blue: 232.0f/255.0f alpha:1.0f];

    }else{
        [UserDataSingleton sharedSingleton].InputTextColor =[UIColor colorWithRed: 202.0f/255.0f green: 131.0f/255.0f blue: 117.0f/255.0f alpha:1.0f];
        [UserDataSingleton sharedSingleton].TextColor      =[UIColor colorWithRed: 232.0f/255.0f green: 169.0f/255.0f blue: 135.0f/255.0f alpha:1.0f];
        [UserDataSingleton sharedSingleton].LabelTextColor =[UIColor colorWithRed: 200.0f/255.0f green: 200.0f/255.0f blue: 200.0f/255.0f alpha:1.0f];
        
    }
    
    [UserDataSingleton sharedSingleton].titleColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].buttonColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].logoutButtonColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].lightTextColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].darkTextColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].placeTextColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].loginTextColor = [[NSMutableDictionary alloc] init];
    [UserDataSingleton sharedSingleton].viewTimedayTextColor = [[NSMutableDictionary alloc] init];
    
    [[UserDataSingleton sharedSingleton].titleColor setObject:[UIColor colorWithRed: 7.0f/255.0f green: 220.0f/255.0f blue: 187.0f/255.0f alpha:1.0f]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].titleColor setObject:[UIColor colorWithRed: 31.0f/255.0f green: 31.0f/255.0f blue: 31.0f/255.0f alpha:1.0f]  forKey:@"2"];
    [[UserDataSingleton sharedSingleton].buttonColor setObject:[UIColor whiteColor]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].buttonColor setObject:[UIColor colorWithRed: 31.0f/255.0f green: 31.0f/255.0f blue: 31.0f/255.0f alpha:1.0f]  forKey:@"2"];
    [[UserDataSingleton sharedSingleton].logoutButtonColor setObject:[UIColor whiteColor]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].logoutButtonColor setObject:[UIColor whiteColor]  forKey:@"2"];
    [[UserDataSingleton sharedSingleton].lightTextColor setObject:[UIColor colorWithRed: 121.0f/255.0f green: 121.0f/255.0f blue: 121.0f/255.0f alpha:1.0f]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].lightTextColor setObject:[UIColor colorWithRed: 220.0f/255.0f green: 220.0f/255.0f blue: 220.0f/255.0f alpha:1.0f]  forKey:@"2"];
    [[UserDataSingleton sharedSingleton].darkTextColor setObject:[UIColor colorWithRed: 59.0f/255.0f green: 59.0f/255.0f blue: 59.0f/255.0f alpha:1.0f]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].darkTextColor setObject:[UIColor whiteColor] forKey:@"2"];
    [[UserDataSingleton sharedSingleton].placeTextColor setObject:[UIColor colorWithRed: 183.0f/255.0f green: 191.0f/255.0f blue: 168.0f/255.0f alpha:1.0f]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].placeTextColor setObject:[UIColor colorWithRed: 183.0f/255.0f green: 191.0f/255.0f blue: 168.0f/255.0f alpha:1.0f] forKey:@"2"];
    [[UserDataSingleton sharedSingleton].loginTextColor setObject:[UIColor colorWithRed: 6.0f/255.0f green: 111.0f/255.0f blue: 146.0f/255.0f alpha:1.0f]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].loginTextColor setObject:[UIColor whiteColor] forKey:@"2"];
    [[UserDataSingleton sharedSingleton].viewTimedayTextColor setObject:[UIColor colorWithRed: 31.0f/255.0f green: 31.0f/255.0f blue: 31.0f/255.0f alpha:1.0f]  forKey:@"1"];
    [[UserDataSingleton sharedSingleton].viewTimedayTextColor setObject:[UIColor colorWithRed: 31.0f/255.0f green: 31.0f/255.0f blue: 31.0f/255.0f alpha:1.0f]  forKey:@"2"];
    [UserDataSingleton sharedSingleton].avatarChangeTextColor =[UIColor colorWithRed: 50.0f/255.0f green: 163.0f/255.0f blue: 250.0f/255.0f alpha:1.0f];
    [UserDataSingleton sharedSingleton].lockedTextColor =[UIColor colorWithRed: 255.0f/255.0f green: 110.0f/255.0f blue: 23.0f/255.0f alpha:1.0f];
    
    [UserDataSingleton sharedSingleton].session=[[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"token"];
    [UserDataSingleton sharedSingleton].password=[[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"password"];
    [UserDataSingleton sharedSingleton].userImage =nil;
    [UserDataSingleton sharedSingleton].idUser =[[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"idUser"];

    [UserDataSingleton sharedSingleton].lastPhotoImageID = @"";
    [UserDataSingleton sharedSingleton].changed = false;
    // GOOGLE
    [UserDataSingleton sharedSingleton].kGoogleplusClientID = @"722056630346-jh5b8vruf0d72hpph7fjjtgn00d9dmla.apps.googleusercontent.com";
    
    // Read Google+ deep-link data.
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    
    // Push Notification Setup
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    else
    {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    [self first];
    [self.window addSubview:hud];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/set_offline"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"set_offline" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/set_online"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"set_online" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSString *deviceTokenString = [deviceToken description];
    deviceTokenString = [deviceTokenString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenString = [deviceTokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [UserDataSingleton sharedSingleton].deviceId = deviceTokenString;
    NSLog(@"deviceID =%@", deviceTokenString );
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    if (error.code == 3010) {
//        NSLog(@"Push notifications are not supported in the iOS Simulator. %@", error.description);
    } else {
        // show some alert or otherwise handle the failure to register.
//        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error.description);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    [UserDataSingleton sharedSingleton].notificationCount = [[aps objectForKey:@"badge"] intValue];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    [UserDataSingleton sharedSingleton].notificationCount = [[aps objectForKey:@"badge"] intValue];
    NSString *from_user_name = [userInfo objectForKey:@"user_name"];
    if (![from_user_name isEqualToString:[UserDataSingleton sharedSingleton].userName]){
        [self getMainViewController];
    
//        if ([UserDataSingleton sharedSingleton].notificationSound  &&  ![[UserDataSingleton sharedSingleton].notificationSound isEqualToString:@"None"]  &&  ![[UserDataSingleton sharedSingleton].notificationSound isEqualToString:@"default"]) {
//            NSArray *parts = [[UserDataSingleton sharedSingleton].notificationSound componentsSeparatedByString:@"."];
//            NSURL *soundUrl = [NSURL fileURLWithPath:path];
//            SystemSoundID pushSoundID;
//            AudioServicesCreateSystemSoundID(CFBridgingRetain(soundUrl), &pushSoundID);
            AudioServicesPlayAlertSound(1304);

//        }
    }
    
    completionHandler(UIBackgroundFetchResultNoData);
}

- (void) getMainViewController
{
    MainViewController *subVC = (MainViewController *)[UserDataSingleton sharedSingleton].mainViewController;
    if (subVC != nil)
        [subVC setNotificationCount];
    
}

- (void)first
{
    if(![[[UserDataSingleton sharedSingleton].userDefaults valueForKey:@"numOfDesign"]  isEqualToString: @""] && [[UserDataSingleton sharedSingleton].userDefaults valueForKey:@"numOfDesign"] != nil) {
        [UserDataSingleton sharedSingleton].numOfDesign = [[[UserDataSingleton sharedSingleton].userDefaults valueForKey:@"numOfDesign"] intValue];
    }
    if ([UserDataSingleton sharedSingleton].session != nil  &&  [[UserDataSingleton sharedSingleton].session length] >= 10)  {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/check_token"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"check_token" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    } else {
        LoginViewController     *vc = [[LoginViewController alloc] init];
        vc.registration = YES;
        self.window.rootViewController = vc;
    }
    
/***/
//        MainViewController     *vc = [[MainViewController alloc] init];
//        self.window.rootViewController = vc;
/**/
    [UserDataSingleton sharedSingleton].isLogOut = NO;
}

- (int)getDevice {
    int Device=1;
    if([UIDevice currentDevice].userInterfaceIdiom==UIUserInterfaceIdiomPad) {
        Device=3;
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0) {
            Device=4;
        }
    }
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0) {
            Device=2;
        }
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height == 480)     {            }
        if(result.height == 568)     { Device=5;  }
    }
    return  Device;
}

//- (void)showMessage:(NSString *)text withTitle:(NSString *)title
//{
//    [[[UIAlertView alloc] initWithTitle:title
//                                message:text
//                               delegate:self
//                      cancelButtonTitle:@"OK!"
//                      otherButtonTitles:nil] show];
//}

- (BOOL)application: (UIApplication *)application
            openURL: (NSURL *)url
  sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {
    if ([[url scheme] isEqualToString:FACEBOOK_SCHEME])
        return [FBSession.activeSession handleOpenURL:url];
    else
        return [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark - GPPDeepLinkDelegate
//- (void)didReceiveDeepLink:(GPPDeepLink *)deepLink {
//    // An example to handle the deep link data.
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"Deep-link Data"
//                          message:[deepLink deepLinkID]
//                          delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];
//    [alert show];
//}

#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (!error) {
            NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
                              options: NSJSONReadingMutableContainers
                              error: &error];
//            NSLog(@"%@", json);
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"check_token"]) {

                    NSDictionary    *message   = [json objectForKey:@"message"];
                    NSDictionary    *data      = [json objectForKey:@"data"];
                    NSDictionary    *user_info      = [data objectForKey:@"user_info"];
                    NSDictionary    *setting      = [data objectForKey:@"setting"];
                    [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
                    [UserDataSingleton sharedSingleton].isLogOut = YES;
                    
                    if ([[message objectForKey:@"code"] intValue] == SUCCESS_LOGIN) {
                        [UserDataSingleton sharedSingleton].session = [user_info objectForKey:@"token"];
                        [UserDataSingleton sharedSingleton].userName= [user_info objectForKey:@"username"];
                        [UserDataSingleton sharedSingleton].idUser  = [user_info objectForKey:@"id"];
                        [UserDataSingleton sharedSingleton].userEmail = [user_info objectForKey:@"email"];
                        
                        NSString *avatar = [user_info objectForKey:@"avatar"];
                        NSURL *url = [NSURL URLWithString:avatar];
                        NSData *userAvatarData = [NSData dataWithContentsOfURL:url];
                        [UserDataSingleton sharedSingleton].userImage = [UIImage imageWithData:userAvatarData];
                        
                        NSError *error = nil;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                        
                        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                        [fetchRequest setEntity:entity];
                        NSError *requestError = nil;
                        NSArray *usersArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
                        Boolean userIsInTheBase = NO;
                        
                        for (int i = 0; i < [usersArray count]; i++) {
                            User *user = [usersArray objectAtIndex:i];
                            if ([user.id isEqual:[UserDataSingleton sharedSingleton].idUser]) {
                                [UserDataSingleton sharedSingleton].password  = user.pass;
                                
                                if (user.name == nil) {
                                    [[CoreDataManager sharedManager].managedObjectContext deleteObject:user];
                                } else {
                                    userIsInTheBase = YES;
                                    break;
                                }
                            }
                        }
                        
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error]) { NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  }
                        
                        if (!userIsInTheBase) {
                            User *user = [NSEntityDescription insertNewObjectForEntityForName:@"Users"  inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                            
                            user.id     =[UserDataSingleton sharedSingleton].idUser;
                            user.name   =[UserDataSingleton sharedSingleton].userName;
                            user.email  =[UserDataSingleton sharedSingleton].userEmail;
                            user.pass   =[UserDataSingleton sharedSingleton].password;
                            NSError *error = nil;
                            if (![[CoreDataManager sharedManager].managedObjectContext save:&error])  {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                        }
                        
                        // Get Setting State;
                        [UserDataSingleton sharedSingleton].pushEnable = [[setting objectForKey:@"push_enable"] boolValue];
                        [UserDataSingleton sharedSingleton].soundEnable = [[setting objectForKey:@"sound_enable"] boolValue];
                        [UserDataSingleton sharedSingleton].notificationSound = [setting objectForKey:@"push_sound"];
                        [UserDataSingleton sharedSingleton].autoAcceptFriendEnable = [[setting objectForKey:@"auto_accept_friend"] boolValue];
                        [UserDataSingleton sharedSingleton].autoNotifyFriendEnable = [[setting objectForKey:@"auto_notify_friend"] boolValue];
                        [UserDataSingleton sharedSingleton].numOfDesign = [[setting objectForKey:@"theme_type"] intValue];
                        
                        MainViewController *vc;
                        if (vc == nil)      vc = [[MainViewController alloc] init];
                        self.window.rootViewController = vc;
                    } else {
                        LoginViewController     *vc;
                        if (vc == nil)  vc = [[LoginViewController alloc] init];
                        vc.registration = YES;
                        self.window.rootViewController = vc;
                        
                    }
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"set_offline"]) {
                NSLog(@"set_offline = %@", json);
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"set_online"]) {
                NSLog(@"set_online = %@", json);
            }
    } else {
        LoginViewController     *vc;
        if (vc == nil)  vc = [[LoginViewController alloc] init];
        vc.registration = YES;
        self.window.rootViewController = vc;
    }
    [[UserDataSingleton sharedSingleton].userDefaults synchronize];
    [hud hide:YES];
}

- (void)requestFailed:(ASIFormDataRequest *)request
{
    [hud hide:YES];
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"Message:"
//                          message:@"You are not connected to the internet."
//                          delegate:self
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];
//    [alert show];
    NSLog(@"change_state");
}

@end