//
//  PhotoRedactorView.h
//  CameraEffectProject
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@protocol PhotoRedactorViewDelegate

- (void)backButtonPress;
- (void)drawPhoto:(UIImage *)photoImage;
- (void)clickPurchase;
@end

@interface PhotoRedactorView : UIView<UIAlertViewDelegate>{

}

@property (nonatomic ,weak) id <PhotoRedactorViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andPhoto:(UIImage *)_photoImage;
- (void)setPhoto:(UIImage *)_photoImage andSave:(BOOL)save;

@end
