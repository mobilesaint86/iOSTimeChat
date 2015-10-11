//
//  VideoRedactorView.h
//  CameraEffectProject
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoDrawViewController.h"

@class VideoRedactorView;

@protocol VideoRedactorViewDelegate

- (void)backButtonPress;
- (void)drawVideo:(NSURL *)videoUrl;

@end

@interface VideoRedactorView : UIView{

}

@property (nonatomic ,weak) id <VideoRedactorViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andVideo:(NSURL *)_urlVideo;
- (void)setVideo:(NSURL *)_urlVideo;
- (void)setPhoto:(UIImage *)image;

@end
