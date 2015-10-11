//
//  FindFriendsByPhonebookViewController.h
//  TimeChat1
//


#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "FindContactCellView.h"
#import "UserDataSingleton.h"

@class FindContactCellView;

@protocol FindContactCellViewDelegate <NSObject>

- (void)contactClick:(FindContactCellView *)findContactCellView andRemove:(BOOL)remove;

@end

@interface FindFriendsByContactsViewController : UIViewController <FindContactCellViewDelegate,
UIAlertViewDelegate>

@property int inviteFriendToFacebook; //0 - not invite, 1 - invite
- (id)init:(int)system;

@end
