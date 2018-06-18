//
//  APIManager.m
//  News-Feed
//
//  Created by Dmitriy Polyakov on 12.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import "APIManager.h"
#import "Constants.h"

@implementation APIManager

- (void)getRequest:(NSString *)requestString withParams:(NSDictionary *)requestParams completion:(GetRequestBlock)completion {
    
    NSString *errorString = NSLocalizedString(@"APIManager.getRequest.Error", nil);
    
    // Make request string with params
    NSURLComponents *components = [NSURLComponents componentsWithString:requestString];
    NSMutableArray *params = [NSMutableArray new];
    for (NSString *key in requestParams) {
        [params addObject:[NSURLQueryItem queryItemWithName:key value:requestParams[key]]];
    }
    components.queryItems = params;
    
    NSLog(@"%@", components.URL);
    // Make request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:components.URL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:APIKey forHTTPHeaderField:@"Authorization"];
    
    // Data Task
    NSURLSessionDataTask *sessionDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
         // Check for error
         if (error) {
             completion(nil, errorString);
             return;
         }
        
         // Check for status code
         BOOL statusCodeIs200 = [self statusCodeIs200:response];
         if (!statusCodeIs200) {
             completion(nil, errorString);
             return;
         }
        
         // Check for data
         if (data == nil) {
             completion(nil, errorString);
             return;
         }
        
         // Create NSDictionary from data and check for error
         id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
         if (error) {
             completion(nil, errorString);
             return;
         }
        
         // Check object
         if ([object isKindOfClass:[NSDictionary class]]) {
             // Check for status in response
             BOOL responseStatusIsOk = [self responseStatusIsOk:object];
             if (!responseStatusIsOk) {
                 completion(nil, errorString);
             } else {
                 completion(object, nil);
             }
         } else {
             completion(nil, errorString);
         }
    }];
    [sessionDataTask resume];
}

// MARK: - Checks for errors
- (BOOL)statusCodeIs200:(NSURLResponse *)response {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        if (httpResponse.statusCode == 200) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)responseStatusIsOk:(NSDictionary *)response {
    NSString *responseStatus = [response valueForKey:@"status"];
    if ([responseStatus isEqualToString:@"ok"]) {
        return YES;
    }
    return NO;
}

@end
