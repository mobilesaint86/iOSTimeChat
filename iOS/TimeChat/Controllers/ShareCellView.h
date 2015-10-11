//
//  ShareCellView.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import "UserDataSingleton.h"
#import "ShareViewController.h"

@protocol ShareCellViewDelegate;

@interface ShareCellView : UIView
- (id)initWithFrame:(CGRect)frame andUserNameString:(NSString *)_userNameString andAvatar:(NSString *)_avatarPath andFriendId: (NSString *)_friendId;

@property (nonatomic, weak) id <ShareCellViewDelegate> delegate;
//@property (nonatomic, strong) UIImage *noAvatarImage;
//@property (nonatomic, strong) NSString *email;
//@property (nonatomic, strong) NSString *identity;
@property (nonatomic, strong) NSString *avatarPath;
@property(nonatomic,strong) NSString *friendId;
//@property (nonatomic) int system;

- (void)contactClick;
- (void)setStatus;

@end