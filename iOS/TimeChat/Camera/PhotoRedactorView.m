//
//  PhotoRedactorView.m
//  CameraEffectProject
//


#import "PhotoRedactorView.h"
#import "AHKActionSheet.h"
#import <StoreKit/SKProductsRequest.h>
#import <StoreKit/SKProduct.h>
#import <StoreKit/SKPaymentQueue.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <StoreKit/SKPayment.h>
#import "PurchaseViewController.h"

@implementation PhotoRedactorView {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *buttonColor;
    UIImage         *vintageButtonUpImage;
    UIImage         *vintageButtonDownImage;
    UIImage         *blackAndWhiteButtonUpImage;
    UIImage         *blackAndWhiteButtonDownImage;
    UIImage         *noneButtonUpImage;
    UIImage         *noneButtonDownImage;
    UIImage         *drawButtonUpImage;
    UIImage         *drawButtonDownImage;
    UIImage         *photoImage;
    UIImage         *photoWithEffectImage;
    UIImageView     *photoImageView;
    UIImageView     *bottomPanelBackgroundImageView;
    UIButton        *saveToGalleryButton;
    UIButton        *saveButton;
    UIButton        *noneButton;
    UIButton        *applyButton;
    UIButton        *vintageButton;
    UIButton        *drawButton;
    UIButton        *blackAndWhiteButton;
    NSString        *fileSufix;
    NSMutableData   *userData;
    Boolean         edited;
}

