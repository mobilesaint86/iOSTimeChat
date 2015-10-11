//
//  PhotoDrawViewController.m
//  TimeChat
//
//  Created by michail on 17/03/14.
//  Copyright (c) 2014 Maksim Denisov. All rights reserved.
//

#import "PhotoDrawViewController.h"

@interface PhotoDrawViewController () {
    UIImage *photoImage;
    UIImageView *photoImageView;
    BOOL mouseSwiped;
    CGPoint lastPoint;
    UIColor *drawColor;
    CGFloat brush;
    CGFloat size;
    UIButton *pencilButton;
    UIButton *brushButton;
    UIButton *eraserButton;
    BOOL instrument;
    UIImage *pencilUpImage;
    UIImage *brushUpImage;
    UIImage *eraserUpImage;
    UIImage *pencilDownImage;
    UIImage *brushDownImage;
    UIImage *eraserDownImage;
    UIImageView *colorSizePanelImageView;
    UIButton *sizeButton;
    UIButton *colorButton;
    UIImageView *sizeImageView;
    UIImageView *colorPickerImageView;
    BOOL pickerColor;
    UIImageView *selectImageView;
    UIButton *bigSizeButton;
    UIButton *mediumSizeButton;
    UIButton *smallSizeButton;
    UIImage *smallSizeUpImage;
    UIImage *mediumSizeUpImage;
    UIImage *bigSizeUpImage;
    UIImage *smallSizeDownImage;
    UIImage *mediumSizeDownImage;
    UIImage *bigSizeDownImage;
    UIImageView *selectedSizeImageView;
    NSMutableArray *pointsArray;
    NSMutableArray *linesArray;
    dispatch_queue_t concurrentQueue;
    dispatch_group_t taskGroup;
    NSString *fileSufix;
    UIButton *acceptColorPickerButton;
}

@end

@implementation PhotoDrawViewController

@synthesize delegate;

