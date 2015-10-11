//
//  FriendCellView.m
//  TimeChat
//


#import "FriendCellView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface FriendCellView() {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor, *viewTimedayTextColor, *avatarChangeTextColor;
    UIImageView     *backgroundImageView;
    PAImageView     *avatarImageView;
    UILabel         *userNameLabel;
    BOOL            pressed;
    UIButton        *viewTimedayButton;
    UIButton        *blockFriendButton;
    UIButton        *removeFriendButton;
    UIImageView     *viewTimedayImageView;
    UIButton        *buttonContact;
    UIImageView     *buttonContactImageView;
    UIImage         *blockFriendButtonUpImage;
    UIImage         *blockFriendButtonDownImage;
    
    ///ATN
    UIImage         *favoriteButtonImage;
    UIImage         *unfavorieteButtonImage;
    UIButton        *favoriteButton;
    int             is_favorite;
    
    NSString        *idFriend;
    NSString        *friendName;
    NSString        *friendAvatar;
    int             friendStatus;
    int             avatar_status;
    int             is_online;
    
    NSString        *fileSufix;
    BOOL            alertOK;
    BOOL            whichButtonClick;  //1:Block friend, 0:Remove friend
    MBProgressHUD   *hud;
}

@end;

@implementation FriendCellView

@synthesize index;

- (id)initWithFrame:(CGRect)frame andNameUser:(NSString *)name andIndex:(int)_index
    andFriendStatus:(NSString *)_friendStatus andIdFriend:(NSString *)_idFriend andAvatar:(NSString *)_avatar
    andAvatarStatus:(int)_avatar_status andIsOnline:(int)_is_online andIsFavorite:(int)_is_favorite/////ATN
{
    self = [super initWithFrame:frame];
    
    screenWidth = self.frame.size.width;
    screenHeight = self.frame.size.height;
    scale = [UserDataSingleton sharedSingleton].scale;
    font1 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize1];
    font2 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize2];
    font3 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize3];
    font4 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize4];
    font5 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize5];
    font6 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize6];
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    viewTimedayTextColor = [[UserDataSingleton sharedSingleton].viewTimedayTextColor objectForKey:str];
    avatarChangeTextColor = [UserDataSingleton sharedSingleton].avatarChangeTextColor;
    
    if (self) {
        
        hud = [[MBProgressHUD alloc] initWithView:self];
        
        NSString *filename;
        UIImage *image;
        CGRect size;
        
        index = _index;
        idFriend = _idFriend;
        friendName = name;
        friendAvatar = _avatar;
        friendStatus = [_friendStatus intValue];
        avatar_status = _avatar_status;
        is_online = _is_online;
        is_favorite = _is_favorite;/////ATN
        
        // Background
        filename = [NSString stringWithFormat:@"friends_item_narrow%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = screenWidth;
        size.size.height = screenHeight;
        size.origin.x = 0;
        size.origin.y = 0;
        backgroundImageView = [[UIImageView alloc] initWithImage:image];
        backgroundImageView.frame = size;
        [self addSubview:backgroundImageView];
        
        // avatar
        widthSpace = 45 * scale;
        heightSpace = 6 * scale;
        filename = [NSString stringWithFormat:@"blank_user%@", fileSufix];
        UIImage *noAvatarImage = [UIImage imageNamed:filename];
        size.size.width = noAvatarImage.size.width * scale;
        size.size.height = noAvatarImage.size.height * scale;
        size.origin.x = widthSpace;
        size.origin.y = heightSpace;
        avatarImageView = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
        [avatarImageView setImage:noAvatarImage];
        [self addSubview:avatarImageView];
        
        if (friendAvatar != nil && ![friendAvatar isEqualToString:@""])
            [self createAvatarImage:friendAvatar];
        
        // online state
        if (is_online){
            filename = [NSString stringWithFormat:@"online_state%@", fileSufix];
            image = [UIImage imageNamed:filename];
            size.size.width = image.size.width * scale;
            size.size.height = image.size.height * scale;
            size.origin.x = avatarImageView.frame.origin.x;
            size.origin.y = avatarImageView.frame.origin.y;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:size ];
            [imageView setImage:image];
            [self addSubview:imageView];
        }
        
        // arrow button
        heightSpace = 34 * scale;
        filename = [NSString stringWithFormat:@"friends_arrow_button%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = image.size.width * scale;
        size.size.height = image.size.height * scale;
        size.origin.y = heightSpace;
        size.origin.x = screenWidth - size.size.width - widthSpace;
        buttonContactImageView  = [[UIImageView alloc] initWithFrame:size];
        [buttonContactImageView setImage:image];
        [self addSubview:buttonContactImageView];
        
        size.size.width = screenWidth;
        size.size.height = 116 * scale;
        size.origin.y = 0;
        size.origin.x = 0;
        buttonContact = [[UIButton alloc] initWithFrame:size];
        [buttonContact setBackgroundColor:[UIColor clearColor]];
        [buttonContact addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:buttonContact];
        
        // friend name
        widthSpace = 178 * scale;
        heightSpace = 34 * scale;
        size.size = [name sizeWithAttributes:@{NSFontAttributeName:font3}];
        size.origin.x = widthSpace;
        size.origin.y = heightSpace;
        userNameLabel = [[UILabel alloc] initWithFrame:size];
        [userNameLabel setText:name];
        [userNameLabel setFont:font3];
        if (avatar_status)
            [userNameLabel setTextColor:avatarChangeTextColor];
        else
            [userNameLabel setTextColor:lightTextColor];
        [self addSubview:userNameLabel];
    }
    return self;
}

