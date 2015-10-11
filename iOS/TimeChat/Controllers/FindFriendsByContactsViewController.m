//
//  FindFriendsByPhonebookViewController.m
//  TimeChat1
//


#import "FindFriendsByContactsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface FindFriendsByContactsViewController () {
    float               screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float               keyboardHeight,statusBarHeight;
    UIFont              *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor             *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    NSString            *fileSufix;
    ABAddressBookRef    addressBook;
    BOOL                selectAll;
    UIButton            *selectAllButton;
    UIButton            *doneButton;
    UIScrollView        *contactsScrollView;
    
    NSMutableArray      *phonebookContactArray;
    NSMutableArray      *contactsAddedArray;
    
    NSMutableArray      *contactsFromServerCellsArray;
    int                 system;
    NSString            *findFriendsString;
    UIImage             *selectAllImage, *selectAllImageSelected;
    UIImage             *selectAllUpImage;
    UIImage             *noAvatarImage;
    UILabel             *myContactsLabel;
    int                 countAddCells;
    MBProgressHUD       *hud;
}
@end

@implementation FindFriendsByContactsViewController
@synthesize inviteFriendToFacebook;

- (id)init:(int)_system {
    system = _system;
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
    
    hud=  [[MBProgressHUD alloc] initWithView:self.view];
    
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
    
    contactsAddedArray = [[NSMutableArray alloc] init];
    contactsFromServerCellsArray = [[NSMutableArray alloc] init];
    countAddCells = 0;
    
    NSString *filename;
    UIImage *image;
    CGRect size;
    
    if(system == 0) {
        findFriendsString = @"Find friends by gmail";
        selectAllImage = [UIImage imageNamed:@"find_friends_email_friend_1@2x~iphone.png"];
        selectAllUpImage = [UIImage imageNamed:@""];
        
        filename = [NSString stringWithFormat:@"blank_user%@", fileSufix];
        noAvatarImage = [UIImage imageNamed:filename];
    } else if (system == 1) {
        CFErrorRef *error = nil;
        addressBook = ABAddressBookCreateWithOptions(NULL, error);
        phonebookContactArray = [[NSMutableArray alloc] init];
        findFriendsString = @"Find friends by Phonebook";
        
        filename = [NSString stringWithFormat:@"find_by_phonebook_select_all%@", fileSufix];
        selectAllImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"find_by_phonebook_select_all_selected%@", fileSufix];
        selectAllImageSelected = [UIImage imageNamed:filename];
    } else if (system == 2) {
        findFriendsString = @"Find friends by Facebook";
        
        filename = [NSString stringWithFormat:@"find_by_phonebook_select_all%@", fileSufix];
        selectAllImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"find_by_phonebook_select_all_selected%@", fileSufix];
        selectAllImageSelected = [UIImage imageNamed:filename];
    } else if (system == 3) {
        findFriendsString = @"Find friends by Google+";
        selectAllImage = [UIImage imageNamed:@"find_friends_email_friend_1@2x~iphone.png"];
        selectAllUpImage = [UIImage imageNamed:@""];
    } else {
        NSLog(@"error");
    }
    filename = [NSString stringWithFormat:@"blank_user%@", fileSufix];
    noAvatarImage = [UIImage imageNamed:filename];
    
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
    size.size = [findFriendsString sizeWithAttributes:@{NSFontAttributeName:font1}];
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = statusBarHeight + (titleBackgroundView.frame.size.height - size.size.height) / 2;
    UILabel *settingsLabel = [[UILabel alloc] initWithFrame:size];
    settingsLabel.textColor = titleColor;
    settingsLabel.text = findFriendsString;
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
    
    // My Contact Label
    heightSpace = 36 * scale;
    widthSpace = 72 * scale;
    size.size=  [@"My contacts" sizeWithAttributes:@{NSFontAttributeName:font2}];
    size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
    size.origin.x = widthSpace;
    myContactsLabel = [[UILabel alloc] initWithFrame:size];
    [myContactsLabel setText:@"My contacts"];
    [myContactsLabel setTextColor:darkTextColor];
    [myContactsLabel setTextAlignment:NSTextAlignmentCenter];
    [myContactsLabel setFont:font2];
    [self.view addSubview:myContactsLabel];

    if (!((system == 2) && (inviteFriendToFacebook == 1))) {
        
        // Select All Button
        heightSpace = 82 * scale;
        widthSpace = 40 * scale;
        size.size.height = selectAllImage.size.height * scale;
        size.size.width = selectAllImage.size.width * scale;
        size.origin.x = screenWidth - widthSpace - size.size.width;
        size.origin.y = titleBackgroundView.frame.origin.y + titleBackgroundView.frame.size.height + heightSpace;
        
        selectAllButton = [[UIButton alloc] initWithFrame:size];
        [selectAllButton setBackgroundImage:selectAllImage forState:UIControlStateNormal];
        [selectAllButton addTarget:self action:@selector(clickSelectAll) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectAllButton];
        
        // Select All Label
        widthSpace = 28 * scale;
        str = @"Select All";
        size.size = [str sizeWithAttributes:@{NSFontAttributeName:font3}];
        size.origin.x = selectAllButton.frame.origin.x - widthSpace - size.size.width;
        size.origin.y = selectAllButton.frame.origin.y;
        UILabel *selectAllLabel = [[UILabel alloc] initWithFrame:size];
        [selectAllLabel setTextColor:darkTextColor];
        [selectAllLabel setTextAlignment:NSTextAlignmentCenter];
        [selectAllLabel setFont:font3];
        [selectAllLabel setText:str];
        [self.view addSubview:selectAllLabel];
    }

    // Done Button
    heightSpace = 38 * scale;
    filename = [NSString stringWithFormat:@"find_by_phonebook_done%@", fileSufix];
    image = [UIImage imageNamed:filename];
    size.size.width = image.size.width * scale;
    size.size.height = image.size.height * scale;
    size.origin.x = (screenWidth - size.size.width) / 2;
    size.origin.y = screenHeight - heightSpace - size.size.height;
    doneButton = [[UIButton alloc] initWithFrame:size];
    [doneButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_by_phonebook_done_down%@", fileSufix];
    [doneButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(clickDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [self.view addSubview:doneButton];
    
    [self createContactsScrollView];
    
    [self.view addSubview:hud];
    
    switch (system) {
        case 1:
            [self getContactsFromPhonebook];
            break;
        case 2:
            [self sendRequestFindByFacebook];
            break;
        default:
            NSLog(@"error");
            break;
    }
}

- (void)createContactsScrollView {

    CGRect size;
    
    if ((system == 2) && (inviteFriendToFacebook == 1)) {
    } else {
    }
    
    heightSpace = 14 * scale;
    float bottom_height = 140 * scale;
    size.size.width = screenWidth;
    size.size.height = screenHeight - (selectAllButton.frame.origin.y + selectAllButton.frame.size.height + heightSpace + bottom_height);
    size.origin.y = selectAllButton.frame.origin.y + selectAllButton.frame.size.height + heightSpace;
    size.origin.x = 0;
    contactsScrollView = [[UIScrollView alloc] initWithFrame:size];
    [self.view addSubview:contactsScrollView];
}

- (void)clickDoneButton {
    if([contactsAddedArray count] > 0) {
        if (system == 1) {
            [self sendRequestFindFriendsByPhonebook];
        } else if(system == 2) {
            [self sendRequestAddedContacts];
        }
    } else {
        NSLog(@"null contacts");
    }
}

- (void)sendRequestAddedContacts
{
    NSString *userIds = nil;
    for (FindContactCellView *cell in contactsAddedArray) {
        if (userIds)
            userIds = [NSString stringWithFormat:@"%@,%@", userIds, cell.identity];
        else userIds = cell.identity;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/add_friends"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUserInfo:@{@"type": @"add_friends"}];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:userIds forKey:@"user_ids"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

- (void)clickSelectAll {
    if(!selectAll) {
        [selectAllButton setBackgroundImage:selectAllImageSelected forState:UIControlStateNormal];
        for (FindContactCellView *findContactCell in contactsAddedArray) {
            [findContactCell setStatus];
        }
        [contactsAddedArray removeAllObjects];
        for (FindContactCellView *findContactCell in contactsFromServerCellsArray) {
            [findContactCell contactClick];
        }
    } else {
        [selectAllButton setBackgroundImage:selectAllImage forState:UIControlStateNormal];
        for (FindContactCellView *findContactCell in contactsAddedArray) {
            [findContactCell setStatus];
        }
        [contactsAddedArray removeAllObjects];
    }
    selectAll = !selectAll;
}

- (void)getContactsFromPhonebook {
    if(addressBook) {
        __block BOOL accessGranted = NO;
        if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            sema = nil;
        } else {
            accessGranted = YES;
        }
        if (accessGranted) {
            NSArray *thePeople =
                (__bridge_transfer NSArray*) ABAddressBookCopyArrayOfAllPeople(addressBook);
            for(int i = 0; i < [thePeople count]; i++) {
                ABRecordRef person = (__bridge ABRecordRef)[thePeople objectAtIndex:i];

                // Get emails from contacts
                NSMutableArray *emailArray = [[NSMutableArray alloc] init];
                ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                    NSString *email =
                        (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, i);
                    if ([email isEqualToString:[UserDataSingleton sharedSingleton].userEmail]) {
                        emailArray = nil;
                        break;
                    }
                    [emailArray addObject:email];
                }
                if (emailArray.count > 0) {
                    // Get name from contacts
                    NSString *firstName =
                    (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                    NSString *secondName = (__bridge NSString *)
                    (ABRecordCopyValue(person, kABPersonLastNameProperty));
                    
                    NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
                    NSString *username = @"";
                    if(firstName && secondName) {
                        username = [NSString stringWithFormat:@"%@ %@", firstName, secondName];
                    } else if(firstName){
                        username = [NSString stringWithFormat:@"%@", firstName];
                    } else if(secondName) {
                        username = [NSString stringWithFormat:@"%@", secondName];
                    }
                    
                    // Get image from contacts
                    NSData *imgData = (__bridge NSData *)ABPersonCopyImageData(person);
                    UIImage *image = [UIImage imageWithData:imgData];
                    if (image) {
                        [contact setObject:image forKey:@"avatar"];
                    } else {
                        [contact setObject:noAvatarImage forKey:@"avatar"];
                    }

                    [contact setValue:username forKey:@"username"];
                    [contact setObject:emailArray forKey:@"email"];
                    [phonebookContactArray addObject:contact];
                }
            }
            if([phonebookContactArray count] > 0) {
                    [self createTableContacts:phonebookContactArray];
            } else {
                [self createAlertView:@"There are no email contacts in your phonebook" andDismissController:NO];
            }
        } else {
            [self createAlertView: @"App need access to your personal contact list. Please check phone setting" andDismissController:NO];
        }
    }
    else {
        [self createAlertView:@"App need access to your personal contact list. Please check phone setting" andDismissController:NO];
    }
}

- (void)createAlertView:(NSString *)message andDismissController:(BOOL)dismiss {
    CGRect sizeAlertView;
    sizeAlertView.size.height /= 3;
    sizeAlertView.size.width /= 2;
    sizeAlertView.origin.x = (self.view.frame.size.width - sizeAlertView.size.width)/2;
    sizeAlertView.origin.y = (self.view.frame.size.height - sizeAlertView.size.height)/2;
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Message:"
                              message:message
                              delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    if(dismiss) {
        alertView.delegate = self;
    }
    [alertView setFrame:sizeAlertView];
    [alertView show];
}

- (void)sendRequestFindFriendsByPhonebook {
    NSMutableArray *addedEmailsContacts = [[NSMutableArray alloc] init];
    for (FindContactCellView *cellView in contactsAddedArray) {
        if (cellView.email) {
            [addedEmailsContacts addObject:cellView.email];
        }
    }
    if (addedEmailsContacts.count == 0) return;

    NSString *emailString = [addedEmailsContacts componentsJoinedByString:@","];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/add_friends_by_phone_book"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setUserInfo:@{@"type": @"phonebook_users"}];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:emailString forKey:@"emails"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)sendRequestFindByGoogle {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
//    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://yahoo.com"]];
    [shareBuilder setPrefillText:@"TimeChat"];
    //[shareBuilder setContentDeepLinkID:@"turns-on-app-deeplinks-and-passes-this-value"];
    //[shareBuilder setCallToActionButtonWithLabel:@"JOIN" URL:[NSURL URLWithString:@"http://google.com"] deepLinkID:@"turns-on-cta-app-deeplinks"];
    [shareBuilder open];
}

- (void)sendRequestFindByFacebook {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/facebook_users", [UserDataSingleton sharedSingleton].session]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setUserInfo:@{@"type": @"facebook_users"}];
    [request setTimeOutSeconds:30.f];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)contactClick:(FindContactCellView *)findContactCellView andRemove:(BOOL)remove {
    if ((system == 2) && (inviteFriendToFacebook == 1)) {
        SendMessageToFacebookViewController *sendMessageToFacebookViewController = [[SendMessageToFacebookViewController alloc] init];
        sendMessageToFacebookViewController.friendID = findContactCellView.identity;
        [self presentViewController:sendMessageToFacebookViewController animated:YES completion:nil];
    } else {
        if(remove) {
            [contactsAddedArray removeObject:findContactCellView];
        } else {
            [contactsAddedArray addObject:findContactCellView];
        }
    }
}

- (void)createTableContacts:(NSArray *)contactsArray {
    
    CGRect size;
    
    NSString *filename = [NSString stringWithFormat:@"find_by_phonebook_item%@", fileSufix];
    UIImage *image = [UIImage imageNamed:filename];

    size.size.width = screenWidth;
    size.size.height = image.size.height / image.size.width * screenWidth;
    size.origin.x = size.origin.y = 0;
    
    for (int i=0; i<[contactsArray count]; i++) {
        NSDictionary *contactDictionary = [contactsArray objectAtIndex:i];
        NSString *name;
        name = [contactDictionary objectForKey:@"username"];
        
        if (system == 1) { // Phonebook
            countAddCells ++;
            NSArray *emailArray = (NSArray *)contactDictionary[@"email"];
            NSString *emails = [emailArray componentsJoinedByString:@","];
            FindContactCellView *findContactCellView = [[FindContactCellView alloc]
                                                        initWithFrame:size
                                                        andUserNameString:name
                                                        andStateInSystem:201
                                                        andEmail:emails
                                                        andNoAvatarImage:noAvatarImage
                                                        andSystem:system
                                                        andIdentity:[contactDictionary objectForKey:@"id"]
                                                        andAvatar:nil];
            findContactCellView.delegate = self;
            [contactsScrollView addSubview:findContactCellView];
            size.origin.y += size.size.height;
            [contactsFromServerCellsArray addObject:findContactCellView];
        } else if (system == 2) { // Facebook
            countAddCells ++;
            FindContactCellView *findContactCellView = [[FindContactCellView alloc]
                                                        initWithFrame:size
                                                        andUserNameString:name
                                                        andStateInSystem:201
                                                        andEmail:[contactDictionary
                                                                  objectForKey:@"email"]
                                                        andNoAvatarImage:noAvatarImage
                                                        andSystem:system
                                                        andIdentity:[contactDictionary objectForKey:@"id"]
                                                        andAvatar:[contactDictionary objectForKey:@"avatar"]];
            findContactCellView.delegate = self;
            [contactsScrollView addSubview:findContactCellView];
            size.origin.y += size.size.height;
            [contactsFromServerCellsArray addObject:findContactCellView];
        }
    }
    if (system == 2) {
        contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                                    countAddCells *
                                                    size.size.height);
    } else {
        contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                                    ([contactsArray count]) *
                                                    size.size.height);
    }
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if (!error) {
        NSDictionary *json = [NSJSONSerialization
                              JSONObjectWithData:[[request responseString] dataUsingEncoding:NSUTF8StringEncoding]
                              options: NSJSONReadingMutableContainers
                              error: &error];
        NSDictionary *message   = [json objectForKey:@"message"];
        [UserDataSingleton sharedSingleton].status = [message objectForKey:@"value"];
        if ([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"facebook_users"]) {
                NSArray *contactsArray = [json objectForKey:@"data"];
                if(contactsArray && [contactsArray count] > 0) {
                        [self createTableContacts:contactsArray];
                } else {
                        [self createAlertView:@"There are no email contacts in your facebook" andDismissController:NO];
                }
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"phonebook_users"]) {
                    [self createAlertView:message[@"value"] andDismissController:YES];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"add_friends"]) {
                    [self createAlertView:@"Email sent successfully!" andDismissController:YES];
                    
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"add_friend"]) {
                    [self createAlertView:@"Email sent successfully!" andDismissController:YES];
            }
        } else {
                [self createAlertView:[message objectForKey:@"value"] andDismissController:NO];
        }
    } else {
            [self createAlertView:@"Error rerquest to server" andDismissController:NO];
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