- (id)initWithImage:(UIImage *)_photoImage {
    if(self = [super init]) {
        fileSufix=[NSString stringWithFormat:@"_%d%@", [UserDataSingleton sharedSingleton].numOfDesign,
                   [UserDataSingleton sharedSingleton].Sufix];
        NSString *filename;
        concurrentQueue = dispatch_get_main_queue();
        taskGroup = dispatch_group_create();
        photoImage = [_photoImage copy];
        instrument = NO;
        filename = [NSString stringWithFormat:@"draw_pensil_up%@", fileSufix];
        pencilUpImage   = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_brush_up%@", fileSufix];
        brushUpImage    = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_eraser_up%@", fileSufix];
        eraserUpImage   = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_pensil_down%@", fileSufix];
        pencilDownImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_brush_down%@", fileSufix];
        brushDownImage  = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_eraser_down%@", fileSufix];
        eraserDownImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_size_small_up%@", fileSufix];
        smallSizeUpImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_size_medium_up%@", fileSufix];
        mediumSizeUpImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_size_big_up%@", fileSufix];
        bigSizeUpImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_size_small_down%@", fileSufix];
        smallSizeDownImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_size_medium_down%@", fileSufix];
        mediumSizeDownImage = [UIImage imageNamed:filename];
        filename = [NSString stringWithFormat:@"draw_size_big_down%@", fileSufix];
        bigSizeDownImage = [UIImage imageNamed:filename];
        drawColor = [UIColor whiteColor];
        pointsArray = [[NSMutableArray alloc] init];
        linesArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *filename;
    filename = [NSString stringWithFormat:@"draw_button_cancel_up%@", fileSufix];
    UIImage *cancelButtonUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_button_save_up%@", fileSufix];
    UIImage *saveButtonUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_button_cancel_down%@", fileSufix];
    UIImage *cancelButtonDownImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_button_save_down%@", fileSufix];
    UIImage *saveButtonDownImage = [UIImage imageNamed:filename];
    CGRect sizeCancelButton = self.view.frame;
    sizeCancelButton.size.width /= 2;
    sizeCancelButton.origin.x = 0;
    //размер как то влияет на рисование , нельзя размер картинки брать!!!!
    sizeCancelButton.size.height = 70;
    sizeCancelButton.origin.y = self.view.frame.size.height - sizeCancelButton.size.height;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:sizeCancelButton];
    [cancelButton setBackgroundImage:cancelButtonUpImage forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:cancelButtonDownImage forState:UIControlStateHighlighted];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(clickCancelButton)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [self.view addSubview:cancelButton];
    
    sizeCancelButton.origin.x += sizeCancelButton.size.width;
    UIButton *saveButton = [[UIButton alloc] initWithFrame:sizeCancelButton];
    [saveButton setBackgroundImage:saveButtonUpImage forState:UIControlStateNormal];
    [saveButton setBackgroundImage:saveButtonDownImage forState:UIControlStateHighlighted];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [saveButton addTarget:self action:@selector(clickSaveButton)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
    CGRect sizePhotoImageView = self.view.frame;
    sizePhotoImageView.origin.x = sizePhotoImageView.origin.y = 0;
    sizePhotoImageView.size.height = self.view.frame.size.height - sizeCancelButton.size.height;
    
    photoImageView = [[UIImageView alloc] initWithFrame:sizePhotoImageView];
    [photoImageView setImage:photoImage];
    [self.view addSubview:photoImageView];
    
    CGRect sizePencilButton;
    sizePencilButton.size.width = pencilUpImage.size.width/2;
    sizePencilButton.size.height = pencilUpImage.size.height/2;
    sizePencilButton.origin.y = sizeCancelButton.origin.y - 10 - sizePencilButton.size.height;
    sizePencilButton.origin.x = (self.view.frame.size.width - sizePencilButton.size.width * 3)/4;
    
    pencilButton = [[UIButton alloc] initWithFrame:sizePencilButton];
    [pencilButton setBackgroundImage:pencilUpImage forState:UIControlStateNormal];
    [pencilButton addTarget:self action:@selector(clickPencilButton)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pencilButton];
    
    sizePencilButton.origin.x += sizePencilButton.origin.x + sizePencilButton.size.width;
    brushButton = [[UIButton alloc] initWithFrame:sizePencilButton];
    [brushButton setBackgroundImage:brushUpImage forState:UIControlStateNormal];
    [brushButton addTarget:self action:@selector(clickBrushButton)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:brushButton];
    
    sizePencilButton.origin.x += ((self.view.frame.size.width - sizePencilButton.size.width * 3)/4 +
                                  sizePencilButton.size.height);
    eraserButton = [[UIButton alloc] initWithFrame:sizePencilButton];
    [eraserButton setBackgroundImage:eraserUpImage forState:UIControlStateNormal];
    [eraserButton addTarget:self action:@selector(clickEraserButton)
           forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:eraserButton];
    
    filename = [NSString stringWithFormat:@"draw_colorsize_panel%@", fileSufix];
    UIImage *drawColorSizePanelImage = [UIImage imageNamed:filename];
    CGRect sizeColorSizePanelImageView;
    sizeColorSizePanelImageView.size.height = drawColorSizePanelImage.size.height/2;
    sizeColorSizePanelImageView.size.width = drawColorSizePanelImage.size.width/2;
    sizeColorSizePanelImageView.origin.x = (self.view.frame.size.width -
                                            sizeColorSizePanelImageView.size.width);
    sizeColorSizePanelImageView.origin.y = 50;
    
    colorSizePanelImageView = [[UIImageView alloc] initWithFrame:sizeColorSizePanelImageView];
    [colorSizePanelImageView setImage:drawColorSizePanelImage];
    [self.view addSubview:colorSizePanelImageView];
    
    CGRect sizeColorLabel = sizeColorSizePanelImageView;
    sizeColorLabel.size.width = sizeColorSizePanelImageView.size.width - 10;
    sizeColorLabel.size.height = 10;
    sizeColorLabel.origin.y = (sizeColorSizePanelImageView.size.height/2 -
                               sizeColorLabel.size.height - 1);
    sizeColorLabel.origin.x = 5;
    
    CGRect sizeColorButton = sizeColorSizePanelImageView;
    sizeColorButton.size.width -= 30;
    sizeColorButton.size.height = sizeColorButton.size.width;
    sizeColorButton.origin.y = 5;
    sizeColorButton.origin.x = (sizeColorSizePanelImageView.size.width - sizeColorButton.size.width)/2;
    
    UILabel *colorLabel = [[UILabel alloc] initWithFrame:sizeColorLabel];
    [colorLabel setText:@"Color"];
    [colorLabel setTextAlignment:NSTextAlignmentCenter];
    [colorLabel setTextColor:[UIColor whiteColor]];
    [colorLabel setFont:[UIFont systemFontOfSize:10]];
    [colorLabel setBackgroundColor:[UIColor clearColor]];
    [colorSizePanelImageView addSubview:colorLabel];
    
    colorButton = [[UIButton alloc] initWithFrame:sizeColorButton];
    [colorButton setBackgroundColor:drawColor];
    [colorButton addTarget:self action:@selector(clickColorButton)
          forControlEvents:UIControlEventTouchUpInside];
    [colorSizePanelImageView addSubview:colorButton];
    
    sizeColorButton.origin.y = sizeColorSizePanelImageView.size.height/2;
    sizeColorButton.size.height = sizeColorSizePanelImageView.size.height/2;
    sizeColorButton.size.width = sizeColorSizePanelImageView.size.width;
    sizeColorButton.origin.x = 0;
    sizeButton = [[UIButton alloc] initWithFrame:sizeColorButton];
    [sizeButton setBackgroundColor:[UIColor clearColor]];
    [sizeButton addTarget:self action:@selector(clickSizeButton)
         forControlEvents:UIControlEventTouchUpInside];
    
    CGRect sizeSizeLabel = sizeColorSizePanelImageView;
    sizeSizeLabel.size.width = sizeColorSizePanelImageView.size.width - 10;
    sizeSizeLabel.size.height = 10;
    sizeSizeLabel.origin.y = sizeColorSizePanelImageView.size.height - sizeSizeLabel.size.height - 2;
    sizeSizeLabel.origin.x = 5;
    
    UILabel *sizeLabel = [[UILabel alloc] initWithFrame:sizeSizeLabel];
    [sizeLabel setText:@"Size"];
    [sizeLabel setTextAlignment:NSTextAlignmentCenter];
    [sizeLabel setTextColor:[UIColor whiteColor]];
    [sizeLabel setFont:[UIFont systemFontOfSize:10]];
    [sizeLabel setBackgroundColor:[UIColor clearColor]];
    [colorSizePanelImageView addSubview:sizeLabel];
    
    filename = [NSString stringWithFormat:@"draw_size_small_down%@", fileSufix];
    UIImage *sizeImage = [UIImage imageNamed:filename];
    CGRect sizeSizeImage;
    sizeSizeImage.size.height = sizeImage.size.height/2;
    sizeSizeImage.size.width = sizeImage.size.width/2;
    sizeSizeImage.origin.x = (sizeColorSizePanelImageView.size.width - sizeSizeImage.size.width)/2;
    sizeSizeImage.origin.y = (sizeColorSizePanelImageView.size.height/2 +
                              (sizeColorSizePanelImageView.size.height/2 -
                               sizeSizeLabel.size.height - sizeSizeImage.size.height)/2);
    selectedSizeImageView = [[UIImageView alloc] initWithFrame:sizeSizeImage];
    [selectedSizeImageView setImage:sizeImage];
    [colorSizePanelImageView addSubview:selectedSizeImageView];
    size = 1;
    [colorSizePanelImageView setUserInteractionEnabled:YES];
    [colorSizePanelImageView addSubview:sizeButton];
    
    filename = [NSString stringWithFormat:@"draw_button_clear_up%@", fileSufix];
    UIImage *clearButtonUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_button_undo_up%@", fileSufix];
    UIImage *undoButtonUpImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_button_clear_down%@", fileSufix];
    UIImage *clearButtonDownImage = [UIImage imageNamed:filename];
    filename = [NSString stringWithFormat:@"draw_button_undo_down%@", fileSufix];
    UIImage *undoButtonDownImage = [UIImage imageNamed:filename];

    CGRect sizeClearButton;
    sizeClearButton.size.width = clearButtonUpImage.size.width/1.5;
    sizeClearButton.size.height = clearButtonUpImage.size.height/1.5;
    sizeClearButton.origin.x = 10;
    sizeClearButton.origin.y = 20;
    
    UIButton *clearButton = [[UIButton alloc] initWithFrame:sizeClearButton];
    [clearButton setBackgroundImage:clearButtonUpImage forState:UIControlStateNormal];
    [clearButton setBackgroundImage:clearButtonDownImage forState:UIControlStateHighlighted];
    [clearButton addTarget:self action:@selector(clickClearButton)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearButton];
    
    CGRect sizeUndoButton;
    sizeUndoButton.size.width = undoButtonDownImage.size.width/1.5;
    sizeUndoButton.size.height = undoButtonDownImage.size.height/1.5;
    sizeUndoButton.origin.x = 10;
    sizeUndoButton.origin.y = sizeClearButton.origin.y + sizeClearButton.size.height + 10;
    
    UIButton *undoButton = [[UIButton alloc] initWithFrame:sizeUndoButton];
    [undoButton setBackgroundImage:undoButtonUpImage forState:UIControlStateNormal];
    [undoButton setBackgroundImage:undoButtonDownImage forState:UIControlStateHighlighted];
    [undoButton addTarget:self action:@selector(clickUndoButton)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:undoButton];
}

- (void)clickUndoButton {
    void(^draw)(void) = ^{
        if([linesArray count] > 0) {
            NSLog(@"draw");
            photoImageView.image = nil;
            [photoImageView setImage:photoImage];
            for(int i = 0; i < [linesArray count] - 1; i++) {
                LineObject *lineObject = [linesArray objectAtIndex:i];
                for(int j = 0; j < [lineObject.pointsArray count]; j++) {
                    PointObject *pointObject = [lineObject.pointsArray objectAtIndex:j];
                    UIGraphicsBeginImageContext(photoImageView.frame.size);
                    [photoImageView.image drawInRect:CGRectMake(0, 0,
                                                               photoImageView.frame.size.width,
                                                               photoImageView.frame.size.height)];
                    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), pointObject.firstPoint.x,
                                         pointObject.firstPoint.y);
                    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), pointObject.secondPoint.x,
                                            pointObject.secondPoint.y);
                    CGContextSetLineCap(UIGraphicsGetCurrentContext(), pointObject.brush);
                    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), pointObject.size);
                    ///////////////////////////////////////////////////////////////////////
                    //CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =1.0;
                    CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha =1.0;
                    [pointObject.drawColor getRed:&red green:&green blue:&blue alpha:&alpha];
                    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red,
                                               green, blue, 1.0);
                    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
                    CGContextStrokePath(UIGraphicsGetCurrentContext());
                    photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    [photoImageView setAlpha:1];
                    UIGraphicsEndImageContext();
                }
            }
            if([linesArray count] > 0) {
                [linesArray removeLastObject];
            }
            NSLog(@"end draw");
        }
    };
    NSLog(@"create queue");
    dispatch_group_async(taskGroup, concurrentQueue, draw);
}

