//
//  MessageCellView.h
//  TimeChat
//


#import <UIKit/UIKit.h>
#import "UserDataSingleton.h"
#import "NotificationsViewController.h"

@protocol MessageCellViewDelegate;

@interface MessageCellView : UIView

@property (nonatomic, assign) int index;
@property (nonatomic, weak) id <MessageCellViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andMessageDictionary:(NSDictionary *)messageDictionary andIndex:(int)index;
-(void)showMedia;
    
@end

