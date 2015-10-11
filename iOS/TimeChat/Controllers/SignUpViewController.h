//
//  ProfileViewController.h
//  TimeChat
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "UserDataSingleton.h"
#import "MainViewController.h"
#import "Kedrom.h"

@interface SignUpViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,NSURLConnectionDelegate, MFMailComposeViewControllerDelegate >
{

}
@property (nonatomic, assign) BOOL registration;


@end
