//
//  ABASBasketManager.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASBasketManager.h"

@implementation ABASBasketManager


+ (id)sharedInstance
{
    static ABASBasketManager *sharedBasketManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBasketManager = [[self alloc] init];
    });
    return sharedBasketManager;
}

@end