@synthesize delegate;

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (id)initWithFrame:(CGRect)frame andPhoto:(UIImage *)_photoImage
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        if ([SKPaymentQueue canMakePayments]) {
//            NSLog(@"Start Shop!");
//            
//            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//            
//            SKProductsRequest *productRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:@"com.wahid.timechat"]];
//            productRequest.delegate = self;
//            
//            [productRequest start];
//        }
//        else
//            NSLog(@"Failed Shop!");
        
        screenWidth = self.frame.size.width;
        screenHeight = self.frame.size.height;
        scale = [UserDataSingleton sharedSingleton].scale;
        keyboardHeight = [UserDataSingleton sharedSingleton].keyboardHeight;
        statusBarHeight = [UserDataSingleton sharedSingleton].statusBarHeight;
        font1 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize1];
        font2 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize2];
        font3 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize3];
        font4 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize4];
        font5 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize5];
        font6 = [UIFont systemFontOfSize:[UserDataSingleton sharedSingleton].textSize6];
        fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,  @".png"];
        
        NSString *str = [NSString stringWithFormat:@"%d", [UserDataSingleton sharedSingleton].numOfDesign];
        buttonColor = [[UserDataSingleton sharedSingleton].buttonColor objectForKey:str];        
        
        NSString *filename;
        UIImage *image;
        CGRect size;
        
        userData = [[NSMutableData alloc] init];
        edited=false;
        photoImage = _photoImage;
        CGRect sizeBottomPanelBackgroundImageView = frame;
        sizeBottomPanelBackgroundImageView.size.height = 85;
        sizeBottomPanelBackgroundImageView.origin.y = (frame.size.height -
                                                       2*sizeBottomPanelBackgroundImageView.size.height);
        bottomPanelBackgroundImageView = [[UIImageView alloc] initWithFrame:
                                          sizeBottomPanelBackgroundImageView];
        filename = [NSString stringWithFormat:@"main_background%@", fileSufix];
        [bottomPanelBackgroundImageView setBackgroundColor:[UIColor colorWithPatternImage:
          [UIImage imageNamed:filename]]];
        bottomPanelBackgroundImageView.userInteractionEnabled = YES;
        [self addSubview:bottomPanelBackgroundImageView];

        // photo image
        CGRect sizePhotoImageView = frame;
        sizePhotoImageView.origin.y = frame.origin.y / 2 + 5;
        //sizePhotoImageView.size.height -= sizeBottomPanelBackgroundImageView.size.height;
        sizePhotoImageView.size.height = screenHeight;
        photoImageView = [[UIImageView alloc] initWithFrame:sizePhotoImageView];
        [photoImageView setImage:photoImage];
        photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:photoImageView];
        
        // save to gallery button
        heightSpace = 20 * scale;
        widthSpace = 18 * scale;
        filename = [NSString stringWithFormat:@"take_photo_blue%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.size.width = image.size.width * scale;
        size.size.height= image.size.height * scale;
        size.origin.y = screenHeight - size.size.height - heightSpace;
        size.origin.x = (screenWidth - size.size.width * 2 - widthSpace) / 2;
        saveToGalleryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveToGalleryButton setFrame:size];
        [saveToGalleryButton setBackgroundImage:image forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"take_photo_blue_down%@", fileSufix];
        [saveToGalleryButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [saveToGalleryButton setTitle:@"Save to gallery" forState:UIControlStateNormal];
        [saveToGalleryButton.titleLabel setFont:font3];
        [saveToGalleryButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [saveToGalleryButton addTarget:self action:@selector(savePhotoToGallery) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:saveToGalleryButton]; 
        
        // save button
        filename = [NSString stringWithFormat:@"take_photo_red%@", fileSufix];
        image = [UIImage imageNamed:filename];
        size.origin.x  = screenWidth - saveToGalleryButton.frame.origin.x - size.size.width;
        saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [saveButton addTarget:self action:@selector(saveButton) forControlEvents:UIControlEventTouchUpInside];
        [saveButton setFrame:size];
        [saveButton setBackgroundImage:image forState:UIControlStateNormal];
        filename = [NSString stringWithFormat:@"take_photo_red_down%@", fileSufix];
        [saveButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [saveButton setTitle:@"Save" forState:UIControlStateNormal];
        [saveButton.titleLabel setFont:font3];
        [saveButton setTitleColor:buttonColor forState:UIControlStateNormal];
        [self addSubview:saveButton];
        
        filename = [NSString stringWithFormat:@"video_none%@", fileSufix];
        noneButtonUpImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"apply_vintage%@", fileSufix];
        vintageButtonDownImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"apply_vintage%@", fileSufix];
        vintageButtonUpImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"apply_BL%@", fileSufix];
        blackAndWhiteButtonDownImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"apply_BL&white_disabled%@", fileSufix];
        blackAndWhiteButtonUpImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"apply_draw%@", fileSufix];
        drawButtonDownImage = [UIImage imageNamed:filename];
        
        filename = [NSString stringWithFormat:@"apply_draw%@", fileSufix];
        drawButtonUpImage = [UIImage imageNamed:filename];
        
        // apply button
        heightSpace = 260 * scale;
        filename =[NSString stringWithFormat:@"video_none%@", fileSufix];
        noneButtonDownImage = [UIImage imageNamed:filename];
        size.size.height = noneButtonDownImage.size.height * scale;
        size.size.width = noneButtonDownImage.size.width * scale;
        size.origin.y = screenHeight - heightSpace;
        size.origin.x = (screenWidth - size.size.width) / 2;
        applyButton = [[UIButton alloc] initWithFrame:size];
        [applyButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
        filename =[NSString stringWithFormat:@"video_none_down%@", fileSufix];
        [applyButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
        [applyButton addTarget:self action:@selector(applyClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:applyButton];
        
        // apply label
        heightSpace = 166 * scale;
        size.size = [@"Apply" sizeWithAttributes:@{NSFontAttributeName:font5}];
        size.origin.x = (screenWidth - size.size.width) / 2;
        size.origin.y = screenHeight - heightSpace;
        UILabel *applyLabel = [[UILabel alloc] initWithFrame:size];
        [applyLabel setText:@"Apply"];
        [applyLabel setTextAlignment:NSTextAlignmentCenter];
        [applyLabel setTextColor:[UIColor colorWithRed:103 green:53 blue:83 alpha:1]];
        [applyLabel setFont:font5];
        [applyLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:applyLabel];
    }
    return self;
}

- (void)clickDraw {
    [delegate drawPhoto:photoImageView.image];
}

- (void)savePhotoToGallery {
    
    SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
    UIImageWriteToSavedPhotosAlbum(photoImageView.image, self, selectorToCall, NULL);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex]) {
        [delegate clickPurchase];
    }else{
        
    }
}

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
- (UIImage *)rotateImage:(UIImage*)image byDegree:(CGFloat)degrees
{
    float newSide = MAX([image size].width/2, [image size].height/2);
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,newSide, newSide)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_RADIANS(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    //[rotatedViewBox release];
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(bitmap, rotatedSize.height, rotatedSize.width);
    
    CGContextRotateCTM(bitmap, DEGREES_RADIANS(degrees));
    
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width/2 , -image.size.height/2, image.size.height/2, image.size.width/2), [image CGImage]);
    
    
  
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

