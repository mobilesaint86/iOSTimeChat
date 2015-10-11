//
//  LicenseViewController.m
//  TimeChat
//


#import "LicenseViewController.h"
#import "UserDataSingleton.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
@interface LicenseViewController ()

@end

@implementation LicenseViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:47.0f/255.0f green:157.0f/255.0f blue:205.0f/255.0f alpha:1];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self text];
    [self create];
}
- (void)text
{
    UIDevice *thisDevice = [UIDevice currentDevice];
    float margin1 = 0;
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
       
    } else if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        margin1 = 60;
    }
    UILabel *lblHobbies = [[UILabel alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 10, self.view.frame.size.width, 40)];
    lblHobbies.text=@"License Agreement";
    lblHobbies.font=[UIFont boldSystemFontOfSize:16.0];
    lblHobbies.textColor=[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:1];
    lblHobbies.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblHobbies];
    
    NSString *str = @"<p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-5px;'>TIMECHAT PRIVACY POLICY<br/><br/>This Privacy Policy (Policy) is incorporated by reference into the TimeChat terms and conditions(‘Terms’). It describes what types of information we collect and what we do with it. Capitalised words used in this Policy have the same meaning as so defined in the Terms.</p><p style='font-size:16px;line-height:14px;font-weight:bold;'>What information will be collected, and what do we do with it?</p><ul><li><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-5px;'>When you register for the App we ask for information such as your name, company name (if required), email address and billing address. If you sign up for a free account, you will be required to enter your personal information so that we can authenticate your identity.</p></li><li><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>We collect the e-mail addresses of those who communicate with us via e-mail, aggregate information on what pages visitors to our Web site(s) access or view, and information voluntarily provided to us (such as survey information and/or account registration information).</p></li><li><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>The information we collect from you is used to improve the quality of the App and any other services TimeChat may provide, and is not shared or sold to third parties for commercial purposes, except to provide products or services you've requested, when we have your permission, or where it is necessary to share information in order to investigate, prevent, or take action regarding illegal activities, suspected fraud, situations involving potential threats to the physical safety of any person, violations of Terms, or as otherwise required by law.</p></li></ul><br/><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>How will your information be stored?</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>TimeChat uses third party vendors and hosting partners to provide the necessary hardware, software, networking, storage, and related technology required to run the App. Although TimeChat owns the code, databases, and all rights to the TimeChat application, you retain all rights to your personal information.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>How securely is the information kept?</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>The security of your personal information is important to us. When you enter sensitive information (such as login credentials) we encrypt the transmission of that information using secure socket layer technology (SSL).</br>We follow generally accepted standards to protect the personal information submitted to us, both during transmission and once we receive it. No method of transmission over the Internet, or method of electronic storage, is 100% secure, however. Therefore, we cannot guarantee its absolute security. If you have any questions about security on our Web site, you can contact us.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>How long will your information be kept?</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>TimeChat will hold onto your personal information for the period that you are a user of the App. Where you cease to be a user, we will endeavour to securely destroy or permanently de-identify information that is no longer needed for the permitted purposes for which it may be used or disclosed.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>Will your information be shared with others?</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>Time Chat may disclose your personal information under special circumstances, such as to comply with subpoenas or if your actions violate the Terms.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>Can this Policy change?</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>We may use customer information for new, unanticipated uses not previously disclosed in our privacy notice. We may periodically update this policy from time to time. To keep up-to-date with TimeChat’s policy, please check its privacy policy page periodically. We will notify you about significant changes in the way we treat personal information by sending a notice to the primary email address specified in your TimeChat account registration and we will seek your consent to such changes.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>How can you contact TimeChat?</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>Any questions about this Policy should be addressed to info@timechat.com.au<br/>                            © 2014 TimeChat Pty Ltd.</p><br/><br/><br/><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>TIMECHAT TERMS AND CONDITIONS</p><br/><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>1. INTRODUCTION:</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>Welcome to our application (the App). This App is published by or on behalf of TimeChat Pty Ltd ACN 167359800 (TimeChat or We or Us) a company registered in Australia whose registered office is at PO Box 3021 Bankstown NSW 2000 Australia.<br/>This app includes a simple do-it-yourself content management system that enables you to easily upload your images without writing a single line of code. By using our App you agree to be bound by the following terms and conditions (Terms). TimeChat reserves the right to update and change these Terms from time to time without notice. Any new features that augment or enhance the current App, including the release of new tools and resources, shall be subject to these Terms. Continued use of the App after any such change(s) shall constitute your consent to such changes.<br/>Violation of any of the Terms will result in the termination of your account or registration to the App. While TimeChat prohibits certain conduct while using the App, you understand and agree that TimeChat cannot be responsible for content posted by you or other users of the App. You agree to use the App at your own risk.<br/>By downloading or otherwise accessing the App you agree to be bound by the following Terms, including our privacy policy and our cookies policy. If you have any queries about the App or these Terms, you can contact Us by any of the means set out in paragraph 11 of these Terms. If you do not agree with these Terms, you should stop using the App immediately.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>2. GENERAL RULES RELATING TO CONDUCT:</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>The App is made available for your own, personal use. The App must not be used for any commercial purpose whatsoever or for any illegal or unauthorised purpose. When you use the App you must comply with all applicable Australian laws and with any applicable international laws, including the local laws in your country of residence (together referred to as Applicable Laws).<br/>                    You agree that when using the App you will comply with all Applicable Laws and these Terms. In particular, but without limitation, you agree not to:<br/>                    (a) Use the App in any unlawful manner or in a manner which promotes or encourages illegal activity including (without limitation) copyright infringement; or<br/>(b) Attempt to gain unauthorised access to the App or any networks, servers or computer systems connected to the App; or<br/>(c) Modify, adapt, translate or reverse engineer any part of the App or re-format or frame any portion of the pages comprising the App, save to the extent expressly permitted by these Terms or by law.<br/>(d) Place any content or other information on the App that contains any information that is unlawful, offensive, threatening, libelous, defamatory, pornographic, obscene or otherwise objectionable or that violate any party’s intellectual property or these Terms.<br/>(e) Not partake in anyverbal, physical, written or other abuse (including threats of abuse or retribution) of any App user, customer, employee, member, or officer, otherwise, TimeChat reserves the right to immediately and indefinitely suspend your use of the App in accordance with clause 7 of these Terms, with no refund or other recourse to you.<br/>You agree to indemnify TimeChat in full and on demand from and against any loss, damage, costs or expenses which its suffers or incurs directly or indirectly as a result of your use of the App otherwise than in accordance with these Terms or Applicable Laws.</p><p style='font-size:16px;line-height:14px;font-weight:bold;margin-bottom:-5px;'>3. CONTENT:</p><p style='font-size:14px;line-height:14px;font-weight:normal;margin-bottom:-10px;'>The copyright in all material contained on, in, or available through the App including all information, data, text, music, sound, photographs, graphics and video messages, the selection and arrangement thereof, and all source code, software compilations and other material (Material) is owned by TimeChat. All rights are reserved. You can view, print or download extracts of the Material for your own personal use but you cannot otherwise copy, edit, vary, reproduce, publish, display, distribute, store, transmit, commercially exploit, disseminate in any form whatsoever or use the Material without TimeChat’s express permission.<br/>     The trademarks, service marks, and logos (Trade Marks) contained on or in the App are owned by TimeChat. You cannot use, copy, edit, vary, reproduce, publish, display, distribute, store, transmit, commercially exploit or disseminate the Trade Marks without the prior written consent of TimeChat.<br/></p>";
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[str dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

    CGSize hobbiesTextViewSize = [self calculateHeightForString:str];
    //now set the hobbiesTextView frame and also the text
    UITextView *tViewhobbies = [[UITextView alloc]initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y + 40, self.view.frame.size.width, hobbiesTextViewSize.height+ 5 - margin1)];
    tViewhobbies.font = [UIFont systemFontOfSize:12.0f];
    tViewhobbies.attributedText = attributedString;
    tViewhobbies.textColor=[UIColor colorWithRed:153.0f/255.0f green:153.0f/255.0f blue:153.0f/255.0f alpha:1];
    [tViewhobbies setEditable:NO];
    [self.view addSubview:tViewhobbies];
}

