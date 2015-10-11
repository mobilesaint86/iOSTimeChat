//
//  FriendsViewController.m
//  TimeChat1
//


#import "FriendsViewController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface FriendsViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *titleColor, *buttonColor, *lightTextColor, *darkTextColor;
    NSMutableArray  *friendsArray;
    UIScrollView    *contactsScrollView;
    NSMutableData   *userData;
    NSString        *fileSufix;
    NSArray         *mediasArray;
    NSArray         *mediasdataArray;
    Media           *media ;
    Mediadata       *mediadata;
    MBProgressHUD   *hud;
    
    CGRect favoritelabelsize, otherlabelsize ;
    UILabel *otherLabel;
    CGRect cellsize;
    float move_size;
}

@end

@implementation FriendsViewController

- (id)init {
    if(self == [super init]) {
        friendsArray = [[NSMutableArray alloc] init];
    }
    userData = [[NSMutableData alloc] init];
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
    str = @"Friends";
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

    
    heightSpace = 25 * scale;
    size.size.width = screenWidth;
    size.size.height = screenHeight - statusBarHeight - titleBackgroundView.frame.size.height - heightSpace;
    size.origin.x = 0;
    size.origin.y = statusBarHeight + titleBackgroundView.frame.size.height + heightSpace;
    contactsScrollView = [[UIScrollView alloc] initWithFrame:size];
    [contactsScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:contactsScrollView];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];

    [self getFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)getFriends {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@", [UserDataSingleton sharedSingleton].serverURL, @"friends", [UserDataSingleton sharedSingleton].session]];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"friends" forKey:@"type"];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:30.f];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)createTableContacts:(NSArray *)contactsArray {
    ///////////////////ATN
    int count_favorite = 0, count_other = 0;
    int number_favorite = 0, number_other = 0;
    
    for(int i = 0; i < [contactsArray count]; i ++) {
        NSDictionary *contactDictionary = [contactsArray objectAtIndex:i];
        int is_favorite = [[contactDictionary objectForKey:@"is_favorite"] intValue];
        if (is_favorite == 1) {
            count_favorite++;
        } else {
            count_other++;
        }
    }
    
    NSString *labeltitle;
    NSString *filename;
    filename = [NSString stringWithFormat:@"friends_item_narrow%@", fileSufix];
    UIImage *noAvatarImage = [UIImage imageNamed:filename];
    cellsize.size.width = screenWidth;
    cellsize.size.height = noAvatarImage.size.height / noAvatarImage.size.width * screenWidth;
    cellsize.origin.x = 0;
    cellsize.origin.y = 0;
    
    //Favorite Label display
    labeltitle = [NSString stringWithFormat:@"Favorites:(%d Favorites)", count_favorite];
    favoritelabelsize.size = [labeltitle sizeWithAttributes:@{NSFontAttributeName:font3}];
    favoritelabelsize.origin.x = 0;
    favoritelabelsize.origin.y = 0;
    UILabel *favoriteLabel = [[UILabel alloc] initWithFrame:favoritelabelsize];
    favoriteLabel.textColor = [UIColor orangeColor];
    favoriteLabel.text = labeltitle;
    [favoriteLabel setBackgroundColor:[UIColor clearColor]];
    [favoriteLabel setFont:font3];
    [contactsScrollView addSubview:favoriteLabel];
    
    // Other Label display
    labeltitle = [NSString stringWithFormat:@"Other Friends:(%d friends)", count_other];
    otherlabelsize.size = [labeltitle sizeWithAttributes:@{NSFontAttributeName:font3}];
    otherlabelsize.origin.x = 0;
    otherlabelsize.origin.y = cellsize.size.height * count_favorite + favoritelabelsize.size.height;
    otherLabel = [[UILabel alloc] initWithFrame:otherlabelsize];
    otherLabel.textColor = [UIColor blueColor];
    otherLabel.text = labeltitle;
    [otherLabel setBackgroundColor:[UIColor clearColor]];
    [otherLabel setFont:font3];
    [contactsScrollView addSubview:otherLabel];
    ///////////////////
//    CGRect size;
    
    
    contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width, [contactsArray count] * cellsize.size.height + favoritelabelsize.size.height * 2);
    for(int i = 0; i < [contactsArray count]; i ++) {
        NSDictionary *contactDictionary = [contactsArray objectAtIndex:i];
        NSString *idFriend = [contactDictionary objectForKey:@"id"];
        NSString *name = [contactDictionary objectForKey:@"username"];
        NSString *friend_status = [contactDictionary objectForKey:@"friend_status"];
        NSString *avatar = [contactDictionary objectForKey:@"avatar"];
        int avatar_status = [[contactDictionary objectForKey:@"avatar_status"] intValue];
        int is_online = [[contactDictionary objectForKey:@"is_online"] intValue];
        int is_favorite = [[contactDictionary objectForKey:@"is_favorite"] intValue];
        FriendCellView *friendCellView = [[FriendCellView alloc] initWithFrame:cellsize
                                                                   andNameUser:name andIndex:i
                                                               andFriendStatus:friend_status
                                                                   andIdFriend:idFriend
                                                                     andAvatar:avatar
                                                               andAvatarStatus:avatar_status
                                                                  	 andIsOnline:is_online
                                                                   andIsFavorite:is_favorite                                                                                                                                 ];
        friendCellView.delegate = self;
        if (is_favorite == 1) {
            cellsize.origin.y = favoritelabelsize.size.height + cellsize.size.height *  number_favorite;
            number_favorite ++;
        } else {
            cellsize.origin.y = otherlabelsize.origin.y + otherlabelsize.size.height + cellsize.size.height * number_other;
            number_other ++;
        }
        friendCellView.frame = cellsize;
        [contactsScrollView addSubview:friendCellView];
        [friendsArray addObject:friendCellView];
    }
    [hud hide:YES];
}

