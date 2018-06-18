//
//  ActivityIndicator.h
//  News-Feed
//
//  Created by Dmitriy Polyakov on 11.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityIndicator : UIActivityIndicatorView
+ (id)shared;
- (void)presentInView:(UIView *)view;
- (void)remove;
@end