- (CGSize)calculateHeightForString:(NSString *)str
{
    CGSize size = CGSizeZero;
    
    UIFont *labelFont = [UIFont systemFontOfSize:12.0f];
    NSDictionary *systemFontAttrDict = [NSDictionary dictionaryWithObject:labelFont forKey:NSFontAttributeName];
    
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:str attributes:systemFontAttrDict];
    CGRect rect = [message boundingRectWithSize:(CGSize){320, MAXFLOAT}
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                        context:nil];//you need to specify the some width, height will be calculated
    if (rect.size.height > self.view.frame.size.height - 110)
        rect.size.height = self.view.frame.size.height - 110;
    
    size = CGSizeMake(rect.size.width, rect.size.height); //padding
    
    return size;
}

- (void)create
{
    NSString        *fileSufix, *filename;
    UIDevice *thisDevice = [UIDevice currentDevice];
    float margin2 = 0;
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        
    } else if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        margin2 = 3;
    }
    
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  [UserDataSingleton sharedSingleton].Sufix];
    filename=[NSString stringWithFormat:@"agree_button%@",  fileSufix];
    UIImage *agreeButtonImage = [UIImage imageNamed:filename];
    CGRect sizeAgreeButton;
    sizeAgreeButton.size.height = agreeButtonImage.size.height / 2;
    sizeAgreeButton.size.width = agreeButtonImage.size.width /2;
    sizeAgreeButton.origin.x = self.view.frame.size.width / 5;
    sizeAgreeButton.origin.y = self.view.frame.size.height - sizeAgreeButton.size.height - 4 - margin2;
    
    UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    [agreeButton setFrame:sizeAgreeButton];
    agreeButton.backgroundColor = [UIColor clearColor];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [agreeButton addTarget:self action:@selector(agreeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeButton];
    
    filename=[NSString stringWithFormat:@"cancel_button%@",  fileSufix];
    UIImage *cancelButtonImage = [UIImage imageNamed:filename];
    CGRect sizeCancelButton;
    sizeCancelButton.size.height = cancelButtonImage.size.height / 2;
    sizeCancelButton.size.width = cancelButtonImage.size.width /2;
    sizeCancelButton.origin.x = self.view.frame.size.width - self.view.frame.size.width / 5 - sizeCancelButton.size.width;
    sizeCancelButton.origin.y = self.view.frame.size.height - sizeCancelButton.size.height- 4 - margin2;
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    [cancelButton setFrame:sizeCancelButton];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [cancelButton addTarget:self action:@selector(cancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];

}
- (void)agreeButton
{
    [[UserDataSingleton sharedSingleton].userDefaults   setValue:@"true" forKey:@"isAgree"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate first];
}

- (void)cancelButton
{
    UIApplication *app = [UIApplication sharedApplication];
    [app performSelector:@selector(suspend)];
    
    [NSThread sleepForTimeInterval:2.0];
    
    exit(0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
