//
//  VideoDrawViewController.m
//  TimeChat
//


#import "VideoDrawViewController.h"

@interface VideoDrawViewController () {
    float           screenWidth, screenHeight, scale, heightSpace, widthSpace;
    float           keyboardHeight,statusBarHeight;
    UIFont          *font1, *font2, *font3, *font4, *font5, *font6;
    UIColor         *buttonColor;
    NSURL           *videoUrl;
    UIImageView     *drawView;
    NSMutableArray  *drawImageArray;
    BOOL            eraserState;
    BOOL            mouseSwiped;
    CGPoint         lastPoint;
    UIColor         *drawColor;
    CGFloat         brush;
    CGFloat         size;
    UIButton        *pencilButton;
    UIButton        *brushButton;
    UIButton        *eraserButton;
    BOOL            instrument;
    UIImage         *pencilUpImage;
    UIImage         *brushUpImage;
    UIImage         *eraserUpImage;
    UIImage         *pencilDownImage;
    UIImage         *brushDownImage;
    UIImage         *eraserDownImage;
    UIImageView     *colorSizePanelImageView;
    UIButton        *sizeButton;
    UIButton        *colorButton;
    UIImageView     *sizeImageView;
    UIImageView     *colorPickerImageView;
    BOOL            pickerColor;
    UIImageView     *selectImageView;
    UIButton        *bigSizeButton;
    UIButton        *mediumSizeButton;
    UIButton        *smallSizeButton;
    UIImage         *smallSizeUpImage;
    UIImage         *mediumSizeUpImage;
    UIImage         *bigSizeUpImage;
    UIImage         *smallSizeDownImage;
    UIImage         *mediumSizeDownImage;
    UIImage         *bigSizeDownImage;
    UIImageView     *selectedSizeImageView;
    UIButton        *playButton;
    UIImageView     *thumpnilImageView;
    MPMoviePlayerController *moviePlayer;
    UIImage         *thumbNail;
    dispatch_queue_t concurrentQueue;
    dispatch_group_t taskGroup;
    NSString        *fileSufix;
    UIButton        *acceptColorPickerButton;
    //////////////
    bool            is_text;
    CGRect sizeTextField;
    UIColor         *inputTextColor;
    NSMutableArray  *textAry;
    int             aryCount;
    UITextField * InputTextField;
}

@end

@implementation VideoDrawViewController

@synthesize delegate;

