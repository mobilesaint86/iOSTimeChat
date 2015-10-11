//
//  FindFriendsByPhonebookViewController.m
//  TimeChat1
//
//  Created by michail on 25/02/14.
//  Copyright (c) 2014 Maksim Denisov. All rights reserved.
//

#import "FindFriendsByContactsViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FindFriendsByContactsViewController () {
    ABAddressBookRef addressBook;
    NSMutableArray *emailArray;
    BOOL selectAll;
    UIButton *selectAllButton;
    UIButton *doneButton;
    UIScrollView *contactsScrollView;
    NSMutableArray *phonebookContactArray;
    NSMutableArray *contactsAddedArray;
    NSMutableArray *contactsFromServerCellsArray;
    int system;
    UIImage *imagePatterm;
    NSString *findFriendsString;
    UIImage *findFriendsImage;
    UIImage *selectAllImage;
    UIImage *selectAllUpImage;
    UIImage *noAvatarImage;
    UILabel *myContactsLabel;
    int countAddCells;
    NSString *fileSufix;
}
@end

@implementation FindFriendsByContactsViewController
@synthesize inviteFriendToFacebook;

- (id)init:(int)_system {
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  [UserDataSingleton sharedSingleton].Sufix];
    NSString *filename;
    system = _system;
    if(self = [super init]) {
        if(system == 0) {
            filename = [NSString stringWithFormat:@"find_friends_facebook_background%@", fileSufix];
            imagePatterm = [UIImage imageNamed:filename];
            findFriendsString = @" Find friends by gmail";
            filename = [NSString stringWithFormat:@"find_friends_email1_icon%@", fileSufix];
            findFriendsImage = [UIImage imageNamed:filename];
            filename = [NSString stringWithFormat:@"find_friends_email_friend%@", fileSufix];
            selectAllImage = [UIImage imageNamed:filename];
            selectAllUpImage = [UIImage imageNamed:@""];
            filename = [NSString stringWithFormat:@"find_friends_facebook_avatar%@", fileSufix];
            noAvatarImage = [UIImage imageNamed:filename];
        } else if (system == 1) {
            CFErrorRef *error = nil;
            addressBook = ABAddressBookCreateWithOptions(NULL, error);
            emailArray = [[NSMutableArray alloc] init];
            phonebookContactArray = [[NSMutableArray alloc] init];
            filename = [NSString stringWithFormat:@"find_friends_phonebook_background%@", fileSufix];
            imagePatterm = [UIImage imageNamed:filename];
            findFriendsString = @" Find friends by Phonebook";
            filename = [NSString stringWithFormat:@"find_friends_phonebook_icon%@", fileSufix];
            findFriendsImage = [UIImage imageNamed:filename];
            filename = [NSString stringWithFormat:@"find_friends_phonebook_select all_down%@", fileSufix];
            selectAllImage = [UIImage imageNamed:filename];
            selectAllUpImage = [UIImage imageNamed:@""];
            filename = [NSString stringWithFormat:@"find_friends_phonebook_avatar%@", fileSufix];
            noAvatarImage = [UIImage imageNamed:filename];
        } else if (system == 2) {
            filename = [NSString stringWithFormat:@"find_friends_facebook_background%@", fileSufix];
            imagePatterm = [UIImage imageNamed:filename];
            findFriendsString = @" Find friends by Facebook";
            filename = [NSString stringWithFormat:@"find_friends_facebook_icon%@", fileSufix];
            findFriendsImage = [UIImage imageNamed:filename];
            filename = [NSString stringWithFormat:@"find_friends_email_friend%@", fileSufix];
            selectAllImage = [UIImage imageNamed:filename];
            selectAllUpImage = [UIImage imageNamed:@""];
            filename = [NSString stringWithFormat:@"find_friends_facebook_avatar%@", fileSufix];
            noAvatarImage = [UIImage imageNamed:filename];
        } else if (system == 3) {
            filename = [NSString stringWithFormat:@"find_friends_facebook_background%@", fileSufix];
            imagePatterm = [UIImage imageNamed:filename];
            findFriendsString = @" Find friends by Google+";
            filename = [NSString stringWithFormat:@"find_friends_google_icon%@", fileSufix];
            findFriendsImage = [UIImage imageNamed:filename];
            filename = [NSString stringWithFormat:@"find_friends_email_friend%@", fileSufix];
            selectAllImage = [UIImage imageNamed:filename];
            selectAllUpImage = [UIImage imageNamed:@""];
            filename = [NSString stringWithFormat:@"find_friends_facebook_avatar%@", fileSufix];
            noAvatarImage = [UIImage imageNamed:filename];
        } else {
            NSLog(@"error");
        }
        contactsAddedArray = [[NSMutableArray alloc] init];
        contactsFromServerCellsArray = [[NSMutableArray alloc] init];
        countAddCells = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filename;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:imagePatterm]];
    CGRect sizeFindFriendsImage;
    sizeFindFriendsImage.size.width = findFriendsImage.size.width/2;
    sizeFindFriendsImage.size.height = findFriendsImage.size.height/2;
    
    CGSize sizeText = [findFriendsString sizeWithFont:[UIFont systemFontOfSize:16]];
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        sizeFindFriendsImage.origin.y = 20;
    } else {
        sizeFindFriendsImage.origin.y = 0;
    }
    sizeFindFriendsImage.origin.x = (self.view.frame.size.width -
                                     (sizeText.width + sizeFindFriendsImage.size.width))/2;
    
    UIImageView *findFriendsImageView = [[UIImageView alloc] initWithFrame:sizeFindFriendsImage];
    [findFriendsImageView setImage:findFriendsImage];
    [findFriendsImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:findFriendsImageView];
    
    CGRect sizeFindFriendsLabel = sizeFindFriendsImage;
    sizeFindFriendsLabel.size.width = sizeText.width;
    sizeFindFriendsLabel.origin.x = sizeFindFriendsImage.origin.x + sizeFindFriendsImage.size.width;
    UILabel *findFriendsLabel = [[UILabel alloc] initWithFrame:sizeFindFriendsLabel];
    [findFriendsLabel setText:findFriendsString];
    [findFriendsLabel setFont:[UIFont systemFontOfSize:16]];
    [findFriendsLabel setTextColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0)
                                                    blue:(255/255.0) alpha:1]];
    [findFriendsLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:findFriendsLabel];
    
    filename = [NSString stringWithFormat:@"everywhere_button_back_up%@", fileSufix];
    UIImage *backImage = [UIImage imageNamed:filename];
    CGRect sizeBackButton;
    sizeBackButton.origin.x = 5;
    sizeBackButton.size.height = backImage.size.height/2;
    sizeBackButton.size.width = backImage.size.width/2;
    sizeBackButton.origin.y = sizeFindFriendsImage.origin.y + (sizeFindFriendsImage.size.height -
                                                               sizeBackButton.size.height)/2;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:sizeBackButton];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"everywhere_button_back_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename]
                          forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(clickBackButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    sizeFindFriendsLabel.origin.y += sizeFindFriendsLabel.size.height;
    sizeFindFriendsLabel.size.width = self.view.frame.size.width;
    sizeFindFriendsLabel.origin.x = 0;
    myContactsLabel = [[UILabel alloc] initWithFrame:sizeFindFriendsLabel];
    [myContactsLabel setText:@"My contacts"];
    [myContactsLabel setBackgroundColor:[UIColor clearColor]];
    [myContactsLabel setTextColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0)
                                                   blue:(255/255.0) alpha:1]];
    [myContactsLabel setTextAlignment:NSTextAlignmentCenter];
    [myContactsLabel setFont:[UIFont systemFontOfSize:24]];
    [self.view addSubview:myContactsLabel];

    if (!((system == 2) && (inviteFriendToFacebook == 1))) {
        NSString *selectAllString = @"Select all";
        CGSize sizeSelectAllText = [selectAllString sizeWithFont:[UIFont systemFontOfSize:24]];
        sizeFindFriendsLabel.origin.y += sizeFindFriendsLabel.size.height;
        sizeFindFriendsLabel.origin.x = self.view.frame.size.width/2;
        sizeFindFriendsLabel.size.width = sizeSelectAllText.width;
        UILabel *selectAllLabel = [[UILabel alloc] initWithFrame:sizeFindFriendsLabel];
        [selectAllLabel setTextColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0)
                                                   blue:(255/255.0) alpha:1]];
        [selectAllLabel setBackgroundColor:[UIColor clearColor]];
        [selectAllLabel setTextAlignment:NSTextAlignmentCenter];
        [selectAllLabel setFont:[UIFont systemFontOfSize:24]];
        [selectAllLabel setText:@"Select all"];
    
        [self.view addSubview:selectAllLabel];
    
        CGRect sizeSelectAllButton = selectAllLabel.frame;
        sizeSelectAllButton.size.height = selectAllImage.size.height/2;
        sizeSelectAllButton.size.width = selectAllImage.size.width/2;
        sizeSelectAllButton.origin.x += (self.view.frame.size.width/2 - selectAllLabel.frame.size.width -
                                     sizeSelectAllButton.size.width)/2 + selectAllLabel.frame.size.width;
        selectAllButton = [[UIButton alloc] initWithFrame:sizeSelectAllButton];
        [selectAllButton setBackgroundImage:selectAllImage forState:UIControlStateNormal];
        [selectAllButton addTarget:self action:@selector(clickSelectAll)
              forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:selectAllButton];
    }
    filename = [NSString stringWithFormat:@"find_friends_phonebook_button_up%@", fileSufix];
    UIImage *doneButtonUpImage = [UIImage
                                  imageNamed:filename];
    filename = [NSString stringWithFormat:@"find_friends_phonebook_button_down%@", fileSufix];
    UIImage *doneButtonDownImage = [UIImage
                                    imageNamed:filename];
    CGRect sizeDoneButton = self.view.frame;
    sizeDoneButton.size.height = doneButtonUpImage.size.height/2;
    sizeDoneButton.origin.x = 0;
    sizeDoneButton.origin.y = self.view.frame.size.height - sizeDoneButton.size.height;
    
    doneButton = [[UIButton alloc] initWithFrame:sizeDoneButton];
    [doneButton setBackgroundImage:doneButtonUpImage forState:UIControlStateNormal];
    [doneButton setBackgroundImage:doneButtonDownImage forState:UIControlStateHighlighted];
    [doneButton addTarget:self action:@selector(clickDoneButton)
         forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:25]];
    [self.view addSubview:doneButton];
    
    [self createContactsScrollView];
    switch (system) {
        case 0:
            [self getContactsFromGmail];
            break;
        case 1:
            [self getContactsFromPhonebook];
            break;
        case 2:
            [self sendRequestFindByFacebook];
            break;
        case 3:
            [self sendRequestFindByGoogle];
            break;
        default:
            NSLog(@"error");
            break;
    }
}

