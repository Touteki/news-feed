//
//  News.h
//  News-Feed
//
//  Created by Dmitriy Polyakov on 12.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *url;

+ (void)fetchAppleNewsForPage:(NSUInteger)page withPageSize:(NSUInteger)pageSize completion:(void (^)(NSArray *response, NSString *errorMessage))completion;

@end
