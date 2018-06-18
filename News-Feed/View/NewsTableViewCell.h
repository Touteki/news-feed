//
//  NewsTableViewCell.h
//  News-Feed
//
//  Created by Dmitriy Polyakov on 11.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
@class News;

@interface NewsTableViewCell : UITableViewCell
- (void)configureWithNews:(News *)news;
@end