- (void)createContactsScrollView {
    if ((system == 2) && (inviteFriendToFacebook == 1)) {
        contactsScrollView = [[UIScrollView alloc]
                              initWithFrame:CGRectMake(0, myContactsLabel.frame.origin.y +
                                                       myContactsLabel.frame.size.height,
                                                       self.view.frame.size.width,
                                                       doneButton.frame.origin.y -
                                                       (myContactsLabel.frame.origin.y +
                                                        myContactsLabel.frame.size.height)
                                                       )];
    } else {
        contactsScrollView = [[UIScrollView alloc]
                          initWithFrame:CGRectMake(0, selectAllButton.frame.origin.y +
                                                   selectAllButton.frame.size.height,
                                                   self.view.frame.size.width,
                                                   doneButton.frame.origin.y -
                                                   (selectAllButton.frame.origin.y +
                                                   selectAllButton.frame.size.height)
                                                   )];
    }
    [self.view addSubview:contactsScrollView];
}

- (void)clickDoneButton {
    if ((system == 2) && (inviteFriendToFacebook == 1)) {
        [self dismissModalViewControllerAnimated:NO];
    } else {
        if([contactsAddedArray count] > 0) {
            NSLog(@"send request %i contacts", [contactsAddedArray count]);
            if(system == 2) {
                [self sendRequestAddedContactsBySocial];
            } else if (system == 3) {
                [self sendRequestAddedContactsBySocial];
            } else {
                [self sendRequestAddedContactsByEmails];
            }
        } else {
            NSLog(@"null contacts");
        }
    }
}

