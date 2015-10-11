//
//  SplashViewController.m
//  TimeChat
//


#import "SplashViewController.h"
#import "AppDelegate.h"

@interface SplashViewController (){
 NSString        *fileSufix;
}
@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filename;
//    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  [UserDataSingleton sharedSingleton].Sufix];

    UIImageView *splashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,   self.view.frame.size.height)];
   
    UIDevice *thisDevice = [UIDevice currentDevice];
    if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        if([UserDataSingleton sharedSingleton].IOSDevice!=5){
            filename=[NSString stringWithFormat:@"splashscreen640x960.png"];
        }else{
            filename=[NSString stringWithFormat:@"splashscreen640x1136.png"];		
        }
    } else if (thisDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        filename=[NSString stringWithFormat:@"splashscreen768x1024.png"];
    }

    
    
    [splashImageView setImage:[UIImage imageNamed:filename]];
    [self.view addSubview:splashImageView];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
