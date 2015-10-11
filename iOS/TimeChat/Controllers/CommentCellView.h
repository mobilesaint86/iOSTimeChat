//
//  CommentCellView.h
//  TimeChat
//
//  Created by michail on 12/03/14.
//  Copyright (c) 2014 Maksim Denisov. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "CommentTimeDayViewController.h"

@protocol CommentCellViewDelegate <NSObject>

- (void)rewriteCells:(int)index;
- (void)deleteFriend:(int)index;
- (void)selectedFriend:(int)index;
@end

@interface CommentCellView : UIView <UIAlertViewDelegate>

@property (nonatomic, assign) int index;
@property (nonatomic, weak) id <CommentCellViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame andNameUser:(NSString *)name andIndex:(int)index
    andFriendStatus:(NSString *)friendStatus andIdFriend:(NSString *)idFriend andAvatar:(NSString *)avatar;

@end
