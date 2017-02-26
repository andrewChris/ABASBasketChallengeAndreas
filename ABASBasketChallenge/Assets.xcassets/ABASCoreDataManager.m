//
//  ABASCoreDataManager.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASCoreDataManager.h"
#import "Basket+CoreDataClass.h"
#import "BasketItem+CoreDataClass.h"
#import "BasketItemType+CoreDataClass.h"
#import "ABASConstants.h"
#import "ABASNetworkManager.h"

@interface ABASCoreDataManager ()


@end

@implementation ABASCoreDataManager

+ (id)sharedInstance
{
    static ABASCoreDataManager *sharedDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDataManager = [[self alloc] init];
    });
    return sharedDataManager;
}

#pragma mark - Config

#pragma mark - Parse Plists

- (NSDictionary *)parseJSONFileWithFileName:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSError *jsonError = nil;
    
    if(filePath == nil)
    {
        NSLog(@"Cannot read JSON file with file name: %@", fileName);
        return nil;
    }
    
    NSDictionary *resultsDict = [NSJSONSerialization
                                 JSONObjectWithData:[NSData dataWithContentsOfFile:filePath]
                                 options:kNilOptions
                                 error:&jsonError];
    
    if(resultsDict == NULL || resultsDict == nil)
    {
        NSLog(@"Unable to read JSON file with error: %@", jsonError);
    }
    
    return resultsDict;
}

- (NSDictionary *)getConfigurationFromFileName:(NSString *)fileName
{
    NSDictionary *resultsDict = [self parseJSONFileWithFileName:fileName];
    
    if(resultsDict == NULL || resultsDict == nil)
    {
        return nil;
    }
    
    return resultsDict;
}


- (NSInteger)getCountFromEntity:(NSString *)entityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:[self managedContext]];
    [request setEntity:entity];
    
    NSError *error = nil;
    NSInteger count = [[self managedContext] countForFetchRequest:request
                                                            error:&error];
    
    if(error !=nil)
    {
        NSLog(@"Error pre pre populating equipment");
        return -1;
    }
    
    if(count > 0)
    {
        NSLog(@"Entity: %@ already exists", entityName);
        return count;
    }
    
    return count;
}

- (void)prePopulateBasketItems
{
    NSDictionary *basketItemTypeResultsDict = [self getConfigurationFromFileName:JSON_BASKET_ITEM_TYPE_ENTITY];
    NSDictionary *basketItemsResultsDict = [self getConfigurationFromFileName:JSON_BASKET_ITEM_ENTITY];
    
    if(basketItemTypeResultsDict == nil || basketItemsResultsDict == nil)
        return;
    
    NSArray *basketItemTypeArray = [basketItemTypeResultsDict valueForKey:JSON_KEY_BASKET_ITEM_TYPE_ENTITY];
    NSArray *basketItemsArray = [basketItemsResultsDict valueForKey:JSON_KEY_BASKET_ITEM_ENTITY];
    
    for (NSDictionary *basketItemTypeDict in basketItemTypeArray)
    {
        for (NSString *key in basketItemTypeDict)
        {
            //In interest of time, only adding the test scenarios. Idealy i would check if the items already exist / have been removed and dynamically add / remove items
            
            BasketItemType *type = [NSEntityDescription insertNewObjectForEntityForName:BASKET_ITEM_TYPE_ENTITY inManagedObjectContext:[self managedContext]];
            
            NSLog(@"Key: %@ : %@", key, [basketItemTypeDict valueForKey:key]);
            
            type.id = [basketItemTypeDict valueForKey:@"id"];
            type.cost_price = [[basketItemTypeDict valueForKey:@"price"] intValue];
            type.name = [basketItemTypeDict valueForKey:@"name"];
            
            if([key isEqualToString:@"id"])
            {
                for (NSDictionary *itemDict in basketItemsArray)
                {
                    if([[itemDict valueForKey:@"id"] isEqualToString:[basketItemTypeDict valueForKey:key]])
                    {
                        BasketItem *item = [NSEntityDescription insertNewObjectForEntityForName:BASKET_ITEM_ENTITY inManagedObjectContext:[self managedContext]];
                        
                        item.id = [itemDict valueForKey:@"id"];
                        item.price = [[itemDict valueForKey:@"price"] intValue];
                        item.type = type;
                        break;
                    }
                }
            }
        }
    }
    
    [self saveContext];
}