- (void)deleteFriend:(int)index {
    FriendCellView *friendCellView = [friendsArray objectAtIndex:index];
    
    CGRect sizeFriendCellView = friendCellView.frame;
    
    [friendsArray removeObjectAtIndex:index];
    [friendCellView removeFromSuperview];
    friendCellView = nil;
    NSLog(@"%d", [friendsArray count]);
    if(index < [friendsArray count]) {
        for(int i = index; i < [friendsArray count]; i ++) {
            FriendCellView *friendCellView = [friendsArray objectAtIndex:i];
            
            CGRect sizeNewCell = friendCellView.frame;
            sizeNewCell.origin.y -= sizeFriendCellView.size.height;
            friendCellView.index = i;
            [friendCellView setFrame:sizeNewCell];
        }
    }

    [contactsScrollView setContentSize:CGSizeMake(contactsScrollView.frame.size.width,
                                                  contactsScrollView.frame.size.height - sizeFriendCellView.size.height)];
}

- (void)rewriteCells:(int)index {
    
    FriendCellView *indexfriendCellView = [friendsArray objectAtIndex:index];
    CGRect sizeFriendCellView = indexfriendCellView.frame;
    move_size = cellsize.size.height * 1.6259;//int changeValue = sizeFriendCellView.size.height -cellsize.size.height;
    int changeValue = sizeFriendCellView.size.height -cellsize.size.height;
    float indexValue = sizeFriendCellView.origin.y;
    float heightScrollView = 0;
    //move other label
    if (sizeFriendCellView.origin.y < otherlabelsize.origin.y) {
        if (changeValue < 10) {
            otherlabelsize.origin.y -= move_size;
        } else {
            otherlabelsize.origin.y += move_size;
        }
        [otherLabel setFrame:otherlabelsize];
    }
    //move cells
    for(int i = 0; i < [friendsArray count]; i ++) {
        FriendCellView *friendCellView = [friendsArray objectAtIndex:i];
        heightScrollView += friendCellView.frame.size.height;
        if(friendCellView.frame.origin.y > indexValue) {
            CGRect sizeNewCell = friendCellView.frame;
            if (changeValue < 10) {
                sizeNewCell.origin.y -= move_size;
//                is_upCell = false;
            } else {
                sizeNewCell.origin.y += move_size;
//                is_upCell = true;
            }
            [friendCellView setFrame:sizeNewCell];
            sizeFriendCellView = sizeNewCell;
        }
    }
    
    [contactsScrollView setContentSize:CGSizeMake(contactsScrollView.frame.size.width, heightScrollView)];
}

