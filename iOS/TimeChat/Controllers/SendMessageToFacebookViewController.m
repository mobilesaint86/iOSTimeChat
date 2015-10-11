//
//  SendMessageToFacebookViewController.m
//  TimeChat
//


#import "SendMessageToFacebookViewController.h"

@interface SendMessageToFacebookViewController () {
    NSString *sendMessageText;
    UITextView *messageTextView;
    NSString *fileSufix;
}

@end

@implementation SendMessageToFacebookViewController
@synthesize friendID;
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
    // Do any additional setup after loading the view.
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  [UserDataSingleton sharedSingleton].Sufix];
    NSString *filename;
    filename = [NSString stringWithFormat:@"find_friends_phonebook_button_up%@", fileSufix];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:filename]]];
    filename = [NSString stringWithFormat:@"find_friends_facebook_icon%@", fileSufix];
    UIImage *findFriendsImage = [UIImage imageNamed:filename];
    CGRect sizeFindFriendsImage;
    sizeFindFriendsImage.size.width = findFriendsImage.size.width/2;
    sizeFindFriendsImage.size.height = findFriendsImage.size.height/2;
    
    CGSize sizeText = [@" Find friends by Facebook" sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:16.0f]}];
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        sizeFindFriendsImage.origin.y = 20;
    } else {
        sizeFindFriendsImage.origin.y = 0;
    }
    sizeFindFriendsImage.origin.x = (self.view.frame.size.width -
                                     (sizeText.width + sizeFindFriendsImage.size.width))/2;
    CGRect sizeTitleLabel = sizeFindFriendsImage;
    sizeTitleLabel.origin.x = sizeTitleLabel.origin.y = 0;
    sizeTitleLabel.size.width = self.view.frame.size.width;
    sizeTitleLabel.size.height += sizeFindFriendsImage.origin.y;
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:sizeTitleLabel];
    filename = [NSString stringWithFormat:@"find_friends_facebook_background%@", fileSufix];
    [titleImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:filename]]];
    [self.view addSubview:titleImageView];
    
    UIImageView *findFriendsImageView = [[UIImageView alloc] initWithFrame:sizeFindFriendsImage];
    [findFriendsImageView setImage:findFriendsImage];
//    filename = [NSString stringWithFormat:@"find_friends_facebook_background%@", fileSufix];
    [findFriendsImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:filename]]];
    [self.view addSubview:findFriendsImageView];
    
    CGRect sizeFindFriendsLabel = sizeFindFriendsImage;
    sizeFindFriendsLabel.size.width = sizeText.width;
    sizeFindFriendsLabel.origin.x = sizeFindFriendsImage.origin.x + sizeFindFriendsImage.size.width;
    UILabel *findFriendsLabel = [[UILabel alloc] initWithFrame:sizeFindFriendsLabel];
    [findFriendsLabel setText:@" Find friends by Facebook"];
    [findFriendsLabel setFont:[UIFont systemFontOfSize:16]];
    [findFriendsLabel setTextColor:[UIColor colorWithRed:(255/255.0) green:(255/255.0)
                                                    blue:(255/255.0) alpha:1]];
