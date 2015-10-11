//
//  PointObject.h
//  TimeChat
//


#import <Foundation/Foundation.h>

@interface PointObject : NSObject

@property (nonatomic, assign) CGPoint firstPoint;
@property (nonatomic, assign) CGPoint secondPoint;
@property (nonatomic, assign) CGFloat brush;
@property (nonatomic, strong) UIColor *drawColor;
@property (nonatomic, assign) CGFloat size;

- (id)initWithFirstPoint:(CGPoint)_firstPoint andSecondPoint:(CGPoint)_secondPoint
                andBrush:(CGFloat)_brush andColor:(UIColor *)_drawColor andSize:(CGFloat)_size;

@end
