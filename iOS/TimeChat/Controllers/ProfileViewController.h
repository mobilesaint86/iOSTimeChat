//
//  ProfileViewController.h
//  TimeChat
//

#import <UIKit/UIKit.h>
#import "UserDataSingleton.h"
#import "MainViewController.h"
#import "Kedrom.h"

@interface ProfileViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,NSURLConnectionDelegate,UIImagePickerControllerDelegate,UIPopoverControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, assign) BOOL registration;
@property (nonatomic, strong) UIPopoverController *popover;
@end
