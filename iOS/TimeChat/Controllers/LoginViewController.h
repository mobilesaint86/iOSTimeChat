//
//  LoginViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import "UserDataSingleton.h"
#import "MainViewController.h"
#import "Kedrom.h"

#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "FHSTwitterEngine.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"


//#импортируем GPPSignIn.h
/*@interface LoginViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,NSURLConnectionDelegate,
FBLoginViewDelegate,GPPSignInDelegate,UIAlertViewDelegate>
{
    
    int  Twitter_AlertView_Tag, Facebook_AlertView_Tag;
   
    
}
 */

@interface LoginViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate,NSURLConnectionDelegate,
                FBLoginViewDelegate, FHSTwitterEngineAccessTokenDelegate, GPPSignInDelegate,UIAlertViewDelegate>
{
    
    int  Twitter_AlertView_Tag, Facebook_AlertView_Tag;
}
 
@property (nonatomic, assign) BOOL registration;

@end

