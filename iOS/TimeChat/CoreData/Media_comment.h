//
//  Media_comment.h
//  TimeChat
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Media_comment : NSManagedObject

@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * media_id;
@property (nonatomic, retain) NSString * message_id;



@end
