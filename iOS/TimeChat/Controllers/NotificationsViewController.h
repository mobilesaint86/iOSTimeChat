//
//  NotificationsViewController.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import "MessageCellView.h"
#import "UserDataSingleton.h"
#import "FriendTimeDayViewController.h"

@class MessageCellView;

@protocol MessageCellViewDelegate <NSObject>

-(void)showMediaPress;

@end

@interface NotificationsViewController : UIViewController <MessageCellViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate,NSURLConnectionDelegate>

@end

