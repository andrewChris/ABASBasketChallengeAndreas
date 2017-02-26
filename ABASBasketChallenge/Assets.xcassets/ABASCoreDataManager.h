//
//  ABASCoreDataManager.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ABASCoreDataManager : NSObject

@property (readonly, strong) NSPersistentContainer *persistentContainer;

+ (id)sharedInstance;

- (void)saveContext;

@end