//    filename = [NSString stringWithFormat:@"find_friends_facebook_background%@", fileSufix];
    [findFriendsLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:filename]]];
    [self.view addSubview:findFriendsLabel];
    
    filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
    UIImage *backImage = [UIImage imageNamed:filename];
    CGRect sizeBackButton;
    sizeBackButton.origin.x = 5;
    sizeBackButton.size.height = backImage.size.height/2;
    sizeBackButton.size.width = backImage.size.width/2;
    sizeBackButton.origin.y = sizeFindFriendsImage.origin.y + (sizeFindFriendsImage.size.height -
                                                               sizeBackButton.size.height)/2;
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:sizeBackButton];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage
                                    imageNamed:filename]
                          forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(clickBackButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    CGRect sizeScrollView;
    sizeScrollView.origin.x = 0;
    sizeScrollView.origin.y = titleImageView.frame.origin.y + titleImageView.frame.size.height;
    sizeScrollView.size.width = self.view.frame.size.width;
    sizeScrollView.size.height = self.view.frame.size.height - sizeScrollView.origin.y;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:sizeScrollView];
    [self.view addSubview:scrollView];
    CGSize sizeLabelText = [@"Sending invitations" sizeWithAttributes:
                   @{NSFontAttributeName:
                         [UIFont systemFontOfSize:24.0f]}];
    CGRect sizeSendingInvitations;
    sizeSendingInvitations.origin.x = 20;
    sizeSendingInvitations.origin.y = 23;
    sizeSendingInvitations.size.width = self.view.frame.size.width - sizeSendingInvitations.origin.x * 2;
    sizeSendingInvitations.size.height = sizeLabelText.height;
    UILabel *sendingInvitationsLabel = [[UILabel alloc] initWithFrame:sizeSendingInvitations];
    [sendingInvitationsLabel setText:@"Sending invitations"];
    [sendingInvitationsLabel setTextColor:[UIColor whiteColor]];
    [sendingInvitationsLabel setFont:[UIFont systemFontOfSize:24]];
    [sendingInvitationsLabel setBackgroundColor:[UIColor clearColor]];
    [scrollView addSubview:sendingInvitationsLabel];
    
    NSString *commentString = @"You can add comment to sending invitation";
    CGRect sizeCommentLabel = sizeSendingInvitations;
    sizeCommentLabel.origin.y += sizeCommentLabel.size.height + 28;
    sizeCommentLabel.size.height *= 2;
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:sizeCommentLabel];
    [commentLabel setTextColor:[UIColor whiteColor]];
    [commentLabel setBackgroundColor:[UIColor clearColor]];
    [commentLabel setText:commentString];
    commentLabel.numberOfLines = 2;
    [commentLabel setFont:[UIFont systemFontOfSize:24]];
    [scrollView addSubview:commentLabel];
    
    filename = [NSString stringWithFormat:@"find_friends_facebook_send_field%@", fileSufix];
    UIImage *textViewImage = [UIImage imageNamed:filename];
    CGRect sizeTextView;
    sizeTextView.size.height = textViewImage.size.height / 2;
    sizeTextView.size.width = textViewImage.size.width / 2;
    sizeTextView.origin.x  =  (self.view.frame.size.width - sizeTextView.size.width) / 2;
    sizeTextView.origin.y = commentLabel.frame.origin.y + commentLabel.frame.size.height + 21;
    UIImageView *textViewImageView = [[UIImageView alloc] initWithFrame:sizeTextView];
    [textViewImageView setImage:textViewImage];
    [scrollView addSubview:textViewImageView];
    
    messageTextView = [[UITextView alloc] initWithFrame:sizeTextView];
    messageTextView.textColor = [UIColor whiteColor];
    messageTextView.font = [UIFont systemFontOfSize:24];
    messageTextView.backgroundColor = [UIColor clearColor];
    messageTextView.returnKeyType = UIReturnKeyDefault;
    messageTextView.delegate = self;
    [scrollView addSubview:messageTextView];
    
    filename = [NSString stringWithFormat:@"find_friends_email1_button_up%@", fileSufix];
    UIImage *sendButtonImage = [UIImage imageNamed:filename];
    CGRect sizeSendButton;
    sizeSendButton.size.height = sendButtonImage.size.height / 2;
    sizeSendButton.size.width = sendButtonImage.size.width / 2;
    sizeSendButton.origin.x = (self.view.frame.size.width - sizeSendButton.size.width) / 2;
    sizeSendButton.origin.y = messageTextView.frame.origin.y + messageTextView.frame.size.height + 25;
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:sizeSendButton];
    [sendButton setBackgroundImage:sendButtonImage forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"find_friends_email1_button_down%@", fileSufix];
    [sendButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [sendButton setBackgroundColor:[UIColor clearColor]];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    UIColor *buttonTextColor = [UIColor colorWithRed:47.0f/255.0f green:156.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    [sendButton setTitleColor:buttonTextColor forState:UIControlStateNormal];
    sendButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [sendButton addTarget:self action:@selector(clickSendButton)
         forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:sendButton];
    
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, sendButton.frame.origin.y +
                                          sendButton.frame.size.height + 10)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)clickSendButton {
    NSDictionary *postParam = [NSDictionary dictionaryWithObjectsAndKeys:friendID, @"to", @"http://timechat.com.au/", @"redirect", nil];
    NSString *sendMessage = [NSString stringWithFormat:@"Welcome to TimeChat! %@", messageTextView.text];
    [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:sendMessage title:@"title" parameters:postParam handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
        if (error) {
            // Error launching the dialog or sending the request.
            NSLog(@"Error sending request.");
        } else {
            if (result == FBWebDialogResultDialogNotCompleted) {
                // User clicked the "x" icon
                NSLog(@"User canceled request.");
            } else {
                // Handle the send request callback
                NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                if (![urlParams valueForKey:@"request"]) {
                    // User clicked the Cancel button
                    NSLog(@"User canceled request.");
                } else {
                    // User clicked the Send button
                    NSString *requestID = [urlParams valueForKey:@"request"];
                    NSLog(@"Request ID: %@", requestID);
                }
            }
        }
    }];
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

-(void)clickBackButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    float keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    if (textView.frame.origin.y + textView.frame.size.height > keyboardHeight) {
        double offset = keyboardHeight - textView.frame.origin.y - textView.frame.size.height - 20;
        CGRect rect = CGRectMake(0, offset, self.view.frame.size.width, self.view.frame.size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    int space = 0;
    //    if(statusBarHeight == 0) {
    //        space = 20;
    //    }
    CGRect rect = CGRectMake(0, space, self.view.frame.size.width, self.view.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.view.frame = rect;
    [UIView commitAnimations];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
    }
    return YES;
}

- (void)removeKeyboard {
    [self resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
