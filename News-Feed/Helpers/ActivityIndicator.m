//
//  ActivityIndicator.m
//  News-Feed
//
//  Created by Dmitriy Polyakov on 11.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import "ActivityIndicator.h"

@implementation ActivityIndicator

+ (id)shared {
    static ActivityIndicator *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared configure];
    });
    return shared;
}

- (void)configure {
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.color = [UIColor whiteColor];
}

- (void)presentInView:(UIView *)view {
    self.frame = view.bounds;
    [view addSubview:self];
    [self startAnimating];
}

- (void)remove {
        [self stopAnimating];
        [self removeFromSuperview];
}

@end