- (void)performStartUpActivities
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    if(![[standardUserDefaults valueForKey:@"kItemConfiguration"]boolValue])
    {
        [standardUserDefaults setObject:@"1" forKey:@"kItemConfiguration"];
        [self prePopulateBasketItems];
    }
}

#pragma mark - Basket

- (void)createBasketWithId:(NSString *)iD withName:(NSString *)name
{
    Basket *basket = [NSEntityDescription insertNewObjectForEntityForName:BASKET_ENTITY inManagedObjectContext:[self managedContext]];
    
    //Local date used to compare against Synced date to determine if data needs to be synced to server
    basket.lastUpdatedLocal = [NSDate date];
    basket.id = [iD intValue];
    basket.name = name;
    
    [self saveContext];
}

- (void)deleteBasket:(Basket *)basket
{
    [[self managedContext]deleteObject:basket];
    [self saveContext];
}

- (Basket *)getBasket
{
    NSFetchRequest *basketFetchRequest = [NSFetchRequest fetchRequestWithEntityName:BASKET_ENTITY];
    
    NSError *error = nil;
    NSArray *results = [[self managedContext] executeFetchRequest:basketFetchRequest error:&error];
    if (!results)
    {
        NSLog(@"Error fetching basket");
        return nil;
    }
    
    if(results.count)
        return [results firstObject];
    
    return nil;
}

- (void)saveBasket:(Basket *)basket
{
    basket.lastUpdatedLocal = [NSDate date];
    
    [self saveContext];
}


#pragma mark - Basket Item

- (BasketItem *)createBasketItem
{
    BasketItem *basketItem = [NSEntityDescription insertNewObjectForEntityForName:BASKET_ITEM_ENTITY inManagedObjectContext:[self managedContext]];

    [self saveContext];
    
    return basketItem;
}

- (void)deleteBasketItem:(Basket *)basketItem
{
    [[self managedContext]deleteObject:basketItem];
    [self saveContext];
}

- (NSArray *)getBasketItems
{
    NSFetchRequest *basketItemFetchRequest = [NSFetchRequest fetchRequestWithEntityName:BASKET_ITEM_ENTITY];
    
    NSError *error = nil;
    NSArray *results = [[self managedContext] executeFetchRequest:basketItemFetchRequest error:&error];
    if (!results)
    {
        NSLog(@"Error fetching basket Item");
    }
    
    return results;
}

- (void)saveBasketItem:(Basket *)basketItem
{
    [self saveContext];
}

#pragma mark - Basket Item Type



- (Basket *)createBasketItemType
{
    Basket *basketItemType = [NSEntityDescription insertNewObjectForEntityForName:BASKET_ITEM_TYPE_ENTITY inManagedObjectContext:[self managedContext]];
    
    [self saveContext];
    
    return basketItemType;
}

- (void)deleteBasketItemType:(Basket *)basketItemType
{
    [[self managedContext]deleteObject:basketItemType];
    [self saveContext];
}

- (NSArray *)getBasketItemType
{
    NSFetchRequest *basketItemTypeFetchRequest = [NSFetchRequest fetchRequestWithEntityName:BASKET_ITEM_TYPE_ENTITY];
    
    NSError *error = nil;
    NSArray *results = [[self managedContext] executeFetchRequest:basketItemTypeFetchRequest error:&error];
    if (!results)
    {
        NSLog(@"Error fetching basket item type");
    }
    
    return results;
}

- (void)saveBasketItemType:(Basket *)basketItemType
{
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"ABASBasketChallenge"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

- (NSManagedObjectContext *)managedContext
{
    return self.persistentContainer.viewContext;
}

@end
