//
//  TakePhotoViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface TakePhotoViewController : UIViewController <UINavigationControllerDelegate,
UIImagePickerControllerDelegate> {
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    UIPopoverController *popover;
}
@property (nonatomic, strong) UIPopoverController *popover;
@end
