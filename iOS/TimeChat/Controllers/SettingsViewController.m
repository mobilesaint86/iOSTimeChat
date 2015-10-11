//
//  ViewController.m
//  TimeChat
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "TCViewController.h"


@interface SettingsViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    NSString        *fileSufix;
    UIScrollView    *scrollView;
    UISwitch        *switch1, *switch2;
    MBProgressHUD   *hud;
}
@end


@implementation SettingsViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    if ([UserDataSingleton sharedSingleton].themeChanged)
        [self setLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLayout];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void) setLayout {
    
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
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,@".png"];

    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
    NSString *filename;
    UIImage *image;
    CGRect size;
    UILabel *label;
    
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
    str = @"Settings";
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
    
    // Design Theme background
    heightSpace = 25 * scale;
    widthSpace = 40 * scale;
    filename=[NSString stringWithFormat:@"settings_theme_back%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = widthSpace;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    UIImageView *themeBackImageView = [[UIImageView alloc] initWithFrame:size];
    [themeBackImageView setImage:image];
    themeBackImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:themeBackImageView];
    
    // Design Theme text
    widthSpace = 43 * scale;
    str = @"Design Theme";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y = (themeBackImageView.frame.size.height - size.size.height) / 2;
    UILabel *LabelTheme = [[UILabel alloc]initWithFrame:size];
    [LabelTheme setTextColor:lightTextColor];
    [LabelTheme setFont:font3];
    [LabelTheme setText:str];
    [themeBackImageView addSubview:LabelTheme];
    
    // Design Theme button
    widthSpace = 87 * scale;
    filename=[NSString stringWithFormat:@"settings_arrow%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = screenWidth - size.size.width - widthSpace;
    size.origin.y = themeBackImageView.frame.origin.y + (themeBackImageView.frame.size.height - size.size.height) / 2;
    UIButton *ThemeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [ThemeButton setFrame: size];
    [ThemeButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"settings_arrow_down%@", fileSufix];
    [ThemeButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    ThemeButton.backgroundColor = [UIColor clearColor];
    [ThemeButton addTarget:self action:@selector(clickThemeButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ThemeButton];
    
    // Notifications label
    heightSpace = 24 * scale;
    str = @"Notifications";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = themeBackImageView.frame.origin.y + themeBackImageView.frame.size.height + heightSpace;
    UILabel *notificationLabel = [[UILabel alloc]initWithFrame:size];
    [notificationLabel setTextColor:darkTextColor];
    [notificationLabel setFont:font1];
    [notificationLabel setText:str];
    [self.view addSubview:notificationLabel];
    
    // Notification Background
    heightSpace = 25 * scale;
    widthSpace = 40 * scale;
    filename=[NSString stringWithFormat:@"settings_notification_back%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = widthSpace;
    size.origin.y = notificationLabel.frame.origin.y + notificationLabel.frame.size.height + heightSpace;
    UIImageView *notificationBackImageView = [[UIImageView alloc] initWithFrame:size];
    [notificationBackImageView setImage:image];
    notificationBackImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:notificationBackImageView];
    
    // Notification Allow notification label
    widthSpace = 43 * scale;
    heightSpace = 30 * scale;
    str = @"Allow notification to arrive on notification bar";
    size.size = [@"Allow notification to arrive" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.size.height *= 2;
    size.origin.x = widthSpace;
    size.origin.y = heightSpace;
    label = [[UILabel alloc] initWithFrame:size];
    [label setTextColor:lightTextColor];
    [label setFont:font3];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    [label setText:str];
    [notificationBackImageView addSubview:label];
    
    // Notification Allow notification switch1 button
    widthSpace = 80 * scale;
    heightSpace = 26 * scale;
    filename = [NSString stringWithFormat:@"settings_switch%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height* scale;
    NSLog(@"scale = %f", scale);
    
    size.origin.y =  notificationBackImageView.frame.origin.y + heightSpace ;
    size.origin.x = screenWidth - widthSpace - size.size.width;
    switch1 = [[UISwitch alloc] initWithFrame:size];
    if (scale >= 1.0) {
        switch1.transform = CGAffineTransformMakeScale(2.4f, 2.14f);
        size.origin.y += size.size.height / 4 ;
        switch1.frame = size;
    }
    
    switch1.onTintColor = [UIColor colorWithRed:12.0f/255.0f green:156.0f/255.0f blue:46.0f/255.0f alpha:1];
    [switch1 setOn :[UserDataSingleton sharedSingleton].pushEnable animated:YES];
    [switch1 addTarget:self action:@selector(allowNotificationsPress:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:switch1];

    // Notification Allow notification sound label
    widthSpace = 43 * scale;
    heightSpace = 154 * scale;
    str = @"Allow notification sound";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y = heightSpace;
    label = [[UILabel alloc] initWithFrame:size];
    [label setTextColor:lightTextColor];
    [label setFont:font3];
    [label setText:str];
    [notificationBackImageView addSubview:label];
    
    // Notification Allow notification sound switch2 button
    widthSpace = 80 * scale;
    heightSpace = 136 * scale;
    filename = [NSString stringWithFormat:@"settings_switch%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.y =  notificationBackImageView.frame.origin.y + heightSpace;
    size.origin.x = screenWidth - widthSpace - size.size.width;
    switch2 = [[UISwitch alloc]initWithFrame:size];
    if (scale >= 1.0) {
        switch2.transform = CGAffineTransformMakeScale(2.4f, 2.14f);
        size.origin.y += size.size.height / 5 ;
        switch2.frame = size;
    }
    
    switch2.onTintColor = [UIColor colorWithRed:12.0f/255.0f green:156.0f/255.0f blue:46.0f/255.0f alpha:1];
    [switch2 setOn :[UserDataSingleton sharedSingleton].pushEnable animated:YES];
    [switch2 addTarget:self action:@selector(notificationsSoundPress:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switch2];

    // Notification Notification sound label
    widthSpace = 43 * scale;
    heightSpace = 262 * scale;
    str = @"notification sound";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y = heightSpace;
    label = [[UILabel alloc] initWithFrame:size];
    [label setTextColor:lightTextColor];
    [label setFont:font3];
    [label setText:str];
    [notificationBackImageView addSubview:label];
    
    // Notification Notification sound button
    widthSpace = 87 * scale;
    heightSpace = 258 * scale;
    filename=[NSString stringWithFormat:@"settings_arrow%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = screenWidth - size.size.width - widthSpace;
    size.origin.y = notificationBackImageView.frame.origin.y + heightSpace;
    UIButton *soundButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [soundButton setFrame: size];
    [soundButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"settings_arrow_down%@", fileSufix];
    [soundButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    soundButton.backgroundColor = [UIColor clearColor];
    [soundButton addTarget:self action:@selector(clicksoundButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:soundButton];

    // Privacy label
    heightSpace = 24 * scale;
    str = @"Privacy";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = notificationBackImageView.frame.origin.y + notificationBackImageView.frame.size.height + heightSpace;
    UILabel *privacyLabel = [[UILabel alloc]initWithFrame:size];
    [privacyLabel setTextColor:darkTextColor];
    [privacyLabel setFont:font1];
    [privacyLabel setText:str];
    [self.view addSubview:privacyLabel];

    // Privacy Background
    heightSpace = 25 * scale;
    widthSpace = 40 * scale;
    filename=[NSString stringWithFormat:@"settings_privacy_back%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = widthSpace;
    size.origin.y = privacyLabel.frame.origin.y + privacyLabel.frame.size.height + heightSpace;
    UIImageView *privacyBackImageView = [[UIImageView alloc] initWithFrame:size];
    [privacyBackImageView setImage:image];
    privacyBackImageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:privacyBackImageView];

    // Privacy Policy label
    widthSpace = 43 * scale;
    heightSpace = 34 * scale;
    str = @"Privacy Policy";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y = heightSpace;
    label = [[UILabel alloc] initWithFrame:size];
    [label setTextColor:lightTextColor];
    [label setFont:font3];
    [label setText:str];
    [privacyBackImageView addSubview:label];
    
    // Privacy Policy button
    widthSpace = 87 * scale;
    heightSpace = 24 * scale;
    filename=[NSString stringWithFormat:@"settings_arrow%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = screenWidth - size.size.width - widthSpace;
    size.origin.y = privacyBackImageView.frame.origin.y + heightSpace;
    UIButton *privacyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [privacyButton setFrame: size];
    [privacyButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"settings_arrow_down%@", fileSufix];
    [privacyButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    privacyButton.backgroundColor = [UIColor clearColor];
    [privacyButton addTarget:self action:@selector(clickPrivacyButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privacyButton];

    // Terms and Conditions label
    widthSpace = 43 * scale;
    heightSpace = 136 * scale;
    str = @"Terms & Conditions";
    size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y = heightSpace;
    label = [[UILabel alloc] initWithFrame:size];
    [label setTextColor:lightTextColor];
    [label setFont:font3];
    [label setText:str];
    [privacyBackImageView addSubview:label];
    
    // Terms and Conditions button
    widthSpace = 87 * scale;
    heightSpace = 132 * scale;
    filename=[NSString stringWithFormat:@"settings_arrow%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.height = image.size.height * scale;
    size.size.width = image.size.width * scale;
    size.origin.x = screenWidth - size.size.width - widthSpace;
    size.origin.y = privacyBackImageView.frame.origin.y + heightSpace;
    UIButton *termsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [termsButton setFrame: size];
    [termsButton setBackgroundImage:image forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"settings_arrow_down%@", fileSufix];
    [termsButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    termsButton.backgroundColor = [UIColor clearColor];
    [termsButton addTarget:self action:@selector(clickTermsButton)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:termsButton];

    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
}

-(void)clickThemeButton
{
    ThemeViewController *subVC;
    if (subVC == nil)   subVC = [[ThemeViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}

-(void)clickTermsButton
{
    [UserDataSingleton sharedSingleton].selectTcPrivate = 1;
    TCViewController *termsViewController = [[TCViewController alloc] init];
    [self presentViewController:termsViewController animated:NO completion:nil];
}

-(void)clickPrivacyButton
{
    [UserDataSingleton sharedSingleton].selectTcPrivate = 2;
    TCViewController *termsViewController = [[TCViewController alloc] init];
    [self presentViewController:termsViewController animated:NO completion:nil];
}

-(void)clicksoundButton
{
    AudioViewController *subVC;
    if (subVC == nil)   subVC = [[AudioViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}

- (void)clickBackButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)allowNotificationsPress:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d", switch1.isOn] forKey:@"push_enable"];
    [params setObject:[NSString stringWithFormat:@"%d", switch2.isOn] forKey:@"sound_enable"];
    [self sendNotificationChanged:params];
    [UserDataSingleton sharedSingleton].pushEnable = switch1.isOn;
}

-(void)notificationsSoundPress:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"%d", switch1.isOn] forKey:@"push_enable"];
    [params setObject:[NSString stringWithFormat:@"%d", switch2.isOn] forKey:@"sound_enable"];
    [self sendNotificationChanged:params];
    [UserDataSingleton sharedSingleton].soundEnable = switch2.isOn;
}

- (void)sendNotificationChanged:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/push_setting"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30.f];
    request.userInfo = [NSDictionary dictionaryWithObject:@"push_setting" forKey:@"type"];
    NSArray *keys = [params allKeys];
    for (NSString *key in keys) {
        [request setPostValue:params[key] forKey:key];
    }
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)sendPrivacyChanged:(NSDictionary *)params
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/privacy_setting"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30.f];
    request.userInfo = [NSDictionary dictionaryWithObject:@"privacy_setting" forKey:@"type"];
    NSArray *keys = [params allKeys];
    for (NSString *key in keys) {
        [request setPostValue:params[key] forKey:key];
    }
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
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
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"push_setting"]) {
            
            [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
       } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"privacy_setting"]) {
           
           [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
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
