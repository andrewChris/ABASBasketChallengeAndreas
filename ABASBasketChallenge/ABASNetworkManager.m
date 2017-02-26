//
//  ABASNetworkManager.m
//  ABASBasketChallenge
//
//  Created by Christophides, A. J. on 22/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "ABASNetworkManager.h"
#import "ABASConstants.h"

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

- (void)getBasketData
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASE_URL, BASKET_URL]]];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *requestDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"123", @"id",
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
                    
                }
                else
                {
                    //Success
                    NSLog(@"%@",jsonResponse);
                }
            }
        }
    }] resume];
}

@end
