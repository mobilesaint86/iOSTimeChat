//
//  SPMImageAsyncView.h
//  ImageDL
//


#import <UIKit/UIKit.h>

@protocol PAImageViewDelegate <NSObject>
@optional
- (void)paImageViewDidTapped:(id)view;
@end

@interface PAImageView : UIView

@property (nonatomic, weak) id<PAImageViewDelegate> delegate;

@property (nonatomic, assign, getter = isCacheEnabled) BOOL cacheEnabled;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong, readonly) UIImageView *containerImageView;

@property (nonatomic, strong) UIColor *backgroundProgresscolor;
@property (nonatomic, strong) UIColor *progressColor;

- (id)initWithFrame:(CGRect)frame backgroundProgressColor:(UIColor *)backgroundProgresscolor progressColor:(UIColor *)progressColor;
- (void)setImageURL:(NSURL *)URL;
- (void)setImage:(UIImage *)image;

- (void)setBackgroundWidth:(CGFloat)width;

@end