#define DEGREES_RADIANS(angle) ((angle) / 180.0 * M_PI)
- (UIImage *)rotateImage1:(UIImage*)image byDegree:(CGFloat)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width/2, image.size.height/2)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DEGREES_RADIANS(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    //[rotatedViewBox release];
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(bitmap, rotatedSize.height, rotatedSize.width);
    
    CGContextRotateCTM(bitmap, DEGREES_RADIANS(degrees));
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width/3 , -image.size.height/2, image.size.height/2, image.size.width/2), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}


- (UIImage *)rotateImage:(UIImage *)image onDegrees:(float)degrees
{
    CGFloat rads = M_PI * degrees / 180;
    float newSide = MAX([image size].width, [image size].height);
    CGSize size =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, newSide, newSide);
    CGContextRotateCTM(ctx, rads);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-[image size].width/2,-[image size].height/2,size.width, size.height),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

- (UIImage *)rotateImage1:(UIImage *)image onDegrees:(float)degrees
{
    CGFloat rads = M_PI * degrees / 180;
    float newSide = MAX([image size].width, [image size].height);
    CGSize size =  CGSizeMake(newSide, newSide);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, newSide/2, newSide/2);
    CGContextRotateCTM(ctx, rads);
    CGContextScaleCTM(ctx, 1.0, -1.0);

    CGContextDrawImage(UIGraphicsGetCurrentContext(),CGRectMake(-[image size].width/2,-[image size].height/2,size.width, size.height),image.CGImage);
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}



- (UIImage *)mergeImage:(UIImage*)bottomImage {

//UIImage *bottomImage = [UIImage imageNamed:@"bottom.png"]; //background image
//UIImage *image       = [UIImage imageNamed:@"top.png"]; //foreground image
    NSString *filename=[NSString stringWithFormat:@"my_timeday_icon_video_prev%@",   fileSufix];
    UIImage *imageVideo=[UIImage imageNamed:filename];
   
    CGSize newSize = CGSizeMake(bottomImage.size.width, bottomImage.size.height);
    UIGraphicsBeginImageContext( newSize );

    // Use existing opacity as is
    [bottomImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];

    // Apply supplied opacity if applicable
    [imageVideo drawInRect:CGRectMake(newSize.width*0.43,newSize.height*0.43,imageVideo.size.width*5.9933,imageVideo.size.height*5.9933) blendMode:kCGBlendModeNormal alpha:1.0];

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return newImage;
}

- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage*)imageCrop:(UIImage*)original
{
    // This calculates the crop area.
//    UIImage *ret;
    float originalWidth  = original.size.width;
    float originalHeight = original.size.height;
    
    float edge = fminf(originalWidth, originalHeight);
    
    float posX = (originalWidth   - edge) / 2.0f;
    float posY = (originalHeight  - edge) / 2.0f;
    
    
    CGRect cropSquare = CGRectMake(posX, posY,
                                   edge, edge);
    
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    
//    ret = [UIImage imageWithCGImage:imageRef
//                              scale:original.scale
//                        orientation:original.imageOrientation];
    UIImage* uiImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    
    return uiImage;
}

- (void)saveButton {
    UIImage *image = photoImageView.image;
    CGSize newSize = CGSizeMake(image.size.width / 2, image.size.height / 2);
    [UserDataSingleton sharedSingleton].cameraImage = [self imageWithImage:image scaledToSize:newSize];
    [UserDataSingleton sharedSingleton].cameraPreview = [self imageCrop:image];
    [UserDataSingleton sharedSingleton].changed = true;
    [self.delegate backButtonPress];
}

- (void)imageWasSavedSuccessfully:(UIImage *)paramImage
         didFinishSavingWithError:(NSError *)paramError
                      contextInfo:(void *)paramContextInfo {
    if(paramError == nil) {
        NSLog(@"Image was saved succesfully");
        [saveToGalleryButton setEnabled:NO];
    } else {
        NSLog(@"An error happened while saving the image");
        NSLog(@"Error = %@", paramError);
    }
}

