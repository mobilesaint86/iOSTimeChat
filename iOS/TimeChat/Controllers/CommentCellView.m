//
//  FriendCellView.m
//  TimeChat
//
//  Created by michail on 12/03/14.
//  Copyright (c) 2014 Maksim Denisov. All rights reserved.
//

#import "CommentCellView.h"
#import "UserDataSingleton.h"

@interface CommentCellView() {
    UIImageView *avatarImageView;
    UILabel *userNameLabel;
    BOOL pressed;
    UIButton *viewTimedayButton;
    UIButton *blockFriendButton;
    UIButton *removeFriendButton;
    UIImageView *viewTimedayImageView;
    UIButton *buttonContact;
    int friendStatus;
    UIImage *blockFriendButtonUpImage;
    UIImage *blockFriendButtonDownImage;
    NSString *idFriend;
    NSString *friendName;
    NSString *friendAvatar;
    NSString *fileSufix;
    BOOL alertOK;
}

@end;

@implementation CommentCellView

@synthesize index;

- (id)initWithFrame:(CGRect)frame andNameUser:(NSString *)name andIndex:(int)_index
    andFriendStatus:(NSString *)_friendStatus andIdFriend:(NSString *)_idFriend andAvatar:(NSString *)_avatar
{
    self = [super initWithFrame:frame];
    if (self) {
        fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  [UserDataSingleton sharedSingleton].Sufix];
        NSString *filename;
        index = _index;
        idFriend = _idFriend;
        friendName=name;
        friendAvatar=_avatar;
        friendStatus = [_friendStatus intValue];
        filename = [NSString stringWithFormat:@"friends_TimeDay_no_avatar%@", fileSufix];
        UIImage *noAvatarImage = [UIImage imageNamed:filename];
        
        avatarImageView = [[UIImageView alloc] initWithFrame:
                                       CGRectMake(10, 10,noAvatarImage.size.width/2,
                                                  noAvatarImage.size.height/2)];
        [avatarImageView setImage:noAvatarImage];
        [self addSubview:avatarImageView];
        filename = [NSString stringWithFormat:@"friends_TimeDay_button_up%@", fileSufix];
        UIImage *buttonImage = [UIImage imageNamed:filename];
        CGRect sizeButton;
        sizeButton.size.width = buttonImage.size.width/2;
        sizeButton.size.height = buttonImage.size.height/2;
        sizeButton.origin.y = (self.frame.size.height - sizeButton.size.height)/2;
        sizeButton.origin.x = self.frame.size.width - sizeButton.size.width - 10;
        buttonContact = [[UIButton alloc] initWithFrame:sizeButton];
        [buttonContact setBackgroundColor:[UIColor clearColor]];
        [buttonContact setBackgroundImage:buttonImage forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"friends_TimeDay_button_down%@", fileSufix];
        [buttonContact setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [buttonContact addTarget:self action:@selector(clickButton)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonContact];
        if (![friendAvatar isEqualToString:@""]) {
            [self createAvatarImage:friendAvatar];
        }
  
        CGRect sizeUserNameLabel = avatarImageView.frame;
        sizeUserNameLabel.origin.x += avatarImageView.frame.size.width + 10;
        sizeUserNameLabel.size.width = sizeButton.origin.x - sizeUserNameLabel.origin.x;
        
        userNameLabel = [[UILabel alloc] initWithFrame:sizeUserNameLabel];
        [userNameLabel setText:name];
        [userNameLabel setFont:[UIFont systemFontOfSize:20]];
        [userNameLabel setTextColor:[UIColor colorWithRed:(47/255.0) green:(156/255.0)
                                                        blue:(204/255.0) alpha:1]];
        [self addSubview:userNameLabel];
    }
    return self;
}

- (void)createAvatarImage:(NSString *) pathPhoto {
    bool addUrl = true;//добавлять
    NSMutableString *stringPhoto;
    NSRange pathPhotoRange = [pathPhoto rangeOfString:@"http"];
    if (pathPhotoRange.length == 4) {
        addUrl = false;
    }
    stringPhoto = [NSMutableString stringWithFormat:@"%@", pathPhoto];
    NSString *stringUrl;
    if (addUrl) {
        stringUrl = [NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, stringPhoto];
    } else {
        stringUrl = stringPhoto;
    }
    NSURL  *url = [NSURL URLWithString:stringUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [avatarImageView setImage:[UIImage imageWithData:urlData]];
    UIImageView *plusPhotoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, avatarImageView.frame.size.width, avatarImageView.frame.size.height)];
    NSString *filename = [NSString stringWithFormat:@"friends_TimeDay_avatar%@", fileSufix];
    [plusPhotoImage setImage:[UIImage imageNamed:filename]];
    [avatarImageView addSubview:plusPhotoImage];
}