- (void)selectedFriend:(int)index {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?token=%@&friend_id=%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/medias_for_friend", [UserDataSingleton sharedSingleton].session, [UserDataSingleton sharedSingleton].idFriend]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"medias_for_friend" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setRequestMethod:@"GET"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hud show:YES];
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Callback Functions
- (void) mediaForFriend_callback:(ASIHTTPRequest *)request_param
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
    NSError *error = nil;
    NSPredicate *predicate;
    NSString *mediaId;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:[[request_param responseString] dataUsingEncoding:NSUTF8StringEncoding]
                          options: NSJSONReadingMutableContainers
                          error: &error];
    userData = [[NSMutableData alloc] init];
    NSDictionary    *message        = [json objectForKey:@"message"];
    [UserDataSingleton sharedSingleton].status=[message objectForKey:@"value"];
    
    // compare user server media  with DB cash
    if([[message objectForKey:@"code"] intValue] == SUCCESS_QUERY) {
        NSArray    *data        = [json objectForKey:@"data"];
        
        int dataCount=0;
        @try {
            dataCount=[data count];
        } @catch (NSException *e) {
            dataCount=0;
        }
        
        if (data!=nil && dataCount>0 ){
            
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            [fetchRequest setEntity:[NSEntityDescription entityForName:@"Medias" inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext]];
            error = nil;
            
            for(int i = 0; i < dataCount; i++) {
                mediaId             =   [[data objectAtIndex:i] objectForKey:@"id"];
                NSString *filename  =   [[data objectAtIndex:i] objectForKey:@"filename"];
                NSString *type      =   [[data objectAtIndex:i] objectForKey:@"type"];
                NSString *time =   [[data objectAtIndex:i] objectForKey:@"created_at"];
                NSString *thumb     = [[data objectAtIndex:i] objectForKey:@"thumb"];
                
                predicate = [NSPredicate predicateWithFormat:@"media_id==%@", mediaId];
                [request setPredicate:predicate];
                mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:request error:&error];
                
                if ([mediasArray count]>0){
                    media  = [mediasArray objectAtIndex:0];
                }else{
                    // add server media to DB
                    media = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    mediadata = [NSEntityDescription insertNewObjectForEntityForName:@"Mediasdata"
                                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    if(media != nil) {
                        
                        media.media_id  = mediaId;
                        media.user_id   = [UserDataSingleton sharedSingleton].idFriend;
                        media.name      = filename;
                        media.time      = time;
                        media.type      = type;
                        if (!type)
                            media.thumb     = thumb;
                        else
                            media.thumb = nil;
                        media.preview_data = nil;
                        
                        NSURL *url;
                        if([media.type isEqualToString:@"1"]){
                            url = [NSURL URLWithString:media.name];
                        } else {
                            url = [NSURL URLWithString:media.thumb];
                        }
                        NSData *nsdata = [NSData dataWithContentsOfURL:url];
                        UIImage *image = [UIImage imageWithData:nsdata];
                        media.preview_data = UIImagePNGRepresentation(image);
                        
                        NSError *error = nil;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                        
                    } else {
                        NSLog(@"new media failed to create");
                    }
                    
                    if(mediadata != nil) {
                        mediadata.media_id   = mediaId;
                        mediadata.data = nil;
                        mediadata.video_data = nil;
                        mediadata.data = media.preview_data;
                        
                        if([media.type isEqualToString:@"0"]){
                            NSURL *url = [NSURL URLWithString:media.name];
                            NSData *nsdata = [NSData dataWithContentsOfURL:url];
                            UIImage *image = [UIImage imageWithData:nsdata];
                            mediadata.video_data = UIImagePNGRepresentation(image);
                        }
                        NSError *error = nil;
                        if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                        {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                    } else {
                        NSLog(@"new media data failed to create");
                    }
                    
                }
            }
        }
        
        [self deleteOldMedia];
        
        FriendTimeDayViewController *subVC;
        if (subVC == nil) subVC =  [[FriendTimeDayViewController alloc] init];
        [self presentViewController:subVC animated:YES completion:nil];
    } else {
        
    }
    
    [hud hide:YES];
}

