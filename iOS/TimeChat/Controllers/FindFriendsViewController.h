//
//  FindFriendsViewController.h
//  TimeChat1
//


#import <UIKit/UIKit.h>
#import "FindFriendsByContactsViewController.h"
#import "FindFriendsByEmailViewController.h"
#import "FindFriendsByUsernameViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "FindFriendsByFacebookViewController.h"
#import "UserDataSingleton.h"

@interface FindFriendsViewController : UIViewController <GPPSignInDelegate>

@end
