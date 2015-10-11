//
//  FindContactCellView.m
//  TimeChat1
//


#import "FindContactCellView.h"
#import "PAImageView.h"

@interface FindContactCellView() {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    PAImageView     *userImageView;
    UIImageView     *userBackgroundImageView;
    NSMutableString *userNameString;
    UIButton        *button;
    int             stateUser;
    BOOL            pressedContact;
    UIImageView     *userStatusImageView;
    NSString        *fileSufix;
}

@end;

@implementation FindContactCellView

@synthesize email;
@synthesize identity;
@synthesize noAvatarImage;
@synthesize avatarPath;
@synthesize system;

- (id)initWithFrame:(CGRect)frame andUserNameString:(NSString *)_userNameString
   andStateInSystem:(int)_stateUser andEmail:(NSString *)_email
   andNoAvatarImage:(UIImage *)_noAvatarImage andSystem:(int)_system andIdentity:(NSString *)_identity andAvatar:(NSString *)_avatarPath
{
    self = [super initWithFrame:frame];
    if (self) {
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
        
        NSString *filename;
        UIImage *image;
        CGRect size;
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        noAvatarImage = _noAvatarImage;
        email = _email;
        stateUser = _stateUser;
        identity = _identity;
        avatarPath = _avatarPath;
        system = _system;
        
        // background
        filename = [NSString stringWithFormat:@"find_by_phonebook_item%@", fileSufix];
        image = [UIImage imageNamed:filename];
        CGRect sizeUserBackgroundImageView = self.frame;
        sizeUserBackgroundImageView.size.width = screenWidth;
        sizeUserBackgroundImageView.size.height = image.size.height / image.size.width * screenWidth;
        sizeUserBackgroundImageView.origin.x = sizeUserBackgroundImageView.origin.y = 0;
        userBackgroundImageView = [[UIImageView alloc] initWithFrame:sizeUserBackgroundImageView];
        [userBackgroundImageView setImage:image];
        [userBackgroundImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:userBackgroundImageView];
        
        // blank avatar
        widthSpace = 30 * scale;
        heightSpace = 20 * scale;
        filename = [NSString stringWithFormat:@"blank_user%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = image.size.width * scale;
        size.size.height = image.size.height * scale;
        size.origin.x = widthSpace;
        size.origin.y = heightSpace;
        userImageView = [[PAImageView alloc] initWithFrame:size];
        [userImageView setBackgroundColor:[UIColor clearColor]];
        [userImageView setBackgroundWidth:0];
        [userImageView setPlaceHolderImage:image];
        [userBackgroundImageView addSubview:userImageView];
        
        if(_userNameString) {
            userNameString = [NSMutableString stringWithString:_userNameString];
        } else if(_email) {
            userNameString = [NSMutableString stringWithString:_email];
        }
        
        // add button
        CGRect sizeUserStatusImageView = sizeUserBackgroundImageView;
        userStatusImageView = [[UIImageView alloc] init];
        if(_stateUser == 201) {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
            UIImage *plusImage = [UIImage imageNamed:filename];
            sizeUserStatusImageView.size.width = plusImage.size.width * scale;
            sizeUserStatusImageView.size.height = plusImage.size.height * scale;
            
            [userStatusImageView setImage:plusImage];
        } else if(_stateUser == 202) {
            if (system == 2) {
                filename = [NSString stringWithFormat:@"find_friends_email1_icon_gray%@", fileSufix];
                UIImage *emailImage = [UIImage imageNamed:filename];
                sizeUserStatusImageView.size.width = emailImage.size.width/2;
                sizeUserStatusImageView.size.height = emailImage.size.height/2;
                [userStatusImageView setImage:emailImage];
            } else {
                filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
                UIImage *plusImage = [UIImage imageNamed:filename];
                sizeUserStatusImageView.size.width = plusImage.size.width * scale;
                sizeUserStatusImageView.size.height = plusImage.size.height * scale;
                [userStatusImageView setImage:plusImage];
            }
        } else {
            NSString *statusString = @"friend request";
            CGSize sizeText = [statusString sizeWithAttributes: @{NSFontAttributeName:font3}];
            sizeUserStatusImageView.size.width = sizeText.width;
            CGRect sizeLabel;
            sizeLabel.origin.x = sizeLabel.origin.y = 0;
            sizeLabel.size.width = sizeText.width;
            sizeLabel.size.height = sizeUserBackgroundImageView.size.height;
            UILabel *label = [[UILabel alloc] initWithFrame:sizeLabel];
            label.numberOfLines = 2;
            [label setText:@"Pending\nfriend request"];
            if(system == 1) {
                [label setTextColor:[UIColor colorWithRed:(235.0f/255.0f) green:(180.0f/255.0f)
                                                     blue:(172.0f/255.0f) alpha:1]];
            } else {
                [label setTextColor:[UIColor colorWithRed:(47.0f/255.0f) green:(156.0f/255.0f)
                                                     blue:(204.0f/255.0f) alpha:1]];
            }
            [label setTextAlignment:NSTextAlignmentRight];
            [label setFont:font3];
            [label setBackgroundColor:[UIColor clearColor]];
            [userStatusImageView addSubview:label];
        }
        widthSpace = 40 * scale;
        heightSpace = 48 * scale;
        sizeUserStatusImageView.origin.x = screenWidth - widthSpace - sizeUserStatusImageView.size.width;
        sizeUserStatusImageView.origin.y = heightSpace;
        [userStatusImageView setFrame:sizeUserStatusImageView];
        [userStatusImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:userStatusImageView];
        
        // username label
        heightSpace = 36 * scale;
        widthSpace = 154 * scale;
        CGRect sizeUserNameLabel;
        sizeUserNameLabel.size = [userNameString sizeWithAttributes:@{NSFontAttributeName:font4}];
        sizeUserNameLabel.origin.x = widthSpace;
        sizeUserNameLabel.origin.y = heightSpace;
        UILabel *userNameLabel = [[UILabel alloc] initWithFrame:sizeUserNameLabel];
        [userNameLabel setText:userNameString];
        [userNameLabel setFont:font4];
        [userNameLabel setTextColor:lightTextColor];
        [self addSubview:userNameLabel];
        
        // email label
        heightSpace = 8 * scale;
        size.size = [_email sizeWithAttributes:@{NSFontAttributeName:font5}];
        size.origin.x = widthSpace;
        size.origin.y = userNameLabel.frame.origin.y + userNameLabel.frame.size.height + heightSpace;
        UILabel *emailLabel = [[UILabel alloc] initWithFrame:size];
        [emailLabel setText:_email];
        [emailLabel setFont:font5];
        [emailLabel setTextColor:lightTextColor];
        [self addSubview:emailLabel];
        
        if(_stateUser == 201 || _stateUser == 202) {
            button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(contactClick) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        if (system == 2) {
            if (![avatarPath isEqualToString:nil]) {
                NSURL  *url = [NSURL URLWithString:avatarPath];
                [userImageView setImageURL:url];
            }
        }
        if (system == 3) {
            if (![avatarPath isEqualToString:nil]) {
                NSString *urlString = avatarPath;
                NSURL  *url = [NSURL URLWithString:urlString];
                NSData *urlData = [NSData dataWithContentsOfURL:url];
                noAvatarImage  = [UIImage imageWithData:urlData];
                [userBackgroundImageView setImage:noAvatarImage];
                filename = [NSString stringWithFormat:@"find_friends_facebook_avatar%@", fileSufix];
                //[userImageView setImage:[UIImage imageNamed:filename]];
            }
        }
    }
    return self;
}

- (void)setStatus {
    NSString *filename;
    UIImage *image;
    if(!pressedContact) {
        if(stateUser == 201) {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add_selected%@", fileSufix];
            image = [UIImage imageNamed:filename];
            [userStatusImageView setImage:image];
        } else {
            filename = [NSString stringWithFormat:@"find_friends_email1_icon%@", fileSufix];
            image = [UIImage imageNamed:filename];
            [userStatusImageView setImage:image];
        }
    } else {
        if(stateUser == 201) {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
            image = [UIImage imageNamed:filename];
            [userStatusImageView setImage:image];
        } else {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
            image = [UIImage imageNamed:filename];
            [userStatusImageView setImage:image];
        }
    }
    pressedContact = !pressedContact;
}

- (void)contactClick {
    NSString *filename;
    UIImage *image;
    if(!pressedContact) {
        if(stateUser == 201) {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add_selected%@", fileSufix];
            image = [UIImage imageNamed:filename];
            [userStatusImageView setImage:image];
        } else {
            filename = [NSString stringWithFormat:@"find_friends_email1_icon%@", fileSufix];
            [userStatusImageView setImage:[UIImage imageNamed:filename]];
        }
        [self.delegate contactClick:self andRemove:NO];
    } else {
        if(stateUser == 201) {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
            [userStatusImageView setImage:[UIImage imageNamed:filename]];
        } else {
            filename = [NSString stringWithFormat:@"find_by_phonebook_add%@", fileSufix];
            [userStatusImageView setImage:[UIImage imageNamed:filename]];
        }
        [self.delegate contactClick:self andRemove:YES];
    }
    pressedContact = !pressedContact;
}

@end