- (void)createAvatarImage:(NSString *) pathPhoto
{
    NSURL  *url = [NSURL URLWithString:pathPhoto];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [avatarImageView setImage:[UIImage imageWithData:urlData]];
}

- (void)clickButton {
    
    if (avatar_status){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/read_avatar"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"read_avatar" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:idFriend forKey:@"friend_id"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    }
    
    NSString *filename;
    UIImage *image;
    CGRect size;
    if(!viewTimedayButton) {
        
        // Background
        filename = [NSString stringWithFormat:@"friends_item_wide%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = screenWidth;
        size.size.height = image.size.height / image.size.width * screenWidth;
        size.origin.x = 0;
        size.origin.y = 0;
        [backgroundImageView setImage:image];
        backgroundImageView.frame = size;
        
        // Arrow Button
        size.origin.x = self.frame.origin.x;
        size.origin.y = self.frame.origin.y;
        [self setFrame:size];
        filename = [NSString stringWithFormat:@"friends_arrow_button_selected%@", fileSufix];
        [buttonContactImageView setImage:[UIImage imageNamed:filename]];
        
        // View TimeDay ImageView
        filename = [NSString stringWithFormat:@"friends_view%@", fileSufix];
        UIImage *viewTimedayButtonImage = [UIImage imageNamed:filename];
        CGRect sizeViewTimedayButton = self.frame;
        sizeViewTimedayButton.size.width = viewTimedayButtonImage.size.width * scale;
        sizeViewTimedayButton.size.height = viewTimedayButtonImage.size.height * scale;
        sizeViewTimedayButton.origin.y = (userNameLabel.frame.origin.y + userNameLabel.frame.size.height);
        sizeViewTimedayButton.origin.x = (self.frame.size.width - sizeViewTimedayButton.size.width) / 2;
        viewTimedayImageView = [[UIImageView alloc] initWithFrame:sizeViewTimedayButton];
        [viewTimedayImageView setImage:viewTimedayButtonImage];
        [self addSubview:viewTimedayImageView];
        
        // View TimeDay Label
        heightSpace = 50 * scale;
        widthSpace = 62 * scale;
        CGRect sizeViewTimedayLabel;
        sizeViewTimedayLabel.size = [@"View TimeDay" sizeWithAttributes:@{NSFontAttributeName:font3}];
        sizeViewTimedayLabel.origin.x = widthSpace;
        sizeViewTimedayLabel.origin.y = heightSpace;
        UILabel *viewTimedayLabel = [[UILabel alloc] initWithFrame:sizeViewTimedayLabel];
        [viewTimedayLabel setText:@"View TimeDay"];
        [viewTimedayLabel setBackgroundColor:[UIColor clearColor]];
        [viewTimedayLabel setTextColor:viewTimedayTextColor];
        [viewTimedayLabel setFont:font3];
        [viewTimedayLabel setTextAlignment:NSTextAlignmentCenter];
        [viewTimedayLabel sizeToFit];
        [viewTimedayImageView addSubview:viewTimedayLabel];
        
        // View TimeDay Button
        viewTimedayButton = [[UIButton alloc] initWithFrame:sizeViewTimedayButton];
        [viewTimedayButton addTarget:self action:@selector(clickViewTimeday) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:viewTimedayButton];
    
        // Block/Unblock Button
        filename = [NSString stringWithFormat:@"friends_block%@", fileSufix];
        blockFriendButtonUpImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"friends_unblock%@", fileSufix];
        blockFriendButtonDownImage = [UIImage imageNamed:filename];
        CGRect sizeBlockButton = sizeViewTimedayButton;
        sizeBlockButton.size.width = blockFriendButtonUpImage.size.width * scale;
        sizeBlockButton.size.height = blockFriendButtonUpImage.size.height * scale;
        sizeBlockButton.origin.y += sizeViewTimedayButton.size.height;
        blockFriendButton = [[UIButton alloc] initWithFrame:sizeBlockButton];
        if(friendStatus == 305) {
            [blockFriendButton setBackgroundImage:blockFriendButtonUpImage forState:UIControlStateNormal];
        } else {
            [blockFriendButton setBackgroundImage:blockFriendButtonDownImage forState:UIControlStateNormal];
        }
        blockFriendButton.titleLabel.numberOfLines = 2;
        if (friendStatus == 305){
            [blockFriendButton setTitle:@"Block\nfriend" forState:UIControlStateNormal];
        } else {
            [blockFriendButton setTitle:@"Unblocked\nfriend" forState:UIControlStateNormal];
        }
        [blockFriendButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [blockFriendButton.titleLabel setFont:font4];
        [blockFriendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [blockFriendButton addTarget:self action:@selector(clickBlockFriendButton)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:blockFriendButton];
        
       
        
        // Remove Button
        filename = [NSString stringWithFormat:@"friends_remove%@", fileSufix];
        UIImage *removeFriendButtonImage = [UIImage imageNamed:filename];
        CGRect sizeRemoveButton = sizeBlockButton;
        sizeRemoveButton.origin.x = sizeBlockButton.origin.x + sizeBlockButton.size.width;
        sizeRemoveButton.size.width = removeFriendButtonImage.size.width * scale;
        removeFriendButton = [[UIButton alloc] initWithFrame:sizeRemoveButton];
        removeFriendButton.titleLabel.numberOfLines = 2;
        [removeFriendButton.titleLabel setFont:font4];
        [removeFriendButton setTitle:@"Remove\nfriend" forState:UIControlStateNormal];
        [removeFriendButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [removeFriendButton setBackgroundImage:removeFriendButtonImage forState:UIControlStateNormal];
        [removeFriendButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [removeFriendButton addTarget:self action:@selector(clickRemoveFriendButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:removeFriendButton];
        
        //Favorite Button//ATN
        filename = [NSString stringWithFormat:@"favorite_1.png"];
        favoriteButtonImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"favorite_2.png"];
        UIImage *unFavoriteButtonImage = [UIImage imageNamed:filename];
        CGRect sizeFavoriteButton = self.frame;
        sizeFavoriteButton.size.width = favoriteButtonImage.size.width * scale * 2;
        sizeFavoriteButton.size.height = favoriteButtonImage.size.height * scale * 2;
        sizeFavoriteButton.origin.x = removeFriendButton.frame.origin.x +  removeFriendButton.frame.size.width;
        sizeFavoriteButton.origin.y = viewTimedayImageView.frame.origin.y + favoriteButtonImage.size.height *scale;
        favoriteButton = [[UIButton alloc] initWithFrame:sizeFavoriteButton];
        
        if (is_favorite){
            [favoriteButton setBackgroundImage:unFavoriteButtonImage forState:UIControlStateNormal];
            favoriteButton.tag = 1;
        } else {
            [favoriteButton setBackgroundImage:favoriteButtonImage forState:UIControlStateNormal];
            favoriteButton.tag = 0;
        }
        [favoriteButton addTarget:self action:@selector(clickFavoriteButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:favoriteButton];
        
    }
    else {
        [viewTimedayImageView removeFromSuperview];
        viewTimedayImageView = nil;
        [viewTimedayButton removeFromSuperview];
        viewTimedayButton = nil;
        [blockFriendButton removeFromSuperview];
        blockFriendButton = nil;
        [removeFriendButton removeFromSuperview];
        removeFriendButton = nil;
        [favoriteButton removeFromSuperview];/////ATN
        favoriteButton = nil;/////ATN
        
        // Background
        filename = [NSString stringWithFormat:@"friends_item_narrow%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = screenWidth;
        size.size.height = image.size.height / image.size.width * screenWidth;
        size.origin.x = 0;
        size.origin.y = 0;
        [backgroundImageView setImage:image];
        backgroundImageView.frame = size;
        
        // Arrow Button
        size.origin.x = self.frame.origin.x;
        size.origin.y = self.frame.origin.y;
        [self setFrame:size];
        filename = [NSString stringWithFormat:@"friends_arrow_button%@", fileSufix];
        [buttonContactImageView setImage:[UIImage imageNamed:filename]];
    }
    [self.delegate rewriteCells:index];
    [self addSubview:hud];
}
- (void)clickViewTimeday {
    [UserDataSingleton sharedSingleton].idFriend = idFriend;
    [UserDataSingleton sharedSingleton].friendName = friendName;
    [UserDataSingleton sharedSingleton].friendAvatar = friendAvatar;
    
    [self.delegate selectedFriend:index];
}
- (void)clickBlockFriendButton {
    
        whichButtonClick = true;
        UIAlertView *alertView;
        if (friendStatus == 305){
            alertView = [[UIAlertView alloc] initWithTitle:@"Message:" message:@"You sure you want to block contact?" delegate:self cancelButtonTitle:@"Yes, I'm sure!" otherButtonTitles: @"No, it was an accident.",nil];
        } else {
            alertView = [[UIAlertView alloc] initWithTitle:@"Message:" message:@"You sure you want to unblock contact?" delegate:self cancelButtonTitle:@"Yes, I'm sure!" otherButtonTitles: @"No, it was an accident.",nil];
        }
        [alertView show];
}
- (void)clickBlockFriendButton_Main {
        if (!alertOK){
            return;
        }
        if(friendStatus == 305) {
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/ignore_friend"]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            request.userInfo = [NSDictionary dictionaryWithObject:@"ignore_friend" forKey:@"type"];
            [request setTimeOutSeconds:30.f];
            [request setPostValue:idFriend forKey:@"friend_id"];
            [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
            [request setDelegate:self];
            [request startAsynchronous];
            
            [hud show:YES];
        } else {
            [blockFriendButton setEnabled:YES];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/remove_ignore_friend"]];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
            request.userInfo = [NSDictionary dictionaryWithObject:@"remove_ignore_friend" forKey:@"type"];
            [request setTimeOutSeconds:30.f];
            [request setPostValue:idFriend forKey:@"friend_id"];
            [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
            [request setDelegate:self];
            [request startAsynchronous];
            
            [hud show:YES];
        }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == [alertView cancelButtonIndex]){
        alertOK=true;
    }else{
        alertOK=false;
    }
    if (whichButtonClick)
        [self clickBlockFriendButton_Main];
    else
        [self clickRemoveFriendButton_Main];
}
- (void)clickRemoveFriendButton {
    whichButtonClick = false;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message:" message:@"You sure you want to block & remove contact?" delegate:self cancelButtonTitle:@"Yes, I'm sure!" otherButtonTitles: @"No, it was an accident.", nil];
    [alertView show];
}
- (void)clickRemoveFriendButton_Main {
    if (!alertOK)
        return;
    
    [removeFriendButton setEnabled:YES];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/remove_friend"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"remove_friend" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:idFriend forKey:@"friend_id"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

/////ATN
- (void)clickFavoriteButton:(UIButton*)sender{
    int flag = sender.tag;
    if (!flag){
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/favorite_friend"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"favorite_friend" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:idFriend forKey:@"friend_id"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/remove_favorite_friend"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"remove_favorite_friend" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:idFriend forKey:@"friend_id"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    }
}

#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if(!error) {
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
                              options: NSJSONReadingMutableContainers
                              error: &error];
        NSLog(@"%@", json);
        NSDictionary *message = [json objectForKey:@"message"];
        if(message && [[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"ignore_friend"]) {
                    [blockFriendButton setBackgroundImage:blockFriendButtonDownImage forState:UIControlStateNormal];
                    [blockFriendButton setTitle:@"Unblock\nfriend" forState:UIControlStateNormal];
                    friendStatus = 304;
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"remove_ignore_friend"]) {
                    [blockFriendButton setBackgroundImage:blockFriendButtonUpImage forState:UIControlStateNormal];
                    [blockFriendButton setTitle:@"Block\nfriend" forState:UIControlStateNormal];
                    friendStatus = 305;
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"remove_friend"]) {
                    [self.delegate deleteFriend:index];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"read_avatar"]) {
                    avatar_status = 0;
                    [userNameLabel setTextColor:lightTextColor];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"favorite_friend"]) {/////ATN
                    NSLog(@"favorite");
                [self.delegate viewDidLoad];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"remove_favorite_friend"]) {/////ATN
                    NSLog(@"unFavorite");
                [self.delegate viewDidLoad];
            }

        } else {
            NSLog(@"error request on server");
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    [hud hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [hud hide:YES];
}

@end
