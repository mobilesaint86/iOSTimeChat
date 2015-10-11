//
//  ThemeViewController.m
//  TimeChat
//

#import "ThemeViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface ThemeViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *lightTextColor, *darkTextColor;
    NSString        *fileSufix;
    UIButton        *blueThemeButton;
    UIButton        *purpleThemeButton;
    UIImage         *activeState;
    UIImage         *disabledState;
    MBProgressHUD   *hud;
}

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    hud = [[MBProgressHUD alloc] initWithView: self.view];

    [self setLayout];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)setLayout
{
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
    font6 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize6];
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
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
    str = @"Choose Theme";
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
    [backButton addTarget:self action:@selector(clickBackButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Sub Background
    heightSpace = 58 * scale;
    filename=[NSString stringWithFormat:@"settings_privacy_back%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    UIImageView *subBackgroundView = [[UIImageView alloc] initWithFrame:size];
    [subBackgroundView setImage:image];
    subBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:subBackgroundView];
    
    // Bright Theme Button
    widthSpace = 46 * scale;
    filename = [NSString stringWithFormat:@"theme_check_on%@", fileSufix];
    activeState = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"theme_check_off%@", fileSufix];
    disabledState = [UIImage imageNamed:filename];
    
    CGRect sizeCheckboxButton;
    sizeCheckboxButton.size.width = activeState.size.width * scale;
    sizeCheckboxButton.size.height = activeState.size.height * scale;
    sizeCheckboxButton.origin.x = subBackgroundView.frame.origin.x + subBackgroundView.frame.size.width - widthSpace - sizeCheckboxButton.size.width;
    sizeCheckboxButton.origin.y = subBackgroundView.frame.origin.y + (subBackgroundView.frame.size.height / 2 - sizeCheckboxButton.size.height) / 2;
    
    blueThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [blueThemeButton setFrame: sizeCheckboxButton];
    if ([UserDataSingleton sharedSingleton].numOfDesign == 1) {
        [blueThemeButton setBackgroundImage:activeState forState:UIControlStateNormal];
        [blueThemeButton setBackgroundImage:activeState forState:UIControlStateHighlighted];
    } else {
        [blueThemeButton setBackgroundImage:disabledState forState:UIControlStateNormal];
        [blueThemeButton setBackgroundImage:disabledState forState:UIControlStateHighlighted];
    }
    blueThemeButton.backgroundColor = [UIColor clearColor];
    [blueThemeButton addTarget:self action:@selector(clickThemeButton:)  forControlEvents:UIControlEventTouchUpInside];
    blueThemeButton.tag = 1;
    [self.view addSubview:blueThemeButton];
    
    // Bright Theme Label
    NSString *blueThemeText = @"Bright theme";
    size = sizeCheckboxButton;
    size.size = [blueThemeText sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = subBackgroundView.frame.origin.x + widthSpace;
    UILabel *blueLabel = [[UILabel alloc]initWithFrame:size];
    [blueLabel setText:blueThemeText];
    [blueLabel setFont:font3];
    [blueLabel setTextColor:lightTextColor];
    [blueLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:blueLabel];

    // Purple Theme Button
    heightSpace = 58 * scale;
    sizeCheckboxButton.origin.y += blueThemeButton.frame.size.height + heightSpace;
    purpleThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [purpleThemeButton setFrame: sizeCheckboxButton];
    if ([UserDataSingleton sharedSingleton].numOfDesign == 2) {
        [purpleThemeButton setBackgroundImage:activeState forState:UIControlStateNormal];
        [purpleThemeButton setBackgroundImage:activeState forState:UIControlStateHighlighted];
    } else {
        [purpleThemeButton setBackgroundImage:disabledState forState:UIControlStateNormal];
        [purpleThemeButton setBackgroundImage:disabledState forState:UIControlStateHighlighted];
    }
    purpleThemeButton.backgroundColor = [UIColor clearColor];
    [purpleThemeButton addTarget:self action:@selector(clickThemeButton:)  forControlEvents:UIControlEventTouchUpInside];
    purpleThemeButton.tag = 2;
    [self.view addSubview:purpleThemeButton];
    
    // Dark Theme Label
    NSString *purpleThemeText = @"Dark theme";
    size.origin.y = sizeCheckboxButton.origin.y;
    size.size = [purpleThemeText sizeWithAttributes:@{NSFontAttributeName:font3}];
    UILabel *purpleLabel = [[UILabel alloc]initWithFrame:size];
    [purpleLabel setText:purpleThemeText];
    [purpleLabel setFont:font3];
    [purpleLabel setTextColor:lightTextColor];
    [purpleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:purpleLabel];
    
    [self.view addSubview:hud];
}

-(void)clickThemeButton:(UIButton *)button
{
    if(button.tag == 1){
        [purpleThemeButton setImage:disabledState forState:UIControlStateNormal];
        [self sendThemeChanged:1];
    }
    if(button.tag == 2)
    {
        [blueThemeButton setImage:disabledState forState:UIControlStateNormal];
        [self sendThemeChanged:2];
    }
}

- (void)sendThemeChanged:(int )type
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/theme_setting"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30.f];
    request.userInfo = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d", type] forKey:@"type"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:[NSString stringWithFormat:@"%d", type] forKey:@"theme_type"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)clickBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
        NSDictionary    *message   = [json objectForKey:@"message"];
        [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
        if ([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"1"]) {
                    [UserDataSingleton sharedSingleton].numOfDesign = 1;
                    [[UserDataSingleton sharedSingleton].userDefaults   setObject:@"1" forKey:@"numOfDesign"];
                    [self setLayout];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"2"]) {
                    [UserDataSingleton sharedSingleton].numOfDesign = 2;
                    [[UserDataSingleton sharedSingleton].userDefaults   setObject:@"2" forKey:@"numOfDesign"];
                    [self setLayout];
            }
            [UserDataSingleton sharedSingleton].themeChanged = true;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
