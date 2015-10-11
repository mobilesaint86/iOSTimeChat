//
//  ViewController.h
//  CameraEffectProject
//


#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+FiltrrCompositions.h"
#import "UIImage+Scale.h"
#import "PhotoRedactorView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoRedactorView.h"
#import "PhotoDrawViewController.h"
#import "PhotoRedactorView.h"
#import "VideoDrawViewController.h"
#import "PurchaseViewController.h"

@protocol PhotoRedactorViewDelegate;
@protocol VideoRedactorViewDelegate;

@interface ViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate, PhotoRedactorViewDelegate, PhotoDrawViewControllerDelegate,
VideoRedactorViewDelegate, VideoDrawViewControllerDelegate> {
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, copy) NSURL *movieUrl;
@property (nonatomic, strong) UIButton *playButton;
- (id)init:(int)type;
@end
