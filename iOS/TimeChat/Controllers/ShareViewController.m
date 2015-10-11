//
//  ShareViewController.m
//  TimeChat
//


#import "ShareViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface ShareViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    NSString        *fileSufix;
    UIImage         *findFriendsImage;
    UIImage         *selectAllImage;
    UIImage         *selectAllUpImage;
    NSMutableArray  *contactsAddedArray;
    NSMutableArray  *contactsFromServerCellsArray;
    NSMutableArray  *allShareCellsArray;
    int             countAddCells;
    UIButton        *selectAllButton;
    UIButton        *doneButton;
    UIScrollView    *contactsScrollView;
    UIImage         *noAvatarImage;
    BOOL            selectAll;
    MBProgressHUD   *hud;
    UIFont          *titleFont;
}

@end

@implementation ShareViewController
@synthesize typeMedia;
@synthesize numberMedia;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self create];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)create
{
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

    filename = [NSString stringWithFormat:@"share_avatar%@", fileSufix];
    noAvatarImage = [UIImage imageNamed:filename];
    contactsAddedArray = [[NSMutableArray alloc] init];
    allShareCellsArray = [[NSMutableArray alloc] init];
    
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
    str = @"Share";
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
    [backButton addTarget:self action:@selector(clickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // Select All Label
    heightSpace = 28 * scale;
    widthSpace = 522 * scale;
    size.size = [@"Select all" sizeWithAttributes:@{NSFontAttributeName:font3}];
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    size.origin.x = widthSpace;
    UILabel *selectAllLabel = [[UILabel alloc] initWithFrame:size];
    [selectAllLabel setTextColor:darkTextColor];
    [selectAllLabel setBackgroundColor:[UIColor clearColor]];
    [selectAllLabel setTextAlignment:NSTextAlignmentCenter];
    [selectAllLabel setFont:font3];
    [selectAllLabel setText:@"Select all"];
    [self.view addSubview:selectAllLabel];
    
    // Select all Button
    heightSpace = 32 * scale;
    widthSpace = 40 * scale;
    filename = [NSString stringWithFormat:@"find_by_phonebook_select_all%@", fileSufix];
    selectAllImage = [UIImage imageNamed:filename];
    selectAllUpImage = [UIImage imageNamed:@""];
    
    size.size.height = selectAllImage.size.height * scale;
    size.size.width = selectAllImage.size.width * scale;
    size.origin.x = screenWidth - widthSpace - size.size.width;
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    selectAllButton = [[UIButton alloc] initWithFrame:size];
    [selectAllButton setBackgroundImage:selectAllImage forState:UIControlStateNormal];
    [selectAllButton addTarget:self action:@selector(clickSelectAll)
                  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectAllButton];
    
    // Done Button
    heightSpace = 22 * scale;
    filename = [NSString stringWithFormat:@"find_by_phonebook_done%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = screenHeight - size.size.height - heightSpace;
    
    doneButton = [[UIButton alloc] initWithFrame:size];
    [doneButton setBackgroundImage:image forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(clickDoneButton)
         forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:font2];
    [self.view addSubview:doneButton];
    
    heightSpace = 118 * scale;
    float height1 = 22 * scale;
    size.size.width = screenWidth;
    size.size.height = screenHeight - heightSpace - (selectAllButton.frame.origin.y + selectAllButton.frame.size.height + height1);
    size.origin.x = 0;
    size.origin.y = selectAllButton.frame.origin.y + selectAllButton.frame.size.height + height1;
    contactsScrollView = [[UIScrollView alloc] initWithFrame:size];
    [self.view addSubview:contactsScrollView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [self getFriends];
}

- (void)getFriends {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@", [UserDataSingleton sharedSingleton].serverURL, @"friends", [UserDataSingleton sharedSingleton].session]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"friends" forKey:@"type"];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)contactClick:(ShareCellView *)shareCellView andRemove:(BOOL)remove {
    if(remove) {
        [contactsAddedArray removeObject:shareCellView];
    } else {
        [contactsAddedArray addObject:shareCellView];
    }
}

- (void)createTableContacts:(NSArray *)contactsArray {
    

    NSString *filename = [NSString stringWithFormat:@"friends_item_narrow%@", fileSufix];
    UIImage *image = [UIImage imageNamed:filename];
    CGRect sizeContactCellView;
    sizeContactCellView.size.height = image.size.height / image.size.width * screenWidth;
    sizeContactCellView.size.width = screenWidth;
    sizeContactCellView.origin.x = 0;
    sizeContactCellView.origin.y = 0;
    for(int i = 0; i < [contactsArray count]; i ++) {
        NSDictionary *contactDictionary = [contactsArray objectAtIndex:i];
        NSString *name = [contactDictionary objectForKey:@"username"];
        NSString *avatarPath = [contactDictionary objectForKey:@"avatar"];
        
        ShareCellView *shareCellView = [[ShareCellView alloc] initWithFrame:sizeContactCellView
                                                          andUserNameString:name
                                                                  andAvatar:avatarPath andFriendId:[contactDictionary objectForKey:@"id"]];
        shareCellView.delegate = self;
        [allShareCellsArray addObject:shareCellView];
        [contactsScrollView addSubview:shareCellView];
        sizeContactCellView.origin.y += sizeContactCellView.size.height;
    }
    contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                                [contactsArray count] * sizeContactCellView.size.height);
}

- (void)clickSelectAll {
    if(!selectAll) {
        NSString *filename;
        filename = [NSString stringWithFormat:@"find_by_phonebook_select_all_selected%@", fileSufix];
        [selectAllButton setBackgroundImage:
         [UIImage imageNamed:filename]
                                   forState:UIControlStateNormal];
        for (ShareCellView *shareCell in contactsAddedArray) {
            [shareCell setStatus];
        }
        [contactsAddedArray removeAllObjects];
        for (int i = 0; i < allShareCellsArray.count; i++) {
            [contactsAddedArray addObject:[allShareCellsArray objectAtIndex:i]];
        }
        for (ShareCellView *shareCell in contactsAddedArray) {
            [shareCell setStatus];
        }

    } else {
        [selectAllButton setBackgroundImage:selectAllImage forState:UIControlStateNormal];
        for (ShareCellView *shareCell in contactsAddedArray) {
            [shareCell setStatus];
        }
        [contactsAddedArray removeAllObjects];
    }
    selectAll = !selectAll;
}

- (void)clickDoneButton {
    if([contactsAddedArray count] > 0) {
        [self sendRequestNotification];
    } else {
        NSLog(@"null contacts");
    }
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendRequestNotification
{
    NSString *friend_ids = @"";
    for(ShareCellView *cellView in contactsAddedArray) {
        if(cellView.friendId) {
            if (![friend_ids isEqualToString:@""])
                friend_ids = [friend_ids stringByAppendingFormat:@",%@", cellView.friendId];
            else
                friend_ids = [friend_ids stringByAppendingFormat:@"%@", cellView.friendId];
        }
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/share_medias"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"share_medias" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:friend_ids forKey:@"friend_ids"];
    [request setPostValue:numberMedia forKey:@"media_id"];
    [request setPostValue:typeMedia forKey:@"type"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)createAlertView:(NSString *)message andDismissController:(BOOL)dismish {
    CGRect sizeAlertView;
    sizeAlertView.size.height /= 3;
    sizeAlertView.size.width /= 2;
    sizeAlertView.origin.x = (self.view.frame.size.width - sizeAlertView.size.width)/2;
    sizeAlertView.origin.y = (self.view.frame.size.height - sizeAlertView.size.height)/2;
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Message:"
                              message:message
                              delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    if(dismish) {
       alertView.delegate = self;
       //[self dismissViewControllerAnimated:NO completion:nil];
    }
    [alertView setFrame:sizeAlertView];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"friends"]) {
                     NSArray *contactsArray = [json objectForKey:@"data"];
                     if(contactsArray && [contactsArray count] > 0) {
                             [self createTableContacts:contactsArray];
                     } else {
                             [self createAlertView:@"There are no friend contacts" andDismissController:NO];
                     }

            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"share_medias"]) {
                     NSDictionary *message = [json objectForKey:@"message"];
                     if(message) {
                             [self createAlertView:@"Successfully shared photo" andDismissController:YES];
                     } else {
                             [self createAlertView:@"Error query" andDismissController:NO];
                     }
            }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unkown error occured." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
