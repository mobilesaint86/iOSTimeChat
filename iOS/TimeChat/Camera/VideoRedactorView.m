//
//  VideoRedactorView.m
//  CameraEffectProject
//


#import "VideoRedactorView.h"

@implementation VideoRedactorView {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *buttonColor;
    NSURL *urlVideo;
    UIImageView *bottomPanelBackgroundImageView;
    UIButton *saveToGalleryButton;
    UIButton *saveButton;
    UIButton *noneButton;
    UIImage *noneButtonDownImage;
    UIImage *noneButtonUpImage;
    UIImage *drawButtonUpImage;
    UIImage *drawButtonDownImage;
    UIButton *drawButton;
    MPMoviePlayerController *moviePlayer;
    UIButton *playButton;
    UIImageView *thumpnilImageView;
    UIImageView *drawImageView;
    UIImage *thumbNail;
    ALAssetsLibrary *assetsLibrary;
    NSString *fileSufix;
    NSData  *videoData;
    NSMutableData   *userData;
}

- (void)dealloc {
    videoData = nil;
    userData = nil;
    thumbNail = nil;
    drawImageView = nil;
    thumpnilImageView = nil;
    // Clear the subviews
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

- (id)initWithFrame:(CGRect)frame andVideo:(NSURL *)_urlVideo
{
    self = [super initWithFrame:frame];
    if (self) {
        
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
        
        userData = [[NSMutableData alloc] init];
        
        NSString *filename;
        UIImage *image;
        
        urlVideo = _urlVideo;
        CGRect sizeBottomPanelBackgroundImageView = frame;
        sizeBottomPanelBackgroundImageView.size.height = 85;
        sizeBottomPanelBackgroundImageView.origin.y = (frame.size.height -
                                                       2*sizeBottomPanelBackgroundImageView.size.height);
        bottomPanelBackgroundImageView = [[UIImageView alloc] initWithFrame:
                                          sizeBottomPanelBackgroundImageView];
        filename = [NSString stringWithFormat:@"main_background%@", fileSufix];
        [bottomPanelBackgroundImageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:filename]]];
        bottomPanelBackgroundImageView.userInteractionEnabled = YES;
        [self addSubview:bottomPanelBackgroundImageView];
        

        CGRect sizePlayerView = frame;
        sizePlayerView.origin.y = 0;
        sizePlayerView.size.height = screenHeight;
        moviePlayer = [[MPMoviePlayerController alloc] init];
        [moviePlayer setContentURL:urlVideo];
        [moviePlayer.view setFrame:sizePlayerView];
        moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        [self addSubview:moviePlayer.view];
        
        UIImage *thumbnilImage = [self generateThumbnilImage:urlVideo];
        thumpnilImageView = [[UIImageView alloc] initWithFrame:sizePlayerView];
        [thumpnilImageView setImage:thumbnilImage];
        [self addSubview:thumpnilImageView];
        
        drawImageView = [[UIImageView alloc] initWithFrame:thumpnilImageView.frame];
        [drawImageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:drawImageView];
        
        // play button
        heightSpace = 400 * scale;
        filename = [NSString stringWithFormat:@"video_play%@", fileSufix];
        image = [UIImage imageNamed:filename];
        CGRect sizePlayButton;
        sizePlayButton.size.height = image.size.height * scale;
        sizePlayButton.size.width = image.size.width * scale;
        sizePlayButton.origin.x = (screenWidth - sizePlayButton.size.width) / 2;
        sizePlayButton.origin.y = heightSpace;        
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playButton setFrame:sizePlayButton];
        [playButton setBackgroundImage:image forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"video_play_down%@", fileSufix];
        [playButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];

        // save to gallery button
        heightSpace = 20 * scale;
        widthSpace = 18 * scale;
        filename = [NSString stringWithFormat:@"take_photo_blue%@", fileSufix];
        image = [UIImage imageNamed:filename];
        CGRect sizeSaveToGalleryButton;
        sizeSaveToGalleryButton.size.width = image.size.width * scale;
        sizeSaveToGalleryButton.size.height = image.size.height * scale;
        sizeSaveToGalleryButton.origin.y = screenHeight - sizeSaveToGalleryButton.size.height - heightSpace;
        sizeSaveToGalleryButton.origin.x = (screenWidth - sizeSaveToGalleryButton.size.width * 2 - widthSpace) / 2;
        saveToGalleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveToGalleryButton setFrame:sizeSaveToGalleryButton];
        [saveToGalleryButton setBackgroundImage:image forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"take_photo_blue_down%@", fileSufix];
        [saveToGalleryButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [saveToGalleryButton addTarget:self action:@selector(saveVideoToGallery) forControlEvents:UIControlEventTouchUpInside];
        [saveToGalleryButton setTitle:@"Save to gallery" forState:UIControlStateNormal];
        [saveToGalleryButton.titleLabel setFont:font3];
        [saveToGalleryButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [self addSubview:saveToGalleryButton];
        
        // save button
        filename = [NSString stringWithFormat:@"take_photo_red%@", fileSufix];
        image = [UIImage imageNamed:filename];
        sizeSaveToGalleryButton.origin.x = screenWidth - saveToGalleryButton.frame.origin.x - sizeSaveToGalleryButton.size.width;
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton setFrame:sizeSaveToGalleryButton];
        [saveButton addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setBackgroundImage:image forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"take_photo_red_down%@", fileSufix];
        [saveButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton.titleLabel setFont:font3];
        [saveButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [self addSubview:saveButton];
        
        filename = [NSString stringWithFormat:@"video_draw_down%@", fileSufix];
        drawButtonUpImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"video_draw%@", fileSufix];
        drawButtonDownImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"video_none%@", fileSufix];
        noneButtonUpImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"video_none_down%@", fileSufix];
        noneButtonDownImage = [UIImage imageNamed:filename];
        
        // none button
        heightSpace = 212 * scale;
        widthSpace = 240 * scale;
        CGRect sizeNoneButton;
        sizeNoneButton.size.width = drawButtonUpImage.size.width * scale;
        sizeNoneButton.size.height = drawButtonUpImage.size.height * scale;
        sizeNoneButton.origin.x = widthSpace;
        sizeNoneButton.origin.y = screenHeight - heightSpace;

        noneButton = [[UIButton alloc] initWithFrame:sizeNoneButton];
        [noneButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
        [noneButton addTarget:self action:@selector(clickNoneButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:noneButton];
        
        // draw button
        CGRect sizeDrawButton;
        sizeDrawButton.size.width = sizeNoneButton.size.width;
        sizeDrawButton.size.height = sizeNoneButton.size.height;
        sizeDrawButton.origin.x = screenWidth - sizeNoneButton.origin.x - sizeNoneButton.size.width;
        sizeDrawButton.origin.y = sizeNoneButton.origin.y;
        drawButton = [[UIButton alloc] initWithFrame:sizeDrawButton];
        [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
        [drawButton addTarget:self action:@selector(clickDrawButton)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:drawButton];

    }
    return self;
}

- (void)clickNoneButton {
    [noneButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
    [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
    drawImageView.image = nil;
    [drawImageView setBackgroundColor:[UIColor clearColor]];
}

-(UIImage *)generateThumbnilImage : (NSURL *)filepath
{
    AVAsset *asset = [AVAsset assetWithURL:filepath];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef scale:1.0
                                       orientation:UIImageOrientationRight];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    thumbNail=thumbnail;
    return thumbnail;
}

- (void)saveVideoToGallery {
    if(!assetsLibrary) {
        assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:urlVideo completionBlock:^(NSURL *assetURL,
                                                                                 NSError *error)
     {
         if(error == nil) {
             NSLog(@"no errors happened");
             [saveToGalleryButton setEnabled:NO];
         } else {
             NSLog(@"Error happened while saving the video");
             NSLog(@"The error is = %@", error);
         }
     }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success save to gallery"
                                                    message:@""
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    alert.tag = 1;
    [alert show];
}

- (void)clickDrawButton {
    [self.delegate drawVideo:urlVideo];
    //[noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
    //[drawButton setBackgroundImage:drawButtonDownImage forState:UIControlStateNormal];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1) {
        if(buttonIndex == 0) {
           
        }
    }
}

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
- (UIImage *)rotateImage:(UIImage*)image byDegree:(CGFloat)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_RADIANS(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    //[rotatedViewBox release];
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(bitmap, rotatedSize.width, rotatedSize.height);
    
    CGContextRotateCTM(bitmap, DEGREES_RADIANS(degrees));
    
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width, -image.size.height, image.size.width, image.size.height), [image CGImage]);
    
    
    NSString *filename=[NSString stringWithFormat:@"my_timeday_icon_video_prev%@",   fileSufix];
    UIImage *imageVideo=[UIImage imageNamed:filename];
    [imageVideo drawInRect:CGRectMake(0,0,image.size.width, image.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (UIImage *)addVideoIconToImage:(UIImage*)bottomImage {
    NSString *filename=[NSString stringWithFormat:@"my_timeday_icon_video_prev%@",   fileSufix];
    UIImage *imageVideo=[UIImage imageNamed:filename];
    
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );
    
    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Apply supplied opacity if applicable
    [imageVideo drawInRect:CGRectMake((newSize.width - imageVideo.size.width) / 2, (newSize.height - imageVideo.size.height) / 2, imageVideo.size.width, imageVideo.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)saveButton {
    UIImage * image=[self addVideoIconToImage:thumpnilImageView.image];
    [moviePlayer stop];
    videoData= [NSData dataWithContentsOfURL:urlVideo options:0 error:NULL];
    thumbNail=[self generateThumbnilImage:urlVideo];
    
    [UserDataSingleton sharedSingleton].cameraVideo = videoData;
    [UserDataSingleton sharedSingleton].cameraPreview = image;
    [UserDataSingleton sharedSingleton].cameraImage  = image;
    [UserDataSingleton sharedSingleton].changed  = true;
    [self.delegate backButtonPress];
}

- (void)setVideo:(NSURL *)_urlVideo {
    [noneButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
    [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
    if(thumpnilImageView) {
        [thumpnilImageView removeFromSuperview];
        thumpnilImageView = nil;
        [playButton removeFromSuperview];
        playButton = nil;
    }
    urlVideo = _urlVideo;
    [moviePlayer setContentURL:urlVideo];
    UIImage *thumbnilImage = [self generateThumbnilImage:urlVideo];
    thumpnilImageView = [[UIImageView alloc] initWithFrame:moviePlayer.view.frame];
    [thumpnilImageView setImage:thumbnilImage];
    [self addSubview:thumpnilImageView];
    
    CGRect sizePlayButton;
    sizePlayButton.size.height = sizePlayButton.size.width = 40;
    sizePlayButton.origin.x = (moviePlayer.view.frame.size.width - sizePlayButton.size.width)/2;
    sizePlayButton.origin.y = (moviePlayer.view.frame.size.height - sizePlayButton.size.height)/2;
    
    playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [playButton setFrame:sizePlayButton];
    [playButton setBackgroundImage:[UIImage imageNamed:@"button_play2@2x~iphone.png"]
                          forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playVideo)
         forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playButton];
    [saveToGalleryButton setEnabled:YES];
}

- (void)videoThumbnailIsAvailable:(NSNotification *)paramNotification {
}

- (void)playVideo {
    [playButton setHidden:YES];
    [thumpnilImageView removeFromSuperview];
//    thumpnilImageView = nil;
    [moviePlayer play];
}

- (void)setPhoto:(UIImage *)image {
    [drawImageView setImage:image];
    [thumpnilImageView setImage:image];
    [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
    [drawButton setBackgroundImage:drawButtonDownImage forState:UIControlStateNormal];
}

@end