- (void)clickClearButton {
    photoImageView.image = nil;
    [photoImageView setImage:photoImage];
    [linesArray removeAllObjects];
    [pointsArray removeAllObjects];
}

- (void)clickSizeButton {
    if(!sizeImageView) {
        CGRect sizePanelView = colorSizePanelImageView.frame;
        sizePanelView.size.height /= 2;
        sizePanelView.origin.y += sizePanelView.size.height;
        NSString *filename;
        filename = [NSString stringWithFormat:@"draw_size_panel%@", fileSufix];
        UIImage *panelViewImage = [UIImage imageNamed:filename];
        sizePanelView.size.width = panelViewImage.size.width/2;
        sizePanelView.origin.x -= sizePanelView.size.width;
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
        sizeSmallButton.size.width = smallSizeUpImage.size.width/2;
        sizeSmallButton.size.height = smallSizeUpImage.size.height/2;
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
        sizeMediumButton.size.width = mediumSizeUpImage.size.width/2;
        sizeMediumButton.size.height = mediumSizeUpImage.size.height/2;
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
        sizeBigButton.size.width = bigSizeUpImage.size.width/2;
        sizeBigButton.size.height = bigSizeUpImage.size.height/2;
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
    NSLog(@"small");
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
    NSLog(@"medium");
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
    NSLog(@"big");
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
        NSString *filename;
        filename = [NSString stringWithFormat:@"draw_color_picker%@", fileSufix];
        UIImage *colorPickerImage = [UIImage imageNamed:filename];
        CGRect sizeColorPicker;
        sizeColorPicker.size.width = colorPickerImage.size.width/2;
        sizeColorPicker.size.height = colorPickerImage.size.height/2;
        sizeColorPicker.origin.x = (self.view.frame.size.width - sizeColorPicker.size.width)/2;
        sizeColorPicker.origin.y = (self.view.frame.size.height - sizeColorPicker.size.height)/2;
    
        colorPickerImageView = [[UIImageView alloc] initWithFrame:sizeColorPicker];
        [colorPickerImageView setImage:colorPickerImage];
        [self.view addSubview:colorPickerImageView];
        
//        filename = [NSString stringWithFormat:@"draw_button_ok%@", fileSufix];
        filename = [NSString stringWithFormat:@"draw_button_ok_1@2x~iphone.png"];
        UIImage *acceptColorPickerButtonImage = [UIImage imageNamed:filename];
        CGRect sizeAcceptColorPickerButton;
        sizeAcceptColorPickerButton.size.width = acceptColorPickerButtonImage.size.width / 2;
        sizeAcceptColorPickerButton.size.height = acceptColorPickerButtonImage.size.height / 2;
        sizeAcceptColorPickerButton.origin.x = (self.view.frame.size.width - sizeAcceptColorPickerButton.size.width) / 2;
        sizeAcceptColorPickerButton.origin.y = colorPickerImageView.frame.origin.y - sizeAcceptColorPickerButton.size.height - 20;
        
        acceptColorPickerButton = [[UIButton alloc] initWithFrame:sizeAcceptColorPickerButton];
        [acceptColorPickerButton setFrame:sizeAcceptColorPickerButton];
        [acceptColorPickerButton setBackgroundColor:[UIColor clearColor]];
//        filename = [NSString stringWithFormat:@"draw_button_cancel_down%@", fileSufix];
        [acceptColorPickerButton setBackgroundImage:[UIImage imageNamed:filename] forState:UIControlStateNormal];
        [acceptColorPickerButton setTitle:@"Ok" forState:UIControlStateNormal];
        [acceptColorPickerButton addTarget:self action:@selector(clickAcceptColorButton)
               forControlEvents:UIControlEventTouchUpInside];
        [acceptColorPickerButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [acceptColorPickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:acceptColorPickerButton];
        
        filename = [NSString stringWithFormat:@"draw_color_select%@", fileSufix];
        UIImage *selectColorImage = [UIImage imageNamed:filename];
        CGRect sizeSelectColorImageView;
        sizeSelectColorImageView.size.width = selectColorImage.size.width/2;
        sizeSelectColorImageView.size.height = selectColorImage.size.height/2;
        sizeSelectColorImageView.origin.x = (sizeColorPicker.size.width -
                                             sizeSelectColorImageView.size.width)/2;
        sizeSelectColorImageView.origin.y = (sizeColorPicker.size.height -
                                             sizeSelectColorImageView.size.height)/2;
        selectImageView = [[UIImageView alloc] initWithFrame:sizeSelectColorImageView];
        [selectImageView setImage:selectColorImage];
        [colorPickerImageView addSubview:selectImageView];
        drawColor = [UIColor whiteColor];
        [colorButton setBackgroundColor:drawColor];
        [acceptColorPickerButton setBackgroundColor:drawColor];
    }/* else {
        [colorPickerImageView removeFromSuperview];
        colorPickerImageView = nil;
        pickerColor = NO;
        lastPoint = CGPointZero;
    }*/
    NSLog(@"color button");
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
    brush = kCGLineCapButt;
}

- (void)clickBrushButton {
    [colorButton setEnabled:YES];
    [sizeButton setEnabled:YES];
    [pencilButton setBackgroundImage:pencilUpImage forState:UIControlStateNormal];
    [brushButton setBackgroundImage:brushDownImage forState:UIControlStateNormal];
    [eraserButton setBackgroundImage:eraserUpImage forState:UIControlStateNormal];
    instrument = YES;
    brush = kCGLineCapRound;
}

- (void)clickEraserButton {
    [sizeButton setEnabled:YES];
    [colorButton setEnabled:YES];
//    if(colorPickerImageView) {
//        [colorPickerImageView removeFromSuperview];
//        colorPickerImageView = nil;
//        pickerColor = NO;
//    }
    [pencilButton setBackgroundImage:pencilUpImage forState:UIControlStateNormal];
    [brushButton setBackgroundImage:brushUpImage forState:UIControlStateNormal];
    [eraserButton setBackgroundImage:eraserDownImage forState:UIControlStateNormal];
    instrument = YES;
    brush = kCGLineCapSquare;
//    drawColor = [UIColor whiteColor];
//    [colorButton setBackgroundColor:drawColor];
//    [acceptColorPickerButton setBackgroundColor:drawColor];
}

- (void)clickCancelButton {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)clickSaveButton {
    [delegate savePhoto:photoImageView.image];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)touchesBegan:(NSSet  *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if(instrument) {
        mouseSwiped = NO;
        lastPoint = [touch locationInView:photoImageView];
    } else if(pickerColor) {
        lastPoint = [touch locationInView:colorPickerImageView];
    }
}

- (void)touchesMoved:(NSSet  *)touches withEvent:(UIEvent *)event {
    if(lastPoint.x > 0 && lastPoint.y > 0 && !pickerColor) {
        mouseSwiped = YES;
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:photoImageView];
        
        UIGraphicsBeginImageContext(photoImageView.frame.size);
        [photoImageView.image drawInRect:CGRectMake(0, 0,
                                               photoImageView.frame.size.width,
                                                    photoImageView.frame.size.height)];
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
        PointObject *point = [[PointObject alloc] initWithFirstPoint:lastPoint
                                                      andSecondPoint:currentPoint andBrush:brush
                                                            andColor:drawColor andSize:size];
        [pointsArray addObject:point];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), brush);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
        /////////////////////////////////////////////////////////////
        //CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
        CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha =0.0;
        [drawColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red,
                                   green, blue, 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        [photoImageView setAlpha:1];
        UIGraphicsEndImageContext();
        lastPoint = currentPoint;
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
    if(!pickerColor) {
        if(!mouseSwiped) {
            UIGraphicsBeginImageContext(photoImageView.frame.size);
            [photoImageView.image drawInRect:CGRectMake(0, 0, photoImageView.frame.size.width,
                                                        photoImageView.frame.size.height)];
            CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
            CGContextSetLineWidth(UIGraphicsGetCurrentContext(), size);
            //////////////////////////////////////////////////////
            //CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
            CGFloat red = 1.0, green = 1.0, blue = 1.0, alpha =0.0;
            [drawColor getRed:&red green:&green blue:&blue alpha:&alpha];
            CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red,
                                       green, blue, 1.0);
            PointObject *point = [[PointObject alloc] initWithFirstPoint:lastPoint
                                                          andSecondPoint:lastPoint andBrush:brush
                                                                andColor:drawColor andSize:size];
            [pointsArray addObject:point];
            CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
            CGContextFlush(UIGraphicsGetCurrentContext());
            photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        LineObject *lineObject = [[LineObject alloc] initWithPointsArray:pointsArray];
        [linesArray addObject:lineObject];
        [pointsArray removeAllObjects];
        UIGraphicsBeginImageContext(photoImageView.frame.size);
        [photoImageView.image drawInRect:CGRectMake(0, 0, photoImageView.frame.size.width,
                                                    photoImageView.frame.size.height)
                               blendMode:kCGBlendModeNormal alpha:1.0];
        photoImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
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
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
