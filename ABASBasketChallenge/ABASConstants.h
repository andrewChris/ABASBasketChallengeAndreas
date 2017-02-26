//
//  ABASConstants.h
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

//CORE DATA
static NSString * const BASKET_ENTITY = @"Basket";
static NSString * const BASKET_ITEM_ENTITY = @"BasketItem";
static NSString * const BASKET_ITEM_TYPE_ENTITY = @"BasketItemType";

//SERVER
static NSString * const BASKET_URL = @"baskets/";
static NSString * const BASKET_ITEM_URL = @"basketitems/";
static NSString * const BASKET_ITEM_TYPE_URL = @"basketitemtypes/";
static NSString * const BASE_URL = @"https://aba-systems.com.au/api/v1/";

//JSON FILES
static NSString * const JSON_BASKET_ITEM_ENTITY = @"BasketItem";
static NSString * const JSON_BASKET_ITEM_TYPE_ENTITY = @"BasketItemType";

//JSON KEYS
static NSString * const JSON_KEY_BASKET_ITEM_ENTITY = @"basketItem";
static NSString * const JSON_KEY_BASKET_ITEM_TYPE_ENTITY = @"basketItemType";

@interface ABASConstants : NSObject

@end
