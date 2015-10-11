//
//  ForgotPasswordViewController.m
//  TimeChat
//


#import "ForgotPasswordViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface ForgotPasswordViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    UIFont          *font1, *font2, *font3, *font4, *font5;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor, *placeTextColor;
    UITextField     *emailTextField;
    float           keyboardHeight, statusBarHeight;
    UIControl       *viewControl;
    NSString        *fileSufix;
    MBProgressHUD   *hud;
}

@end

@implementation ForgotPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    font1 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize1];
    font2 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize2];
    font3 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize3];
    font4 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize4];
    font5 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize5];
    
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    placeTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
    hud = [[MBProgressHUD alloc] initWithView: self.view];
    
    fileSufix = [NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    
    NSString *filename;
    CGRect size;
    
    // Statubar
    [self setNeedsStatusBarAppearanceUpdate];
    
    // Background
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0,statusBarHeight,screenWidth, screenHeight)];
    filename = [NSString stringWithFormat:@"background%@", fileSufix];
    [background setImage:[UIImage imageNamed:filename]];
    background.backgroundColor = [UIColor clearColor];
    [self.view addSubview:background];

    // Title Background
    filename=[NSString stringWithFormat:@"title_background%@", fileSufix];
    UIImage *titleBackground = [UIImage imageNamed:filename];
    size.size.width = screenWidth;
    size.size.height = titleBackground.size.height / titleBackground.size.width * size.size.width;
    size.origin.x = 0;
    size.origin.y = statusBarHeight;
    UIImageView *titleBackgroundView = [[UIImageView alloc] initWithFrame:size];
    [titleBackgroundView setImage:titleBackground];
    titleBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleBackgroundView];
    
    // Back button
    widthSpace = 25 * scale;
    filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
    UIImage *backImage = [UIImage imageNamed:filename];
    CGRect sizeBackButton;
    sizeBackButton.size.height = backImage.size.height * scale;
    sizeBackButton.size.width = backImage.size.width * scale;
    sizeBackButton.origin.x = widthSpace;
    sizeBackButton.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - sizeBackButton.size.height) / 2;
    UIButton *backButton = [[UIButton alloc] initWithFrame:sizeBackButton];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Forgot your password
    heightSpace = 94 * scale;
    CGRect sizeLabel;
    sizeLabel.size = [@"Forgot your password?" sizeWithAttributes:@{NSFontAttributeName:font1}];
    sizeLabel.origin.x = (screenWidth - sizeLabel.size.width) / 2;
    sizeLabel.origin.y = backButton.frame.origin.y + backButton.frame.size.height + heightSpace;
    
    UILabel *forgotLabel = [[UILabel alloc] initWithFrame:sizeLabel];
    forgotLabel.textColor = darkTextColor;
    forgotLabel.text = @"Forgot your password?";
    [forgotLabel setBackgroundColor:[UIColor clearColor]];
    [forgotLabel setFont:font1];
    [self.view addSubview:forgotLabel];
    
    // It’s Okay. Everyone forgets!
    heightSpace = 70 * scale;
    sizeLabel.size = [@"It’s Okay. Everyone forgets!" sizeWithAttributes:@{NSFontAttributeName:font2}];
    sizeLabel.origin.x = (screenWidth - sizeLabel.size.width) / 2;
    sizeLabel.origin.y = forgotLabel.frame.origin.y + forgotLabel.frame.size.height + heightSpace;
    UILabel *descriptionBeginForgotLabel = [[UILabel alloc] initWithFrame:sizeLabel];
    descriptionBeginForgotLabel.textColor = darkTextColor;
    descriptionBeginForgotLabel.text = @"It’s Okay. Everyone forgets!";
    [descriptionBeginForgotLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionBeginForgotLabel setFont:font2];
    descriptionBeginForgotLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionBeginForgotLabel.numberOfLines = 0;
    [self.view addSubview:descriptionBeginForgotLabel];
    
    // Just tell us ..
    heightSpace = 70 * scale;
    sizeLabel.size = [@"Just tell us your email address" sizeWithAttributes:@{NSFontAttributeName:font2}];
    sizeLabel.size.height *= 4;
    sizeLabel.origin.x = (screenWidth - sizeLabel.size.width) / 2;
    sizeLabel.origin.y = descriptionBeginForgotLabel.frame.origin.y + descriptionBeginForgotLabel.frame.size.height + heightSpace;
    
    UILabel *descriptionEndForgotLabel = [[UILabel alloc] initWithFrame:sizeLabel];
    descriptionEndForgotLabel.textColor = darkTextColor;
    descriptionEndForgotLabel.text = @"Just tell us your email address you used to create your account and we’ll send you a new one!";
    [descriptionEndForgotLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionEndForgotLabel setFont:font2];
    descriptionEndForgotLabel.lineBreakMode = NSLineBreakByWordWrapping;
    descriptionEndForgotLabel.textAlignment = NSTextAlignmentCenter;
    descriptionEndForgotLabel.numberOfLines = 0;
    [self.view addSubview:descriptionEndForgotLabel];
    
    // email input
    heightSpace = 60 * scale;
    filename = [NSString stringWithFormat:@"forgot_input%@", fileSufix];
    UIImage *textFieldImage = [UIImage imageNamed:filename];
    size.size.width = textFieldImage.size.width * scale;
    size.size.height = textFieldImage.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = descriptionEndForgotLabel.frame.origin.y + descriptionEndForgotLabel.frame.size.height + heightSpace;
    
    emailTextField = [[UITextField alloc] initWithFrame: size];
    emailTextField.backgroundColor = [UIColor clearColor];
    emailTextField.textColor = lightTextColor;
    emailTextField.font = font1;
    [emailTextField setBackground:textFieldImage];
    emailTextField.returnKeyType = UIReturnKeyDone;
    emailTextField.delegate = self;
    emailTextField.placeholder = @"EMAIL";
    emailTextField.textAlignment = NSTextAlignmentCenter;
    emailTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.view addSubview:emailTextField];
    
    // Submit button
    heightSpace = 20 * scale;
    filename = [NSString stringWithFormat:@"forgot_button%@", fileSufix];
    UIImage *saveButtonImage = [UIImage imageNamed:filename];
    CGRect sizeSaveButton;
    sizeSaveButton.size.height = saveButtonImage.size.height * scale;
    sizeSaveButton.size.width = saveButtonImage.size.width * scale;
    sizeSaveButton.origin.x = (screenWidth - sizeSaveButton.size.width) / 2;
    sizeSaveButton.origin.y = emailTextField.frame.origin.y + emailTextField.frame.size.height + heightSpace;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"forgot_button_down%@", fileSufix];
    [saveButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [saveButton setFrame:sizeSaveButton];
    saveButton.backgroundColor = [UIColor clearColor];
    [saveButton setTitle:@"SUBMIT" forState:UIControlStateNormal];
    [saveButton setTitleColor:buttonColor  forState:UIControlStateNormal];
    saveButton.titleLabel.font = font1;
    [saveButton addTarget:self action:@selector(pressSubmitButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    [self.view addSubview:hud];
}

-(void)pressSubmitButton {
    if (emailTextField.text && ![emailTextField.text isEqualToString:@""]) {
        [self sendForgotPassword];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)sendForgotPassword {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/forgot_password"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"forgot_password" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:emailTextField.text forKey:@"email"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.frame.origin.y + textField.frame.size.height > keyboardHeight) {
        double offset = keyboardHeight - textField.frame.origin.y - textField.frame.size.height;
        CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
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
    [viewControl removeFromSuperview];
    viewControl = nil;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)removeKeyboard {
    //    [statusTextView resignFirstResponder];
    [emailTextField resignFirstResponder];
    [viewControl removeFromSuperview];
    viewControl = nil;
}


- (void)backButtonPress {
    [self dismissViewControllerAnimated:YES completion:nil];
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
        
        NSDictionary *messageDictionary = [json objectForKey:@"message"];
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"forgot_password"]) {

                 if([[messageDictionary objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
                         UIAlertView *alertSentView = [[UIAlertView alloc]
                                                       initWithTitle:@"Message:"
                                                       message:@"We have sent you your new password to your email address."
                                                       delegate:nil
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                         [alertSentView show];
                 } else {
                         UIAlertView *alertView = [[UIAlertView alloc]
                                                   initWithTitle:@"Message:"
                                                   message:@"This email is not registered in our system."
                                                   delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
                         [alertView show];
                 }

        }
    } else {
            UIAlertView *alertErrorView = [[UIAlertView alloc]
                                           initWithTitle:@"error"
                                           message:@"Error rerquest to server"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
            [alertErrorView show];
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
