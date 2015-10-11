//
//  MainViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>

#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreMotion/CoreMotion.h>

#import "FindFriendsViewController.h"
#import "TakePhotoViewController.h"
#import "ProfileViewController.h"

#import "MyTimeDayViewController.h"
#import "FriendsViewController.h"
#import "ViewController.h"
#import "CoreDataManager.h"
#import "NotificationsViewController.h"
#import "SettingsViewController.h"
#import "ShareViewController.h"
#import "PAImageView.h"

@interface MainViewController : UIViewController < AVAudioPlayerDelegate>
{
    PAImageView *lastPhotoImageView;
}

- (void)setNotificationCount;
- (void)getNotificationCount;

@end
