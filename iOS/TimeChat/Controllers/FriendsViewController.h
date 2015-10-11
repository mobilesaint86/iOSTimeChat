//
//  FriendsViewController.h
//  TimeChat1
//

#import <UIKit/UIKit.h>
#import "FriendCellView.h"
#import "UserDataSingleton.h"

@protocol FriendCellViewDelegate <NSObject>

- (void)rewriteCells:(int)index;
- (void)deleteFriend:(int)index;
- (void)selectedFriend:(int)index;
- (void)viewDidLoad;
@end
@interface FriendsViewController: UIViewController <FriendCellViewDelegate>

@end
