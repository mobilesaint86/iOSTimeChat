//
//  FullPhotoViewController.m
//
//  TimeChat
//



#import "AppDelegate.h"
#import "FullPhotoViewController.h"

@interface FullPhotoViewController () {
    float           keyboardHeight,statusBarHeight;
    UIImageView     *fotoImage;
    UIControl       *viewControl;
    NSMutableData   *userData;
    UIScrollView    *scrollView;
    UIView          *photoFormViewHolder;
    UIView          *formView;
    UIColor         *textColor;
    UIColor         *labelTextColor;
    NSString        *fileSufix;
    UIImageView*    userImage;
    MPMoviePlayerController *moviePlayer;
    UIButton        *playButton;
    ALAssetsLibrary *assetsLibrary;
    int             serverRequestType;
    NSString        *zoomMediaID;
    UIButton *shareButton;
    NSArray *mediasArray;
    NSArray *mediasdataArray;
    Media   *media ;
    Mediadata *mediadata;
    NSURL *urlVideo;
    NSData *urlData;
    int currentHour;
    float titleHight;
}
@end

@implementation FullPhotoViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1];
    [super viewDidLoad];
    [self create];
    userData = [[NSMutableData alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) dealloc {
    userImage =nil;
    
    for (UIView *subview in photoFormViewHolder.subviews) {
        [subview removeFromSuperview];
    }
    
    fotoImage=nil;
    viewControl=nil;    
    userData=nil;
    scrollView=nil;
    photoFormViewHolder=nil;
    formView=nil;
    textColor=nil;
    labelTextColor=nil;
    fileSufix=nil;
    userImage=nil;
    moviePlayer=nil;
    playButton=nil;
    assetsLibrary=nil;
    zoomMediaID=nil;
    urlVideo=nil;
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)create {
   
    NSString *filename;
    serverRequestType=0;
    fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
    labelTextColor = [UserDataSingleton sharedSingleton].LabelTextColor;
    textColor      = [UserDataSingleton sharedSingleton].TextColor;
    keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
    
    titleHight=self.view.frame.size.height/6;
    
    // Background
    UIButton *background = [UIButton buttonWithType:UIButtonTypeCustom];
    [background setFrame: CGRectMake(0, titleHight,  self.view.frame.size.width,  self.view.frame.size.height-titleHight)];
    background.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:255.0/255.0f  blue:255.0/255.0f alpha:1.0f];
//    [self.view addSubview:background];
    
    // scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height)];
    scrollView.scrollEnabled = YES;
    
    formView = [[UIView alloc] initWithFrame:CGRectMake(0, titleHight, self.view.frame.size.width, self.view.frame.size.height)];
    photoFormViewHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, formView.frame.size.width,formView.frame.size.height+300)];
    scrollView.userInteractionEnabled=YES;
    [scrollView addSubview:photoFormViewHolder];
    photoFormViewHolder.hidden=true;
    [self photoView:@""];
    [self.view addSubview:scrollView];
    
    // Back Button
    float scale = [UserDataSingleton sharedSingleton].scale;
    float widthSpace = 26 * scale;
    float heightSpace = 54 * scale;
    
    filename=[NSString stringWithFormat:@"back_button%@", fileSufix];
    UIImage *backImage = [UIImage imageNamed:filename];
    CGRect sizeBackButton;
    sizeBackButton.size.height = backImage.size.height * scale;
    sizeBackButton.size.width = backImage.size.width * scale;
    sizeBackButton.origin.y = heightSpace;
    sizeBackButton.origin.x = widthSpace;
    UIButton *backButton = [[UIButton alloc] initWithFrame:sizeBackButton];
    [backButton setFrame:sizeBackButton];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
    filename=[NSString stringWithFormat:@"back_button_down%@", fileSufix];
    [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backButtonPress)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)photoView:(NSString*)photoNum {
    photoFormViewHolder.hidden = true;

    UIImage *image;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSError *error = nil;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"media_id==%@", [UserDataSingleton sharedSingleton].selectedMediaID];
  
    [fetchRequest setPredicate:predicate];
    mediasArray = [[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Mediasdata"
                                              inManagedObjectContext:[CoreDataManager sharedManager].managedObjectContext];
    [fetchRequest setEntity:entity];
    requestError = nil;
    error = nil;
    predicate = [NSPredicate predicateWithFormat:@"media_id==%@",[UserDataSingleton sharedSingleton].selectedMediaID ];
    [fetchRequest setPredicate:predicate];
    mediasdataArray=[[CoreDataManager sharedManager].managedObjectContext executeFetchRequest:fetchRequest error:&error];

    int cellSize=self.view.frame.size.width;
    // Clear the subviews
    for (UIView *subview in photoFormViewHolder.subviews) {
        [subview removeFromSuperview];
    }
    if([mediasArray count]>0) {
        media = [mediasArray objectAtIndex:0];
        mediadata = [mediasdataArray objectAtIndex:0];
        
        if ([[NSString stringWithFormat:@"%@", [UserDataSingleton sharedSingleton].selectedMediaID] isEqualToString:media.media_id]) {
            image=[UIImage imageWithData:mediadata.data];
            
            CGRect sizeRect;
            sizeRect.size.width = cellSize;
            sizeRect.size.height = cellSize / image.size.width * image.size.height;
            sizeRect.origin.x = 0;
            sizeRect.origin.y = (self.view.frame.size.height - (cellSize/image.size.width)*image.size.height) / 2;
            
            UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
            [imageView setFrame:sizeRect];
            
            [photoFormViewHolder addSubview:imageView];
            
            if([media.type isEqualToString:@"0"]){
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory = [paths objectAtIndex:0];
                NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"MyFile.m4v"];

                [mediadata.video_data writeToFile:appFile atomically:YES];
                
                urlVideo = [NSURL fileURLWithPath:appFile];

                moviePlayer = [[MPMoviePlayerController alloc] init];
                [moviePlayer setContentURL:urlVideo];
                [moviePlayer.view setFrame:sizeRect];
                moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
                [photoFormViewHolder addSubview:moviePlayer.view];
                
                playButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [playButton setFrame:sizeRect];
                [playButton setBackgroundImage:imageView.image forState:UIControlStateNormal];
                [playButton addTarget:self action:@selector(playVideo)   forControlEvents:UIControlEventTouchUpInside];
                [photoFormViewHolder addSubview:playButton];
            }
        }
    }
    [scrollView setContentSize:(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height))];
    photoFormViewHolder.hidden= false;
}

- (void)playVideo {
    [playButton setHidden:YES];
    //[shareButton setHidden:YES];
//    [thumpnilImageView removeFromSuperview];
//    thumpnilImageView = nil;
    [moviePlayer play];
}

- (void)backButtonPress {
    [moviePlayer stop];
    [playButton setHidden:NO];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
