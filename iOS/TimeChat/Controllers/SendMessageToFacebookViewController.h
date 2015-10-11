//
//  SendMessageToFacebookViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "UserDataSingleton.h"

@interface SendMessageToFacebookViewController : UIViewController<UITextViewDelegate, FBWebDialogsDelegate>
@property NSString *friendID;
@end
