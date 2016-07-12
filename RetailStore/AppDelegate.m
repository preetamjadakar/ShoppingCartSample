//
//  AppDelegate.m
//  RetailStore
//
//  Created by Preetam Jadakar on 09/07/16.
//  Copyright © 2016 Preetam Jadakar. All rights reserved.
//

#import "AppDelegate.h"
#import "Product.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool isPreloaded = [defaults boolForKey:@"isPreloaded"];
    if (!isPreloaded) {
        [self preloadData];
        [defaults setBool:true forKey: @"isPreloaded"];
        [defaults synchronize];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.TW.RetailStore" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RetailStore" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RetailStore.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
-(void)preloadData{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    // Create a new managed object
    Product *newProduct1 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    newProduct1.productName = @"Microwave oven";
    newProduct1.category = @"Electronics";
    newProduct1.price = [NSDecimalNumber decimalNumberWithString:@"22.4"];
    newProduct1.image = nil;
    newProduct1.carted = @0;
    

    
    Product *newProduct2 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    newProduct2.productName = @"Television";
    newProduct2.category = @"Electronics";
    newProduct2.price = [NSDecimalNumber decimalNumberWithString:@"29.0"];
    newProduct2.image = nil;
    newProduct2.carted = @0;
    
    Product *newProduct3 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    newProduct3.productName = @"Vaccume Cleaner";
    newProduct3.category = @"Electronics";
    newProduct3.price = [NSDecimalNumber decimalNumberWithString:@"11.0"];
    newProduct3.image = nil;
    newProduct3.carted = @0;
    
    Product *newProduct4 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    newProduct4.productName = @"Table";
    newProduct4.category = @"Furniture";
    newProduct4.price = [NSDecimalNumber decimalNumberWithString:@"11.0"];
    newProduct4.image = nil;
    newProduct4.carted = @0;
    
    
    Product *newProduct5 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    newProduct5.productName = @"Chair";
    newProduct5.category = @"Furniture";
    newProduct5.price = [NSDecimalNumber decimalNumberWithString:@"5.0"];
    newProduct5.image = nil;
    newProduct5.carted = @0;
    
    Product *newProduct6 = [NSEntityDescription insertNewObjectForEntityForName:@"Product" inManagedObjectContext:context];
    newProduct6.productName = @"Almirah";
    newProduct6.category = @"Furniture";
    newProduct6.price = [NSDecimalNumber decimalNumberWithString:@"32.0"];
    newProduct6.image = nil;
    newProduct6.carted = @0;
    
    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    
    
    
}
@end
