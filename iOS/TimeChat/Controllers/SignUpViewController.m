//
//  ProfileViewController.m
//  TimeChat
//


#import "SignUpViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface SignUpViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor, *placeTextColor;
    UITextField     *encryptionKeyTextField;
    UITextField     *nameTextField,*userNameTextField;
    UITextField     *passwordTextField,*confirmPasswordTextField;
    UIImageView     *fotoImage;
    UIControl       *viewControl;
    NSMutableData   *userData;
    NSString *fileSufix;
    UIScrollView    *scrollView;
    CGSize sizeTextInField;
    float margin1;
    float margin2;
    MBProgressHUD *hud;
}

@end

@implementation SignUpViewController

@synthesize registration;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    userData = [[NSMutableData alloc] init];
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    
    [self create];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)create {
    
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
    placeTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
    NSString *filename, *fieldFilename;
    UIImage *image;
    CGRect size;
    
    UIDevice *thisDevice = [UIDevice currentDevice];
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        margin1 = 0;
        margin2 = 77;
    } else if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        margin1 = 20;
        margin2 = 77.5;
    }
    
    UIColor *textColor = [UIColor colorWithRed:255.0f/255.0f green:171.0f/255.0f blue:136.0f/255.0f alpha:1];
    UIColor *InputTextColor = [UserDataSingleton sharedSingleton].InputTextColor;
    
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
    str = @"Create an account";
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
    [backButton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    // scrollView
    size.size.width = screenWidth;
    size.size.height = screenHeight - (statusBarHeight + titleBackgroundView.frame.size.height);
    size.origin.x = 0;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height;
    scrollView = [[UIScrollView alloc] initWithFrame:size];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    
    // USERNAME Label
    heightSpace = 58 * scale;
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font2}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = heightSpace;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:size];
    userNameLabel.text          = @"USERNAME";
    userNameLabel.textColor     = darkTextColor;
    userNameLabel.font          = font2;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:userNameLabel];
    
    // USERNAME Input
    heightSpace = 18 * scale;
    fieldFilename = [NSString stringWithFormat:@"signup_input%@", fileSufix];
    UIImage *textFieldImage = [UIImage imageNamed:fieldFilename];
    CGRect sizeTextFieldsBounds;
    sizeTextFieldsBounds.size.width = textFieldImage.size.width * scale;
    sizeTextFieldsBounds.size.height = textFieldImage.size.height * scale;
    sizeTextFieldsBounds.origin.x = (self.view.frame.size.width - sizeTextFieldsBounds.size.width) / 2;
    sizeTextFieldsBounds.origin.y = userNameLabel.frame.origin.y + userNameLabel.frame.size.height + heightSpace;
    userNameTextField = [[UITextField alloc] initWithFrame: sizeTextFieldsBounds];
    [userNameTextField setBackground:textFieldImage];
    userNameTextField.backgroundColor = [UIColor clearColor];
    userNameTextField.textColor = lightTextColor;
    userNameTextField.font = font2;
    userNameTextField.returnKeyType = UIReturnKeyDone;
    userNameTextField.delegate = self;
    userNameTextField.textAlignment = NSTextAlignmentCenter;
    userNameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:userNameTextField];
    
    // EMAIL Label
    heightSpace = 58 * scale;
    size.origin.y = userNameTextField.frame.origin.y + userNameTextField.frame.size.height + heightSpace;
    UILabel *emailLabel = [[UILabel alloc] initWithFrame:size];
    emailLabel.text          = @"EMAIL";
    emailLabel.textColor     = darkTextColor;
    emailLabel.font          = font2;
    emailLabel.textAlignment = NSTextAlignmentCenter;
    emailLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:emailLabel];
    
    // EMAIL Input
    heightSpace = 18 * scale;
    sizeTextFieldsBounds.origin.y = emailLabel.frame.origin.y + emailLabel.frame.size.height + heightSpace;
    nameTextField = [[UITextField alloc] initWithFrame:sizeTextFieldsBounds];
    [nameTextField setBackground:textFieldImage];
    nameTextField.backgroundColor = [UIColor clearColor];
    nameTextField.textColor = lightTextColor;
    nameTextField.font = font2;
    nameTextField.returnKeyType = UIReturnKeyDone;
    nameTextField.delegate = self;
    nameTextField.textAlignment = NSTextAlignmentCenter;
    nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [scrollView addSubview:nameTextField];
    
    // PASSWORD Label
    heightSpace = 58 * scale;
    size.origin.y = nameTextField.frame.origin.y + nameTextField.frame.size.height + heightSpace;
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:size];
    passwordLabel.text          = @"PASSWORD";
    passwordLabel.textColor     = darkTextColor;
    passwordLabel.font          = font2;
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:passwordLabel];
    
    // PASSWORD Input
    heightSpace = 18 * scale;
    sizeTextFieldsBounds.origin.y = passwordLabel.frame.origin.y + passwordLabel.frame.size.height + heightSpace;
    passwordTextField = [[UITextField alloc] initWithFrame:sizeTextFieldsBounds];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.text = @"";
    [passwordTextField setBackground:textFieldImage];
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    passwordTextField.font = font2;
    passwordTextField.textColor = lightTextColor;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.delegate = self;
    passwordTextField.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:passwordTextField];

    // CONFIRM PASSWORD Label
    heightSpace = 58 * scale;
    size.size = [@"CONFIRM PASSWORD" sizeWithAttributes:@{NSFontAttributeName:font2}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = passwordTextField.frame.origin.y + passwordTextField.frame.size.height + heightSpace;
    UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:size];
    confirmPasswordLabel.text = @"CONFIRM PASSWORD";
    confirmPasswordLabel.textColor = darkTextColor;
    confirmPasswordLabel.font = font2;
    confirmPasswordLabel.backgroundColor = [UIColor clearColor];
    confirmPasswordLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:confirmPasswordLabel];
    
    // CONFIRM PASSWORD Input
    heightSpace = 18 * scale;
    sizeTextFieldsBounds.origin.y = confirmPasswordLabel.frame.origin.y + confirmPasswordLabel.frame.size.height + heightSpace;
    confirmPasswordTextField = [[UITextField alloc] initWithFrame:sizeTextFieldsBounds];
    confirmPasswordTextField.secureTextEntry = YES;
    confirmPasswordTextField.text = @"";
    [confirmPasswordTextField setBackground:textFieldImage];
    [confirmPasswordTextField setBackgroundColor:[UIColor clearColor]];
    confirmPasswordTextField.font = font2;
    confirmPasswordTextField.textColor = lightTextColor;
    confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    confirmPasswordTextField.delegate = self;
    confirmPasswordTextField.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:confirmPasswordTextField];
    
    // Sign Up Button
    heightSpace = 68 * scale;
    filename = [NSString stringWithFormat:@"signup_button%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = confirmPasswordTextField.frame.origin.y + confirmPasswordTextField.frame.size.height + heightSpace;
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"signup_button_down%@", fileSufix];
    [signUpButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [signUpButton setFrame:size];
    signUpButton.backgroundColor = [UIColor clearColor];
    [signUpButton setTitle:@"SIGN UP" forState:UIControlStateNormal];
    [signUpButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [signUpButton addTarget:self action:@selector(pressSignUpButton)  forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:signUpButton];
    
    heightSpace = 48 * scale;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, signUpButton.frame.origin.y + signUpButton.frame.size.height + heightSpace);
    
    [self.view addSubview:hud];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

//==============================   BUTTONS   ========================================

- (void)backButtonPress {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)pressSignUpButton {


        if([userNameTextField.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input username." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if([nameTextField.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input email." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if([passwordTextField.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Please input password." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if ([passwordTextField.text length] < 8){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Password is too short (minimum is 8 characters)" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        if (![passwordTextField.text isEqualToString: confirmPasswordTextField.text]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"ConfirmPassword is incorrect." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
            [alertView show];
            return;
        }

        [[UserDataSingleton sharedSingleton].userDefaults setObject:passwordTextField.text forKey:@"password"];
        [[UserDataSingleton sharedSingleton].userDefaults synchronize];
        [UserDataSingleton sharedSingleton].password = passwordTextField.text;
        [UserDataSingleton sharedSingleton].userName = nameTextField.text;
    
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/sign_up"]];
    
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"sign_up" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:userNameTextField.text forKey:@"username"];
        [request setPostValue:nameTextField.text forKey:@"email"];
        [request setPostValue:@"email" forKey:@"social_type"];
        [request setPostValue:passwordTextField.text forKey:@"password"];
        [request setPostValue:[UserDataSingleton sharedSingleton].deviceId forKey:@"dev_id"];
        [request setPostValue:[self getTimeZone] forKey:@"time_zone"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
}

- (NSString *)getTimeZone
{
    NSTimeZone *localTime = [NSTimeZone systemTimeZone];
    NSString *stringTimeZone = [NSString stringWithFormat:@"%ld",[localTime secondsFromGMT]/3600];
    return stringTimeZone;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)sendMail{
    if ([MFMailComposeViewController canSendMail]){
        NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
        NSString *model = [[UIDevice currentDevice] model];
        NSString *version = @"FGS_VERSION";
        NSString *build = @"SUCCESS_LOGIN";
        MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
        
        mailComposer.mailComposeDelegate = self;
        [mailComposer setToRecipients:[NSArray arrayWithObjects: nameTextField.text,nil]];
        [mailComposer setSubject:[NSString stringWithFormat: @"%@ V%@ (build %@) Support", NSLocalizedString(@"Family GoStop", @"App Name"),version,build]];
        NSString *supportText = [NSString stringWithFormat:@"[Device: %@]\n[iOS Version:%@]\n",model,iOSVersion];
        supportText = [supportText stringByAppendingString: NSLocalizedString(@"Please describe your problem or question.", @"")];
        [mailComposer setMessageBody:supportText isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Message"
                                  message:@"This device can't send mail."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];

    if (result == MFMailComposeResultFailed) {
        NSLog(@"Support mail failed: Error Code:%ld, %@", (long)error.code, [error description]);
    }
}

//==============================   EDIT   ========================================
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.frame.origin.y + textView.frame.size.height > keyboardHeight) {
        double offset = keyboardHeight - textView.frame.origin.y - textView.frame.size.height - 20;
        CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                              self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(removeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
}
- (void)removeKeyboard {
//    [statusTextView resignFirstResponder];
    [nameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [viewControl removeFromSuperview];
    viewControl = nil;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    int space = 0;
//    if(statusBarHeight == 0) {
//        space = 20;
//    }
    CGRect rect = CGRectMake(0, space, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
    [viewControl removeFromSuperview];
    viewControl = nil;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ((textField.frame.origin.y + textField.frame.size.height + statusBarHeight + margin2 - scrollView.contentOffset.y) > keyboardHeight) {
        double offset = (textField.frame.origin.y + textField.frame.size.height + statusBarHeight + margin2 - scrollView.contentOffset.y) - keyboardHeight;
        // - statusBarHeight;
        CGRect rect = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = rect;
        [UIView commitAnimations];
    }
    viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,
                                                              self.view.frame.size.height)];
    [viewControl addTarget:self action:@selector(removeKeyboard)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewControl];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    int space = 0;
//    if(statusBarHeight == 0) {
//        space = 20;
//    }
    CGRect rect = CGRectMake(0, space, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
    [viewControl removeFromSuperview];
    viewControl = nil;
}
//=================================================================================
#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if(!error) {
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
                              options: NSJSONReadingMutableContainers
                              error: &error];
         NSLog(@"signUp = %@", json);
        NSDictionary    *message   = [json objectForKey:@"message"];
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"sign_up"]) {
            userData = [[NSMutableData alloc] init];
            [UserDataSingleton sharedSingleton].status=[message objectForKey:@"value"];

            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Message"
                                      message:[message objectForKey:@"value"]
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            if ([[message objectForKey:@"type"] isEqualToString:@"success"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
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
