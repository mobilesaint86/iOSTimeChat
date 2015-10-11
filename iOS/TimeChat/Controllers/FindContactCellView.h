//
//  FindContactCellView.h
//  TimeChat1
//


#import <UIKit/UIKit.h>
#import "FindFriendsByContactsViewController.h"
#import "SendMessageToFacebookViewController.h"

@protocol FindContactCellViewDelegate;

@interface FindContactCellView : UIView

- (id)initWithFrame:(CGRect)frame andUserNameString:(NSString *)_userNameString
   andStateInSystem:(int)_stateUser andEmail:(NSString *)_email
   andNoAvatarImage:(UIImage *)_noAvatarImage andSystem:(int)_system andIdentity:(NSString *)_identity andAvatar:(NSString *)_avatarPath;

@property (nonatomic, weak) id <FindContactCellViewDelegate> delegate;
@property (nonatomic, strong) UIImage *noAvatarImage;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *avatarPath;
@property (nonatomic) int system;

- (void)contactClick;
- (void)setStatus;

@end
