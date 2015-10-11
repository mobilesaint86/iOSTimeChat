//
//  FHSStream.h
//  FHSTwitterEngine
//


#import <Foundation/Foundation.h>
#import "FHSTwitterEngine.h"

@interface FHSStream : NSObject

@property (nonatomic, copy) StreamBlock block;

+ (FHSStream *)streamWithURL:(NSString *)url httpMethod:(NSString *)httpMethod parameters:(NSDictionary *)params timeout:(float)timeout block:(StreamBlock)block;

- (void)stop;
- (void)start;

@end
