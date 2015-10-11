//
//  FriendTimeDayViewController..h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>



#import "UserDataSingleton.h"
#import "MainViewController.h"
#import "Kedrom.h"
//#импортируем GPPSignIn.h

@interface FriendTimeDayViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate, UITextViewDelegate,NSURLConnectionDelegate,AVAudioPlayerDelegate>
{
    
   
}
@property (nonatomic, assign) NSString *friendIDForShare;
@property (nonatomic, assign) NSString *numberShareMedia;
@property (nonatomic, assign) BOOL registration;
@property(nonatomic, retain) AVAudioPlayer *audioPlayer;
@end

