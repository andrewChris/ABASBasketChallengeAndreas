//
//  ABASNetworkManager.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 22/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABASNetworkManager : NSObject

+ (id)sharedInstance;

- (void)getBasketData;

@end
