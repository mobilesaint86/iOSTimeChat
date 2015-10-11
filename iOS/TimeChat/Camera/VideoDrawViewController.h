//
//  VideoDrawViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "PointObject.h"
#import "LineObject.h"
#import "UserDataSingleton.h"

@protocol VideoDrawViewControllerDelegate <NSObject>

- (void)saveVideo:(UIImage *)image;

@end

@interface VideoDrawViewController : UIViewController

- (id)initWithVideo:(NSURL *)_videoUrl;

@property (nonatomic, weak) id <VideoDrawViewControllerDelegate> delegate;

@end
