//
//  LineObject.m
//  TimeChat
//


#import "LineObject.h"

@implementation LineObject

@synthesize pointsArray;

- (id)initWithPointsArray:(NSMutableArray *)_pointsArray {
    if(self == [super init]) {
        pointsArray = [[NSMutableArray alloc] initWithArray:_pointsArray];
    }
    return self;
}

@end
