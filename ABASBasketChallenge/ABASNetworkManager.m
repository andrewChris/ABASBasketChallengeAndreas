//
//  ABASNetworkManager.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 22/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASNetworkManager.h"
#import "ABASConstants.h"

@interface ABASNetworkManager ()

@end

@implementation ABASNetworkManager

+ (id)sharedInstance
{
    static ABASNetworkManager *sharedNetworkManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNetworkManager = [[self alloc] init];
    });
    return sharedNetworkManager;
}

//Idealy would have created a method fro all 3 given more time

- (void)createNewBasketWithCompletion:(serviceCompletionBlock)completion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, BASKET_URL]]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *requestDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"", @"id",
                         @"basket1", @"name",
                         nil];
    NSError *error;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];
    
    [request setHTTPBodyStream:[NSInputStream inputStreamWithData:requestBody]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError)
                {
                    //Error
                    completion(YES, nil, nil);
                }
                else
                {
                    //Success
                    completion(YES, [jsonResponse objectForKey:@"id"], [jsonResponse objectForKey:@"name"]);
                    NSLog(@"%@",jsonResponse);
                }
            }
        }
    }] resume];
}

- (void)addBasketItemWithPrice:(int)price withCompletion:(basketItemCompletionBlock)completion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, BASKET_ITEM_TYPE_URL]]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *requestDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"", @"id",
                                 price, @"price",
                                 nil];
    NSError *error;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];
    
    [request setHTTPBodyStream:[NSInputStream inputStreamWithData:requestBody]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError)
                {
                    //Error
                    completion(YES, nil);
                }
                else
                {
                    //Success
                    completion(YES, jsonResponse);
                    NSLog(@"%@",jsonResponse);
                }
            }
        }
    }] resume];
}

- (void)addBasketItemTypeWithName:(NSString *)name costPrice:(int)cost withCompletion:(basketItemCompletionBlock)completion
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, BASKET_ITEM_TYPE_URL]]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *requestDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"", @"id",
                                 name, @"name",
                                 cost, @"cost_price",
                                 nil];
    NSError *error;
    NSData *requestBody = [NSJSONSerialization dataWithJSONObject:requestDict options:0 error:&error];
    
    [request setHTTPBodyStream:[NSInputStream inputStreamWithData:requestBody]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error)
        {
            if ([response isKindOfClass:[NSHTTPURLResponse class]])
            {
                NSError *jsonError;
                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                
                if (jsonError)
                {
                    //Error
                    completion(YES, nil);
                }
                else
                {
                    //Success
                    completion(YES, jsonResponse);
                    NSLog(@"%@",jsonResponse);
                }
            }
        }
    }] resume];
}

@end