- (id)initWithVideo:(NSURL *)_videoUrl
{
    self = [super init];
    if (self) {
        
        concurrentQueue = dispatch_get_main_queue();
        taskGroup = dispatch_group_create();
        videoUrl = _videoUrl;
        instrument = NO;
        aryCount   = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    is_text = false;
    
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
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

    drawColor = [UIColor whiteColor];
    inputTextColor = drawColor;
    drawImageArray = [[NSMutableArray alloc] init];
    textAry = [[NSMutableArray alloc] init];
    
    NSString *filename;
    UIImage *image;
    
    filename = @"draw_t2.png";//[NSString stringWithFormat:@"draw_pen%@", fileSufix];
    pencilUpImage   = [UIImage imageNamed:filename];
    filename = @"draw_t1.png";
    pencilDownImage = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"draw_brush%@", fileSufix];
    brushUpImage    = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_brush_selected%@", fileSufix];
    brushDownImage  = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"draw_eraser%@", fileSufix];
    eraserUpImage   = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_eraser_selected%@", fileSufix];
    eraserDownImage = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"draw_size_small%@", fileSufix];
    smallSizeUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_size_small_selected%@", fileSufix];
    smallSizeDownImage = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"draw_size_medium%@", fileSufix];
    mediumSizeUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_size_medium_selected%@", fileSufix];
    mediumSizeDownImage = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"draw_size_big%@", fileSufix];
    bigSizeUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_size_big_selected%@", fileSufix];
    bigSizeDownImage = [UIImage imageNamed:filename];
    
    // moviePlayer
    heightSpace = 116 * scale;
    CGRect sizePlayerView = self.view.frame;
    sizePlayerView.origin.x = sizePlayerView.origin.y = 0;
    sizePlayerView.size.height = self.view.frame.size.height;
    
    moviePlayer = [[MPMoviePlayerController alloc] init];
    [moviePlayer setContentURL:videoUrl];
    [moviePlayer.view setFrame:sizePlayerView];
    moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
    [self.view addSubview:moviePlayer.view];
    
    UIImage *thumbnilImage = [self generateThumbnilImage:videoUrl];
    thumpnilImageView = [[UIImageView alloc] initWithFrame:sizePlayerView];
    [thumpnilImageView setImage:thumbnilImage];
    [self.view addSubview:thumpnilImageView];
    
    drawView = [[UIImageView alloc] initWithFrame:thumpnilImageView.frame];
    [self.view addSubview:drawView];
    
    // playButton
    heightSpace = 400 * scale;
    filename = [NSString stringWithFormat:@"video_play%@", fileSufix];
    image = [UIImage imageNamed:filename];
    CGRect sizePlayButton = sizePlayerView;
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
//    [self.view addSubview:playButton];

    // Cancel Button
    widthSpace = 20 * scale;
    heightSpace = 20 * scale;
    filename = [NSString stringWithFormat:@"take_photo_blue%@", fileSufix];
    image = [UIImage imageNamed:filename];
    CGRect sizeCancelButton;
    sizeCancelButton.size.width = image.size.width * scale;
    sizeCancelButton.size.height = image.size.height * scale;
    sizeCancelButton.origin.x = (screenWidth - sizeCancelButton.size.width * 2 - widthSpace) / 2;
    sizeCancelButton.origin.y = screenHeight - heightSpace - sizeCancelButton.size.height;
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:sizeCancelButton];
    [cancelButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"take_photo_blue_down%@", fileSufix];
    [cancelButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    // Save Button
    filename = [NSString stringWithFormat:@"take_photo_red%@", fileSufix];
    image = [UIImage imageNamed:filename];
    sizeCancelButton.origin.x = screenWidth - cancelButton.frame.origin.x - cancelButton.frame.size.width;
    UIButton *saveButton = [[UIButton alloc] initWithFrame:sizeCancelButton];
    [saveButton setBackgroundImage:image forState:UIControlStateNormal];
    filename = [NSString stringWithFormat:@"take_photo_red_down%@", fileSufix];
    [saveButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateHighlighted];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(clickSaveButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    // Pencil Button
    heightSpace = 135 * scale;
    CGRect sizePencilButton;
    sizePencilButton.size.width = pencilUpImage.size.width * scale;
    sizePencilButton.size.height = pencilUpImage.size.height * scale;
    sizePencilButton.origin.y = screenHeight - heightSpace - sizePencilButton.size.height;
    widthSpace = (screenWidth - sizePencilButton.size.width * 3) / 4;
    sizePencilButton.origin.x = widthSpace;
    pencilButton = [[UIButton alloc] initWithFrame:sizePencilButton];
    [pencilButton setBackgroundImage:pencilUpImage forState:UIControlStateNormal];
    [pencilButton addTarget:self action:@selector(clickTextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pencilButton];
    
    // Brush Button
    sizePencilButton.origin.x += sizePencilButton.size.width + widthSpace;
    brushButton = [[UIButton alloc] initWithFrame:sizePencilButton];
    [brushButton setBackgroundImage:brushUpImage forState:UIControlStateNormal];
    [brushButton addTarget:self action:@selector(clickBrushButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:brushButton];
    
    // Eraser Button
    sizePencilButton.origin.x += sizePencilButton.size.width + widthSpace;
    eraserButton = [[UIButton alloc] initWithFrame:sizePencilButton];
    [eraserButton setBackgroundImage:eraserUpImage forState:UIControlStateNormal];
    [eraserButton addTarget:self action:@selector(clickEraserButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraserButton];
    
    // colorsize panel
    heightSpace = 116 * scale;
    filename = [NSString stringWithFormat:@"draw_colorsize_panel%@", fileSufix];
    UIImage *colorsizePanelImage = [UIImage imageNamed:filename];
    CGRect sizeColorSizePanelImageView;
    sizeColorSizePanelImageView.size.height = colorsizePanelImage.size.height * scale;
    sizeColorSizePanelImageView.size.width = colorsizePanelImage.size.width * scale;
    sizeColorSizePanelImageView.origin.x = self.view.frame.size.width - sizeColorSizePanelImageView.size.width;
    sizeColorSizePanelImageView.origin.y = heightSpace;
    colorSizePanelImageView = [[UIImageView alloc] initWithFrame:sizeColorSizePanelImageView];
    [colorSizePanelImageView setImage:colorsizePanelImage];
    [self.view addSubview:colorSizePanelImageView];
    
    // Color Label
    heightSpace = 70 * scale;
    CGRect sizeColorLabel;
    sizeColorLabel.size = [@"Color" sizeWithAttributes:@{NSFontAttributeName:font5}];
    sizeColorLabel.origin.y = heightSpace;
    sizeColorLabel.origin.x = (colorSizePanelImageView.frame.size.width - sizeColorLabel.size.width) / 2;
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:sizeColorLabel];
    [colorLabel setText:@"Color"];
    [colorLabel setTextAlignment:NSTextAlignmentCenter];
    [colorLabel setTextColor:[UIColor whiteColor]];
    [colorLabel setFont:font5];
    [colorLabel setBackgroundColor:[UIColor clearColor]];
    [colorSizePanelImageView addSubview:colorLabel];
    
    // Color Button
    heightSpace = 20 * scale;
    CGRect sizeColorButton;
    sizeColorButton.size.width = 50 * scale;
    sizeColorButton.size.height = 50 * scale;
    sizeColorButton.origin.y = heightSpace;
    sizeColorButton.origin.x = (sizeColorSizePanelImageView.size.width - sizeColorButton.size.width) / 2;
    
    colorButton = [[UIButton alloc] initWithFrame:sizeColorButton];
    [colorButton setBackgroundColor:drawColor];
    [colorButton addTarget:self action:@selector(clickColorButton) forControlEvents:UIControlEventTouchUpInside];
    [colorSizePanelImageView addSubview:colorButton];
    
    // Size Label
    heightSpace = 5 * scale;
    CGRect sizeSizeLabel;
    sizeSizeLabel.size = [@"Size" sizeWithAttributes:@{NSFontAttributeName:font5}];
    sizeSizeLabel.origin.y = sizeColorSizePanelImageView.size.height - sizeSizeLabel.size.height -heightSpace;
    sizeSizeLabel.origin.x = (sizeColorSizePanelImageView.size.width - sizeSizeLabel.size.width) / 2;
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:sizeSizeLabel];
    [sizeLabel setText:@"Size"];
    [sizeLabel setTextAlignment:NSTextAlignmentCenter];
    [sizeLabel setTextColor:[UIColor whiteColor]];
    [sizeLabel setFont:font5];
    [sizeLabel setBackgroundColor:[UIColor clearColor]];
    [colorSizePanelImageView addSubview:sizeLabel];
    
    // Size Image
    heightSpace = 120 * scale;
    CGRect sizeSizeImage;
    sizeSizeImage.size.height = smallSizeDownImage.size.height * scale;
    sizeSizeImage.size.width = smallSizeDownImage.size.width * scale;
    sizeSizeImage.origin.x = (sizeColorSizePanelImageView.size.width - sizeSizeImage.size.width) / 2;
    sizeSizeImage.origin.y = heightSpace;
    selectedSizeImageView = [[UIImageView alloc] initWithFrame:sizeSizeImage];
    [selectedSizeImageView setImage:smallSizeDownImage];
    [colorSizePanelImageView addSubview:selectedSizeImageView];
    
    size = 1;
    [colorSizePanelImageView setUserInteractionEnabled:YES];
    
    // Size Button
    sizeColorButton.size.height = sizeColorSizePanelImageView.size.height / 2;
    sizeColorButton.size.width = sizeColorSizePanelImageView.size.width;
    sizeColorButton.origin.x = 0;
    sizeColorButton.origin.y = sizeColorSizePanelImageView.size.height / 2;
    sizeButton = [[UIButton alloc] initWithFrame:sizeColorButton];
    [sizeButton setBackgroundColor:[UIColor clearColor]];
    [sizeButton addTarget:self action:@selector(clickSizeButton) forControlEvents:UIControlEventTouchUpInside];
    [colorSizePanelImageView addSubview:sizeButton];
    
    filename = [NSString stringWithFormat:@"draw_recycle%@", fileSufix];
    UIImage *clearButtonUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_recycle_selected%@", fileSufix];
    UIImage *clearButtonDownImage = [UIImage imageNamed:filename];
    
    filename = [NSString stringWithFormat:@"draw_undo%@", fileSufix];
    UIImage *undoButtonUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_undo_selected%@", fileSufix];
    UIImage *undoButtonDownImage = [UIImage imageNamed:filename];
    
    // clear button
    widthSpace = 20 * scale;
    heightSpace = 80 * scale;
    CGRect sizeClearButton;
    sizeClearButton.size.width = clearButtonUpImage.size.width * scale;
    sizeClearButton.size.height = clearButtonUpImage.size.height *scale;
    sizeClearButton.origin.x = widthSpace;
    sizeClearButton.origin.y = heightSpace;
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:sizeClearButton];
    [clearButton setBackgroundImage:clearButtonUpImage forState:UIControlStateNormal];
    [clearButton setBackgroundImage:clearButtonDownImage forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(clickClearButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    // Undo Button
    heightSpace = 22 * scale;
    CGRect sizeUndoButton;
    sizeUndoButton.size.width = undoButtonDownImage.size.width * scale;
    sizeUndoButton.size.height = undoButtonDownImage.size.height * scale;
    sizeUndoButton.origin.x = widthSpace;
    sizeUndoButton.origin.y = sizeClearButton.origin.y + sizeClearButton.size.height + heightSpace;
    
    UIButton *undoButton = [[UIButton alloc] initWithFrame:sizeUndoButton];
    [undoButton setBackgroundImage:undoButtonUpImage forState:UIControlStateNormal];
    [undoButton setBackgroundImage:undoButtonDownImage forState:UIControlStateHighlighted];
    [undoButton addTarget:self action:@selector(clickUndoButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:undoButton];
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
    CGImageRelease(imageRef);
    thumbNail=thumbnail;
    return thumbnail;
}

- (void)playVideo {
    [playButton setHidden:YES];
    [thumpnilImageView removeFromSuperview];
    thumpnilImageView = nil;
    [moviePlayer play];
}

- (void)clickSizeButton {
    if(!sizeImageView) {
        
        NSString *filename = [NSString stringWithFormat:@"draw_size_panel_horizontal%@", fileSufix];
        UIImage *panelViewImage = [UIImage imageNamed:filename];
        CGRect sizePanelView;
        sizePanelView.size.height = panelViewImage.size.height * scale;
        sizePanelView.size.width = panelViewImage.size.width * scale;
        sizePanelView.origin.y = colorSizePanelImageView.frame.origin.y + colorSizePanelImageView.frame.size.height - sizePanelView.size.height;
        sizePanelView.origin.x = colorSizePanelImageView.frame.origin.x - sizePanelView.size.width;
        sizeImageView = [[UIImageView alloc] initWithFrame:sizePanelView];
        [sizeImageView setImage:panelViewImage];
        [self.view addSubview:sizeImageView];
        
        UIImage *activeSizeImage = smallSizeDownImage;
        int activeSize = 0;
        if(size == 5) {
            activeSizeImage = mediumSizeDownImage;
            activeSize = 1;
        } else if (size == 10) {
            activeSizeImage = bigSizeDownImage;
            activeSize = 2;
        }
        
        CGRect sizeSmallButton = sizePanelView;
        sizeSmallButton.size.width = smallSizeUpImage.size.width * scale;
        sizeSmallButton.size.height = smallSizeUpImage.size.height * scale;
        sizeSmallButton.origin.y = (sizePanelView.size.height - sizeSmallButton.size.height)/2;
        sizeSmallButton.origin.x = (sizePanelView.size.width/3 - sizeSmallButton.size.width)/2;
        
        smallSizeButton = [[UIButton alloc] initWithFrame:sizeSmallButton];
        if(activeSize == 0) {
            [smallSizeButton setBackgroundImage:smallSizeDownImage forState:UIControlStateNormal];
        } else {
            [smallSizeButton setBackgroundImage:smallSizeUpImage forState:UIControlStateNormal];
        }
        [smallSizeButton addTarget:self action:@selector(clickSizeSmallButton)
                  forControlEvents:UIControlEventTouchUpInside];
        
        [sizeImageView addSubview:smallSizeButton];
        
        CGRect sizeMediumButton = sizePanelView;
        sizeMediumButton.size.width = mediumSizeUpImage.size.width * scale;
        sizeMediumButton.size.height = mediumSizeUpImage.size.height * scale;
        sizeMediumButton.origin.y = (sizePanelView.size.height - sizeMediumButton.size.height)/2;
        sizeMediumButton.origin.x = sizePanelView.size.width/3 + (sizePanelView.size.width/3 -
                                                                  sizeMediumButton.size.width)/2;
        mediumSizeButton = [[UIButton alloc] initWithFrame:sizeMediumButton];
        if(activeSize == 1) {
            [mediumSizeButton setBackgroundImage:mediumSizeDownImage forState:UIControlStateNormal];
        } else {
            [mediumSizeButton setBackgroundImage:mediumSizeUpImage forState:UIControlStateNormal];
        }
        [mediumSizeButton addTarget:self action:@selector(clickSizeMediumButton)
                   forControlEvents:UIControlEventTouchUpInside];
        [sizeImageView addSubview:mediumSizeButton];
        
        CGRect sizeBigButton = sizePanelView;
        sizeBigButton.size.width = bigSizeUpImage.size.width * scale;
        sizeBigButton.size.height = bigSizeUpImage.size.height * scale;
        sizeBigButton.origin.y = (sizePanelView.size.height - sizeBigButton.size.height)/2;
        sizeBigButton.origin.x = 2*sizePanelView.size.width/3 + (sizePanelView.size.width/3 -
                                                                 sizeBigButton.size.width)/2;
        bigSizeButton = [[UIButton alloc] initWithFrame:sizeBigButton];
        if(activeSize == 2) {
            [bigSizeButton setBackgroundImage:bigSizeDownImage forState:UIControlStateNormal];
        } else {
            [bigSizeButton setBackgroundImage:bigSizeUpImage forState:UIControlStateNormal];
        }
        
        [bigSizeButton addTarget:self action:@selector(clickSizeBigButton)
                forControlEvents:UIControlEventTouchUpInside];
        [sizeImageView addSubview:bigSizeButton];
        [sizeImageView setUserInteractionEnabled:YES];
    } else {
        [sizeImageView removeFromSuperview];
        sizeImageView = nil;
    }
}
- (void)clickSizeSmallButton {
    CGRect sizeSelectedImageView = selectedSizeImageView.frame;
    sizeSelectedImageView.size.width = smallSizeUpImage.size.width/2;
    sizeSelectedImageView.size.height = smallSizeUpImage.size.height/2;
    sizeSelectedImageView.origin.x = (colorSizePanelImageView.frame.size.width -
                                      sizeSelectedImageView.size.width)/2;
    sizeSelectedImageView.origin.y = (colorSizePanelImageView.frame.size.height/2 +
                                      (colorSizePanelImageView.frame.size.height/2 -
                                       10 - sizeSelectedImageView.size.height)/2);
    [selectedSizeImageView setFrame:sizeSelectedImageView];
    
    [selectedSizeImageView setImage:smallSizeDownImage];
    [smallSizeButton setBackgroundImage:smallSizeDownImage forState:UIControlStateNormal];
    
    [mediumSizeButton setBackgroundImage:mediumSizeUpImage forState:UIControlStateNormal];
    [bigSizeButton setBackgroundImage:bigSizeUpImage forState:UIControlStateNormal];
    size = 1;
}

- (void)clickSizeMediumButton {
    CGRect sizeSelectedImageView = selectedSizeImageView.frame;
    sizeSelectedImageView.size.width = mediumSizeUpImage.size.width/2;
    sizeSelectedImageView.size.height = mediumSizeUpImage.size.height/2;
    sizeSelectedImageView.origin.x = (colorSizePanelImageView.frame.size.width -
                                      sizeSelectedImageView.size.width)/2;
    sizeSelectedImageView.origin.y = (colorSizePanelImageView.frame.size.height/2 +
                                      (colorSizePanelImageView.frame.size.height/2 -
                                       10 - sizeSelectedImageView.size.height)/2);
    [selectedSizeImageView setFrame:sizeSelectedImageView];
    
    [selectedSizeImageView setImage:mediumSizeDownImage];
    [smallSizeButton setBackgroundImage:smallSizeUpImage forState:UIControlStateNormal];
    
    [mediumSizeButton setBackgroundImage:mediumSizeDownImage forState:UIControlStateNormal];
    [bigSizeButton setBackgroundImage:bigSizeUpImage forState:UIControlStateNormal];
    size = 5;
}

- (void)clickSizeBigButton {
    CGRect sizeSelectedImageView = selectedSizeImageView.frame;
    sizeSelectedImageView.size.width = bigSizeUpImage.size.width/2;
    sizeSelectedImageView.size.height = bigSizeUpImage.size.height/2;
    sizeSelectedImageView.origin.x = (colorSizePanelImageView.frame.size.width -
                                      sizeSelectedImageView.size.width)/2;
    sizeSelectedImageView.origin.y = (colorSizePanelImageView.frame.size.height/2 +
                                      (colorSizePanelImageView.frame.size.height/2 -
                                       10 - sizeSelectedImageView.size.height)/2);
    [selectedSizeImageView setFrame:sizeSelectedImageView];
    
    [selectedSizeImageView setImage:bigSizeDownImage];
    [smallSizeButton setBackgroundImage:smallSizeUpImage forState:UIControlStateNormal];
    
    [mediumSizeButton setBackgroundImage:mediumSizeUpImage forState:UIControlStateNormal];
    [bigSizeButton setBackgroundImage:bigSizeDownImage forState:UIControlStateNormal];
    size = 10;
}

- (void)clickColorButton {
    
    if(!colorPickerImageView) {
        pickerColor = YES;
        
        // draw color picker
        NSString *filename = [NSString stringWithFormat:@"draw_color_picker%@",fileSufix];
        UIImage *colorPickerImage = [UIImage imageNamed:filename];
        CGRect sizeColorPicker;
        sizeColorPicker.size.width = colorPickerImage.size.width * scale;
        sizeColorPicker.size.height = colorPickerImage.size.height * scale;
        sizeColorPicker.origin.x = (self.view.frame.size.width - sizeColorPicker.size.width) / 2;
        sizeColorPicker.origin.y = (self.view.frame.size.height - sizeColorPicker.size.height) / 2;
        
        colorPickerImageView = [[UIImageView alloc] initWithFrame:sizeColorPicker];
        [colorPickerImageView setImage:colorPickerImage];
        [self.view addSubview:colorPickerImageView];

        // OK Button
        heightSpace = 48 * scale;
        CGRect sizeAcceptColorPickerButton;
        sizeAcceptColorPickerButton.size.width = 160 * scale;
        sizeAcceptColorPickerButton.size.height = 60 * scale;
        sizeAcceptColorPickerButton.origin.x = (self.view.frame.size.width - sizeAcceptColorPickerButton.size.width) / 2;
        sizeAcceptColorPickerButton.origin.y = colorPickerImageView.frame.origin.y - sizeAcceptColorPickerButton.size.height - heightSpace;
        
        acceptColorPickerButton = [[UIButton alloc] initWithFrame:sizeAcceptColorPickerButton];
        [acceptColorPickerButton setFrame:sizeAcceptColorPickerButton];
        [acceptColorPickerButton setBackgroundColor:[UIColor whiteColor]];
        [acceptColorPickerButton setTitle:@"OK" forState:UIControlStateNormal];
        [acceptColorPickerButton addTarget:self action:@selector(clickAcceptColorButton) forControlEvents:UIControlEventTouchUpInside];
        [acceptColorPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:acceptColorPickerButton];
        
        // draw color select
        filename = [NSString stringWithFormat:@"draw_color_select%@", fileSufix];
        UIImage *selectColorImage = [UIImage imageNamed:filename];
        CGRect sizeSelectColorImageView;
        sizeSelectColorImageView.size.width = selectColorImage.size.width * scale;
        sizeSelectColorImageView.size.height = selectColorImage.size.height * scale;
        sizeSelectColorImageView.origin.x = (sizeColorPicker.size.width - sizeSelectColorImageView.size.width) / 2;
        sizeSelectColorImageView.origin.y = (sizeColorPicker.size.height - sizeSelectColorImageView.size.height) / 2;
        selectImageView = [[UIImageView alloc] initWithFrame:sizeSelectColorImageView];
        [selectImageView setImage:selectColorImage];
        [colorPickerImageView addSubview:selectImageView];
        drawColor = [UIColor whiteColor];
        [colorButton setBackgroundColor:drawColor];
    } /*else {
        [colorPickerImageView removeFromSuperview];
        colorPickerImageView = nil;
        pickerColor = NO;
        lastPoint = CGPointZero;
    }*/
}

-(void)clickAcceptColorButton {
    [colorPickerImageView removeFromSuperview];
    [acceptColorPickerButton removeFromSuperview];
    colorPickerImageView = nil;
    pickerColor = NO;
    lastPoint = CGPointZero;
}

- (void)clickPencilButton {
    [self clickSizeSmallButton];
    [colorButton setEnabled:YES];
    if(sizeImageView) {
        [sizeImageView removeFromSuperview];
        sizeImageView = nil;
    }
    [sizeButton setEnabled:NO];
    [pencilButton setBackgroundImage:pencilDownImage forState:UIControlStateNormal];
    [brushButton setBackgroundImage:brushUpImage forState:UIControlStateNormal];
    [eraserButton setBackgroundImage:eraserUpImage forState:UIControlStateNormal];
    instrument = YES;
    eraserState = NO;
    brush = kCGLineCapButt;
}
- (void)clickTextButton {
    [colorButton setEnabled:YES];
    [sizeButton setEnabled:NO];
    [pencilButton setBackgroundImage:pencilDownImage forState:UIControlStateNormal];
    [brushButton setBackgroundImage:brushUpImage forState:UIControlStateNormal];
    [eraserButton setBackgroundImage:eraserUpImage forState:UIControlStateNormal];
    instrument = NO;
    eraserState = NO;
    is_text = true;
    brush = NO;
}
- (void)clickBrushButton {
    [colorButton setEnabled:YES];
    [sizeButton setEnabled:YES];
    [pencilButton setBackgroundImage:pencilUpImage forState:UIControlStateNormal];
    [brushButton setBackgroundImage:brushDownImage forState:UIControlStateNormal];
    [eraserButton setBackgroundImage:eraserUpImage forState:UIControlStateNormal];
    instrument = YES;
    eraserState = NO;
    brush = kCGLineCapRound;
    is_text = false;
}

- (void)clickEraserButton {
    [sizeButton setEnabled:YES];
    [colorButton setEnabled:NO];
    if(colorPickerImageView) {
        [colorPickerImageView removeFromSuperview];
        colorPickerImageView = nil;
        pickerColor = NO;
    }
    [pencilButton setBackgroundImage:pencilUpImage forState:UIControlStateNormal];
    [brushButton setBackgroundImage:brushUpImage forState:UIControlStateNormal];
    [eraserButton setBackgroundImage:eraserDownImage forState:UIControlStateNormal];
    instrument = YES;
    eraserState = YES;
    brush = kCGLineCapSquare;
//    drawColor = [UIColor whiteColor];
//    [colorButton setBackgroundColor:drawColor];
    is_text = false;
}

- (void)clickCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickSaveButton {
    if ([drawImageArray count] == 0 && [textAry count] == 0 ) {
        
    }else{
        CGSize newSize = CGSizeMake(drawView.image.size.width,drawView.image.size.height);
        UIGraphicsBeginImageContext( newSize );
        
        [thumpnilImageView.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        
        [drawView.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height) blendMode:kCGBlendModeNormal alpha:1];
        
        for (int i = 0; i < aryCount; i++) {
            UITextField * TextField = [textAry objectAtIndex:i];
            NSString * str = TextField.text;
            NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
            [style setAlignment:NSTextAlignmentCenter];
            UIFont *font = [UIFont systemFontOfSize:23];
            NSDictionary *attr = @{NSFontAttributeName:font , NSForegroundColorAttributeName:TextField.textColor, NSParagraphStyleAttributeName:style};
            [str drawInRect:TextField.frame withAttributes: attr];
        }
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [delegate saveVideo:newImage];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet  *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(instrument) {
        mouseSwiped = NO;
        lastPoint = [touch locationInView:thumpnilImageView];
    
    } else if(pickerColor) {
        lastPoint = [touch locationInView:colorPickerImageView];
    } else if (is_text){
        lastPoint = [touch locationInView:thumpnilImageView];
        
        sizeTextField.size.height = 70 * scale;
        sizeTextField.size.width = screenWidth;
        sizeTextField.origin.x = 0;
        sizeTextField.origin.y = lastPoint.y ;
        
        UITextField * LastTextField = [textAry lastObject];
        if ([LastTextField.text isEqualToString:@""]) {
            [textAry removeLastObject];
            [LastTextField removeFromSuperview];
        }
        
        InputTextField = [[UITextField alloc] initWithFrame:sizeTextField];
        InputTextField.backgroundColor = [UIColor colorWithRed: 1.0f green: 1.0f blue: 1.0f alpha:0.3f];
        
        InputTextField.textColor = inputTextColor;//[UIColor blueColor];//drawColor;//
        InputTextField.font = font2;
        InputTextField.returnKeyType = UIReturnKeyDone;
        InputTextField.delegate = self;
        InputTextField.textAlignment = NSTextAlignmentCenter;
        InputTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        InputTextField.placeholder = @"";
        [self.view addSubview:InputTextField];
        [InputTextField becomeFirstResponder];
        
        [textAry addObject:InputTextField];
        aryCount ++;
    }else {}
}

- (void)touchesMoved:(NSSet  *)touches withEvent:(UIEvent *)event {
    if(lastPoint.x > 0 && lastPoint.y > 0 && !pickerColor) {
        if (!eraserState && !is_text) {
            mouseSwiped = YES;
            UITouch *touch = [touches anyObject];
            CGPoint currentPoint = [touch locationInView:drawView];
            
            UIGraphicsBeginImageContext(drawView.frame.size);
            [drawView.image drawInRect:CGRectMake(0, 0,
                                                  drawView.frame.size.width,
                                                  drawView.frame.size.height)];
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), brush);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
            
            CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha =0.0;
            [drawColor getRed:&red green:&green blue:&blue alpha:&alpha];
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red,
                                       green, blue, 1.0);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            drawView.image = UIGraphicsGetImageFromCurrentImageContext();
            [drawView setAlpha:1];
            UIGraphicsEndImageContext();
            
            lastPoint = currentPoint;
        }else if (is_text){
            
        } else {
            UITouch *touch = [touches anyObject];
            CGPoint currentPoint = [touch locationInView:drawView];
            
            UIGraphicsBeginImageContext(drawView.frame.size);
            [drawView.image drawInRect:CGRectMake(0, 0, drawView.frame.size.width, drawView.frame.size.height)];
            
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(),10);
            CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
            
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255, 255, 255, 1.0);
            CGContextBeginPath(UIGraphicsGetCurrentContext());
            CGContextSetShouldAntialias(UIGraphicsGetCurrentContext(), YES);
            
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            drawView.image = UIGraphicsGetImageFromCurrentImageContext();
            
            UIGraphicsEndImageContext();
            
            lastPoint = currentPoint;
        }
    } else {
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:colorPickerImageView];
        if([self enterPoint:currentPoint]) {
            CGRect sizeSelectImageView = selectImageView.frame;
            sizeSelectImageView.origin.x = currentPoint.x;
            sizeSelectImageView.origin.y = currentPoint.y;
            [selectImageView setFrame:sizeSelectImageView];
            CGPoint point = CGPointMake(sizeSelectImageView.origin.x +
                                        sizeSelectImageView.size.width/2,
                                        sizeSelectImageView.origin.y +
                                        sizeSelectImageView.size.height/2);
            drawColor = [self colorFromImage:colorPickerImageView.image
                              sampledAtPoint:
                         CGPointMake(point.x/colorPickerImageView.frame.size.width,
                                     point.y/colorPickerImageView.frame.size.height)];
            [colorButton setBackgroundColor:drawColor];
            [acceptColorPickerButton setBackgroundColor:drawColor];
            inputTextColor = drawColor;
        }
    }
}