-(void)deleteOldMedia
{
    NSError *error = nil;
    NSError *requestError = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id==%@", [UserDataSingleton sharedSingleton].idFriend];
    [fetchRequest setPredicate:predicate];
    
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext
                   executeFetchRequest:fetchRequest error:&requestError];
    NSString *mediaid=nil;
    for(int k = 0; k < [mediasArray count]; k++) {
        media  = [mediasArray objectAtIndex:k];
        if (media != nil){
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay |NSCalendarUnitHour | NSCalendarUnitMinute;
                NSCalendar * cal = [NSCalendar currentCalendar];
                NSDate *myDate = [df dateFromString: media.time];
                mediaid = media.media_id;
                
                NSDateComponents *comps = [cal components:unitFlags fromDate:myDate];
                int day = [comps day];
                
                NSDate *currDate = [NSDate date];
                comps = [cal components:unitFlags fromDate:currDate];
                int currday = [comps day];
                
                if(day!=currday || media.preview_data == nil){
                    for (int i=0; i<[mediasArray count]; i++){
                        Media *temp = [mediasArray objectAtIndex:i];
                        if ([mediaid isEqualToString:temp.thumb] ){
                            [[CoreDataManager sharedManager].managedObjectContext deleteObject:temp];
                        }
                    }
                    [[CoreDataManager sharedManager].managedObjectContext deleteObject:media];
                    
                    fetchRequest = [[NSFetchRequest alloc] init];
                    entity = [NSEntityDescription entityForName:@"Mediasdata"
                                         inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                    [fetchRequest setEntity:entity];
                    requestError = nil;
                    NSError *error = nil;
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@", mediaid];
                    [fetchRequest setPredicate:predicate];
                    mediasdataArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    if([mediasdataArray count] > 0){
                        mediadata = [mediasdataArray objectAtIndex:[mediasdataArray count]-1];
                        [[CoreDataManager sharedManager].managedObjectContext deleteObject:mediadata];
                    }
                }
        }
    }
    mediasArray = [NSArray arrayWithObjects:  nil];
    if (![[CoreDataManager sharedManager].managedObjectContext save:&error]) { NSLog(@"Unresolved error %@, %@", error, [error userInfo]);  }
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
            NSLog(@"%@", json);
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"friends"]) {
                
                     NSArray *contactsArray = [json objectForKey:@"data"];
                     if(contactsArray && [contactsArray count] > 0) {
                             [self createTableContacts:contactsArray];
                     } else {
                             CGRect sizeLabel;
                             sizeLabel.size = [@"There are no friends" sizeWithAttributes:@{NSFontAttributeName:
                                                            font1}];
                             sizeLabel.origin.x = (screenWidth - sizeLabel.size.width) / 2;
                             sizeLabel.origin.y = (screenHeight - sizeLabel.size.height) / 2;
                             UILabel *label = [[UILabel alloc] initWithFrame:sizeLabel];
                             label.text          = @"There are no friends";
                             label.textColor = lightTextColor;
                             label.font          = font1;
                             label.textAlignment = NSTextAlignmentCenter;
                             label.backgroundColor = [UIColor clearColor];
                             [self.view addSubview:label];
                             [hud hide:YES];
                     }

            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"medias_for_friend"]) {
                    [self mediaForFriend_callback:request];
                
            }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        [hud hide:YES];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    [hud hide:YES];
}

@end