- (void)sendRequestAddedContactsByEmails {
    
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL,
                           @"/api/friend/addFriends"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:stringUrl]];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
    //                                [NSURL URLWithString:
    //                                 @"http://timechat.rhinoda.ru/api/friend/addFriends"]];
    [request setHTTPMethod:@"POST"];
    NSMutableArray *addedEmailsContacts = [[NSMutableArray alloc] init];
    for(FindContactCellView *cellView in contactsAddedArray) {
        if(cellView.email) {
            [addedEmailsContacts addObject:cellView.email];
        }
    }
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          addedEmailsContacts,@"emails", nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:30.0f];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:
                                         CGRectMake((self.view.frame.size.width - 10)/2 ,
                                                    (self.view.frame.size.height - 10)/2,
                                                    10, 10)];
    [activity setColor:[UIColor whiteColor]];
    [self.view addSubview:activity];
    [activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [activity stopAnimating];
         });
         if([data length] > 0 && error == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
             NSDictionary *message = [json objectForKey:@"message"];
             if(message) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:[message objectForKey:@"value"] andDismissController:YES];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:@"Error query" andDismissController:NO];
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self createAlertView:@"Error rerquest to server" andDismissController:NO];
             });
         }
     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)sendRequestAddedContactsBySocial {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL,
                           @"/api/friend/addSocialFriends"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:stringUrl]];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
    //                                [NSURL URLWithString:
    //                                 @"http://timechat.rhinoda.ru/api/friend/addSocialFriends"]];
    [request setHTTPMethod:@"POST"];
    NSString *service = nil;
    if (system == 2) {
        service = @"facebook";
    } else {
        service = @"google_oauth";
    }
    NSMutableArray *addedSocialContacts = [[NSMutableArray alloc] init];
    for(FindContactCellView *cellView in contactsAddedArray) {
        if(cellView.identity) {
            NSMutableDictionary *contactDictionary = [[NSMutableDictionary alloc] init];
            [contactDictionary setValue:cellView.identity forKey:@"identity"];
            [contactDictionary setValue:service forKey:@"service"];
            [addedSocialContacts addObject:contactDictionary];
        }
    }
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          addedSocialContacts,@"social", nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:30.0f];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:
                                         CGRectMake((self.view.frame.size.width - 10)/2 ,
                                                    (self.view.frame.size.height - 10)/2,
                                                    10, 10)];
    [activity setColor:[UIColor whiteColor]];
    [self.view addSubview:activity];
    [activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             [activity stopAnimating];
         });
         if([data length] > 0 && error == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
             NSDictionary *message = [json objectForKey:@"message"];
             if(message) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:[message objectForKey:@"value"] andDismissController:YES];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:@"Error query" andDismissController:NO];
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self createAlertView:@"Error rerquest to server" andDismissController:NO];
             });
         }
     }];
}

