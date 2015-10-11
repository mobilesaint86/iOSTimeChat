//
//  LineObject.h
//  TimeChat
//


#import <Foundation/Foundation.h>

@interface LineObject : NSObject

@property (nonatomic, strong) NSMutableArray *pointsArray;

- (id)initWithPointsArray:(NSMutableArray *)_pointsArray;

@end
