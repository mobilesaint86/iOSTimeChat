//
//  ShareCellView.m
//  TimeChat
//

#import "ShareCellView.h"
#import "PAImageView.h"

@interface ShareCellView() {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    UIImage         *noAvatarImage;
    UIImageView     *userImageView;
    PAImageView     *userBackgroundImageView;
    NSMutableString *userNameString;
    UIButton        *button;
    BOOL            pressedContact;
    UIImageView     *userStatusImageView;
    NSString        *fileSufix;
}

@end;

@implementation ShareCellView

@synthesize avatarPath;
@synthesize friendId;

- (id)initWithFrame:(CGRect)frame andUserNameString:(NSString *)_userNameString andAvatar:(NSString *)_avatarPath andFriendId:(NSString *)_friendId
{
    self = [super initWithFrame:frame];
    
    screenWidth = self.frame.size.width;
    screenHeight = self.frame.size.height;
    scale = [UserDataSingleton sharedSingleton].scale;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    statusBarHeight = [UserDataSingleton sharedSingleton].statusBarHeight;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
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
    
    if (self) {

        NSString *filename;
        UIImage *image;
        CGRect size;
        
        avatarPath = _avatarPath;
        friendId = _friendId;
        
        // Background
        filename = [NSString stringWithFormat:@"friends_item_narrow%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = screenWidth;
        size.size.height = screenHeight;
        size.origin.x = 0;
        size.origin.y = 0;
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        backgroundImageView.frame = size;
        [self addSubview:backgroundImageView];
        
        // Avatar
        heightSpace = 6 * scale;
        widthSpace = 45 * scale;
        filename = [NSString stringWithFormat:@"blank_user%@", fileSufix];
        noAvatarImage = [UIImage imageNamed:filename];
        CGRect sizeUserBackgroundImageView;
        sizeUserBackgroundImageView.size.height = noAvatarImage.size.width * scale;
        sizeUserBackgroundImageView.size.width = noAvatarImage.size.height * scale;
        sizeUserBackgroundImageView.origin.x = widthSpace;
        sizeUserBackgroundImageView.origin.y = heightSpace;
        
        userBackgroundImageView = [[PAImageView alloc] initWithFrame:sizeUserBackgroundImageView backgroundProgressColor:[UIColor clearColor] progressColor:[UIColor clearColor]];
        [userBackgroundImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:userBackgroundImageView];
        
        if (![avatarPath isEqualToString:@""]) {
            NSURL  *url = [NSURL URLWithString:avatarPath];
            NSData *urlData = [NSData dataWithContentsOfURL:url];
            noAvatarImage  = [UIImage imageWithData:urlData];
        }
        [userBackgroundImageView setImage:noAvatarImage];

        // Add Button
        heightSpace = 34 * scale;
        filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
        UIImage *plusImage = [UIImage imageNamed:filename];
        CGRect sizeUserStatusImageView;
        sizeUserStatusImageView.size.width = plusImage.size.width * scale;
        sizeUserStatusImageView.size.height = plusImage.size.height * scale;
        sizeUserStatusImageView.origin.x = screenWidth - widthSpace - sizeUserStatusImageView.size.width;
        sizeUserStatusImageView.origin.y = heightSpace;
        userStatusImageView = [[UIImageView alloc] init];
        [userStatusImageView setFrame:sizeUserStatusImageView];
        [userStatusImageView setImage:plusImage];
        [userStatusImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:userStatusImageView];
        
        // friend name
        userNameString = [NSMutableString stringWithString:_userNameString];
        widthSpace = 178 * scale;
        heightSpace = 34 * scale;
        size.size = [userNameString sizeWithAttributes:@{NSFontAttributeName:font3}];
        size.origin.x = widthSpace;
        size.origin.y = heightSpace;
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:size];
        [userNameLabel setText:userNameString];
        [userNameLabel setFont:font3];
        [userNameLabel setTextColor:lightTextColor];
        [self addSubview:userNameLabel];
        
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(contactClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)setStatus {
    NSString *filename;
    if(!pressedContact) {
        filename = [NSString stringWithFormat:@"find_by_phonebook_add_selected%@", fileSufix];
        [userStatusImageView setImage:[UIImage imageNamed:filename]];
    } else {
        filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
        [userStatusImageView setImage:[UIImage imageNamed:filename]];

    }
    pressedContact = !pressedContact;
}

- (void)contactClick {
    NSString *filename;
    if(!pressedContact) {
        filename = [NSString stringWithFormat:@"find_by_phonebook_add_selected%@", fileSufix];
        [userStatusImageView setImage:[UIImage imageNamed:filename]];
        [self.delegate contactClick:self andRemove:NO];
    } else {
        filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
        [userStatusImageView setImage:[UIImage imageNamed:filename]];
        [self.delegate contactClick:self andRemove:YES];
    }
    pressedContact = !pressedContact;
}

@end