- (void)clickSelectAll {
    if(!selectAll) {
        NSString *filename;
        filename = [NSString stringWithFormat:@"find_friends_phonebook_select all_up%@", fileSufix];
        [selectAllButton setBackgroundImage:
         [UIImage imageNamed:filename]
                                   forState:UIControlStateNormal];
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

- (void)getContactsFromGmail {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL,
                           @"/api/friend/searchMailFriends"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:stringUrl]];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
    //                                [NSURL URLWithString:
    //                                 @"http://timechat.rhinoda.ru/api/friend/searchMailFriends"]];
    [request setHTTPMethod:@"POST"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserDataSingleton sharedSingleton].googleToken,@"access_token",
                          @"google_oauth",@"service", nil];
    NSLog(@"%@", [UserDataSingleton sharedSingleton].googleToken);
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:30.0f];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:
                                         CGRectMake((self.view.frame.size.width - 10)/2 ,
                                                    (self.view.frame.size.height - 10)/2,
                                                    10, 10)];
    [activity setColor:[UIColor whiteColor]];
    [self.view addSubview:activity];
    [activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
             NSArray *contactsArray = [json objectForKey:@"data"];
             if(contactsArray && [contactsArray count] > 0) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activity stopAnimating];
                     [self createTableContacts:contactsArray];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:@"There are no email contacts in your gmail"
                      andDismissController:NO];
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self createAlertView:@"Error rerquest to server" andDismissController:NO];
             });
         }
     }];
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
                NSString *firstName =
                    (__bridge NSString *)(ABRecordCopyValue(person, kABPersonFirstNameProperty));
                NSString *secondName = (__bridge NSString *)
                    (ABRecordCopyValue(person, kABPersonLastNameProperty));
                ABMultiValueRef emails = ABRecordCopyValue(person, kABPersonEmailProperty);
                for (CFIndex i = 0; i < ABMultiValueGetCount(emails); i++) {
                    NSString *email =
                        (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(emails, i);
                    NSLog(@"%@ email :%@",firstName, email);
                    NSMutableDictionary *contact = [[NSMutableDictionary alloc] init];
                    [contact setValue:email forKey:@"email"];
                    NSString *username;
                    if(firstName && secondName) {
                        username = [NSString stringWithFormat:@"%@ %@", firstName, secondName];
                    } else if(firstName){
                        username = [NSString stringWithFormat:@"%@", firstName];
                    } else if(secondName) {
                        username = [NSString stringWithFormat:@"%@", secondName];
                    }
                    [contact setValue:username forKey:@"name"];
                    [phonebookContactArray addObject:contact];
                    [emailArray addObject:email];
                }
            }
            if([emailArray count] > 0) {
                [self sendRequestFindFriendsByPhonebook];
            } else {
                [self createAlertView:@"There are no email contacts in your phonebook"
                 andDismissController:NO];
            }
        } else {
            [self createAlertView:
             @"App need access to your personal contact list. Please check phone setting"
             andDismissController:NO];
        }
    } else {
        [self createAlertView:
         @"App need access to your personal contact list. Please check phone setting"
         andDismissController:NO];
    }
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
    }
    [alertView setFrame:sizeAlertView];
    [alertView show];
}

