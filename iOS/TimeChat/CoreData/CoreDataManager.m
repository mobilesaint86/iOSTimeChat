//
//  CoreDataManager.m
//  TimeChat
//

#import "CoreDataManager.h"

@interface CoreDataManager()


@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
- (void)setupManagedObjectContext;

@end

@implementation CoreDataManager

static CoreDataManager *coreDataManager;

+ (CoreDataManager *)sharedManager
{
    if (!coreDataManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            coreDataManager = [[CoreDataManager alloc] init];
        });
    }
    return coreDataManager;
}

#pragma mark - setup

- (id)init
{
    self = [super init];
    if (self) {
        [self setupManagedObjectContext];
    }
    return self;
}

- (void)setupManagedObjectContext
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentDirectoryURL = [fileManager URLsForDirectory: NSDocumentDirectory inDomains:NSUserDomainMask][0];
    
    NSURL *persistentURL = [documentDirectoryURL URLByAppendingPathComponent: [NSString stringWithFormat:@"TimeChat.sqlite"]];
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeChatModel" withExtension:@"momd"];
    
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    self.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]  initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error = nil;
    NSPersistentStore *persistentStore =
        [self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:persistentURL
                                                            options:nil
                                                              error:&error];
    if (persistentStore) {
        self.managedObjectContext = [[NSManagedObjectContext alloc] init];
        self.managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    } else {
        NSLog(@"ERROR!!!!!!!!!!: %@", error.description);
    }
}

- (void)saveContext {
    NSError *savingError = nil;
    if([self.managedObjectContext save:&savingError]) {
        NSLog(@"Successfully saved the context");
    } else {
        NSLog(@"error %@", [savingError description]);
    }
}

- (void)insertMedia:(NSString *)media_id UserId:(NSString *)userId Time:(NSString *)time Name:(NSString *)name Type:(NSString *)type Thumb:(NSString *)thumb Preview_data:(NSData *)preview_data Counter:(NSString *)counter{
    Media *media = [NSEntityDescription  insertNewObjectForEntityForName:@"Medias" inManagedObjectContext: self.managedObjectContext];
    if(media != nil) {
        media.media_id        = media_id;
        media.user_id   = userId;
        media.name      = name;
        media.time      = time;
        media.type      = type;
        media.thumb      = thumb;
        media.preview_data = preview_data;
        media.counter = counter;
        [self.managedObjectContext insertObject:media];
    } else {
        NSLog(@"new media failed to create");
    }
     
}

- (void)insertUser:(NSString *)user_id Name:(NSString *)name Avatar:(NSData *)avatar Email:(NSString *)email{
    User *user = [NSEntityDescription insertNewObjectForEntityForName:@"Users"   inManagedObjectContext: self.managedObjectContext];
    if(user != nil) {
        user.id = user_id;
        user.name = name;
        user.avatar = avatar;
        user.email = email;
        [self.managedObjectContext insertObject:user];
    } else {
        NSLog(@"new user failed to create");
    }
}

- (User *)getUser:(NSString *)idUser {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users"    inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *usersArray = [self.managedObjectContext executeFetchRequest:fetchRequest  error:&requestError];
   
    for(int i = 0; i < [usersArray count]; i++) {
        User *user = [usersArray objectAtIndex:i];
        if([user.id isEqual:idUser]) {
            return user;
        }
    }
    
    return nil;
}

- (Media *)getMedia:(NSString *)media_id {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Medias"   inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *requestError = nil;
    NSArray *mediasArray = [self.managedObjectContext executeFetchRequest:fetchRequest
                                                                   error:&requestError];
    
    for(int i = 0; i < [mediasArray count]; i++) {
        Media *media = [mediasArray objectAtIndex:i];
        if([media.media_id isEqual:media_id]) {
            return media;
        }
    }
    
    return nil;
}

- (void)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Could Not Save Data"
                                                        message:@"There was a problem saving your data but it is not your fault. If you restart the app, you can try again. Please contact support (support@domain.com) to notify us of this issue."
                                                       delegate:self
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    abort();
}

@end
