//
//  LoginViewController.m
//
//  TimeChat
//

#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "LRGlowingButton.h"
#import "TCViewController.h"

@interface LoginViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor, *placeTextColor, *loginTextColor;
    UILabel         *passwordLabel;
    UITextField     *passwordTextField;
    UILabel         *nameLabel;
    UITextField     *emailTextField;
    UIImageView     *fotoImage;
    UIControl       *viewControl;
    NSData          *userData;
    NSString        *fileSufix;
    UIButton        *sliderButton;
    Boolean         sliderShow;
    NSArray         *mediasArray;
    NSArray         *mediasdataArray;
    Media           *media;
    Mediadata       *mediadata;
    MBProgressHUD   *hud;
    UIView          *eulaView;
}
@end


@implementation LoginViewController

@synthesize registration;

- (void)viewDidLoad
{
    [super viewDidLoad];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    userData = [[NSMutableData alloc] init];
    [UserDataSingleton sharedSingleton].lastPhotoImageID = @"";
    
    ///////////////
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
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign, @".png"];
    
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    placeTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    loginTextColor = [[UserDataSingleton sharedSingleton].loginTextColor objectForKey:str];
    
    NSString *filename;
    // Statubar
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Background
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,statusBarHeight,self.view.frame.size.width, self.view.frame.size.height)];
    filename = [NSString stringWithFormat:@"background%@",   fileSufix];
    UIImage *image=[UIImage imageNamed:filename];
    [background setImage:image];
    background.backgroundColor = [UIColor clearColor];
    [self.view addSubview:background];
    //////////////
    if(![[[UserDataSingleton sharedSingleton].userDefaults valueForKey:@"isAgree"]  isEqualToString: @"true"]) {
        [self createEula];
    }else [self create];
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
////////////////////////////EULA AGREEMENT////////////////////////////////
-(void)createEula{
    float space = 20.5;
    UIFont          *eulafont1, *eulafont2, *eulafont3;
    eulafont1 = [UIFont systemFontOfSize:20];
    eulafont2 = [UIFont systemFontOfSize:18];
    eulafont3 = [UIFont systemFontOfSize:15];
    CGRect  sizePanel;
    sizePanel.size = CGSizeMake(260, 240);
    sizePanel.origin.x = (self.view.bounds.size.width - sizePanel.size.width) / 2;
    sizePanel.origin.y = (self.view.bounds.size.height - sizePanel.size.height) / 2;
    eulaView = [[UIView alloc] initWithFrame:sizePanel];
    eulaView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:eulaView];
    eulaView.layer.cornerRadius = 32.0f;
    eulaView.layer.masksToBounds = YES;
    eulaView.layer.borderColor = [[UIColor grayColor]CGColor];
    eulaView.layer.borderWidth = 1.0f;
    
    UILabel *titleLabel ;
    CGRect  sizeTitle;
    sizeTitle.size = [@"EULA AGREEMENT" sizeWithAttributes:@{NSFontAttributeName:eulafont1}];
    sizeTitle.origin.x = (eulaView.frame.size.width - sizeTitle.size.width) / 2;
    sizeTitle.origin.y = space;
    titleLabel = [[UILabel alloc] initWithFrame: sizeTitle];
    titleLabel.text             = @"EULA AGREEMENT";
    titleLabel.textColor        = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font             = eulafont1;
    titleLabel.backgroundColor  = [UIColor clearColor];
    [eulaView addSubview:titleLabel];
    
    UILabel *firstLabel ;
    CGRect  sizefirst;
    sizefirst.size = [@"BEFORE CONTINUING\n PLEASE READ OUR" sizeWithAttributes:@{NSFontAttributeName:eulafont3}];
    sizefirst.size.width = eulaView.frame.size.width;
    sizefirst.size.height *= 2;
    sizefirst.origin.x = (eulaView.frame.size.width - sizefirst.size.width) / 2;
    sizefirst.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height + space;
    firstLabel = [[UILabel alloc] initWithFrame: sizefirst];
    firstLabel.text             = @"BEFORE CONTINUING\n PLEASE READ OUR";
    firstLabel.textColor        = [UIColor blackColor];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstLabel.numberOfLines = 0;
    firstLabel.font             = eulafont3;
    firstLabel.backgroundColor  = [UIColor clearColor];
    [eulaView addSubview:firstLabel];
    
    NSString *privacyStr = @"PRIVACY POLICY";
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sizefirst.size = [privacyStr sizeWithAttributes:@{NSFontAttributeName:eulafont3}];
    sizefirst.origin.x = (eulaView.frame.size.width - sizefirst.size.width) / 2;
    sizefirst.origin.y += sizefirst.size.height * 3;
    [privacyButton setBackgroundColor:[UIColor clearColor]];
    [privacyButton setFrame:sizefirst];
    [privacyButton setTitle:privacyStr forState:UIControlStateNormal];
    [privacyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [privacyButton.titleLabel setFont:eulafont3];
    [privacyButton addTarget:self action:@selector(pressPrivacyButton:) forControlEvents:UIControlEventTouchUpInside];
    [eulaView addSubview:privacyButton];
    
    sizefirst.size = [@"&" sizeWithAttributes:@{NSFontAttributeName:eulafont3}];
    sizefirst.origin.x = privacyButton.frame.origin.x + privacyButton.frame.size.width;
    firstLabel = [[UILabel alloc] initWithFrame: sizefirst];
    firstLabel.text             = @"&";
    firstLabel.textColor        = [UIColor blackColor];
    firstLabel.textAlignment = NSTextAlignmentCenter;
    firstLabel.lineBreakMode = NSLineBreakByWordWrapping;
    firstLabel.numberOfLines = 0;
    firstLabel.font             = eulafont3;
    firstLabel.backgroundColor  = [UIColor clearColor];
    [eulaView addSubview:firstLabel];
    
    privacyStr = @"TERMS OF CONDITIONS.";
    UIButton *TCButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sizefirst.size = [privacyStr sizeWithAttributes:@{NSFontAttributeName:eulafont3}];
    sizefirst.origin.x = (eulaView.frame.size.width - sizefirst.size.width) / 2;
    sizefirst.origin.y += sizefirst.size.height;
    [TCButton setBackgroundColor:[UIColor clearColor]];
    [TCButton setFrame:sizefirst];
    [TCButton setTitle:privacyStr forState:UIControlStateNormal];
    [TCButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [TCButton.titleLabel setFont:eulafont3];
    [TCButton addTarget:self action:@selector(pressTCButton:) forControlEvents:UIControlEventTouchUpInside];
    [eulaView addSubview:TCButton];
    
    privacyStr = @"CANCEL";
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sizefirst.size = CGSizeMake(eulaView.frame.size.width / 3, space * 2);
    sizefirst.origin.x = (eulaView.frame.size.width - sizefirst.size.width * 2) / 3;
    sizefirst.origin.y += sizefirst.size.height;
    [cancelButton setBackgroundColor:[UIColor orangeColor]]; // colorWithRed:1.0 green:110/255 blue:23/255 alpha:1.0
    [cancelButton setFrame:sizefirst];
    [cancelButton setTitle:privacyStr forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:eulafont2];
    [cancelButton addTarget:self action:@selector(pressCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [eulaView addSubview:cancelButton];
    cancelButton.layer.cornerRadius = 16.0f;
    cancelButton.layer.masksToBounds = YES;
    
    privacyStr = @"ACCEPT";
    UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sizefirst.origin.x = sizefirst.size.width + (eulaView.frame.size.width - sizefirst.size.width * 2)*2 / 3;
    [acceptButton setBackgroundColor:[UIColor cyanColor]]; // colorWithRed:7/255 green:220/255 blue:187/255 alpha:1.0
    [acceptButton setFrame:sizefirst];
    [acceptButton setTitle:privacyStr forState:UIControlStateNormal];
    [acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [acceptButton.titleLabel setFont:eulafont2];
    [acceptButton addTarget:self action:@selector(pressAcceptButton:) forControlEvents:UIControlEventTouchUpInside];
    [eulaView addSubview:acceptButton];
    acceptButton.layer.cornerRadius = 16.0f;
    acceptButton.layer.masksToBounds = YES;
    
}

-(void)pressPrivacyButton:(id)sender{
    [UserDataSingleton sharedSingleton].selectTcPrivate = 2;
    TCViewController *termsViewController = [[TCViewController alloc] init];
    [self presentViewController:termsViewController animated:NO completion:nil];
}

-(void)pressTCButton:(id)sender{
    [UserDataSingleton sharedSingleton].selectTcPrivate = 1;
    TCViewController *termsViewController = [[TCViewController alloc] init];
    [self presentViewController:termsViewController animated:NO completion:nil];
}

-(void)pressCancelButton:(id)sender{
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    [NSThread sleepForTimeInterval:2.0];
    exit(0);
}

-(void)pressAcceptButton:(id)sender{
    [[UserDataSingleton sharedSingleton].userDefaults   setValue:@"true" forKey:@"isAgree"];
    [eulaView setHidden:YES];
    [self create];
}
//////////////////////////////////////////////////////////////////////////
- (void)create {
    
    NSString *filename;
    // LOGIN label
    UILabel *loginLabel;
    heightSpace = 165 * scale;
    CGRect sizeLogin;
    sizeLogin.size = [@"Login" sizeWithAttributes:@{NSFontAttributeName:font1}];
    sizeLogin.origin.x = (screenWidth - sizeLogin.size.width) / 2;
    sizeLogin.origin.y = heightSpace;
    loginLabel = [[UILabel alloc] initWithFrame: sizeLogin];
    loginLabel.text             = @"Login";
    loginLabel.textColor        = loginTextColor;
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.font             = font1;
    loginLabel.backgroundColor  = [UIColor clearColor];
    [self.view addSubview:loginLabel];
    
    //Email or Username input
    heightSpace = 28 * scale;
    filename = [NSString stringWithFormat:@"login_input%@", fileSufix];
    UIImage *textFieldImage = [UIImage imageNamed:filename];
    CGRect sizeTextField;
    sizeTextField.size.height = textFieldImage.size.height * scale;
    sizeTextField.size.width = textFieldImage.size.width * scale;
    sizeTextField.origin.x = (screenWidth - sizeTextField.size.width) / 2;
    sizeTextField.origin.y = loginLabel.frame.origin.y + loginLabel.frame.size.height + heightSpace;
    
    emailTextField = [[UITextField alloc] initWithFrame:sizeTextField];
    emailTextField.backgroundColor = [UIColor clearColor];
    emailTextField.textColor = lightTextColor;
    emailTextField.text=[UserDataSingleton sharedSingleton].userEmail;
    emailTextField.font = font2;
    [emailTextField setBackground:textFieldImage];
    emailTextField.returnKeyType = UIReturnKeyDone;
    emailTextField.delegate = self;
    emailTextField.textAlignment = NSTextAlignmentCenter;
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    emailTextField.placeholder = @"EMAIL or USERNAME";
//    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL or USERNAME" attributes:@{NSForegroundColorAttributeName: placeTextColor}];
    [self.view addSubview:emailTextField];
    
    //Password input
    heightSpace = 20 * scale;
    sizeTextField.origin.y += emailTextField.frame.size.height + heightSpace;

    passwordTextField = [[UITextField alloc] initWithFrame:sizeTextField];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.text = @"";
    [passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    [passwordTextField setBackground:textFieldImage];
    passwordTextField.font = font2;
    passwordTextField.textColor = lightTextColor;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.delegate = self;
    passwordTextField.textAlignment = NSTextAlignmentCenter;
    passwordTextField.placeholder = @"PASSWORD";
//    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: placeTextColor}];
    [self.view addSubview:passwordTextField];
    
    // Sign In Button
    heightSpace = 20 * scale;
    filename=[NSString stringWithFormat:@"login_signin%@", fileSufix];
    UIImage *signButtonImage = [UIImage imageNamed:filename];
    CGRect sizeSignButton;
    sizeSignButton.size.height = signButtonImage.size.height * scale;
    sizeSignButton.size.width = signButtonImage.size.width * scale;
    sizeSignButton.origin.x = sizeTextField.origin.x;
    sizeSignButton.origin.y = sizeTextField.origin.y + passwordTextField.frame.size.height + heightSpace;
    
    UIButton *signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signInButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"login_signin_down%@", fileSufix];
    [signInButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [signInButton setFrame:sizeSignButton];
    signInButton.backgroundColor = [UIColor clearColor];
    [signInButton setTitle:@"SIGN IN" forState:UIControlStateNormal];
    [signInButton setTitleColor:buttonColor forState:UIControlStateNormal];
    signInButton.titleLabel.font = font1;
    [signInButton addTarget:self action:@selector(pressSignInButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signInButton];
    
    sizeSignButton.origin.x += sizeSignButton.size.width + (screenWidth - sizeTextField.origin.x *2 - sizeSignButton.size.width * 2);
    
    // Sign Up Button
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filename=[NSString stringWithFormat:@"login_signup%@", fileSufix];
    [signUpButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"login_signup_down%@", fileSufix];
        [signUpButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [signUpButton setFrame:sizeSignButton];
    signUpButton.backgroundColor = [UIColor clearColor];
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [signUpButton.titleLabel setFont:font1];
    [signUpButton addTarget:self action:@selector(pressSignUpButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:signUpButton];
    
    // OrImage
    heightSpace = 46 * scale;
    filename=[NSString stringWithFormat:@"login_or%@", fileSufix];
    UIImage *orImage = [UIImage imageNamed:filename];
    CGRect sizeOr;
    sizeOr.size.height = orImage.size.height * scale;
    sizeOr.size.width = orImage.size.width * scale;
    sizeOr.origin.x = (screenWidth - sizeOr.size.width) / 2;
    sizeOr.origin.y = signInButton.frame.origin.y + signInButton.frame.size.height + heightSpace;
    UIImageView *orImageView = [[UIImageView alloc] initWithFrame:sizeOr];
    [orImageView setImage:orImage];
    orImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:orImageView];
    
    // Facebook Sign In Button
    heightSpace = 40 * scale;
    filename = [NSString stringWithFormat:@"login_facebook%@", fileSufix];
    UIImage *socialImage = [UIImage imageNamed:filename];
    CGRect sizeSozialButton;
    sizeSozialButton.size.height = socialImage.size.height * scale;
    sizeSozialButton.size.width = socialImage.size.width * scale;
    sizeSozialButton.origin.y = sizeOr.origin.y + sizeOr.size.height + heightSpace;
    widthSpace = (screenWidth - sizeSozialButton.size.width * 2) / 3;
    sizeSozialButton.origin.x = widthSpace;
    
    // Facebook Sign In Button
    UIButton *facebookSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filename=[NSString stringWithFormat:@"login_facebook%@", fileSufix];
    [facebookSignInButton setBackgroundImage:[UIImage imageNamed:filename]  forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"login_facebook_down%@", fileSufix];
    [facebookSignInButton setBackgroundImage:[UIImage imageNamed:filename]  forState:UIControlStateHighlighted];
    [facebookSignInButton setFrame:sizeSozialButton];
    facebookSignInButton.backgroundColor = [UIColor clearColor];
    [facebookSignInButton addTarget:self action:@selector(pressFacebookSignInButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:facebookSignInButton];
    
    sizeSozialButton.origin.x += sizeSozialButton.size.width + widthSpace;
    
     // Twitter Sign In Button
//    UIButton *twitterSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    filename=[NSString stringWithFormat:@"login_twitter%@", fileSufix];
//    [twitterSignInButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
//    filename=[NSString stringWithFormat:@"login_twitter_down%@", fileSufix];
//    [twitterSignInButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
//    [twitterSignInButton setFrame:sizeSozialButton];
//    twitterSignInButton.backgroundColor = [UIColor clearColor];
//    [twitterSignInButton addTarget:self action:@selector(pressTwitterSignInButton) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:twitterSignInButton];
//    
//    sizeSozialButton.origin.x += sizeSozialButton.size.width + widthSpace;
    
    // Google Sign In Button
    UIButton *googleSignInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    filename=[NSString stringWithFormat:@"login_google+%@",  fileSufix];
    [googleSignInButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"login_google+_down%@",  fileSufix];
    [googleSignInButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [googleSignInButton setFrame:sizeSozialButton];
    googleSignInButton.backgroundColor = [UIColor clearColor];
    [googleSignInButton addTarget:self action:@selector(pressGoogleSignInButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:googleSignInButton];
    
    // ForgotButton
    heightSpace = 70 * scale;
    NSString *forgotString = @"Forgot password?";
    CGRect sizeForgotPassword;
    UIButton *forgotPasswordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sizeForgotPassword.size = [forgotString sizeWithAttributes:@{NSFontAttributeName:font2}];
    sizeForgotPassword.origin.x = (screenWidth - sizeForgotPassword.size.width) / 2;
    sizeForgotPassword.origin.y = sizeSozialButton.origin.y + sizeSozialButton.size.height + heightSpace;
    [forgotPasswordButton setBackgroundColor:[UIColor clearColor]];
    [forgotPasswordButton setFrame:sizeForgotPassword];
    [forgotPasswordButton setTitle:forgotString forState:UIControlStateNormal];
    [forgotPasswordButton setTitleColor:loginTextColor forState:UIControlStateNormal];
    [forgotPasswordButton.titleLabel setFont:font2];
    [forgotPasswordButton addTarget:self action:@selector(pressForgotPasswordButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgotPasswordButton];

    [self.view addSubview:hud];
}

//==============================   BUTTONS   ========================================
#pragma mark- Click buttons Event
- (void)pressSignInButton {
    if(![emailTextField.text isEqual:@""] && ![passwordTextField isEqual:@""]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/sign_in"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"sign_in" forKey:@"type"];
        [request setPostValue:emailTextField.text forKey:@"email"];
        [request setPostValue:passwordTextField.text forKey:@"password"];
        [request setPostValue:[self getTimeZone] forKey:@"timezone"];
        [request setPostValue:[UserDataSingleton sharedSingleton].deviceId forKey:@"dev_id"];
        [request setTimeOutSeconds:30.f];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    }
}
- (void)pressSignUpButton {
    SignUpViewController *signUpViewController = [[SignUpViewController alloc] init];
    [self presentViewController:signUpViewController animated:YES completion:nil];
}
- (void)pressForgotPasswordButton {
    ForgotPasswordViewController *forgotPasswordViewController = [[ForgotPasswordViewController alloc] init];
    [self presentViewController:forgotPasswordViewController animated:YES completion:nil];
}

//============================================ Google+ ================================
#pragma mark Google+ Related Methods
- (void)pressGoogleSignInButton {
    [hud show:YES];
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    [signIn setClientID:[UserDataSingleton sharedSingleton].kGoogleplusClientID];
    if (![[GPPSignIn sharedInstance] trySilentAuthentication]) {
        [signIn setShouldFetchGoogleUserID:YES];
        [signIn setShouldFetchGooglePlusUser:YES];
        [signIn setShouldFetchGoogleUserEmail:YES];
        [signIn setScopes:@[kGTLAuthScopePlusLogin]];
        [signIn setDelegate:self];
        [signIn authenticate];
    }
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    [hud hide:YES];
    if (error == nil) {
        NSString *userID = [GPPSignIn sharedInstance].userID;
        NSString *userEmail = [GPPSignIn sharedInstance].userEmail;
        NSString *userName = [GPPSignIn sharedInstance].googlePlusUser.displayName;
        NSString *avatar = [GPPSignIn sharedInstance].googlePlusUser.image.url;
        NSDictionary *params = @{@"social_type":@"google", @"user_id":userID, @"username":userName, @"email":userEmail, @"avatar":avatar, @"dev_id":[UserDataSingleton sharedSingleton].deviceId};
        NSLog(@"g+ params = %@", params);
        [self socialLoginWithParams:params];
    }
}

//============================================ Twitter ===================================
#pragma mark- Twitter Related Methods
- (NSString*)GetPictureLink
{
    NSString *Link = @"-------";
    return Link;
}

- (NSString*)GetMessageText
{
    NSString *Link = @"---------";
    return Link;
}

- (void)pressTwitterSignInButton {
    [hud show:YES];
    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:@"JbZQaxizWErbZaFquT7SMWgB1" andSecret:@"wrX0Ls5bxZuTjXInZB4J9QinUxt464JLAa1NPVk9BnX7QEDS5Z"];
    [[FHSTwitterEngine sharedEngine] setDelegate:self];
    [[FHSTwitterEngine sharedEngine] loadAccessToken];
    
    if ([FHSTwitterEngine sharedEngine].isAuthorized) {
        NSDictionary *params = @{@"social_type":@"twitter", @"user_id":[[FHSTwitterEngine sharedEngine] authenticatedID], @"username":[[FHSTwitterEngine sharedEngine] authenticatedUsername], @"dev_id":[UserDataSingleton sharedSingleton].deviceId};
        NSLog(@"twitter_params1= %@", params);
        [self socialLoginWithParams:params];
    } else {
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            if ([FHSTwitterEngine sharedEngine].isAuthorized) {
                [hud hide:YES];
                NSDictionary *params = @{@"social_type":@"twitter", @"user_id":[[FHSTwitterEngine sharedEngine] authenticatedID], @"username":[[FHSTwitterEngine sharedEngine] authenticatedUsername], @"dev_id":[UserDataSingleton sharedSingleton].deviceId};
                [self performSelector:@selector(socialLoginWithParams:) withObject:params afterDelay:1];
                NSLog(@"twitter_params2 = %@", params);
            }
        }]	;
        [self presentViewController:loginController animated:YES completion:nil];
    }
    NSLog(@"Twitter - Cancel press");
    [hud hide:YES];
}

#pragma mark- FHSTwitterEngine Delegate Methods
//==================================================
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedTwitterAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedTwitterAccessHTTPBody"];
}

//============================================ Facebook  =========================================
#pragma mark Facebook Related Methods
- (void)pressFacebookSignInButton {
    [hud show:YES];
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             // Retrieve the app delegate
             [self sessionStateChanged:session state:state error:error];
         }];
    }
}

- (void)requestUserFBInfo
{
    // We will request the user's public picture and the user's birthday
    // These are the permissions we need:
    // Request the permissions the user currently has
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *userInfo, NSError *error) {
        if (!error) {
            // Success! Include your code to handle the results here
            NSDictionary *params = @{@"social_type":@"facebook", @"user_id":userInfo[@"id"], @"username":userInfo[@"name"], @"email":userInfo[@"email"], @"avatar":[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", userInfo[@"id"]], @"dev_id":[UserDataSingleton sharedSingleton].deviceId};
            NSLog(@"facebookBook_param = %@", params);
            [self socialLoginWithParams:params];
            
        } else {
            // An error occurred, we need to handle the error
            // Check out our error handling guide: https://developers.facebook.com/docs/ios/errors/
            NSLog(@"error %@", error.description);
            NSLog(@"FaceBook1");
        }
    }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error {
    switch (state) {
        case FBSessionStateOpen: {
            NSString *fbToken=[[[FBSession activeSession] accessTokenData] description];
            [UserDataSingleton sharedSingleton].facebookToken = fbToken;
            [self requestUserFBInfo];
            break;
        }
        case FBSessionStateClosed:
            NSLog(@"FaceBook - FBSessionStateClosed");
        case FBSessionStateClosedLoginFailed: {
//            UIAlertView *alertView = [[UIAlertView alloc]
//                                      initWithTitle:@"Close"
//                                      message:error.localizedDescription
//                                      delegate:nil
//                                      cancelButtonTitle:@"OK"
//                                      otherButtonTitles:nil];
//            [alertView show];
            NSLog(@"FaceBook2 - FBSessionStateClosedLoginFailed");
            break;
        }
        default:
        {
            break;
        }
    }
//    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Error"
//                                  message:error.localizedDescription
//                                  delegate:nil
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//        NSLog(@"FaceBook3 - %@", error.localizedDescription);
//    }
    [hud hide:YES];
}
//=====IN USERNAME REMOVE SPACE =====//
-(NSString *)fixUsername:(NSString *)userName{
    NSString * newUserName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newUserName;
}
//==============================   EDIT   ===========================================================
#pragma mark Edit Methods
- (void)removeKeyboard {
//    [statusTextView resignFirstResponder];
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [viewControl removeFromSuperview];
    viewControl = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y + textField.frame.size.height > keyboardHeight) {
        double offset = keyboardHeight - textField.frame.origin.y - textField.frame.size.height - statusBarHeight;
        CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    
    passwordLabel.text = @"  ";
    nameLabel.text     = @"  ";
    viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                              self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(removeKeyboard)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int space = 0;
//    if(statusBarHeight == 0) {
//        space = 20;
//    }
    CGRect rect = CGRectMake(0, space, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    [viewControl removeFromSuperview];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//================================================================================================
- (void)socialLoginWithParams:(NSDictionary *)params
{  
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/sign_up"]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30.f];
    
    NSArray *keys = [params allKeys];
    for (NSString *key in keys) {
        [request setPostValue:params[key] forKey:key];
        
    }
    request.userInfo = [NSDictionary dictionaryWithObject:@"sign_up" forKey:@"type"];
    [request setPostValue:[self getTimeZone] forKey:@"time_zone"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
    NSLog(@"FaceBook - socialLoginWithParams");
}

- (NSString *)getTimeZone
{
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    NSString *stringTimeZone = [NSString stringWithFormat:@"%ld",[localTime secondsFromGMT]/3600];
    return stringTimeZone;
}
//===============================================================================================
#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (!error) {
        NSDictionary *json = [NSJSONSerialization
            JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
            options: NSJSONReadingMutableContainers
            error: &error];
        
        NSDictionary    *message   = [json objectForKey:@"message"];
        NSDictionary *data = [json objectForKey:@"data"];
        NSDictionary *user_info;
        NSDictionary *setting;
        
        [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"sign_up"])  {
            if ([[message objectForKey:@"code"] intValue] == SUCCESS_LOGIN) {
                user_info = [data objectForKey:@"user_info"];
                setting = [data objectForKey:@"setting"];
                NSLog(@"social login data = %@", json);
                [[UserDataSingleton sharedSingleton] setIsLogOut:NO];
                
                //Get User Info
                [UserDataSingleton sharedSingleton].session = [user_info objectForKey:@"token"];
                [UserDataSingleton sharedSingleton].userName= [self fixUsername:[user_info objectForKey:@"username"]];
                [UserDataSingleton sharedSingleton].idUser  = [user_info objectForKey:@"id"];
                [UserDataSingleton sharedSingleton].userEmail = [user_info objectForKey:@"email"];
                
                // Get Setting Info
                [UserDataSingleton sharedSingleton].pushEnable = [[setting objectForKey:@"push_enable"] boolValue];
                [UserDataSingleton sharedSingleton].soundEnable = [[setting objectForKey:@"sound_enable"] boolValue];
                [UserDataSingleton sharedSingleton].notificationSound = [setting objectForKey:@"push_sound"];
                [UserDataSingleton sharedSingleton].autoAcceptFriendEnable = [[setting objectForKey:@"auto_accept_friend"] boolValue];
                [UserDataSingleton sharedSingleton].autoNotifyFriendEnable = [[setting objectForKey:@"auto_notify_friend"] boolValue];
                [UserDataSingleton sharedSingleton].numOfDesign = [[setting objectForKey:@"theme_type"] intValue];
                
                [[UserDataSingleton sharedSingleton].userDefaults   setObject:passwordTextField.text forKey:@"password"];
                [[UserDataSingleton sharedSingleton].userDefaults   setObject:[UserDataSingleton sharedSingleton].session forKey:@"token"];
                [[UserDataSingleton sharedSingleton].userDefaults synchronize];
                
                NSString *avatar = [user_info objectForKey:@"avatar"];
                NSURL *url = [NSURL URLWithString:avatar];
                NSData *userAvatarData = [NSData dataWithContentsOfURL:url];
                [UserDataSingleton sharedSingleton].userImage = [UIImage imageWithData:userAvatarData];
                
                NSError *error = nil;
                if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                [fetchRequest setEntity:entity];
                NSError *requestError = nil;
                NSArray *usersArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
                
                for(int i = 0; i < [usersArray count]; i++) {
                    User *user = [usersArray objectAtIndex:i];
                    if([user.id isEqual:[UserDataSingleton sharedSingleton].idUser]) {
                        [UserDataSingleton sharedSingleton].password  = user.pass;
                        break;
                    }
                }
                
                MainViewController *subVC;
                if (subVC == nil)   subVC = [[MainViewController alloc] init];
                [self presentViewController:subVC animated:YES completion:nil];
            } else {
                [UserDataSingleton sharedSingleton].session = @"token";
                if ([[message objectForKey:@"type"] isEqualToString:@"error"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"error" message:[message objectForKey:@"value"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                }
            }
            [hud hide:YES];
        } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"sign_in"]) {
            NSLog(@"=== sign_in ===");
            NSLog(@"%@", json);
            NSLog(@"=== sign_in ===");
            if ([[message objectForKey:@"code"] intValue] == SUCCESS_LOGIN) {
                [hud hide:YES];
                user_info = [data objectForKey:@"user_info"];
                setting = [data objectForKey:@"setting"];
                
                [[UserDataSingleton sharedSingleton] setIsLogOut:NO];

                // Get User Info
                [UserDataSingleton sharedSingleton].session = [user_info objectForKey:@"token"];
                [UserDataSingleton sharedSingleton].userName= [user_info objectForKey:@"username"];
                [UserDataSingleton sharedSingleton].idUser  = [user_info objectForKey:@"id"];
                [UserDataSingleton sharedSingleton].userEmail = [user_info objectForKey:@"email"];
                
                // Get Setting Info
                [UserDataSingleton sharedSingleton].pushEnable = [[setting objectForKey:@"push_enable"] boolValue];
                [UserDataSingleton sharedSingleton].soundEnable = [[setting objectForKey:@"sound_enable"] boolValue];
                [UserDataSingleton sharedSingleton].notificationSound = [setting objectForKey:@"push_sound"];
                [UserDataSingleton sharedSingleton].autoAcceptFriendEnable = [[setting objectForKey:@"auto_accept_friend"] boolValue];
                [UserDataSingleton sharedSingleton].autoNotifyFriendEnable = [[setting objectForKey:@"auto_notify_friend"] boolValue];
                [UserDataSingleton sharedSingleton].numOfDesign = [[setting objectForKey:@"theme_type"] intValue];
                
                [[UserDataSingleton sharedSingleton].userDefaults   setObject:passwordTextField.text forKey:@"password"];
                [[UserDataSingleton sharedSingleton].userDefaults   setObject:[UserDataSingleton sharedSingleton].session forKey:@"token"];
                [[UserDataSingleton sharedSingleton].userDefaults synchronize];
                
                NSString *avatar = [user_info objectForKey:@"avatar"];
                NSURL *url = [NSURL URLWithString:avatar];
                NSData *userAvatarData = [NSData dataWithContentsOfURL:url];
                [UserDataSingleton sharedSingleton].userImage = [UIImage imageWithData:userAvatarData];
                
                NSError *error = nil;
                if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                [fetchRequest setEntity:entity];
                NSError *requestError = nil;
                NSArray *usersArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
                
                for(int i = 0; i < [usersArray count]; i++) {
                    User *user = [usersArray objectAtIndex:i];
                    if([user.id isEqual:[UserDataSingleton sharedSingleton].idUser]) {
                        [UserDataSingleton sharedSingleton].password  = user.pass;
                        break;
                    }
                }
                
                MainViewController *subVC;
                if (subVC == nil)   subVC = [[MainViewController alloc] init];
                [self presentViewController:subVC animated:YES completion:nil];
            } else {
                [UserDataSingleton sharedSingleton].session = @"token";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:[message objectForKey:@"value"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                [hud hide:YES];
            }
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
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