- (void)sendRequestFindFriendsByPhonebook {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL,
                           @"/api/friend/searchFriends"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:stringUrl]];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
    //                                [NSURL URLWithString:
    //                                 @"http://timechat.rhinoda.ru/api/friend/searchFriends"]];
    NSMutableString *emailsString = [[NSMutableString alloc] init];
    for(int i = 0; i < [emailArray count]; i++) {
        NSString *email = [emailArray objectAtIndex:i];
        [emailsString appendFormat:@"%@", email];
        if(i != [emailArray count] -1) {
            [emailsString appendString:@","];
        }
    }
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          emailArray,@"emails", nil];
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:30.0f];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:
                                         CGRectMake((self.view.frame.size.width - 10)/2 ,
                                                    (self.view.frame.size.height - 10)/2,
                                                    10, 10)];
    [activity setColor:[UIColor whiteColor]];
    [self.view addSubview:activity];
    [activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
             NSArray *contactsArray = [json objectForKey:@"data"];
             if(contactsArray && [contactsArray count] > 0) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activity stopAnimating];
                     [self createTableContacts:contactsArray];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:@"There are no email contacts in your phonebook"
                      andDismissController:NO];
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self createAlertView:@"Error rerquest to server" andDismissController:NO];
             });
         }
     }];
}

