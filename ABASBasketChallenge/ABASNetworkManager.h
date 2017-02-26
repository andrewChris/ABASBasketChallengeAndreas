//
//  ABASNetworkManager.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 22/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABASNetworkManager : NSObject

typedef void (^serviceCompletionBlock)(BOOL success, NSString *iD, NSString *name);
typedef void (^basketItemCompletionBlock)(BOOL success, NSDictionary *responseDict);

+ (id)sharedInstance;

- (void)createNewBasketWithCompletion:(serviceCompletionBlock)completion;

@end
