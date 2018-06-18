//
//  NewsTableViewCell.m
//  News-Feed
//
//  Created by Dmitriy Polyakov on 11.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "News.h"

@interface NewsTableViewCell()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@end


@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self configureView];
    }
    
    return self;
}

- (void)configureView {
    //Configure Title
    UILayoutGuide *layoutMargins = self.contentView.layoutMarginsGuide;
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    self.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:self.titleLabel];
    
    //Setuip Title constaints
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.titleLabel.leadingAnchor constraintEqualToAnchor:layoutMargins.leadingAnchor].active = YES;
    [self.titleLabel.topAnchor constraintEqualToAnchor:layoutMargins.topAnchor].active = YES;
    [self.titleLabel.trailingAnchor constraintEqualToAnchor:layoutMargins.trailingAnchor].active = YES;
    
    //Configure Description
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont systemFontOfSize:13];
    self.descriptionLabel.textColor = UIColor.lightGrayColor;
    self.descriptionLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descriptionLabel];
    
    //Setup Description Constraints
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.descriptionLabel.leadingAnchor constraintEqualToAnchor:layoutMargins.leadingAnchor].active = YES;
    [self.descriptionLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:4].active = YES;
    [self.descriptionLabel.trailingAnchor constraintEqualToAnchor:layoutMargins.trailingAnchor].active = YES;
    [self.descriptionLabel.bottomAnchor constraintEqualToAnchor:layoutMargins.bottomAnchor].active = YES;
}

- (void)configureWithNews:(News *)news {
    self.titleLabel.text = news.title;
    self.descriptionLabel.text = news.desc;
}

@end
