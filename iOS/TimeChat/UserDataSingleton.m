//
//  UserDataSingleton.m
//  TimeChat
//


#import "UserDataSingleton.h"

@implementation UserDataSingleton

@synthesize password;
@synthesize session;
@synthesize userName;
@synthesize userEmail;

@synthesize status;
@synthesize idUser;
@synthesize newMessageContactsCount;
@synthesize newMessageGroupsCount;
@synthesize notificationTone;
@synthesize vibration;
@synthesize serverURL;
@synthesize userDefaults;

static UserDataSingleton *sharedSingleton = NULL;

- (id)init
{
    self = [super init];
    if (self) {
        // Work your initialising magic here as you normally would
        
    }
    return self;
}

+ (UserDataSingleton *)sharedSingleton {
    if (!sharedSingleton || sharedSingleton == NULL) {
		sharedSingleton = [UserDataSingleton new];
	}
	return sharedSingleton;
}

/* START By Ping Ahn */


- (BOOL)notificationSoundEnabled
{
    if ([self.userDefaults objectForKey:@"notificationSoundEnabled"]) {
        return [[self.userDefaults objectForKey:@"notificationSoundEnabled"] boolValue];
    } else {
        return YES;
    }
}

- (void)setNotificationSoundEnabled:(BOOL)notificationSoundEnabled
{
    [self.userDefaults setObject:[NSNumber numberWithBool:notificationSoundEnabled] forKey:@"notificationSoundEnabled"];
    [self.userDefaults synchronize];
}

- (NSString *)notificationSound
{
    if ([self.userDefaults objectForKey:@"notificationSound"]) {
        return [self.userDefaults objectForKey:@"notificationSound"];
    } else {
        return @"None";
    }
}

- (void)setNotificationSound:(NSString *)notificationSound
{
    [self.userDefaults setObject:notificationSound forKey:@"notificationSound"];
    [self.userDefaults synchronize];
}

- (BOOL)autoAcceptFriendEnabled
{
    if ([self.userDefaults objectForKey:@"autoAcceptFriendEnabled"]) {
        return [[self.userDefaults objectForKey:@"autoAcceptFriendEnabled"] boolValue];
    } else {
        return YES;
    }
}

- (void)setAutoAcceptFriendEnabled:(BOOL)autoAcceptFriendEnabled
{
    [self.userDefaults setObject:[NSNumber numberWithBool:autoAcceptFriendEnabled] forKey:@"autoAcceptFriendEnabled"];
    [self.userDefaults synchronize];
}

- (BOOL)autoNotifyFriendEnabled
{
    if ([self.userDefaults objectForKey:@"autoNotifyFriendEnabled"]) {
        return [[self.userDefaults objectForKey:@"autoNotifyFriendEnabled"] boolValue];
    } else {
        return YES;
    }
}

- (void)setAutoNotifyFriendEnabled:(BOOL)autoNotifyFriendEnabled
{
    [self.userDefaults setObject:[NSNumber numberWithBool:autoNotifyFriendEnabled] forKey:@"autoNotifyFriendEnabled"];
    [self.userDefaults synchronize];
}

/* END By Ping Ahn */

- (void)dealloc {
    password = nil;
    userName = nil;
    userEmail = nil;
    status = nil;
    session = nil;
    idUser = nil;
}

@end
