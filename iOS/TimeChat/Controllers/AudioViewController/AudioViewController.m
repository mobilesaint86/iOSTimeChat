//
//  AudioViewController.m
//  TimeChat
//


#import "AudioViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "UserDataSingleton.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface AudioViewController ()
{
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    UIFont          *titleFont;
    NSArray         *allAudios;
    MBProgressHUD   *hud;
    
    NSString        *soundName;
    NSIndexPath     *selectedIndexPath;
    NSString        *fileSufix;
    UITableView     *uiTableView;
}

@end

@implementation AudioViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadPage];
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
    font6 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize6];
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    
    NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
    titleColor = [[UserDataSingleton sharedSingleton].titleColor objectForKey:str];
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
    allAudios = [[NSArray alloc] initWithObjects:@"None", @"Aurora", @"Bamboo", @"Chord", @"Circles", @"Complete", @"Hello", @"Input", @"Keys", @"Note", @"Popcorn", @"Pulse", @"Synth", @"Apex", @"Beacon", @"Bulletin", @"By The Seaside", @"Chimes", @"Circuit", @"Constellation", @"Cosmic", @"Crystals", @"Hillside", @"Illuminate", @"Night Owl", @"Opening", @"Playtime", @"Presto", @"Radar", @"Radiate", @"Ripples", @"Sencha", @"Signal", @"Silk", @"Slow Rise", @"Stargaze", @"Summit", @"Twinkle", @"Uplift", @"Waves", nil];
    
    NSString *filename;
    UIImage *image;
    CGRect size;
    
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
    str = @"Notification Sound";
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
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    // TableView
    size.size.width = screenWidth;
    size.size.height = screenHeight - (titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height);
    size.origin.x = 0;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height;
    uiTableView = [[UITableView alloc] initWithFrame:size style:UITableViewStylePlain];
    [uiTableView setDataSource:self];
    [uiTableView setDelegate:self];
    [uiTableView setBackgroundColor:[UIColor clearColor]];
    [uiTableView setShowsVerticalScrollIndicator:NO];
    uiTableView.translatesAutoresizingMaskIntoConstraints = NO;
    uiTableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:uiTableView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)reloadPage
{
    if ([UserDataSingleton sharedSingleton].notificationSound == nil) {
        NSString *defaultSound = @"Bamboo.m4r";
        [UserDataSingleton sharedSingleton].notificationSound = defaultSound;
        NSArray *parts = [defaultSound componentsSeparatedByString:@"."];
        soundName = [parts objectAtIndex:0];
    } else {
        NSArray *parts = [[UserDataSingleton sharedSingleton].notificationSound componentsSeparatedByString:@"."];
        soundName = [parts objectAtIndex:0];
        soundName = [soundName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        NSLog(@"sound2 = %@", soundName);
    }
    [uiTableView reloadData];
}

- (IBAction)clickBackButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allAudios.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100 * scale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"AudioCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [allAudios objectAtIndex:indexPath.row];
    cell.textLabel.textColor = lightTextColor;
    NSLog(@"soundAry = %@", cell.textLabel.text);
    if ([cell.textLabel.text isEqualToString:soundName]) {
        NSString *filename = [NSString stringWithFormat:@"notification_sound_select%@", fileSufix];
        UIImage *image = [UIImage imageNamed:filename];
        CGRect size;
        size.size.width = image.size.width * scale;
        size.size.height = image.size.height * scale;
        size.origin.x = 0;
        size.origin.y = 0;
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:size];
        [checkImageView setImage:image];
        checkImageView.backgroundColor = [UIColor clearColor];
        
        cell.accessoryView = checkImageView;
        selectedIndexPath = indexPath;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row > 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:[allAudios objectAtIndex:indexPath.row] ofType:@"m4r"];
        NSURL *soundUrl = [NSURL fileURLWithPath:path];
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID(CFBridgingRetain(soundUrl), &soundID);
        AudioServicesPlayAlertSound(soundID);
        [UserDataSingleton sharedSingleton].notificationSound = [NSString stringWithFormat:@"%@.m4r", [allAudios objectAtIndex:indexPath.row]];
    } else {
        [UserDataSingleton sharedSingleton].notificationSound = @"None";
    }
    
    if (selectedIndexPath.row != indexPath.row) {
        
        // remove cell check image selected before
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        cell.accessoryView = nil;
        
        // add cell check image selected now
        cell = [tableView cellForRowAtIndexPath:indexPath];
        soundName = cell.textLabel.text;
        
        NSString *filename = [NSString stringWithFormat:@"notification_sound_select%@", fileSufix];
        UIImage *image = [UIImage imageNamed:filename];
        CGRect size;
        size.size.width = image.size.width * scale;
        size.size.height = image.size.height * scale;
        size.origin.x = 0;
        size.origin.y = 0;
        UIImageView *checkImageView = [[UIImageView alloc] initWithFrame:size];
        [checkImageView setImage:image];
        checkImageView.backgroundColor = [UIColor clearColor];
        cell.accessoryView = checkImageView;
        
        selectedIndexPath = indexPath;
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"accounts/sound_setting"]];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        [request setTimeOutSeconds:30.f];
        request.userInfo = [NSDictionary dictionaryWithObject:@"sound_setting" forKey:@"type"];
        [request setPostValue:[UserDataSingleton sharedSingleton].notificationSound forKey:@"push_sound"];
        [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
        [request setDelegate:self];
        [request startAsynchronous];
        [hud show:YES];
    }
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
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"sound_setting"]) {
            [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
            if ([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:@"Error occured" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
            }
        }
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
