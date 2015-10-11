//
//  MessageCellView.m
//  TimeChat
//


#import "MessageCellView.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"

@interface MessageCellView() {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *buttonColor, *lightTextColor, *darkTextColor;
    PAImageView     *avatarImageView;
    bool            automaticallyAdd; //TRUE - YES, FALSE - NO
    NSDictionary    *notificationDictionary;
    UIButton        *button1;
    UIButton        *button2;
    NSString        *fileSufix;
    MBProgressHUD   *hub, *hub1;
//    NSArray *media_Array, *mediasData_Array;

    int MediaTypePhoto;
}

@end;

@implementation MessageCellView

@synthesize index;

- (id)initWithFrame:(CGRect)frame andMessageDictionary:(NSDictionary *)messageDictionary andIndex:(int)_index
{
    self = [super initWithFrame:frame];
    
    screenWidth = self.frame.size.width;
    screenHeight = self.frame.size.height;
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
    buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];
    lightTextColor = [[UserDataSingleton sharedSingleton].lightTextColor objectForKey:str];
    darkTextColor = [[UserDataSingleton sharedSingleton].darkTextColor objectForKey:str];
    
    if (self) {
        
        hub = [[MBProgressHUD alloc] initWithView:self];
        hub1 = [[MBProgressHUD alloc] initWithView:self];
        
        NSString *filename;
        UIImage *image;
        CGRect size;
        
        [self setBackgroundColor:[UIColor clearColor]];
        notificationDictionary = [[NSDictionary alloc] initWithDictionary:messageDictionary];
        
        NSString *typeMessage = [messageDictionary objectForKey:@"type"];
        
        index = _index;
        
        // Background
        filename = [NSString stringWithFormat:@"notification_item%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = screenWidth;
        size.size.height = screenHeight;
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        backgroundImageView.frame = size;
        [self addSubview:backgroundImageView];
        
        // Avatar
        heightSpace = 30 * scale;
        widthSpace = 45 * scale;
        filename = [NSString stringWithFormat:@"blank_user%@", fileSufix];
        UIImage *noAvatarImage = [UIImage imageNamed:filename];
        size.size.width = noAvatarImage.size.width * scale;
        size.size.height = noAvatarImage.size.height * scale;
        size.origin.x = widthSpace;
        size.origin.y = heightSpace;
        avatarImageView = [[PAImageView alloc] initWithFrame:size backgroundProgressColor:[UIColor whiteColor] progressColor:[UIColor lightGrayColor]];
        [avatarImageView setImage:noAvatarImage];
        [avatarImageView.layer setBorderWidth:0.f];
        [self addSubview:avatarImageView];
        
        if ([[notificationDictionary objectForKey:@"type"] intValue ] != 420 && [notificationDictionary objectForKey:@"friend_avatar"] != nil && ![[notificationDictionary objectForKey:@"friend_avatar"] isEqualToString:@""])
            [self createAvatarImage:@"3"];
        else
            [avatarImageView setImage:[UserDataSingleton sharedSingleton].userImage];
        
        // Text
        widthSpace = 203 * scale;
        heightSpace = 38 * scale;
        size.size = [@"test added you" sizeWithAttributes:@{NSFontAttributeName:font3}];
        size.size.width = 512 * scale;
        size.size.height = size.size.height * 2;
        size.origin.x = widthSpace;
        size.origin.y = heightSpace;
        
        UILabel *textMessage = [[UILabel alloc] initWithFrame:size];
        [textMessage setFont:font3];
        [textMessage setTextColor:darkTextColor];
        [textMessage setBackgroundColor:[UIColor clearColor]];
        textMessage.numberOfLines = 0;
        textMessage.text = [messageDictionary objectForKey:@"debug"];
        [self addSubview:textMessage];
        
        // Button
        filename = [NSString stringWithFormat:@"notification_red%@", fileSufix];
        UIImage *buttonImage = [UIImage imageNamed:filename];
        widthSpace = 204 * scale;
        heightSpace = 172 * scale;
        if ([typeMessage intValue] == 403 || [typeMessage intValue] == 405 || [typeMessage intValue] == 406 || ([typeMessage intValue] == 402 && automaticallyAdd)) {
            if (automaticallyAdd) {
                textMessage.text = [NSString stringWithFormat:@"%@ accepted according to your personal settings", [messageDictionary objectForKey:@"friend_name"]];
                [self acceptFriend];
            }
            size.size.width = buttonImage.size.width * scale;
            size.size.height = buttonImage.size.height * scale;
            size.origin.x = widthSpace;
            size.origin.y = heightSpace;
            
            UIButton *button = [[UIButton alloc] initWithFrame:size];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"notification_red_down%@", fileSufix];
            [button setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            [button setTitle:@"Ok" forState:UIControlStateNormal];
            [button setTitleColor:buttonColor forState:UIControlStateNormal];
            [button.titleLabel setFont:font3];
            [button addTarget:self action:@selector(clickButton:)
             forControlEvents:UIControlEventTouchUpInside];
            button.tag = 0;
            [self addSubview:button];
        } else {
            CGRect sizeButton1;
            sizeButton1.size.width = buttonImage.size.width * scale;
            sizeButton1.size.height = buttonImage.size.height * scale;
            sizeButton1.origin.x = widthSpace;
            sizeButton1.origin.y = heightSpace;
            
            button1 = [[UIButton alloc] initWithFrame:sizeButton1];
            [button1 setBackgroundColor:[UIColor clearColor]];
            filename = [NSString stringWithFormat:@"notification_red%@", fileSufix];
            [button1 setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"notification_red_down%@", fileSufix];
            [button1 setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            if ([typeMessage intValue] == 402) {
                [button1 setTitle:@"Accept" forState:UIControlStateNormal];
            } else if ([typeMessage intValue] == 404) {
                [button1 setTitle:@"Add friend" forState:UIControlStateNormal];
            } else if ([typeMessage intValue] == 416) {
                [button1 setTitle:@"Add friend" forState:UIControlStateNormal];
            } else if ([typeMessage intValue] == 420) {
                [button1 setTitle:@"Try again" forState:UIControlStateNormal];
            } else {
                [button1 setTitle:@"Show" forState:UIControlStateNormal];
            }
            [button1 setTitleColor:buttonColor forState:UIControlStateNormal];
            [button1.titleLabel setFont:font3];
            button1.tag = 1;
            [button1 addTarget:self action:@selector(clickButton:)
              forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button1];
            
            widthSpace = 8 * scale;
            CGRect sizeButton2 = sizeButton1;
            sizeButton2.origin.x += sizeButton1.size.width + widthSpace;
            button2 = [[UIButton alloc] initWithFrame:sizeButton2];
            [button2 setBackgroundColor:[UIColor clearColor]];
            filename = [NSString stringWithFormat:@"notification_blue%@", fileSufix];
            [button2 setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"notification_blue_down%@", fileSufix];
            [button2 setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            if ([typeMessage intValue] == 402) {
                [button2 setTitle:@"Decline" forState:UIControlStateNormal];
            } else if ([typeMessage intValue] == 404) {
                [button2 setTitle:@"Delete" forState:UIControlStateNormal];
            } else if ([typeMessage intValue] == 420) {
                [button2 setTitle:@"Delete" forState:UIControlStateNormal];
            } else {
                [button2 setTitle:@"Dismiss" forState:UIControlStateNormal];
            }
            [button2 setTitleColor:buttonColor forState:UIControlStateNormal];
            [button2.titleLabel setFont:font3];
            button2.tag = 2;
            [button2 addTarget:self action:@selector(clickButton:)
              forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button2];
            
            [self addSubview:hub];
            [self addSubview:hub1];
        }
    }
    return self;
}

- (void)clickButton:(UIButton*) button {
    NSString *typeMessage = [notificationDictionary objectForKey:@"type"];
    if ([typeMessage intValue] == 402 || [typeMessage intValue] == 404 || [typeMessage intValue] == 416) {
        if (button.tag == 1) {
            [button setHidden:YES];
            [button2 setHidden:YES];
            if ([typeMessage intValue] == 402)
                [self acceptFriend];
            else
                [self addFriend];
        } else if (button.tag == 2) {
            [button setHidden:YES];
            [button1 setHidden:YES];
            if ([typeMessage intValue] != 416)
                [self declineFriend];
        } else {
            [button setHidden:YES];
        }
    }
    if ([typeMessage  intValue] == 407 || [typeMessage  intValue] == 408 || [typeMessage  intValue] == 409 || [typeMessage  intValue] == 410 || [typeMessage  intValue] == 411 || [typeMessage  intValue] == 412) {
        [button1 setHidden:YES];
        [button2 setHidden:YES];
        if (button.tag == 1)
            [self showMedia];
    }
    if ([typeMessage  intValue] == 403 || [typeMessage  intValue] == 405 || [typeMessage  intValue] == 406) {
        [button setHidden:YES];
    }
    if ([typeMessage  intValue] == 420) {
        if (button.tag == 1) {
            [self reUpload];
        } else if (button.tag == 2) {
            [self removeLocalNotification];
        }
    }
    if ([typeMessage  intValue] != 420)
        [self deleteNotification];
}

- (void)reUpload{
    
    NSData *photoData, *previewData, *videoData;
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Media"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSPredicate *predicate;
    
    NSArray *media_Array, *mediasData_Array;
    
    Mediadata *mediasData;
    Media *media;
    predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [notificationDictionary objectForKey:@"media_id"]];
    [fetchRequest setPredicate:predicate];
//    media_Array=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
//    media = [media_Array objectAtIndex:[media_Array count]-1];
//    [[CoreDataManager sharedManager].managedObjectContext deleteObject:media];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Mediasdata"
                         inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    error = nil;
    predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [notificationDictionary objectForKey:@"media_id"]];
    [fetchRequest setPredicate:predicate];
//    mediasData_Array=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    media = [media_Array objectAtIndex:0];
    MediaTypePhoto = (int)media.type;
    if (MediaTypePhoto){
        mediasData = [mediasData_Array objectAtIndex:0];
        photoData = mediasData.data;
    } else {
        previewData = media.preview_data;
        videoData = mediasData.video_data;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"medias/main_page_info"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"main_page_info" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:@"1" forKey:@"media_exist"];
    
    if (MediaTypePhoto){
        [request setPostValue:@"1" forKey:@"media_type"];
        [request setData:photoData withFileName:@"new.png" andContentType:@"image/png" forKey:@"media"];
    }
    else{
        [request setPostValue:@"0" forKey:@"media_type"];
        [request setData:previewData withFileName:@"video_thumb.png" andContentType:@"image/png" forKey:@"video_thumb"];
        [request setData:videoData withFileName:@"new.mp4" andContentType:@"multipart/form-data" forKey:@"media"];
    }
    
    [request setDelegate:self];
    [request startAsynchronous];
    [hub show:YES];

}

