//
//  TakePhotoViewController.m
//  TimeChat
//


#import "TakePhotoViewController.h"
#import "AppDelegate.h"

@interface TakePhotoViewController () {
    UIImageView *imageView;
}

@end

@implementation TakePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 30.0;
    opacity = 1.0;
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blackColor]];
    [button setFrame:CGRectMake(10, 100, 100, 50)];
    [button setTitle:@"Takephoto" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateApplication];
    [self.view addSubview:button];
    
    UIButton *buttonG = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonG setBackgroundColor:[UIColor blackColor]];
    [buttonG setFrame:CGRectMake(120, 100, 100, 50)];
    [buttonG setTitle:@"Fromgallery" forState:UIControlStateNormal];
    [buttonG addTarget:self action:@selector(buttonClickG) forControlEvents:UIControlEventTouchUpInside];
    [buttonG setTitleColor:[UIColor whiteColor] forState:UIControlStateApplication];
    [self.view addSubview:buttonG];
  
    
    UIButton *buttonS = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonS setBackgroundColor:[UIColor blackColor]];
    [buttonS setFrame:CGRectMake(240, 100, 100, 50)];
    [buttonS setTitle:@"Save" forState:UIControlStateNormal];
    [buttonS addTarget:self action:@selector(buttonClickS) forControlEvents:UIControlEventTouchUpInside];
    [buttonS setTitleColor:[UIColor whiteColor] forState:UIControlStateApplication];
    [self.view addSubview:buttonS];
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 200, self.view.frame.size.width - 40,
                                                              300)];
    [self.view addSubview:imageView];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundColor:[UIColor blackColor]];
    [button2 setFrame:CGRectMake(10, 30, 100, 50)];
    [button2 setTitle:@"Black \nand white" forState:UIControlStateNormal];
    button2.titleLabel.numberOfLines = 2;
    [button2 addTarget:self action:@selector(buttonBlackAndWhiteClick) forControlEvents:UIControlEventTouchUpInside];
    [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateApplication];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setBackgroundColor:[UIColor blackColor]];
    [button3 setFrame:CGRectMake(120, 30, 100, 50)];
    [button3 setTitle:@"Vintage" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(buttonVintageClick) forControlEvents:UIControlEventTouchUpInside];
    [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateApplication];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setBackgroundColor:[UIColor blackColor]];
    [button4 setFrame:CGRectMake(230, 30, 100, 50)];
    [button4 setTitle:@"Green" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonGreenClick) forControlEvents:UIControlEventTouchUpInside];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateApplication];
    [self.view addSubview:button4];
}

- (void)buttonGreenClick {
    imageView.image = [self imageGreen];
}


- (void)buttonVintageClick {
    imageView.image = [self imageVintage];
}

- (void)buttonBlackAndWhiteClick {
    imageView.image = [self imageBlackAndWhite];
}

