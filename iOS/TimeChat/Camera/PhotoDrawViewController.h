//
//  PhotoDrawViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import "PointObject.h"
#import "LineObject.h"
#import "UserDataSingleton.h"

@protocol PhotoDrawViewControllerDelegate <NSObject, UITextFieldDelegate>

- (void)savePhoto:(UIImage *)image;

@end

@interface PhotoDrawViewController : UIViewController

- (id)initWithImage:(UIImage *)_photoImage;

@property (nonatomic, weak) id <PhotoDrawViewControllerDelegate> delegate;

@end
