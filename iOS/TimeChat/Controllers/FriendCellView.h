//
//  FriendCellView.h
//  TimeChat
//

#import <UIKit/UIKit.h>

#import "FriendTimeDayViewController.h"
#import "FriendsViewController.h"

@protocol FriendCellViewDelegate;
@interface FriendCellView : UIView <UIAlertViewDelegate>

@property (nonatomic, assign) int index;
@property (nonatomic, weak) id <FriendCellViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andNameUser:(NSString *)name andIndex:(int)index
    andFriendStatus:(NSString *)friendStatus andIdFriend:(NSString *)idFriend andAvatar:(NSString *)avatar andAvatarStatus:(int)avatar_status andIsOnline:(int)is_online andIsFavorite:(int)_is_favorite;////A

@end
