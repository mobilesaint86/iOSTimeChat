//
//  ViewController.m
//  CameraEffectProject
//


#import "ViewController.h"
//#import "AppDelegate.h"

@interface ViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIImageView *imageView;
    UIImageView *backgroundTopPanelImageView;
    PhotoRedactorView *photoRedactorView;
    VideoRedactorView *videoRedactorView;
    NSString *fileSufix;
    UIImage *theImage;
    Boolean Exit;
    Boolean _mediaType;
    Boolean first;
    Boolean cancelPressed;
}

@end

@implementation ViewController

@synthesize moviePlayer;

- (id)init:(int) type {
    _mediaType = type;
    if(self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    for (UIView *subview in self.view.subviews) {
        [subview removeFromSuperview];
    }
    
    photoRedactorView = nil;
    videoRedactorView = nil;
    imageView         = nil;
    backgroundTopPanelImageView = nil;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (Exit) {
        Exit=false;
        [videoRedactorView removeFromSuperview];
        [photoRedactorView removeFromSuperview];
        photoRedactorView = nil;
        videoRedactorView = nil;
    }
    if (first == true){
        first = false;
        [self buttonPhotoClick];
    }
    if (cancelPressed)
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Exit = false;
    first = true;
    
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
}

- (void)drawVideo:(NSURL *)videoUrl {
    VideoDrawViewController *videoDrawViewController = [[VideoDrawViewController alloc]    initWithVideo:videoUrl];
    videoDrawViewController.delegate = self;
    [self presentViewController:videoDrawViewController animated:YES completion:nil];
}

- (void)backButtonPress {
    [photoRedactorView setPhoto:nil andSave:YES];
    [videoRedactorView setVideo:nil ];

    Exit=true;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonVintageClick {
//    imageView.image = [self imageVintage];
}

- (void)buttonBlackAndWhiteClick {
//imageView.image = [self imageBlackAndWhite];
}

- (void)buttonPhotoClick{
    UIImagePickerController *imagePicker;
    if ([UserDataSingleton sharedSingleton].appImagePicker==nil) {
        imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        [UserDataSingleton sharedSingleton].appImagePicker=imagePicker;
    }else{
        imagePicker=[UserDataSingleton sharedSingleton].appImagePicker;
        imagePicker.delegate = self;
    }
    
    #if TARGET_IPHONE_SIMULATOR
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        /*if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
            [self.popover presentPopoverFromRect:CGRectMake(00, 1000, 1, 1) inView:self.view
                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [self.popover setPopoverContentSize:CGSizeMake(700, 1000)];
        }else{*/
            [self presentViewController:imagePicker animated:YES completion:NULL];
        //}
    #else
    
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if(_mediaType) {
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        } else {
            [imagePicker setVideoQuality:UIImagePickerControllerQualityTypeMedium];
            imagePicker.mediaTypes = @[(NSString *) kUTTypeMovie];
            imagePicker.videoMaximumDuration = 20.0f;
        }
        imagePicker.allowsEditing = NO;
        [self presentViewController:imagePicker animated:YES completion:nil];

    #endif

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    float heightStatusBar = 0;
    if([[[UIDevice currentDevice] systemVersion] intValue] >= 7) {
        heightStatusBar = 20;
    } else {
        heightStatusBar = 0;
    }
    NSString *filename;
    
    if([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        if(videoRedactorView) {
           /////t [videoRedactorView removeFromSuperview];
           /////t videoRedactorView = nil;
        }
        theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        float imageHight=800;
        //theImage=[self imageWithImage:theImage  scaledToSize:CGSizeMake(theImage.size.width/4, theImage.size.height/4 )];
        theImage=[self imageWithImage:theImage  scaledToSize:CGSizeMake(theImage.size.width*(imageHight/theImage.size.height), imageHight )];
        
        if(!photoRedactorView) {
            CGRect sizePhotoRedactorView = self.view.frame;
            sizePhotoRedactorView.origin.y = backgroundTopPanelImageView.frame.size.height+11;
            sizePhotoRedactorView.size.height -= sizePhotoRedactorView.origin.y;
            photoRedactorView = [[PhotoRedactorView alloc] initWithFrame:sizePhotoRedactorView    andPhoto:theImage];
            photoRedactorView.delegate = self;
            [self.view addSubview:photoRedactorView];
            
            // Back Button
            heightSpace = 54 * scale;
            widthSpace = 26 * scale;
            filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
            UIImage *backButtonImage = [UIImage imageNamed:filename];
            CGRect sizeBackButton;
            sizeBackButton.size.width = backButtonImage.size.width * scale;
            sizeBackButton.size.height = backButtonImage.size.height * scale;
            sizeBackButton.origin.y = heightSpace;
            sizeBackButton.origin.x = widthSpace;
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
            [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            [backButton setFrame:sizeBackButton];
            backButton.backgroundColor = [UIColor clearColor];
            [backButton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backButton];
        } else {
            [photoRedactorView setPhoto:theImage andSave:YES];
        }
        
        //theImage=nil;
        //photoRedactorView.delegate = self;
    } else {
        if(photoRedactorView) {
           /////t[photoRedactorView removeFromSuperview];
           /////t photoRedactorView = nil;
        }
        if(!videoRedactorView) {
            self.movieUrl = info[UIImagePickerControllerMediaURL];
            CGRect sizePhotoRedactorView = self.view.frame;
            sizePhotoRedactorView.origin.y = backgroundTopPanelImageView.frame.size.height;
            sizePhotoRedactorView.size.height -= sizePhotoRedactorView.origin.y;
        
            videoRedactorView = [[VideoRedactorView alloc]
                                 initWithFrame:sizePhotoRedactorView
                                 andVideo:info[UIImagePickerControllerMediaURL]];
            videoRedactorView.delegate = self;
            [self.view addSubview:videoRedactorView];
            
            // Back Button
            heightSpace = 54 * scale;
            widthSpace = 26 * scale;
            filename = [NSString stringWithFormat:@"back_button%@", fileSufix];
            UIImage *backButtonImage = [UIImage imageNamed:filename];
            CGRect sizeBackButton;
            sizeBackButton.size.width = backButtonImage.size.width * scale;
            sizeBackButton.size.height = backButtonImage.size.height * scale;
            sizeBackButton.origin.y = heightSpace;
            sizeBackButton.origin.x = widthSpace;
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
            filename = [NSString stringWithFormat:@"back_button_down%@", fileSufix];
            [backButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
            [backButton setFrame:sizeBackButton];
            backButton.backgroundColor = [UIColor clearColor];
            [backButton addTarget:self action:@selector(backButtonPress) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:backButton];
        } else {
            [videoRedactorView setVideo:info[UIImagePickerControllerMediaURL]];
        }
        //videoRedactorView.delegate = self;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage*)imageWithImage:(UIImage*)image   scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)clickPurchase
{
    PurchaseViewController *subVC;
    if(subVC==nil)  subVC = [[PurchaseViewController alloc] init];
    [self presentViewController:subVC animated:YES completion:nil];
}

- (void)drawPhoto:(UIImage *)photoImage {
    PhotoDrawViewController *photoDrawViewController = [[PhotoDrawViewController alloc]
                                                        initWithImage:photoImage];
    photoDrawViewController.delegate = self;
    [self presentViewController:photoDrawViewController animated:YES completion:nil];
}

- (void)savePhoto:(UIImage *)image {
    [photoRedactorView setPhoto:image andSave:YES];
}

- (void)saveVideo:(UIImage *)image {
    [videoRedactorView setPhoto:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    cancelPressed = true;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError
                      contextInfo:(void *)paramContextInfo {
    if(paramError == nil) {
        NSLog(@"Image was saved succesfully...");
    } else {
        NSLog(@"An error happened while saving the image");
        NSLog(@"Error = %@", paramError);
    }
}

- (BOOL)isCameraAvailable {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie
                          sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType
                 sourceType:(UIImagePickerControllerSourceType)paramSourceType {
    __block BOOL result = NO;
    if([paramMediaType length] == 0) {
        NSLog(@"Media type is empty.");
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController
                                    availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)object;
        if([mediaType isEqualToString:paramMediaType]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
