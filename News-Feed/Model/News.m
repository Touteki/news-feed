//
//  News.m
//  News-Feed
//
//  Created by Dmitriy Polyakov on 12.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import "News.h"
#import "APIManager.h"

@implementation News

+ (void)fetchAppleNewsForPage:(NSUInteger)page withPageSize:(NSUInteger)pageSize completion:(void (^)(NSArray *response, NSString *errorMessage))completion {
    NSString *requestURL = @"https://newsapi.org/v2/everything";
    NSMutableDictionary *params = [NSMutableDictionary new];
    //params[@"from"] = @"2020-01-01T00:00:00"; //Empty test
    params[@"X-No-Cache"] = @"true";
    params[@"q"] = @"a";
    params[@"sortBy"] = @"publishedAt";
    //params[@"language"] = @"ru";
    params[@"pagesize"] = @(pageSize).stringValue;
    params[@"page"] = @(page).stringValue;
    
    [[APIManager alloc] getRequest:requestURL withParams:params completion:^(NSDictionary *response, NSString *errorMessage) {
        if (errorMessage) {
            completion(nil, errorMessage);
        } else {
            NSArray *responseArray = [response objectForKey:@"articles"];
            NSMutableArray *newsArray = [NSMutableArray new];
            for (NSDictionary *responseObject in responseArray) {
                News *news = [[News alloc] init];
                news.title = [responseObject objectForKey:@"title"];
                news.desc = [responseObject objectForKey:@"description"];
                news.url = [responseObject objectForKey:@"url"];
                [news fixNSNull];
                [newsArray addObject:news];
            }
            completion(newsArray, nil);
        }
    }];
}

- (void)fixNSNull {
    if (self.title == (NSString *)[NSNull null]) {
        self.title = nil;
    }
    
    if (self.desc == (NSString *)[NSNull null]) {
        self.desc = nil;
    }
    
    if (self.url == (NSString *)[NSNull null]) {
        self.url = nil;
    }
}

@end
