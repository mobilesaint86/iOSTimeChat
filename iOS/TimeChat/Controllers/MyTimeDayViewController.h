//
//  LoginViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserDataSingleton.h"
#import "MainViewController.h"
#import "Kedrom.h"
#import "ShareViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface MyTimeDayViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate, UITextViewDelegate, NSURLConnectionDelegate, AVAudioPlayerDelegate, UIActionSheetDelegate>
{

}
@property (nonatomic, assign) BOOL registration;
@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@end