- (void)buttonClick{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes =
    @[(NSString *) kUTTypeImage,
      (NSString *) kUTTypeMovie];
    
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSLog(@"Picker returned successfully");
    NSLog(@"%@", info);
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if([mediaType isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *theImage = nil;
        if([picker allowsEditing]) {
            theImage = [info objectForKey:UIImagePickerControllerEditedImage];
        } else {
            theImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        [imageView setImage:theImage];
        [UserDataSingleton sharedSingleton].cameraImage=theImage;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonClickS  {
     [self dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------

- (void)buttonClickG{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.popover = [[UIPopoverController alloc] initWithContentViewController:picker];
        [self.popover presentPopoverFromRect:CGRectMake(00, 1000, 1, 1) inView:self.view
                    permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self.popover setPopoverContentSize:CGSizeMake(700, 1000)];
    }else{
        [self presentViewController:picker animated:YES completion:NULL];
    }
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController__:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosen = info[UIImagePickerControllerEditedImage  ];//info[UIImagePickerControllerOriginalImage];
    
    float scale=800/chosen.size.width;
    if(chosen.size.height*scale>1250) scale=1250/chosen.size.height;
/*
    
    chosenImage =[self resizeImage:chosen newSize:CGSizeMake(chosen.size.width*scale, chosen.size.height*scale)  ];
    float xxx=390; if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
        xxx=propo*self.imageView.bounds.size.height; //xxx=self.imageView.bounds.size.width;
    
    CGRect frame = CGRectMake(self.imageView.bounds.origin.x,  self.imageView.bounds.origin.y,
                              xxx,                             self.imageView.bounds.size.height);
    
    [self.imageView setBounds:frame ];
    
    [self.imageView setImage:chosenImage ];
    self.SelectImageButton.hidden=true;
    self.TakePhotoButton.hidden=true;
    placeLips = true;
    
    
    isDefaultImage=false;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    self.lipsMakeUpUIView.hidden=true;
    [NSTimer scheduledTimerWithTimeInterval: 1.0f target:self selector:@selector(startPlacing) userInfo:nil repeats:NO];
    
   // faceImage = chosenImage;
  */
}

- (UIImage*)resizeImage:(UIImage*)image   newSize:(CGSize)newSize{
    [self.popover dismissPopoverAnimated:YES];
    UIGraphicsBeginImageContext( newSize );
    [image    drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
   NSLog(@"Picker was cancelled");
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

//------------------------------------------



- (UIImage *)imageBlackAndWhite
{
    CIImage *beginImage = [CIImage imageWithCGImage:imageView.image.CGImage];
    
    CIImage *blackAndWhite = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputImageKey, beginImage, @"inputBrightness", [NSNumber numberWithFloat:0.0], @"inputContrast", [NSNumber numberWithFloat:1.1], @"inputSaturation", [NSNumber numberWithFloat:0.0], nil].outputImage;
    CIImage *output = [CIFilter filterWithName:@"CIExposureAdjust" keysAndValues:kCIInputImageKey, blackAndWhite, @"inputEV", [NSNumber numberWithFloat:0.7], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    
    CGImageRelease(cgiimage);
    
    return newImage;
}

- (UIImage *)imageVintage
{
    CIContext *context = [CIContext contextWithOptions:nil];               // 1
    CIImage *image = [CIImage imageWithCGImage:imageView.image.CGImage];               // 2
    //CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];           // 3
    CIFilter *filter = [CIFilter filterWithName: @"CIPhotoEffectInstant" keysAndValues: kCIInputImageKey, image, nil];           // 3
    
    //CIFilter *filter = [CIFilter filterWithName: @"CISmoothLinearGradient"];           // 3
    //[filter setValue:image forKey:kCIInputImageKey];
    //[filter setValue:@0.2f forKey:kCIInputIntensityKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return newImage;
}

- (UIImage *)imageGreen
{
//    CIContext *context = [CIContext contextWithOptions:nil];               // 1
//    CIImage *image = [CIImage imageWithCGImage:imageView.image.CGImage];               // 2
//    //CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];           // 3
//    CIFilter *filter = [CIFilter filterWithName: @"CIPhotoEffectInstant" keysAndValues: kCIInputImageKey, image, nil];           // 3
//    
//    //CIFilter *filter = [CIFilter filterWithName: @"CISmoothLinearGradient"];           // 3
//    //[filter setValue:image forKey:kCIInputImageKey];
//    //[filter setValue:@0.2f forKey:kCIInputIntensityKey];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];              // 4
//    CGRect extent = [result extent];
//    CGImageRef cgImage = [context createCGImage:result fromRect:extent];
//    
//    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
//    
//    CGImageRelease(cgImage);
//    
//    return newImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *image = [CIImage imageWithCGImage:imageView.image.CGImage];
    CIFilter *filter = [CIFilter filterWithName: @"CIHueAdjust" keysAndValues: kCIInputImageKey, image, nil];
    
    [filter setValue:[NSNumber numberWithFloat:2.0f] forKey:@"inputAngle"];
    
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    CGRect extent = [result extent];
    CGImageRef cgImage = [context createCGImage:result fromRect:extent];

    UIImage *newImage = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);

    return newImage;
}

- (void)imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError
                      contextInfo:(void *)paramContextInfo {
    if(paramError == nil) {
        NSLog(@"Image was saved succesfully.");
        
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
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock:^(id object, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)object;
        if([mediaType isEqualToString:paramMediaType]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}

- (void)touchesBegan:(NSSet  *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    
    lastPoint = [touch locationInView:imageView];
    NSLog(@"%fx%f", lastPoint.x, lastPoint.y);
}

- (void)touchesMoved:(NSSet  *)touches withEvent:(UIEvent *)event {
    if(lastPoint.x > 0 && lastPoint.y > 0) {
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:imageView];
        
        UIGraphicsBeginImageContext(imageView.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0,
                                               imageView.frame.size.width, imageView.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [imageView setAlpha:opacity];
        UIGraphicsEndImageContext();
        
        lastPoint = currentPoint;
    }
}

- (void)touchesEnded:(NSSet  *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    /*UIGraphicsBeginImageContext(self.mainImage.frame.size);
     [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
     [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
     self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
     self.tempDrawImage.image = nil;
     UIGraphicsEndImageContext();
     */
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
