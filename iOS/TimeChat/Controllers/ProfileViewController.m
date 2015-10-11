//
//  ProfileViewController.m
//  TimeChat
//


#import "ProfileViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface ProfileViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor, *placeTextColor, *logoutTextColor;
    UITextField     *encryptionKeyTextField;
    UITextField     *emailTextField,*userNameTextField;
    UITextField     *passwordTextField,*newPasswordTextField,*confirmPasswordTextField;
    UIImageView     *fotoImage;
    UIControl       *viewControl;
    NSMutableData   *userData;
    NSString        *fileSufix;
    UIScrollView    *scrollView;
    PAImageView*    userImage;
    
    Boolean         changePhoto,changePassword,changeEmail,changeName,newUserImage;
    int             changeProcess;
    NSTimer         *timer;
    CGSize          sizeTextInField;
    float           margin1, margin2;
    UIImage         *chosen;
    MBProgressHUD   *hub;
}

@end

@implementation ProfileViewController

@synthesize registration;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	userData = [[NSMutableData alloc] init];
    hub = [[MBProgressHUD alloc] initWithView:self.view];
    
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
    placeTextColor = [[UserDataSingleton sharedSingleton].placeTextColor objectForKey:str];
    logoutTextColor = [[UserDataSingleton sharedSingleton].logoutButtonColor objectForKey:str];
    
    NSString *filename;
    UIImage *image;
    CGRect size;
    
    NSString *fieldFilename;
    UIDevice *thisDevice = [UIDevice currentDevice];
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        margin1 = 0;
        margin2 = 77;
    } else if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        margin1 = 10;
        margin2 = 85;
    }
    
    fileSufix = [NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];

