//
//  ABASBasketManager.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ABASBasketManager : NSObject

//Singleton shared instance
+ (id)sharedInstance;

//Instance methods
- (int)getNumberOfItemsInBasket;
- (double)getTotalPriceOfBasket;

@end
