//
//  FindFriendsByFacebookViewController.m
//  TimeChat
//


#import "FindFriendsByFacebookViewController.h"

@interface FindFriendsByFacebookViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    int             system;
    int             numberPressedButton;
    NSString        *fileSufix;
}

@end

@implementation FindFriendsByFacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    CGRect size;
    
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
    str = @"Find by Facebook";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - size.size.height) / 2;
    UILabel *settingsLabel = [[UILabel alloc] initWithFrame:size];
    settingsLabel.textColor = titleColor;
    settingsLabel.text = str;
    [settingsLabel setBackgroundColor:[UIColor clearColor]];
    [settingsLabel setFont:font1];
    [self.view addSubview:settingsLabel];
    
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
    [backButton addTarget:self action:@selector(clickBackButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // facebook icon
    heightSpace = 204 * scale;
    filename = [NSString stringWithFormat:@"find_by_facebook%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.y = heightSpace;
    size.origin.x = (screenWidth - size.size.width) / 2;
    
    UIImageView *facebookImageView = [[UIImageView alloc] initWithFrame:size];
    [facebookImageView setImage:image];
    [facebookImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:facebookImageView];
    
    // Add registered user to my friend list
    widthSpace = 58 * scale;
    heightSpace = 40 * scale;
    filename = [NSString stringWithFormat:@"find_by_facebook_item%@", fileSufix];
    UIImage *buttonImage = [UIImage imageNamed:filename];
    CGRect sizeButton;
    sizeButton.size.height = buttonImage.size.height * scale;
    sizeButton.size.width = buttonImage.size.width * scale;
    sizeButton.origin.x = widthSpace;
    sizeButton.origin.y = facebookImageView.frame.origin.y + facebookImageView.frame.size.height + heightSpace;
    
    UIButton *registeredButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registeredButton setFrame:sizeButton];
    [registeredButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_by_facebook_item_down%@", fileSufix];
    [registeredButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [registeredButton setBackgroundColor:[UIColor clearColor]];
    [registeredButton setTitle:@"Add registered users to my Friends list" forState:UIControlStateNormal];
    [registeredButton setTitleColor:darkTextColor forState:UIControlStateNormal];
    [registeredButton.titleLabel setFont:font2];
    registeredButton.titleLabel.numberOfLines = 2;
    registeredButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    registeredButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [registeredButton setTag:0];
    [registeredButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registeredButton];
    
    // Invite friends to TimeChat
    heightSpace = 45 * scale;
    sizeButton.origin.y += sizeButton.size.height + heightSpace;
    UIButton *inviteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteButton setFrame:sizeButton];
    [inviteButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_by_facebook_item_down%@", fileSufix];
    [inviteButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [inviteButton setBackgroundColor:[UIColor clearColor]];
    [inviteButton setTitle:@"Invite friends to TimeChat" forState:UIControlStateNormal];
    [inviteButton setTitleColor:darkTextColor forState:UIControlStateNormal];
    [inviteButton.titleLabel setFont:font2];
    inviteButton.titleLabel.numberOfLines = 2;
    [inviteButton setTag:1];
    [inviteButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:inviteButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)clickButton:(UIButton *)button {
    numberPressedButton = button.tag;
    NSLog(@"facebook %d", numberPressedButton);
    
    if (numberPressedButton == 1) { // Invite button
        if ([UserDataSingleton sharedSingleton].facebookToken) {
            [self inviteFacebookFriends];
        } else {
            [FBSession openActiveSessionWithReadPermissions:@[@"user_friends"]
                                               allowLoginUI:YES
                                          completionHandler:
             ^(FBSession *session, FBSessionState state, NSError *error) {
                 [self sessionStateChanged:session state:state error:error];
             }];
        }
    } else {
        FindFriendsByContactsViewController *controller =
        [[FindFriendsByContactsViewController alloc] init:2];
        controller.inviteFriendToFacebook = numberPressedButton;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
            NSString *fbToken=[[[FBSession activeSession] accessTokenData] description];
            [UserDataSingleton sharedSingleton].facebookToken = fbToken;
            [self inviteFacebookFriends];
            break;
        }
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed: {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Close"
                                      message:error.localizedDescription
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            break;
        }
        default:
        {
            break;
        }
    }
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)inviteFacebookFriends
{
    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
//    params.link = [NSURL URLWithString:@"http://yahoo.com"];
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if (error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        // If the Facebook app is NOT installed and we can't present the share dialog
    } else {
        // FALLBACK: publish just a link using the Feed dialog
        // Put together the dialog parameters
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       @"TimeChat", @"name",
                                       @"", @"caption",
                                       @"Add me on TimeChat", @"description",
                                       
                                       @"", @"picture",
                                       nil];//@"http://yahoo.com", @"link",
        
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User canceled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
    }
}

// A function for parsing URL parameters returned by the Feed Dialog.

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
@end