//    UIColor *textColor = [UIColor colorWithRed:255.0f/255.0f green:171.0f/255.0f blue:136.0f/255.0f alpha:1];
//    UIColor *InputTextColor = [UserDataSingleton sharedSingleton].InputTextColor;
    
    changePhoto = changePassword = changeEmail = changeName = newUserImage = false;
    changeProcess=0;
    
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
    str = @"Profile";
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
    [backButton addTarget:self action:@selector(backButtonPress)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // LogOut Button
    heightSpace = 23 * scale;
    widthSpace = 21 * scale;
    filename = [NSString stringWithFormat:@"profile_logout%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = screenWidth - widthSpace - size.size.width;
    size.origin.y = statusBarHeight + heightSpace;
    
    UIButton *logOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [logOutButton setBackgroundImage:image   forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"profile_logout_down%@", fileSufix];
       [logOutButton setBackgroundImage:[UIImage imageNamed:filename]   forState:UIControlStateHighlighted];
    [logOutButton setFrame:size];
    logOutButton.backgroundColor = [UIColor clearColor];
    [logOutButton setTitle:@"Log out" forState:UIControlStateNormal];
    [logOutButton setTitleColor:logoutTextColor forState:UIControlStateNormal];
    logOutButton.titleLabel.font = font3;
    [logOutButton addTarget:self action:@selector(pressLogOutButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logOutButton];
    
    // scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, statusBarHeight + titleBackgroundView.frame.size.height, screenWidth, screenHeight - statusBarHeight - titleBackgroundView.frame.size.height)];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];

    // userImage
    heightSpace = 82 * scale;
    image = [UserDataSingleton sharedSingleton].userImage;
    if([UserDataSingleton sharedSingleton].userImage == nil){
        filename = [NSString stringWithFormat:@"main_thumb%@",   fileSufix];
        image = [UIImage imageNamed:filename];
    }
    size.size.width = 315 * scale;
    size.size.height = 315 * scale;
    size.origin.x  = (screenWidth - size.size.width) / 2;
    size.origin.y = heightSpace;
    userImage = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
    [userImage setImage:image];
    [userImage.layer setBorderWidth:10.f];
    [userImage.layer setBorderColor:[UIColor colorWithRed:231/255.0f green:231/255.0f  blue:231/255.0f alpha:1.0f].CGColor];
    [scrollView  addSubview:userImage];

    
    // Change Photo Label
    heightSpace = 30 * scale;
    str = @"CHANGE PHOTO";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = userImage.frame.origin.y + userImage.frame.size.height + heightSpace;
    UILabel *userPhotoLabel = [[UILabel alloc] initWithFrame:size];
    userPhotoLabel.text = str;
    userPhotoLabel.textColor = darkTextColor;
    userPhotoLabel.font = font3;
    userPhotoLabel.textAlignment = NSTextAlignmentCenter;
    userPhotoLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:userPhotoLabel];

    // View Button
    heightSpace = 52 * scale;
    widthSpace = 190 * scale;
    size.size = [@"View" sizeWithAttributes:@{NSFontAttributeName:font4}];
    size.origin.x = widthSpace;
    size.origin.y = userPhotoLabel.frame.origin.y + userPhotoLabel.frame.size.height + heightSpace;
    UIButton *viewPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    viewPhotoButton.frame = size;
    viewPhotoButton.backgroundColor = [UIColor clearColor];
    [viewPhotoButton setTitle:@"View" forState:UIControlStateNormal];
    [viewPhotoButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    viewPhotoButton.titleLabel.font = font4;
    viewPhotoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [viewPhotoButton addTarget:self action:@selector(selectPhoto)  forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:viewPhotoButton];

    // Take a photo Button
    size.size = [@"Take a photo" sizeWithAttributes:@{NSFontAttributeName:font4}];
    size.origin.x = screenWidth - widthSpace - size.size.width;
    UIButton *takePhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [takePhotoButton setFrame:size];
    takePhotoButton.backgroundColor = [UIColor clearColor];
    [takePhotoButton setTitle:@"Take a photo" forState:UIControlStateNormal];
    [takePhotoButton setTitleColor:lightTextColor forState:UIControlStateNormal];
    takePhotoButton.titleLabel.font = font4;
    takePhotoButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [takePhotoButton addTarget:self action:@selector(takePhoto)  forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:takePhotoButton];

    // USERNAME Label
    heightSpace = 70 * scale;
    size.size = [@"USERNAME" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = takePhotoButton.frame.origin.y + takePhotoButton.frame.size.height + heightSpace;
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:size];
    userNameLabel.text          = @"USERNAME";
    userNameLabel.textColor     = darkTextColor;
    userNameLabel.font          = font3;
    userNameLabel.textAlignment = NSTextAlignmentCenter;
    userNameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:userNameLabel];

    // USERNAME Input
    heightSpace = 16 * scale;
    fieldFilename=[NSString stringWithFormat:@"profile_input%@",   fileSufix];
    image = [UIImage imageNamed:fieldFilename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = userNameLabel.frame.origin.y + userNameLabel.frame.size.height + heightSpace;
    userNameTextField = [[UITextField alloc] initWithFrame: size];
    [userNameTextField setBackground:image];
    userNameTextField.backgroundColor = [UIColor clearColor];
    userNameTextField.textColor = lightTextColor;
    userNameTextField.text=[UserDataSingleton sharedSingleton].userName;
    userNameTextField.font = font3;
    userNameTextField.returnKeyType = UIReturnKeyDone;
    userNameTextField.delegate = self;
    userNameTextField.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:userNameTextField];

    // EMAIL Label
    heightSpace = 54 * scale;
    size.size = [@"EMAIL" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = userNameTextField.frame.origin.y + userNameTextField.frame.size.height + heightSpace;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:size];
    nameLabel.text          = @"EMAIL";
    nameLabel.textColor     = darkTextColor;
    nameLabel.font          = font3;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:nameLabel];

    // EMAIL Input
    heightSpace = 16 * scale;
    fieldFilename=[NSString stringWithFormat:@"profile_input%@",   fileSufix];
    image = [UIImage imageNamed:fieldFilename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = nameLabel.frame.origin.y + nameLabel.frame.size.height + heightSpace;

    emailTextField = [[UITextField alloc] initWithFrame:size];
    [emailTextField setBackground:image];
    emailTextField.backgroundColor = [UIColor clearColor];
    emailTextField.textColor = lightTextColor;
    emailTextField.text=[UserDataSingleton sharedSingleton].userEmail;
    emailTextField.font = font3;
    emailTextField.returnKeyType = UIReturnKeyDone;
    emailTextField.delegate = self;
    emailTextField.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:emailTextField];

    // OLD PASSWORD Label
    heightSpace = 54 * scale;
    size.size = [@"OLD PASSWORD" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = emailTextField.frame.origin.y + emailTextField.frame.size.height + heightSpace;
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:size];
    passwordLabel.text = @"OLD PASSWORD";
    passwordLabel.textColor = darkTextColor;
    passwordLabel.font = font3;
    passwordLabel.textAlignment = NSTextAlignmentCenter;
    passwordLabel.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:passwordLabel];

    // OLD PASSWORD Input
    heightSpace = 16 * scale;
    fieldFilename=[NSString stringWithFormat:@"profile_input%@",   fileSufix];
    image = [UIImage imageNamed:fieldFilename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = passwordLabel.frame.origin.y + passwordLabel.frame.size.height + heightSpace;

    passwordTextField = [[UITextField alloc] initWithFrame:size];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.text = @"";
    [passwordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [passwordTextField setBackground:image];
    [passwordTextField setBackgroundColor:[UIColor clearColor]];
    passwordTextField.font = font3;
    passwordTextField.textColor = lightTextColor;
    passwordTextField.returnKeyType = UIReturnKeyDone;
    passwordTextField.delegate = self;
    passwordTextField.textAlignment = NSTextAlignmentCenter;
    passwordTextField.placeholder = @"PASSWORD";
    [scrollView addSubview:passwordTextField];

    // NEW PASSWORD Label
    heightSpace = 54 * scale;
    size.size = [@"NEW PASSWORD" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = passwordTextField.frame.origin.y + passwordTextField.frame.size.height + heightSpace;
    UILabel *newPasswordLabel = [[UILabel alloc] initWithFrame:size];
    newPasswordLabel.text = @"NEW PASSWORD";
    newPasswordLabel.textColor = darkTextColor;
    newPasswordLabel.font = font3;
    newPasswordLabel.backgroundColor = [UIColor clearColor];
    newPasswordLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:newPasswordLabel];

    // NEW PASSWORD Input
    heightSpace = 16 * scale;
    fieldFilename=[NSString stringWithFormat:@"profile_input%@",   fileSufix];
    image = [UIImage imageNamed:fieldFilename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = newPasswordLabel.frame.origin.y + newPasswordLabel.frame.size.height + heightSpace;

    newPasswordTextField = [[UITextField alloc] initWithFrame:size];
    newPasswordTextField.secureTextEntry = YES;
    newPasswordTextField.text = @"";
    [newPasswordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [newPasswordTextField setBackground:image];
    [newPasswordTextField setBackgroundColor:[UIColor clearColor]];
    newPasswordTextField.font = font3;
    newPasswordTextField.textColor = lightTextColor;
    newPasswordTextField.returnKeyType = UIReturnKeyDone;
    newPasswordTextField.delegate = self;
    newPasswordTextField.textAlignment = NSTextAlignmentCenter;
    newPasswordTextField.placeholder = @"NEW PASSWORD";
    [scrollView addSubview:newPasswordTextField];

    // confirm Password Label
    heightSpace = 54 * scale;
    size.size = [@"CONFIRM PASSWORD" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = newPasswordTextField.frame.origin.y + newPasswordTextField.frame.size.height + heightSpace;
    UILabel *confirmPasswordLabel = [[UILabel alloc] initWithFrame:size];
    confirmPasswordLabel.text = @"CONFIRM PASSWORD";
    confirmPasswordLabel.textColor = darkTextColor;
    confirmPasswordLabel.font = font3;
    confirmPasswordLabel.backgroundColor = [UIColor clearColor];
    confirmPasswordLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:confirmPasswordLabel];

    // Confirm Password Input
    heightSpace = 16 * scale;
    fieldFilename=[NSString stringWithFormat:@"profile_input%@",   fileSufix];
    image = [UIImage imageNamed:fieldFilename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = confirmPasswordLabel.frame.origin.y + confirmPasswordLabel.frame.size.height + heightSpace;

    confirmPasswordTextField = [[UITextField alloc] initWithFrame:size];
    confirmPasswordTextField.secureTextEntry = YES;
    confirmPasswordTextField.text = @"";
    [confirmPasswordTextField setLeftViewMode:UITextFieldViewModeAlways];
    [confirmPasswordTextField setBackground:image];
    [confirmPasswordTextField setBackgroundColor:[UIColor clearColor]];
    confirmPasswordTextField.font = font3;
    confirmPasswordTextField.textColor = lightTextColor;
    confirmPasswordTextField.returnKeyType = UIReturnKeyDone;
    confirmPasswordTextField.delegate = self;
    confirmPasswordTextField.textAlignment = NSTextAlignmentCenter;
    confirmPasswordTextField.placeholder = @"CONFIRM PASSWORD";
    [scrollView addSubview:confirmPasswordTextField];

    // Save Button
    heightSpace = 54 * scale;
    fieldFilename=[NSString stringWithFormat:@"profile_save%@",   fileSufix];
    image = [UIImage imageNamed:fieldFilename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = confirmPasswordTextField.frame.origin.y + confirmPasswordTextField.frame.size.height + heightSpace;
    
    UIButton *signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [signUpButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"profile_save_down%@",   fileSufix];
    [signUpButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [signUpButton setFrame:size];
    signUpButton.backgroundColor = [UIColor clearColor];
    [signUpButton setTitle:@"Save" forState:UIControlStateNormal];
    [signUpButton setTitleColor:buttonColor forState:UIControlStateNormal];
    signUpButton.titleLabel.font = font2;
    [signUpButton addTarget:self action:@selector(pressSaveButton)  forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:signUpButton];
    
    heightSpace = 82 * scale;
    scrollView.contentSize = CGSizeMake(screenWidth, signUpButton.frame.origin.y + signUpButton.frame.size.height + heightSpace);
 
    [self.view addSubview:hub];
}

//==============================   BUTTONS   ========================================

- (void)backButtonPress {
        [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pressLogOutButton {
        NSString *url = [NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL,@"accounts/sign_out"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        request.userInfo = [NSDictionary dictionaryWithObject:@"sign_out" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startSynchronous];
        [hub show:YES];
}

- (void)pressSaveButton {
        if(![newPasswordTextField.text isEqualToString:@""]){
            changePassword=true;
        }
        
        if(![[UserDataSingleton sharedSingleton].userName isEqualToString:userNameTextField.text]){
            changeName=true;
        }
        
        if(![[UserDataSingleton sharedSingleton].userEmail isEqualToString:emailTextField.text]){
            changeEmail=true;
        }
        
        if(newUserImage){
            changePhoto=true;
            newUserImage=false;
            [UserDataSingleton sharedSingleton].userImage = chosen;
            // save user avatar to DB
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity=[NSEntityDescription entityForName:@"Users" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
            [fetchRequest setEntity:entity];
            NSError *requestError = nil;
            NSArray *usersArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
            for(int i = 0; i < [usersArray count]; i++) {
                User *user = [usersArray objectAtIndex:i];
                if([user.id isEqual:[UserDataSingleton sharedSingleton].idUser]) {
                    NSData *Data = UIImagePNGRepresentation([UserDataSingleton sharedSingleton].userImage);
                    user.avatar     = Data;
                    NSError *error = nil;
                    if (![[CoreDataManager sharedManager].managedObjectContext save:&error])  {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                    break;
                }
            }
        }
        
        [self sendToServer];
}

- (void)sendToServer {
    
    if(changePassword || changeName || changeEmail || changePhoto) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/change_profile"]];
        
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request.userInfo = [NSDictionary dictionaryWithObject:@"change_profile" forKey:@"type"];
        [request setTimeOutSeconds:30.f];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        if (changePassword) {
            [request setPostValue:passwordTextField.text forKey:@"old_password"];
            [request setPostValue:newPasswordTextField.text forKey:@"new_password"];
        }
        if (changeName){
            [request setPostValue:userNameTextField.text forKey:@"user_name"];
        }
        if (changeEmail){
                [request setPostValue:emailTextField.text forKey:@"new_email"];
        }
        if (changePhoto){
                NSData *imageData= UIImagePNGRepresentation([UserDataSingleton sharedSingleton].userImage);
                [request setData:imageData withFileName:@"avatar.png" andContentType:@"image/png" forKey:@"avatar"];
        }
        [request setDelegate:self];
        [request startAsynchronous];
        [hub show:YES];
    }
}

//==============================   EDIT   ========================================

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


- (void)textViewDidBeginEditing:(UITextView *)textView
{
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
    [emailTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [viewControl removeFromSuperview];
    viewControl = nil;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    int space = 0;
    CGRect rect = CGRectMake(0, space, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ((textField.frame.origin.y + textField.frame.size.height + statusBarHeight + margin2 - scrollView.contentOffset.y) > keyboardHeight) {
        double offset = (textField.frame.origin.y + textField.frame.size.height + statusBarHeight + margin2 - scrollView.contentOffset.y) - keyboardHeight;
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

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    int space = 0;
    CGRect rect = CGRectMake(0, space, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
    [viewControl removeFromSuperview];
}


//===================================================Camera or Gallery Photo Pick======================
//=====================================================================================================
- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [self.popover presentPopoverFromRect:CGRectMake(00, 1000, 1, 1) inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popover setPopoverContentSize:CGSizeMake(700, 1000)];
    }else{
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
     self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
     [self.popover presentPopoverFromRect:CGRectMake(00, 1000, 1, 1) inView:self.view
     permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
     [self.popover setPopoverContentSize:CGSizeMake(700, 1000)];
     }else{*/
    [self presentViewController:picker animated:YES completion:NULL];
    //}
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.popover dismissPopoverAnimated:YES];
    
    chosen = info[UIImagePickerControllerEditedImage  ];
    
    CGSize newSize = CGSizeMake(200, 200);
    chosen = [self imageWithImage:chosen scaledToSize:newSize];
    
    float fScale = 800 / chosen.size.width;
    if(chosen.size.height * fScale > 1250)
        fScale = 1250 / chosen.size.height;
    
    newUserImage=true;
    [userImage setImage:chosen];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.preferredContentSize = CGSizeMake(700, 1000);
}

#pragma mark - ASIHttpRequest Delegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    if (!error) {
            NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
                              options: NSJSONReadingMutableContainers
                              error: &error];
            NSLog(@"==== sign_out ===");
            NSLog(@"%@", json);
            NSLog(@"==== sign_out ===");
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"sign_out"])
            {
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    NSEntityDescription *entity= [NSEntityDescription entityForName:@"Users" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    [fetchRequest setEntity:entity];
                    NSError *requestError = nil;
                    NSArray *usersArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
                    User *user;
                    for(int i = 0; i < [usersArray count]; i++) {
                        user = [usersArray objectAtIndex:i];
                        if([user.id isEqual:[UserDataSingleton sharedSingleton].idUser])   break;
                    }

                    NSDictionary    *message   = [json objectForKey:@"message"];
                    [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
                    
                if ([[message objectForKey:@"code"] intValue] == SUCCESS_LOGOUT) {
                    [[UserDataSingleton sharedSingleton].userDefaults   setObject:@"logout" forKey:@"token"];
                    [[UserDataSingleton sharedSingleton].userDefaults synchronize];
                    [UserDataSingleton sharedSingleton].idUser = @"";
                    [UserDataSingleton sharedSingleton].isLogOut = YES;
                    
                    [FBSession.activeSession closeAndClearTokenInformation];
                    [FBSession.activeSession close];
                    [FBSession setActiveSession:nil];
                    [[FHSTwitterEngine sharedEngine] clearAccessToken];
                    [[FHSTwitterEngine sharedEngine] clearConsumer];
                    [[GPPSignIn sharedInstance] signOut];
                    
                    LoginViewController     *loginViewController = [[LoginViewController alloc] init];
                    [self presentViewController:loginViewController animated:YES completion:nil];
                }
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"change_profile"]) {
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                NSEntityDescription *entity= [NSEntityDescription entityForName:@"Users" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                [fetchRequest setEntity:entity];
                NSError *requestError = nil;
                NSArray *usersArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&requestError];
                User *user;
                for(int i = 0; i < [usersArray count]; i++) {
                    user = [usersArray objectAtIndex:i];
                    if([user.id isEqual:[UserDataSingleton sharedSingleton].idUser])   break;
                }

                userData = [[NSMutableData alloc] init];
                    
                NSDictionary    *message   = [json objectForKey:@"message"];
                [UserDataSingleton sharedSingleton].status=[message objectForKey:@"value"];
                
                if([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY){
                    if(changePassword) {
                        [UserDataSingleton sharedSingleton].password=newPasswordTextField.text;
                        user.pass=[UserDataSingleton sharedSingleton].password;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])  {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                        changePassword = false;
                    }
                    if(changeName) {
                        [UserDataSingleton sharedSingleton].userName = userNameTextField.text;
                        user.name=[UserDataSingleton sharedSingleton].userName;
                        
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])  {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                        changeName = false;
                    }
                    
                    if(changeEmail) {
                        [UserDataSingleton sharedSingleton].userEmail=emailTextField.text;
                        user.email=[UserDataSingleton sharedSingleton].userEmail;

                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])  {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                        changeEmail = false;
                    }
                    if(changePhoto) {
                        changePhoto = false;
                    }
                }
                [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:[UserDataSingleton sharedSingleton].status delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [alertView show];
                
            }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
    [hub hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [hub hide:YES];
}

@end
