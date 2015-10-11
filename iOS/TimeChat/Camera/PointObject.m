//
//  PointObject.m
//  TimeChat
//


#import "PointObject.h"

@implementation PointObject

@synthesize firstPoint;
@synthesize secondPoint;
@synthesize brush;
@synthesize drawColor;
@synthesize size;

- (id)initWithFirstPoint:(CGPoint)_firstPoint andSecondPoint:(CGPoint)_secondPoint
                andBrush:(CGFloat)_brush andColor:(UIColor *)_drawColor andSize:(CGFloat)_size {
    if(self == [super init]) {
        firstPoint = _firstPoint;
        secondPoint = _secondPoint;
        brush = _brush;
        drawColor = _drawColor;
        size = _size;
    }
    return self;
}

@end