- (void)setPhoto:(UIImage *)_photoImage andSave:(BOOL)save {
    [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
    [vintageButton setBackgroundImage:vintageButtonUpImage forState:UIControlStateNormal];
    if(save) {
        photoImage = _photoImage;
        [noneButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
        [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
    } else {
        [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
        [drawButton setBackgroundImage:drawButtonDownImage forState:UIControlStateNormal];
    }
    //_photoImage=[self rotateImage:_photoImage byDegree:90];
    edited = true;
    
    [photoImageView setImage:_photoImage];
    [saveToGalleryButton setEnabled:YES];
}

- (void)blackAndWhiteClick {
    [photoImageView setImage:[self imageBlackAndWhite]];
    [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonDownImage forState:UIControlStateNormal];
    [vintageButton setBackgroundImage:vintageButtonUpImage forState:UIControlStateNormal];
    [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
    [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
}

- (void)applyClick {
    AHKActionSheet *actionSheet = [[AHKActionSheet alloc] initWithTitle:	NSLocalizedString(@"", nil)];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"None", nil)
                              image:noneButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [photoImageView setImage:photoImage];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonUpImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue1", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [self imageHue1];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];

    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue2", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
//                                [photoImageView setImage:[self imageHue2]];
                                [self imageHue2];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];


    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue3", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
//                                [photoImageView setImage:[self imageHue3]];
                                [self imageHue3];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];

    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue4", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //                                [photoImageView setImage:[self imageHue3]];
                                [self imageHue4];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue5", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //                                [photoImageView setImage:[self imageHue3]];
                                [self imageHue5];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue6", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //                                [photoImageView setImage:[self imageHue3]];
                                [self imageHue6];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Hue7", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                //                                [photoImageView setImage:[self imageHue3]];
                                [self imageHue7];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Vintage", nil)
                              image:vintageButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [photoImageView setImage:[self imageVintage]];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"B & L", nil)
                              image:blackAndWhiteButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [photoImageView setImage:[self imageBlackAndWhite]];
                                [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonDownImage forState:UIControlStateNormal];
                                [vintageButton setBackgroundImage:vintageButtonUpImage forState:UIControlStateNormal];
                                [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
                                [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
                            }];
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"Draw", nil)
                              image:drawButtonDownImage
                               type:AHKActionSheetButtonTypeDefault
                            handler:^(AHKActionSheet *as) {
                                [delegate drawPhoto:photoImageView.image];
                            }];
    
    [actionSheet show];
}

- (void)noneClick {
    [photoImageView setImage:photoImage];
    [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
    [vintageButton setBackgroundImage:vintageButtonUpImage forState:UIControlStateNormal];
    [noneButton setBackgroundImage:noneButtonDownImage forState:UIControlStateNormal];
    [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
}

- (void)vintageClick {
    [photoImageView setImage:[self imageVintage]];
    [blackAndWhiteButton setBackgroundImage:blackAndWhiteButtonUpImage forState:UIControlStateNormal];
    [vintageButton setBackgroundImage:vintageButtonDownImage forState:UIControlStateNormal];
    [noneButton setBackgroundImage:noneButtonUpImage forState:UIControlStateNormal];
    [drawButton setBackgroundImage:drawButtonUpImage forState:UIControlStateNormal];
}

- (UIImage *)imageBlackAndWhite
{
    CIImage *beginImage = [CIImage imageWithCGImage:photoImage.CGImage];
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey,
                              beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0],
                              @"inputContrast", [NSNumber numberWithFloat:1.1],
                              @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust"   keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV",
                       [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
    CGFloat originalScale = photoImageView.image.scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:originalScale  orientation:originalOrientation];
    context=nil;
    CGImageRelease(cgiimage);
    output=nil;
    cgiimage=nil;
    return newImage;
}

- (UIImage *)imageVintage
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"
                                  keysAndValues:kCIInputImageKey, image, nil];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
    CGFloat originalScale = photoImageView.image.scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                      orientation:originalOrientation];
    
    context=nil;
    CGImageRelease(cgImage);
    cgImage=nil;
    return newImage;
}

- (void) restoreTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStateRestored");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStateFailed");
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
- (void) completeTransaction: (SKPaymentTransaction *)transaction
{
    NSLog(@"SKPaymentTransactionStatePurchased");
    
    NSLog(@"Trasaction Identifier : %@", transaction.transactionIdentifier);
    NSLog(@"Trasaction Date : %@", transaction.transactionDate);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [photoImageView setImage:[self imageHue1_purchased]];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse*)response {
    NSLog(@"SKProductRequest got response");
    if( [response.products count] > 0 ) {
        SKProduct *product = [response.products objectAtIndex:0];
        NSLog(@"Title : %@", product.localizedTitle);
        NSLog(@"Description : %@", product.localizedDescription);
        NSLog(@"Price : %@", product.price);
    }
    
    if( [response.invalidProductIdentifiers count] > 0 ) {
        NSString *invalidString = [response.invalidProductIdentifiers objectAtIndex:0];
        NSLog(@"Invalid Identifiers : %@", invalidString);
    }
}

