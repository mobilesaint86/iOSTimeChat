//
//  CoreDataManager.h
//  TimeChat
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Media.h"
#import "Mediadata.h"
#import "Media_comment.h"
#import "User.h"

@interface CoreDataManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (CoreDataManager *)sharedManager;

- (void)insertMedia:(NSString *)media_id  UserId:(NSString *)userId Time:(NSString *)time Name:(NSString *)name  Type:(NSString *)type
            Thumb:(NSString *)thumb Preview_data:(NSData *)preview_data Counter:(NSString *)counter;

- (Media *)getMedia:(NSString *)media_id;

- (void)insertUser:(NSString *)user_id  Name:(NSString *)name  Avatar:(NSData *)avatar Email:(NSString *)email;

- (User *)getUser:(NSString *)user_id;


@end

