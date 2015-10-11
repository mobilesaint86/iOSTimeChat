//
//  AppDelegate.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "ProfileViewController.h"
#import "MainViewController.h"
#import "SplashViewController.h"
#import "UserDataSingleton.h"

#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import "CoreDataManager.h"
#import "MBProgressHUD.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, AVAudioPlayerDelegate> {
    NSMutableData   *userData;
    NSString        *session;
    UINavigationController *navController_;
    MBProgressHUD *hud;
    NSTimer *timer;
}
@property (readonly) UINavigationController *navController;
  
@property (strong, nonatomic) UIWindow *window;
- (void)first;
@end
