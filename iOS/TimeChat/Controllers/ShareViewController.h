//
//  ShareViewController.h
//  TimeChat
//


/*#import <UIKit/UIKit.h>
#import "UserDataSingleton.h"
#import "FindContactCellView.h"
#import "ShareCellView.h"

@interface ShareViewController : UIViewController

@end*/

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "FindContactCellView.h"
#import "UserDataSingleton.h"
#import "ShareCellView.h"

@class ShareCellView;

@protocol ShareCellViewDelegate <NSObject>

- (void)contactClick:(ShareCellView *)shareCellView andRemove:(BOOL)remove;

@end

@interface ShareViewController : UIViewController <ShareCellViewDelegate,
UIAlertViewDelegate>

@property NSString *typeMedia;
@property NSString *numberMedia;

@end

