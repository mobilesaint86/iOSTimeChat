//
//  FullPhotoViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>



#import "UserDataSingleton.h"
//#import "MainViewController.h"
#import "Kedrom.h"
#import "ShareViewController.h"
//#импортируем GPPSignIn.h

@interface FullPhotoViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate, UITextViewDelegate,NSURLConnectionDelegate>
{
}
@property (nonatomic, assign) BOOL registration;

@end

