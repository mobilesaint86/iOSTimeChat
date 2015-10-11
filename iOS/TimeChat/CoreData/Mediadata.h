//
//  Mediadata.h
//  TimeChat
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mediadata : NSManagedObject

@property (nonatomic, retain) NSString * media_id;
//@property (nonatomic, retain) NSString * user_id;
//@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * time;
//@property (nonatomic, retain) NSString * type;
//@property (nonatomic, retain) NSData   * preview_data;
@property (nonatomic, retain) NSData   * data;
@property (nonatomic, retain) NSData   * video_data;



@end

