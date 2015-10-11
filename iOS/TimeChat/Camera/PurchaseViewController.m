//
//  PurchaseViewController.m
//  TimeChat
//

#import "PurchaseViewController.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "IMOBIAPHelper.h"

@interface PurchaseViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *lightTextColor, *darkTextColor, *buttonColor, *lockedTextColor;
    
    NSString        *fileSufix;
    UIButton        *blueThemeButton;
    UIButton        *purpleThemeButton;
    UIImage         *activeState;
    UIImage         *disabledState;
    MBProgressHUD   *hud;
    
    SKProduct *myProduct;
}

@end

@implementation PurchaseViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]){
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)productPurchased:(NSNotification *)notification{
    NSString *productIdentifier = notification.object;
    NSLog(@"Identifier: %@", productIdentifier);
    
    [[UserDataSingleton sharedSingleton].userDefaults setObject:@"true" forKey:@"unlocked"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Sucessfully purchased all photo effects" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[IMOBIAPHelper sharedInstance]requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if(products && products.count>0){
            myProduct = products[0];
        }
    }];

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
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    lockedTextColor = [UserDataSingleton sharedSingleton].lockedTextColor;
    
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
    str = @"Purchase Effects";
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
    heightSpace = 40 * scale;
    filename=[NSString stringWithFormat:@"purchase_7items_back%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    UIImageView *subBackgroundView = [[UIImageView alloc] initWithFrame:size];
    [subBackgroundView setImage:image];
    subBackgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:subBackgroundView];
    
    // effect1 Label
    heightSpace = 87 * scale;
    widthSpace = 110 * scale;
    size.size = [@"Hue1" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    size.origin.x = widthSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue1"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];

    // effect2 Label
    heightSpace = 100 * scale;
    size.size = [@"Hue2" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y += heightSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue2"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    // effect3 Label
    heightSpace = 100 * scale;
    size.size = [@"Hue3" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y += heightSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue3"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    // effect4 Label
    heightSpace = 100 * scale;
    size.size = [@"Hue4" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y += heightSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue4"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    // effect5 Label
    heightSpace = 100 * scale;
    size.size = [@"Hue5" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y += heightSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue5"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    // effect6 Label
    heightSpace = 100 * scale;
    size.size = [@"Hue6" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y += heightSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue6"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    
    // effect7 Label
    heightSpace = 100 * scale;
    size.size = [@"Hue7" sizeWithAttributes: @{NSFontAttributeName:font3}];
    size.origin.x = widthSpace;
    size.origin.y += heightSpace;
    label = [[UILabel alloc]initWithFrame:size];
    [label setText:@"Hue7"];
    [label setFont:font3];
    [label setTextColor:lightTextColor];
    [label setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:label];
    

    if (![[[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"] isEqualToString:@"true"]){
        
            // effect1 Label
            heightSpace = 87 * scale;
            widthSpace = 510 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
            size.origin.x = widthSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
            
            // effect2 Label
            heightSpace = 100 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y += heightSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
            
            // effect3 Label
            heightSpace = 100 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y += heightSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
            
            // effect4 Label
            heightSpace = 100 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y += heightSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
            
            // effect5 Label
            heightSpace = 100 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y += heightSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
            
            // effect6 Label
            heightSpace = 100 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y += heightSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
            
            // effect7 Label
            heightSpace = 100 * scale;
            size.size = [@"Locked" sizeWithAttributes: @{NSFontAttributeName:font3}];
            size.origin.x = widthSpace;
            size.origin.y += heightSpace;
            label = [[UILabel alloc]initWithFrame:size];
            [label setText:@"Locked"];
            [label setFont:font3];
            [label setTextColor:lockedTextColor];
            [label setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:label];
    }
    
    // restore button
    heightSpace = 30 * scale;
    widthSpace = 18 * scale;
    filename = [NSString stringWithFormat:@"take_photo_blue%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height= image.size.height * scale;
    size.origin.y = screenHeight - size.size.height - heightSpace;
    size.origin.x = (screenWidth - size.size.width * 2 - widthSpace) / 2;
    UIButton *restoreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [restoreButton setFrame:size];
    [restoreButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"take_photo_blue_down%@", fileSufix];
    [restoreButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [restoreButton setTitle:@"Restore" forState:UIControlStateNormal];
    [restoreButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [restoreButton addTarget:self action:@selector(clickRestore) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:restoreButton];
    
    // unlock button
    widthSpace = 18 * scale;
    filename = [NSString stringWithFormat:@"take_photo_red%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height= image.size.height * scale;
    size.origin.y = screenHeight - size.size.height - heightSpace;
    size.origin.x = screenWidth - restoreButton.frame.origin.x - size.size.width;
    UIButton *unlockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [unlockButton setFrame:size];
    [unlockButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"take_photo_red_down%@", fileSufix];
    [unlockButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [unlockButton setTitle:@"Unlock All($0.99)" forState:UIControlStateNormal];
    [unlockButton setTitleColor:buttonColor forState:UIControlStateNormal];
    unlockButton.titleLabel.font = font3;
    [unlockButton addTarget:self action:@selector(clickUnlock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:unlockButton];
    
    [self.view addSubview:hud];
}

-(void)clickRestore
{
    [[IMOBIAPHelper sharedInstance] restoreCompletedTransactions];
}

-(void)clickUnlock
{
    [[IMOBIAPHelper sharedInstance]buyProduct:myProduct];
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