-(void)removeLocalNotification{
    [button1 setHidden:YES];
    [button2 setHidden:YES];
//    [[UserDataSingleton sharedSingleton].userDefaults setObject:@"" forKey:@"localNotification"];[notificationDictionary objectForKey:@"media_id"]
//    NSArray *idsAry = [self.delegate getLocalNotificationIDs];
    
    NSString *str = [[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"localNotification"];//
    NSString *newStr = @"";
    if (![str isEqualToString:@""]){
        NSArray *foo = [str componentsSeparatedByString: @";"];
        for (int i=1;i<[foo count];i++){
            NSString *nodeString = [foo objectAtIndex:i];
            if (i == (int)[notificationDictionary objectForKey:@"media_id"]) {
                newStr = @"";
            } else {
                newStr = nodeString;
                
                if (i > (int)[notificationDictionary objectForKey:@"media_id"] && i != 0) {
                    NSArray *nodeAry = [nodeString componentsSeparatedByString: @","];
                    newStr = [NSString stringWithFormat:@"%d, %@", i-1, [nodeAry objectAtIndex:1]];//0:unread, 1:read
                }
            }
        }
    }
    [[UserDataSingleton sharedSingleton].userDefaults setObject:newStr forKey:@"localNotification"];
    
}
- (void)createAvatarImage:(NSString *) typePhoto {
    NSMutableString *stringUrl = [[NSMutableString alloc] initWithString:[notificationDictionary objectForKey:@"friend_avatar"]];
    NSURL  *url = [NSURL URLWithString:stringUrl];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    [avatarImageView setImage:[UIImage imageWithData:urlData]];
}
-(void)addFriend {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/add_friend_by_username"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:30.f];
    request.userInfo = [NSDictionary dictionaryWithObject:@"add_friend_by_username" forKey:@"type"];
    if ([[notificationDictionary objectForKey:@"type"] intValue]== 416)
        [request setPostValue:[notificationDictionary objectForKey:@"media_user_name"] forKey:@"username"];
    else
        [request setPostValue:[notificationDictionary objectForKey:@"friend_name"] forKey:@"username"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hub show:YES];
}
-(void)acceptFriend {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/accept_friend"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"accept_friend" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:[notificationDictionary objectForKey:@"friend_id"] forKey:@"friend_id"];
    [request setPostValue:[notificationDictionary objectForKey:@"id"] forKey:@"notification_id"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hub show:YES];
}
-(void)declineFriend {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"friends/decline_friend"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"decline_friend" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setPostValue:[notificationDictionary objectForKey:@"friend_id"] forKey:@"friend_id"];
    [request setPostValue:[notificationDictionary objectForKey:@"id"] forKey:@"notification_id"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hub show:YES];
}
-(void)deleteNotification {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", [UserDataSingleton sharedSingleton].serverURL, @"notifications/delete"]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    request.userInfo = [NSDictionary dictionaryWithObject:@"delete" forKey:@"type"];
    [request setTimeOutSeconds:30.f];
    [request setPostValue:[notificationDictionary objectForKey:@"id"] forKey:@"notification_id"];
    [request setPostValue:[UserDataSingleton sharedSingleton].session forKey:@"token"];
    [request setDelegate:self];
    [request startAsynchronous];
    [hub1 show:YES];
}
-(void)showMedia {
    [UserDataSingleton sharedSingleton].shareMediaId = [notificationDictionary objectForKey:@"media_id"];
    [UserDataSingleton sharedSingleton].idFriend = [notificationDictionary objectForKey:@"friend_id"];
    [UserDataSingleton sharedSingleton].friendName = [notificationDictionary objectForKey:@"friend_name"];
    [UserDataSingleton sharedSingleton].friendAvatar = [notificationDictionary objectForKey:@"friend_avatar"];
    [UserDataSingleton sharedSingleton].mediaCreatedTime = [notificationDictionary objectForKey:@"media_created_time"];
    [UserDataSingleton sharedSingleton].showButtonPressed = true;
    [self.delegate showMediaPress];
}

