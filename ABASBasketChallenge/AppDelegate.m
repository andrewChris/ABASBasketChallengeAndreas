//
//  AppDelegate.m
//  ABASBasketChallenge
//
//  Created by Sean O'Connor on 21/2/17.
//  Copyright © 2017 ABA Systems. All rights reserved.
//

#import "AppDelegate.h"

#import <OHHTTPStubs/OHHTTPStubs.h>
#import <OHHTTPStubs/OHPathHelpers.h>

#import "ABASAddItemViewController.h"
#import "ABASCoreDataManager.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureStubs];
    [[ABASCoreDataManager sharedInstance] performStartUpActivities];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[ABASCoreDataManager sharedInstance] saveContext];
}
    
#pragma mark - Configuration Methods
    
- (void)configureStubs {
    static id<OHHTTPStubsDescriptor> textStub = nil;
    textStub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [self isABARequest:request];
    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        return [self responseForRequest:request];
    }];
}
    
#pragma mark - Mocking Methods
    
- (BOOL)isABARequest:(NSURLRequest *)request {
    return [request.URL.host rangeOfString:@"aba-systems.com.au"].location != NSNotFound;
}
    
- (OHHTTPStubsResponse *)responseForRequest:(NSURLRequest *)request {
    
    //HTTPBody always returned nil, related to issue found here: https://github.com/AliSoftware/OHHTTPStubs#known-limitations hence used HTTPBodyStream
    
    NSMutableData *requestData = [NSMutableData data];
    u_int8_t buffer[1024];
    NSInteger length;
    
    [request.HTTPBodyStream open];
    
    do
    {
        length = [request.HTTPBodyStream read:buffer maxLength:sizeof(buffer)];
        if (length > 0)
        {
            [requestData appendBytes:buffer length:length];
        }
    }
    while (length > 0);
    
    [request.HTTPBodyStream close];
    
    NSError* error;
    NSDictionary* requestJSON = [NSJSONSerialization JSONObjectWithData:requestData
                                                         options:kNilOptions
                                                           error:&error];
    
    NSMutableDictionary *responseJSON = [NSMutableDictionary new];
    int statusCode = 200;
    NSDictionary *headers = @{@"Content-Type":@"application/json"};
    
    if ([request.HTTPMethod isEqualToString:@"POST"] == NO) {
        statusCode = 405;
    }
    
    if ([[self endpointForRequest:request] isEqual:@"baskets/"]) {
        responseJSON = requestJSON.mutableCopy;
        [responseJSON setObject:[NSNumber numberWithInt:arc4random() % 99] forKey:@"id"];
    }
    else if ([[self endpointForRequest:request] isEqual:@"basketitems/"]) {
        if ([requestJSON[@"type"] isKindOfClass:[NSNumber class]] && [requestJSON[@"type"] integerValue] > 0) {
            responseJSON = requestJSON.mutableCopy;
            [responseJSON setObject:[NSNumber numberWithInt:arc4random() % 99] forKey:@"id"];
        } else {
            statusCode = 400;
        }
    }
    else if ([[self endpointForRequest:request] isEqual:@"basketitemtypes/"]) {
        responseJSON = requestJSON.mutableCopy;
        [responseJSON setObject:[NSNumber numberWithInt:arc4random() % 99] forKey:@"id"];
    } else {
        statusCode = 404;
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseJSON
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    
    return [[OHHTTPStubsResponse responseWithData:data statusCode:statusCode headers:headers] requestTime:0.0f responseTime:OHHTTPStubsDownloadSpeedWifi];
}
    
- (NSString *)endpointForRequest:(NSURLRequest *)request {
    return [request.URL.absoluteString componentsSeparatedByString:@"https://aba-systems.com.au/api/v1/"].lastObject;
}

@end
