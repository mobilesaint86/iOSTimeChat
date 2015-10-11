//
//  FindFriendsViewController.m
//  TimeChat1
//


#import "FindFriendsViewController.h"

@interface FindFriendsViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    NSString        *fileSufix;
}

@end

@implementation FindFriendsViewController

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.width;
    scale = [UserDataSingleton sharedSingleton].scale;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    statusBarHeight = [UserDataSingleton sharedSingleton].statusBarHeight;
    font1 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize1];
    font2 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize2];
    font3 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize3];
    font4 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize4];
    font5 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize5];
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,@".png"];
    
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
    NSString *filename;
    UIImage *image;
    CGRect size, sizeIcon;
    
    // Statubar
    [self setNeedsStatusBarAppearanceUpdate];
    
    // background
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,statusBarHeight, self.view.frame.size.width, self.view.frame.size.height)];
    if([UserDataSingleton sharedSingleton].IOSDevice!=5){
        filename=[NSString stringWithFormat:@"background%@",   fileSufix];
    }else{
        filename=[NSString stringWithFormat:@"background%@",   fileSufix];
    }
    image=[UIImage imageNamed:filename];
    [background setImage:image];
    background.backgroundColor = [UIColor clearColor];
    [self.view addSubview:background];
    
    // Title Background
    filename=[NSString stringWithFormat:@"title_background%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = screenWidth;
    size.size.height = image.size.height / image.size.width * size.size.width;
    size.origin.x = 0;
    size.origin.y = statusBarHeight;
    UIImageView *titleBackgroundView = [[UIImageView alloc] initWithFrame:size];
    [titleBackgroundView setImage:image];
    titleBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleBackgroundView];
    
    // Title text!
    str = @"Find Friends";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - size.size.height) / 2;
    UILabel *descriptionBeginForgotLabel = [[UILabel alloc] initWithFrame:size];
    descriptionBeginForgotLabel.textColor = titleColor;
    descriptionBeginForgotLabel.text = str;
    [descriptionBeginForgotLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionBeginForgotLabel setFont:font1];
    [self.view addSubview:descriptionBeginForgotLabel];
    
    // Back button
    widthSpace = 25 * scale;
    filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
    image = [UIImage imageNamed:filename];
    CGRect sizeBackButton;
    sizeBackButton.size.height = image.size.height * scale;
    sizeBackButton.size.width = image.size.width * scale;
    sizeBackButton.origin.x = widthSpace;
    sizeBackButton.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - sizeBackButton.size.height) / 2;
    UIButton *backButton = [[UIButton alloc] initWithFrame:sizeBackButton];
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Email Button
    heightSpace = 110 * scale;
    filename = [NSString stringWithFormat:@"find_friends_item%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (self.view.frame.size.width - size.size.width)/2;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    UIButton *emailButton = [[UIButton alloc] initWithFrame:size];
    [emailButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_friends_item_down%@", fileSufix];
    [emailButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [emailButton setTitle:@"EMAIL" forState:UIControlStateNormal];
    [emailButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    [emailButton.titleLabel setFont:font1];
    [emailButton addTarget:self action:@selector(clickFindFriendByEmail)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailButton];
    
    // Email Icon
    widthSpace = 23 * scale;
    heightSpace = 8 *scale;
    filename = [NSString stringWithFormat:@"find_friends_email%@", fileSufix];
    image = [UIImage imageNamed:filename];
    sizeIcon.size.height = image.size.height * scale;
    sizeIcon.size.width  = image.size.width * scale;
    sizeIcon.origin.x = widthSpace;
    sizeIcon.origin.y = heightSpace;
    UIImageView *emailImageView = [[UIImageView alloc] initWithFrame:sizeIcon];
    [emailImageView setImage:image];
    emailImageView.backgroundColor = [UIColor clearColor];
    [emailButton addSubview:emailImageView];
    
    // Username Button
    float spaceBetweenButton = 23 * scale;
    filename = [NSString stringWithFormat:@"find_friends_item%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.origin.y += emailButton.frame.size.height + spaceBetweenButton;
    UIButton *usernameButton = [[UIButton alloc] initWithFrame:size];
    [usernameButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_friends_item_down%@", fileSufix];
    [usernameButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [usernameButton setTitle:@"USERNAME" forState:UIControlStateNormal];
    [usernameButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    [usernameButton addTarget:self action:@selector(clickFindFriendByUsername) forControlEvents:UIControlEventTouchUpInside];
    [usernameButton.titleLabel setFont:font1];
    [self.view addSubview:usernameButton];
    
    // Username Icon
    filename = [NSString stringWithFormat:@"find_friends_username%@", fileSufix];
    image = [UIImage imageNamed:filename];
    UIImageView *usernameImageView = [[UIImageView alloc] initWithFrame:sizeIcon];
    [usernameImageView setImage:image];
    usernameImageView.backgroundColor = [UIColor clearColor];
    [usernameButton addSubview:usernameImageView];
    
    // Phonebook Button
    size.origin.y += emailButton.frame.size.height + spaceBetweenButton;
    filename = [NSString stringWithFormat:@"find_friends_item%@", fileSufix];
    UIButton *phonebookButton = [[UIButton alloc] initWithFrame:size];

    [phonebookButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_friends_item_down%@", fileSufix];
    [phonebookButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [phonebookButton setTitle:@"PHONEBOOK" forState:UIControlStateNormal];
    [phonebookButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    [phonebookButton.titleLabel setFont:font1];
    [phonebookButton addTarget:self action:@selector(clickFindFriendByPhonebook) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phonebookButton];
    
    // Phonebook Icon
    filename = [NSString stringWithFormat:@"find_friends_phonebook%@", fileSufix];
    image = [UIImage imageNamed:filename];
    UIImageView *phonebookImageView = [[UIImageView alloc] initWithFrame:sizeIcon];
    [phonebookImageView setImage:image];
    phonebookImageView.backgroundColor = [UIColor clearColor];
    [phonebookButton addSubview:phonebookImageView];
    
    // Facebook Button
    size.origin.y += emailButton.frame.size.height + spaceBetweenButton;
    UIButton *facebookButton = [[UIButton alloc] initWithFrame:size];
    filename = [NSString stringWithFormat:@"find_friends_item%@", fileSufix];
    [facebookButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_friends_item_down%@", fileSufix];
    [facebookButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [facebookButton setTitle:@"FACEBOOK" forState:UIControlStateNormal];
    [facebookButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    [facebookButton addTarget:self action:@selector(clickFindFriendByFacebook)
             forControlEvents:UIControlEventTouchUpInside];
    [facebookButton.titleLabel setFont:font1];
    [self.view addSubview:facebookButton];
    
    // Facebook Icon
    filename = [NSString stringWithFormat:@"find_friends_facebook%@", fileSufix];
    image = [UIImage imageNamed:filename];
    UIImageView *facebookImageView = [[UIImageView alloc] initWithFrame:sizeIcon];
    [facebookImageView setImage:image];
    facebookImageView.backgroundColor = [UIColor clearColor];
    [facebookButton addSubview:facebookImageView];
    
    // Google+ Button
    size.origin.y += emailButton.frame.size.height + spaceBetweenButton;
    UIButton *googleButton = [[UIButton alloc] initWithFrame:size];
    [googleButton setTitle:@"GOOGLE+" forState:UIControlStateNormal];
    [googleButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    [googleButton.titleLabel setFont:font1];
    filename = [NSString stringWithFormat:@"find_friends_item%@", fileSufix];
    [googleButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_friends_item_down%@", fileSufix];
    [googleButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [googleButton addTarget:self action:@selector(clickFindFriendByGooogle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:googleButton];
    
    // Google+ Icon
    filename = [NSString stringWithFormat:@"find_friends_google+%@", fileSufix];
    image = [UIImage imageNamed:filename];
    UIImageView *googleImageView = [[UIImageView alloc] initWithFrame:sizeIcon];
    [googleImageView setImage:image];
    googleImageView.backgroundColor = [UIColor clearColor];
    [googleButton addSubview:googleImageView];
}

- (void)backButtonPress {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickFindFriendByEmail {
    FindFriendsByEmailViewController *controller = [[FindFriendsByEmailViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)clickFindFriendByUsername {
    FindFriendsByUsernameViewController *controller = [[FindFriendsByUsernameViewController alloc] init];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)clickFindFriendByPhonebook {
    FindFriendsByContactsViewController *controller =
        [[FindFriendsByContactsViewController alloc] init:1];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)clickFindFriendByFacebook {
    FindFriendsByFacebookViewController *findFriendsByFacebookViewController = [[FindFriendsByFacebookViewController alloc] init];
    [self presentViewController:findFriendsByFacebookViewController animated:YES completion:nil];
}

- (void)clickFindFriendByGooogle {
    if ([UserDataSingleton sharedSingleton].googleToken) {
        [self inviteGooglePlusFriends];
    } else {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        signIn.clientID = [UserDataSingleton sharedSingleton].kGoogleplusClientID;
        signIn.scopes = [NSArray arrayWithObjects: kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe, nil];
        signIn.delegate = self;
        [signIn authenticate];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if (error == nil){
        NSString *authDescr=[auth accessToken];
        [UserDataSingleton sharedSingleton].googleToken = authDescr;
        [self inviteGooglePlusFriends];
    }
}

- (void)inviteGooglePlusFriends
{
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
//    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://yahoo.com"]];
    [shareBuilder setPrefillText:@"Add me on TimeChat. A fun photo sharing app"];
    //[shareBuilder setContentDeepLinkID:@"turns-on-app-deeplinks-and-passes-this-value"];
    //[shareBuilder setCallToActionButtonWithLabel:@"JOIN" URL:[NSURL URLWithString:@"http://google.com"] deepLinkID:@"turns-on-cta-app-deeplinks"];
    [shareBuilder open];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
