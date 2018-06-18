//
//  APIManager.h
//  News-Feed
//
//  Created by Dmitriy Polyakov on 12.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GetRequestBlock)(NSDictionary *response, NSString *errorMessage);

@interface APIManager : NSObject
- (void)getRequest:(NSString *)requestString withParams:(NSDictionary *)requestParams completion:(GetRequestBlock)completion;
@end