- (void)sendRequestFindByGoogle {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL,
                           @"/api/socialInfo/getFriendByAccessToken"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:stringUrl]];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
    //                                [NSURL URLWithString:
    //                                 @"http://timechat.rhinoda.ru/api/socialInfo/getFriendByAccessToken"]];
    [request setHTTPMethod:@"POST"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserDataSingleton sharedSingleton].googleToken,@"access_token",
                          @"google_oauth",@"service", nil];
    NSLog(@"%@", [UserDataSingleton sharedSingleton].googleToken);
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:30.0f];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:
                                         CGRectMake((self.view.frame.size.width - 10)/2 ,
                                                    (self.view.frame.size.height - 10)/2,
                                                    10, 10)];
    [activity setColor:[UIColor whiteColor]];
    [self.view addSubview:activity];
    [activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
             NSArray *contactsArray = [json objectForKey:@"data"];
             if(contactsArray && [contactsArray count] > 0) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activity stopAnimating];
                     [self createTableContacts:contactsArray];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:@"There are no email contacts in your google"
                      andDismissController:NO];
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self createAlertView:@"Error rerquest to server" andDismissController:NO];
             });
         }
     }];
}

- (void)sendRequestFindByFacebook {
    NSString *stringUrl = [NSString stringWithFormat:@"%@%@",[UserDataSingleton sharedSingleton].serverURL,
                           @"/api/socialInfo/getFriendByAccessToken"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString:stringUrl]];
    //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:
    //                                [NSURL URLWithString:
    //                                 @"http://timechat.rhinoda.ru/api/socialInfo/getFriendByAccessToken"]];
    [request setHTTPMethod:@"POST"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UserDataSingleton sharedSingleton].facebookToken,@"access_token",
                          @"facebook",@"service", nil];
    NSLog(@"facebook searh = %@", data);
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    [request setHTTPBody:jsonData];
    [request setTimeoutInterval:30.0f];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:
                                         CGRectMake((self.view.frame.size.width - 10)/2 ,
                                                    (self.view.frame.size.height - 10)/2,
                                                    10, 10)];
    [activity setColor:[UIColor whiteColor]];
    [self.view addSubview:activity];
    [activity startAnimating];
    [NSURLConnection sendAsynchronousRequest:request queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && error == nil) {
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:kNilOptions
                                                                    error:nil];
             NSArray *contactsArray = [json objectForKey:@"data"];
             if(contactsArray && [contactsArray count] > 0) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [activity stopAnimating];
                     [self createTableContacts:contactsArray];
                 });
             } else {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [self createAlertView:@"There are no email contacts in your facebook"
                      andDismissController:NO];
                 });
             }
         } else {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self createAlertView:@"Error rerquest to server" andDismissController:NO];
             });
         }
     }];
}

- (void)contactClick:(FindContactCellView *)findContactCellView andRemove:(BOOL)remove {
    if ((system == 2) && (inviteFriendToFacebook == 1)) {
        SendMessageToFacebookViewController *sendMessageToFacebookViewController = [[SendMessageToFacebookViewController alloc] init];
        sendMessageToFacebookViewController.friendID = findContactCellView.identity;
        [self presentViewController:sendMessageToFacebookViewController animated:NO completion:nil];
    } else {
        if(remove) {
            [contactsAddedArray removeObject:findContactCellView];
        } else {
            [contactsAddedArray addObject:findContactCellView];
        }
    }
/*    if (system != 2) {
        if(remove) {
            [contactsAddedArray removeObject:findContactCellView];
        } else {
            [contactsAddedArray addObject:findContactCellView];
        }
    } else {
        SendMessageToFacebookViewController *sendMessageToFacebookViewController = [[SendMessageToFacebookViewController alloc] init];
        sendMessageToFacebookViewController.friendID = findContactCellView.identity;
        [self presentViewController:sendMessageToFacebookViewController animated:NO completion:nil];
    }*/
}