- (void)clickButton {
    NSString *filename;
    if(!viewTimedayButton) {
        filename = [NSString stringWithFormat:@"friends_TimeDay_view_timeday_button_up%@", fileSufix];
        UIImage *viewTimedayButtonImage =
            [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"friends_TimeDay_block_friend_button_up%@", fileSufix];
        blockFriendButtonUpImage =
            [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"friends_TimeDay_block_friend_button_down%@", fileSufix];
        blockFriendButtonDownImage =
        [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"friends_TimeDay_remove_friend_button_up%@", fileSufix];
        UIImage *removeFriendButtonImage =
            [UIImage imageNamed:filename];
        CGRect sizeViewTimedayButton = self.frame;
        sizeViewTimedayButton.size.height = viewTimedayButtonImage.size.height/2;
        sizeViewTimedayButton.origin.y = (userNameLabel.frame.origin.y +
                                          userNameLabel.frame.size.height);
        sizeViewTimedayButton.origin.x = (avatarImageView.frame.origin.x +
                                          avatarImageView.frame.size.width);
        sizeViewTimedayButton.size.width = self.frame.size.width - sizeViewTimedayButton.origin.x;
        
        viewTimedayImageView = [[UIImageView alloc] initWithFrame:sizeViewTimedayButton];
        [viewTimedayImageView setImage:viewTimedayButtonImage];
        [self addSubview:viewTimedayImageView];
        
        
        UILabel *viewTimedayLabel = [[UILabel alloc] initWithFrame:sizeViewTimedayButton];
        [viewTimedayLabel setText:@"View TimeDay"];
        [viewTimedayLabel setBackgroundColor:[UIColor clearColor]];
        [viewTimedayLabel setTextColor:[UIColor whiteColor]];
        [viewTimedayLabel setFont:[UIFont systemFontOfSize:20]];
        [viewTimedayLabel setTextAlignment:NSTextAlignmentCenter];
        [viewTimedayLabel sizeToFit];
        CGRect sizeViewTimedayLabel = viewTimedayLabel.frame;
        sizeViewTimedayLabel.origin.x = (sizeViewTimedayButton.size.width -
                                         sizeViewTimedayLabel.size.width)/2 - 10;
        sizeViewTimedayLabel.origin.y = (sizeViewTimedayButton.size.height -
                                         sizeViewTimedayLabel.size.height)/2 + 5;
        [viewTimedayLabel setFrame:sizeViewTimedayLabel];
        [viewTimedayImageView addSubview:viewTimedayLabel];
        
        viewTimedayButton = [[UIButton alloc] initWithFrame:sizeViewTimedayButton];
        [viewTimedayButton addTarget:self action:@selector(clickViewTimeday)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewTimedayButton];
    
        CGRect sizeBlockButton = sizeViewTimedayButton;
        sizeBlockButton.origin.y += sizeViewTimedayButton.size.height;
        sizeBlockButton.size.width = blockFriendButtonUpImage.size.width/2;
        sizeBlockButton.size.height -= 10;
        blockFriendButton = [[UIButton alloc] initWithFrame:sizeBlockButton];
        if(friendStatus == 305) {
            [blockFriendButton setBackgroundImage:blockFriendButtonDownImage
                                         forState:UIControlStateNormal];
            [blockFriendButton setBackgroundImage:blockFriendButtonUpImage
                                         forState:UIControlStateHighlighted];
        } else {
            [blockFriendButton setBackgroundImage:blockFriendButtonUpImage
                                         forState:UIControlStateNormal];
            [blockFriendButton setBackgroundImage:blockFriendButtonDownImage
                                         forState:UIControlStateHighlighted];
        }
        blockFriendButton.titleLabel.numberOfLines = 2;
        
        [blockFriendButton setTitle:@"Block\nfriend" forState:UIControlStateNormal];
        [blockFriendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [blockFriendButton addTarget:self action:@selector(clickBlockFriendButton)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:blockFriendButton];
        
        CGRect sizeRemoveButton = sizeBlockButton;
        sizeRemoveButton.origin.x = sizeBlockButton.origin.x + sizeBlockButton.size.width;
        sizeRemoveButton.size.width = sizeViewTimedayButton.size.width - sizeBlockButton.size.width;
        
        removeFriendButton = [[UIButton alloc] initWithFrame:sizeRemoveButton];
        removeFriendButton.titleLabel.numberOfLines = 3;
        [removeFriendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [removeFriendButton setTitle:@"Remove\nfriend\n(Also blocks contact)"
                            forState:UIControlStateNormal];
        [removeFriendButton setBackgroundImage:removeFriendButtonImage
                                      forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"friends_TimeDay_remove_friend_button_down%@", fileSufix];
        [removeFriendButton setBackgroundImage:
         [UIImage imageNamed:filename]
                                      forState:UIControlStateHighlighted];
        [removeFriendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [removeFriendButton addTarget:self action:@selector(clickRemoveFriendButton)
                     forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeFriendButton];
        
        CGRect sizeNewCell = self.frame;
        sizeNewCell.size.height += (sizeViewTimedayButton.size.height + sizeBlockButton.size.height -
                                    (self.frame.size.height -avatarImageView.frame.size.height)/2);
        [self setFrame:sizeNewCell];
        filename = [NSString stringWithFormat:@"friends_TimeDay_button_down%@", fileSufix];
        [buttonContact setBackgroundImage:
         [UIImage imageNamed:filename]
                                 forState:UIControlStateNormal];
    } else {
        [viewTimedayImageView removeFromSuperview];
        viewTimedayImageView = nil;
        [viewTimedayButton removeFromSuperview];
        viewTimedayButton = nil;
        [blockFriendButton removeFromSuperview];
        blockFriendButton = nil;
        [removeFriendButton removeFromSuperview];
        removeFriendButton = nil;
        CGRect sizeNewCell = self.frame;
        sizeNewCell.size.height = (avatarImageView.frame.size.height +
                                   avatarImageView.frame.origin.y * 2);
        [self setFrame:sizeNewCell];
        filename = [NSString stringWithFormat:@"friends_TimeDay_button_up%@", fileSufix];
        [buttonContact setBackgroundImage:
         [UIImage imageNamed:filename]
                                 forState:UIControlStateNormal];
    }
    [self.delegate rewriteCells:index];
}


@end
