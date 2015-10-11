//
//  FindFriendsByUsernameViewController.m
//  TimeChat
//


#import "FindFriendsByUsernameViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface FindFriendsByUsernameViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    UIControl       *viewControl;
    UITextField     *emailTextField;
    UITextField     *gmailTextField;
    UITextField     *passwordTextField;
    UIImageView     *emailTextView;
    NSString        *fileSufix;
    MBProgressHUD   *hud;
}
@end

@implementation FindFriendsByUsernameViewController

- (id)init {
    if(self = [super init]) {
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
    screenHeight = self.view.frame.size.height;
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
    str = @"Find friends by username";
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
    filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(clickBackButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Username Image
    heightSpace = 86 * scale;
    filename=[NSString stringWithFormat:@"find_by_username%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    UIImageView *usernameImageView = [[UIImageView alloc] initWithFrame:size];
    [usernameImageView setImage:image];
    usernameImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:usernameImageView];
    
    // Username Input
    filename = [NSString stringWithFormat:@"forgot_input%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = usernameImageView.frame.origin.y + usernameImageView.frame.size.height + heightSpace;
    
    emailTextField = [[UITextField alloc] initWithFrame:size];
    emailTextField.backgroundColor = [UIColor clearColor];
    [emailTextField setBackground:image];
    emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    emailTextField.placeholder = @"USERNAME";
    [emailTextField setTextColor:[UIColor whiteColor]];
    emailTextField.delegate = self;
    [emailTextField setTextAlignment:NSTextAlignmentCenter];
    [emailTextField setFont:font2];
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:emailTextField];
    
    // SEARCH Button
    heightSpace = 20 * scale;
    filename = [NSString stringWithFormat:@"forgot_button%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = emailTextField.frame.origin.y + emailTextField.frame.size.height + heightSpace;
    
    UIButton *sendInviteButton = [[UIButton alloc] initWithFrame:size];
    [sendInviteButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"forgot_button_down%@", fileSufix];
    [sendInviteButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [sendInviteButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [sendInviteButton setTitle:@"SEND INVITE" forState:UIControlStateNormal];
    [sendInviteButton addTarget:self action:@selector(clickSendInvite) forControlEvents:UIControlEventTouchUpInside];
    [sendInviteButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [sendInviteButton.titleLabel setFont:font1];
    [self.view addSubview:sendInviteButton];
    
    // hud
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y + textField.frame.size.height  >
        self.view.frame.size.height - keyboardHeight - statusBarHeight) {
        double offset = keyboardHeight + statusBarHeight - textField.frame.origin.y - textField.frame.size.height;
        CGRect rect = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                              self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(removeKeyboard)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
    [viewControl removeFromSuperview];
    viewControl = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)removeKeyboard {
    [emailTextField resignFirstResponder];
    [gmailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [viewControl removeFromSuperview];
    viewControl = nil;
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSendInvite {
    
    if(![emailTextField.text isEqualToString:@""]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/add_friend_by_username"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setTimeOutSeconds:30.f];
        request.userInfo = [NSDictionary dictionaryWithObject:@"add_friend_by_username" forKey:@"type"];
        [request setPostValue:emailTextField.text forKey:@"username"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    } else {
        [self createAlertView:@"Please enter username"];
    }
}

- (void)createAlertView:(NSString *)message {
    CGRect sizeAlertView;
    sizeAlertView.size.height /= 3;
    sizeAlertView.size.width /= 2;
    sizeAlertView.origin.x = (self.view.frame.size.width - sizeAlertView.size.width)/2;
    sizeAlertView.origin.y = (self.view.frame.size.height - sizeAlertView.size.height)/2;
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Message:"
                              message:message
                              delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView setFrame:sizeAlertView];
    [alertView show];
}

- (void)clickViewContacts {
    if([UserDataSingleton sharedSingleton].googleToken) {
        FindFriendsByContactsViewController *controller =
        [[FindFriendsByContactsViewController alloc] init:0];
        [self presentViewController:controller animated:YES completion:nil];
    } else {
        GPPSignIn *signIn = [GPPSignIn sharedInstance];
        
        signIn.clientID = [UserDataSingleton sharedSingleton].kGoogleplusClientID;
        signIn.scopes = [NSArray arrayWithObjects: kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,
                         @"https://www.googleapis.com/auth/userinfo.profile",
                         @"https://www.google.com/m8/feeds",nil];
        signIn.delegate = self;
        [signIn authenticate];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    if(error==nil){
        NSString *authDescr=[auth accessToken];
        [UserDataSingleton sharedSingleton].googleToken = authDescr;
        FindFriendsByContactsViewController *controller =
        [[FindFriendsByContactsViewController alloc] init:0];
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        NSLog(@"=== invite by username ===");
        NSLog(@"%@", json);
        NSLog(@"=== invite by username ===");
        NSDictionary *message = [json objectForKey:@"message"];
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"add_friend_by_username"]) {
            
            if([[message objectForKey:@"type"] isEqualToString:@"success"]) {
                    NSDictionary *contactDictionary = [json objectForKey:@"data"];
                    if ([[contactDictionary objectForKey:@"code"] integerValue] == 201) {
                        [self createAlertView:@"Invitation was sent"];
                    } else {
                        [self createAlertView:[contactDictionary objectForKey:@"debug"]];
                    }
                    emailTextField.text = @"";
            } else {
                [self createAlertView:[message objectForKey:@"value"]]; //@"Can not find this user."];//
            }
        }
    } else {
            [self createAlertView:@"Invalid request"];
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