- (void)createTableContacts:(NSArray *)contactsArray {
    CGRect sizeContactCellView;
    sizeContactCellView.size.height = noAvatarImage.size.height/2 + 20;
    sizeContactCellView.origin.x = sizeContactCellView.origin.y = 0;
    sizeContactCellView.size.width = self.view.frame.size.width;
/*    if (system == 2) {
        contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                                    countAddCells *
                                                    sizeContactCellView.size.height);
    } else {
        contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                              ([contactsArray count]) *
                                              sizeContactCellView.size.height);
    }*/
    for(int i = 0; i < [contactsArray count]; i ++) {
        NSDictionary *contactDictionary = [contactsArray objectAtIndex:i];
        int userCode = [[contactDictionary objectForKey:@"code"] intValue];
        NSDictionary *phonebookContactDictionary = [phonebookContactArray objectAtIndex:i];
        NSString *name;
        if([contactDictionary objectForKey:@"username"]) {
            name = [contactDictionary objectForKey:@"username"];
        } else {
            name = [phonebookContactDictionary objectForKey:@"name"];
        }
        if(userCode != 301) {
            if (system == 2) {
                if ((inviteFriendToFacebook == 0) && (userCode != 202)) {
                    countAddCells ++;
                    FindContactCellView *findContactCellView = [[FindContactCellView alloc]
                                           initWithFrame:sizeContactCellView
                                           andUserNameString:name
                                           andStateInSystem:userCode
                                           andEmail:[contactDictionary
                                                     objectForKey:@"email"]
                                           andNoAvatarImage:noAvatarImage
                                           andSystem:system
                                           andIdentity:[contactDictionary
                                                        objectForKey:@"identity"]
                                           andAvatar:[contactDictionary objectForKey:@"avatar"]];
                    findContactCellView.delegate = self;
                    [contactsScrollView addSubview:findContactCellView];
                    sizeContactCellView.origin.y += sizeContactCellView.size.height;
                    if(userCode == 201 || userCode == 202) {
                        [contactsFromServerCellsArray addObject:findContactCellView];
                    }
                }
                if ((inviteFriendToFacebook == 1) && (userCode == 202)) {
                    countAddCells ++;
                    FindContactCellView *findContactCellView = [[FindContactCellView alloc]
                                           initWithFrame:sizeContactCellView
                                           andUserNameString:name
                                           andStateInSystem:userCode
                                           andEmail:[contactDictionary
                                                     objectForKey:@"email"]
                                           andNoAvatarImage:noAvatarImage
                                           andSystem:system
                                           andIdentity:[contactDictionary
                                                        objectForKey:@"identity"]
                                           andAvatar:[contactDictionary objectForKey:@"avatar"]];
                    findContactCellView.delegate = self;
                    [contactsScrollView addSubview:findContactCellView];
                    sizeContactCellView.origin.y += sizeContactCellView.size.height;
                    if(userCode == 201 || userCode == 202) {
                        [contactsFromServerCellsArray addObject:findContactCellView];
                    }
                }
            } else {
                FindContactCellView *findContactCellView = [[FindContactCellView alloc]
                                                        initWithFrame:sizeContactCellView
                                                        andUserNameString:name
                                                        andStateInSystem:userCode
                                                        andEmail:[contactDictionary
                                                                  objectForKey:@"email"]
                                                        andNoAvatarImage:noAvatarImage
                                                        andSystem:system
                                                        andIdentity:[contactDictionary
                                                                     objectForKey:@"identity"]
                                                        andAvatar:[contactDictionary objectForKey:@"avatar"]];
                findContactCellView.delegate = self;
                [contactsScrollView addSubview:findContactCellView];
                sizeContactCellView.origin.y += sizeContactCellView.size.height;
                if(userCode == 201 || userCode == 202) {
                    [contactsFromServerCellsArray addObject:findContactCellView];
                }
            }
        }
    }
    if (system == 2) {
        contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                                    countAddCells *
                                                    sizeContactCellView.size.height);
    } else {
        contactsScrollView.contentSize = CGSizeMake(contactsScrollView.frame.size.width,
                                                    ([contactsArray count]) *
                                                    sizeContactCellView.size.height);
    }
    [phonebookContactArray removeAllObjects];
    phonebookContactArray = nil;
}

- (void)clickBackButton {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