- (UIColor *)colorFromImage:(UIImage*)image sampledAtPoint:(CGPoint)p {
    CGImageRef cgImage = [image CGImage];
    CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    CFDataRef bitmapData = CGDataProviderCopyData(provider);
    const UInt8* data = CFDataGetBytePtr(bitmapData);
    size_t bytesPerRow = CGImageGetBytesPerRow(cgImage);
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    int col = p.x*(width-1);
    int row = p.y*(height-1);
    const UInt8* pixel = data + row*bytesPerRow+col*4;
    int r = pixel[0];
    int g = pixel[1];
    int b = pixel[2];
    UIColor* returnColor = [[UIColor alloc] initWithRed:(r/255.0f) green:g/255.0f blue:b/255.0f
                                                  alpha:1];
    CFRelease(bitmapData);
    return returnColor;
}

- (BOOL)enterPoint:(CGPoint)point {
    float radius = colorPickerImageView.frame.size.width/2;
    float space = selectImageView.frame.size.width/2;
    if((point.x - radius + space) * (point.x - radius + space) +
       ((point.y + space - radius) * (point.y + space - radius)) <=  radius*radius) {
        return YES;
    } else {
        return NO;
    }
}

- (void)touchesEnded:(NSSet  *)touches withEvent:(UIEvent *)event {
    if (!eraserState){
        if(!pickerColor) {
            if(!mouseSwiped && !is_text) {
                UIGraphicsBeginImageContext(drawView.frame.size);
                [drawView.image drawInRect:CGRectMake(0, 0, drawView.frame.size.width,
                                                      drawView.frame.size.height)];
                CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
                
                CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha =0.0;
                [drawColor getRed:&red green:&green blue:&blue alpha:&alpha];
                CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
                
                CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
                CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
                CGContextStrokePath(UIGraphicsGetCurrentContext());
                CGContextFlush(UIGraphicsGetCurrentContext());
                drawView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            
            UIGraphicsBeginImageContext(drawView.frame.size);
            [drawView.image drawInRect:CGRectMake(0, 0, drawView.frame.size.width,
                                                  drawView.frame.size.height)
                             blendMode:kCGBlendModeNormal alpha:1.0];
            drawView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            [drawImageArray addObject:drawView.image];
            
        } else {
            UITouch *touch = [touches anyObject];
            CGPoint currentPoint = [touch locationInView:colorPickerImageView];
            if([self enterPoint:currentPoint]) {
                CGRect sizeSelectImageView = selectImageView.frame;
                sizeSelectImageView.origin.x = currentPoint.x;
                sizeSelectImageView.origin.y = currentPoint.y;
                [selectImageView setFrame:sizeSelectImageView];
                if([self enterPoint:currentPoint]) {
                    CGRect sizeSelectImageView = selectImageView.frame;
                    sizeSelectImageView.origin.x = currentPoint.x;
                    sizeSelectImageView.origin.y = currentPoint.y;
                    [selectImageView setFrame:sizeSelectImageView];
                    CGPoint point = CGPointMake(sizeSelectImageView.origin.x +
                                                sizeSelectImageView.size.width/2,
                                                sizeSelectImageView.origin.y +
                                                sizeSelectImageView.size.height/2);
                    drawColor = [self colorFromImage:colorPickerImageView.image
                                      sampledAtPoint:
                                 CGPointMake(point.x/colorPickerImageView.frame.size.width,
                                             point.y/colorPickerImageView.frame.size.height)];
                    [colorButton setBackgroundColor:drawColor];
                    [acceptColorPickerButton setBackgroundColor:drawColor];
                    inputTextColor = drawColor;
                    InputTextField.textColor = inputTextColor;
                }
            }
        }
    } else {
//        if (!pickerColor){
//            [drawImageArray addObject:drawView.image];
//        }
    }
}

- (void)clickClearButton {
    drawView.image = nil;
    [drawImageArray removeAllObjects];
}

- (void)clickUndoButton {
    [drawImageArray removeLastObject];
    UIImage *image = [drawImageArray lastObject];
    drawView.image = image;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