- (UIImage *)imageHue1_purchased
{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                      keysAndValues:kCIInputImageKey, image, nil];
    
        [filter setValue:[NSNumber numberWithFloat:-2.0f] forKey:@"inputAngle"];
    
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGRect extent = [result extent];
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];
        UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
        CGFloat originalScale = photoImageView.image.scale;
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                          orientation:originalOrientation];
    
        context=nil;
        CGImageRelease(cgImage);
        cgImage=nil;
        return newImage;
}

- (UIImage *)imageHue2_purchased
{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                      keysAndValues:kCIInputImageKey, image, nil];
    
        [filter setValue:[NSNumber numberWithFloat:1.0f] forKey:@"inputAngle"];
    
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGRect extent = [result extent];
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];
        UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
        CGFloat originalScale = photoImageView.image.scale;
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                          orientation:originalOrientation];
    
        context=nil;
        CGImageRelease(cgImage);
        cgImage=nil;
        return newImage;
}

- (UIImage *)imageHue3_purchased
{
        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
        CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                      keysAndValues:kCIInputImageKey, image, nil];
    
        [filter setValue:[NSNumber numberWithFloat:2.0f] forKey:@"inputAngle"];
    
        CIImage *result = [filter valueForKey:kCIOutputImageKey];
        CGRect extent = [result extent];
        CGImageRef cgImage = [context createCGImage:result fromRect:extent];
        UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
        CGFloat originalScale = photoImageView.image.scale;
        UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                          orientation:originalOrientation];
    
        context=nil;
        CGImageRelease(cgImage);
        cgImage=nil;
        return newImage;
}

- (UIImage *)imageHue4_purchased
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                  keysAndValues:kCIInputImageKey, image, nil];
    
    [filter setValue:[NSNumber numberWithFloat:3.0f] forKey:@"inputAngle"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
    CGFloat originalScale = photoImageView.image.scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                      orientation:originalOrientation];
    
    context=nil;
    CGImageRelease(cgImage);
    cgImage=nil;
    return newImage;
}

- (UIImage *)imageHue5_purchased
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                  keysAndValues:kCIInputImageKey, image, nil];
    
    [filter setValue:[NSNumber numberWithFloat:4.0f] forKey:@"inputAngle"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
    CGFloat originalScale = photoImageView.image.scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                      orientation:originalOrientation];
    
    context=nil;
    CGImageRelease(cgImage);
    cgImage=nil;
    return newImage;
}

- (UIImage *)imageHue6_purchased
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                  keysAndValues:kCIInputImageKey, image, nil];
    
    [filter setValue:[NSNumber numberWithFloat:5.0f] forKey:@"inputAngle"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
    CGFloat originalScale = photoImageView.image.scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                      orientation:originalOrientation];
    
    context=nil;
    CGImageRelease(cgImage);
    cgImage=nil;
    return newImage;
}

- (UIImage *)imageHue7_purchased
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:photoImage.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"
                                  keysAndValues:kCIInputImageKey, image, nil];
    
    [filter setValue:[NSNumber numberWithFloat:6.0f] forKey:@"inputAngle"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    UIImageOrientation originalOrientation = photoImageView.image.imageOrientation;
    CGFloat originalScale = photoImageView.image.scale;
    UIImage *newImage = [UIImage imageWithCGImage:cgImage scale:originalScale
                                      orientation:originalOrientation];
    
    context=nil;
    CGImageRelease(cgImage);
    cgImage=nil;
    return newImage;
}

- (void)imageHue1
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 1;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue1_purchased]];
    }
//    SKPayment *payment = [SKPayment paymentWithProduct:@"com.wahid.timechat"];
//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)imageHue2
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 2;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue2_purchased]];
    }
}

- (void)imageHue3
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 3;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue3_purchased]];
    }
}

- (void)imageHue4
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 4;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue4_purchased]];
    }
}

- (void)imageHue5
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 4;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue5_purchased]];
    }
}
- (void)imageHue6
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 4;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue6_purchased]];
    }
}
- (void)imageHue7
{
    if (![[UserDataSingleton sharedSingleton].userDefaults objectForKey:@"unlocked"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Effects are locked. Will you unlock effects?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"CANCEL", nil];
        alert.tag = 4;
        alert.delegate = self;
        [alert show];
    } else {
        [photoImageView setImage:[self imageHue7_purchased]];
    }
}

- (void)dealloc {
    photoImage = nil;
    photoWithEffectImage = nil;
    photoImageView = nil;
    bottomPanelBackgroundImageView = nil;
    userData = nil;
}

@end