- (void)createAlertView:(NSString *)message {
    CGRect sizeAlertView;
    sizeAlertView.size.height /= 3;
    sizeAlertView.size.width /= 2;
    sizeAlertView.origin.x = (self.frame.size.width - sizeAlertView.size.width)/2;
    sizeAlertView.origin.y = (self.frame.size.height - sizeAlertView.size.height)/2;
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Message:"
                              message:message
                              delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView setFrame:sizeAlertView];
    [alertView show];
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
        NSDictionary *message = [json objectForKey:@"message"];
        NSDictionary *data = [json objectForKey:@"data"];
        ///////////////////ATN
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"main_page_info"]) {
            
            NSLog(@"=== main_page_info ===");
            NSLog(@"%@", json);
            NSLog(@"=== main_page_info ===");
            
            if([[message objectForKey:@"code"] intValue] == SUCCESS_UPLOADED) {
                
                NSString *mediaId = [data objectForKey:@"id"];
                
                // add new media to DB
//                NSError *error = nil;
                Media           *media;
                Mediadata       *mediadata;
                media     = [NSEntityDescription insertNewObjectForEntityForName:@"Medias"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                mediadata = [NSEntityDescription insertNewObjectForEntityForName:@"Mediasdata"
                                                          inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
                
                if(media != nil) {
                    media.media_id  = mediaId;
                    media.user_id   = [UserDataSingleton sharedSingleton].idUser;
                    media.name      = [data objectForKey:@"filename"];
                    media.time      = [data objectForKey:@"created_at"];
                    media.type      = MediaTypePhoto?@"1":@"0";
                    
                    NSError *error = nil;
                    if (![[CoreDataManager sharedManager].managedObjectContext save:&error])
                    {   NSLog(@"Unresolved error %@, %@", error, [error userInfo]);}
                } else {
                    NSLog(@"new media failed to create");
                }
                
                if(mediadata != nil) {
                    
                    mediadata.media_id  = mediaId;
                    mediadata.time      = [data objectForKey:@"created_at"];
                    NSError *error = nil;
                    if (![[CoreDataManager sharedManager].managedObjectContext save:&error]){
                        NSLog(@"Unresolved error for media Data db write %@, %@", error, [error userInfo]);}
                    else {
                        NSLog(@"new media failed to create");
                    }
                } else {
                    NSLog(@"!!!new media data failed to create");
                }
                [self createAlertView:@"Your media was uploaded."];
                [UserDataSingleton sharedSingleton].changed = true;
                [self removeLocalNotification];
                [hub hide:YES];
            }else{
            }
            
        }
        ///////////////////////
        else if([[message objectForKey:@"code"] integerValue] == SUCCESS_QUERY) {
            
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"accept_friend"]) {
                [hub hide:YES];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"decline_friend"]) {
                [hub hide:YES];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"delete"]) {
                [hub1 hide:YES];
            } else if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"add_friend_by_username"]) {
                [hub hide:YES];
                NSDictionary *contactDictionary = [json objectForKey:@"data"];
                if ([[contactDictionary objectForKey:@"code"] integerValue] == 201) {
                    [self createAlertView:@"Invitation was sent"];
                } else {
                    [self createAlertView:[contactDictionary objectForKey:@"debug"]];
                }
            }
        }
        else {
            if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"delete"]) {
                [hub1 hide:YES];
            } else {
                [hub hide:YES];
            }
            [self createAlertView:@"Invalid data"];//////////ATN
        }
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Unknown error occured" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
        if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"delete"]) {
            [hub1 hide:YES];
        } else {
            [hub hide:YES];
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"You are not connected to the internet." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    if ([[request.userInfo objectForKey:@"type"] isEqualToString:@"delete"]) {
        [hub1 hide:YES];
    } else {
        [hub hide:YES];
    }
    [hub hide:YES];
}
@end
