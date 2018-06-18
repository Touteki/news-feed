//
//  NewsViewController.m
//  News-Feed
//
//  Created by Dmitriy Polyakov on 12.06.2018.
//  Copyright © 2018 Dmitriy Polyakov. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"
#import "ActivityIndicator.h"
#import "News.h"

static NSString *const kCellReuseIdentifier = @"cell";
static NSInteger const kPageSize = 20;

@interface NewsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end


@implementation NewsViewController

// MARK: - Loading & Configure
- (void)viewDidLoad {
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableData = [NSArray new];
    [self configureTableView];
    [self configureRefreshControl];
    [self fetchNews];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *layoutMargins = self.view.layoutMarginsGuide;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:layoutMargins.topAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    [self.tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:kCellReuseIdentifier];
}

- (void)configureRefreshControl {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Updating"];
    [self.refreshControl addTarget:self action:@selector(updateNews) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

// MARK: - Fetch & Updates
- (void)fetchNews {
    if (!self.tableData.count) [[ActivityIndicator shared] presentInView:self.view];
    NSUInteger nextPage = (self.tableData.count / kPageSize) + 1;
    [News fetchAppleNewsForPage:nextPage withPageSize:kPageSize completion:^(NSArray *response, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ActivityIndicator shared] remove];
            if (errorMessage) {
                [self showErrorMessage:errorMessage];
            } else {
                self.tableData = [self.tableData arrayByAddingObjectsFromArray:response];
                [self.tableView reloadData];
            }
        });
    }];
}

- (void)updateNews {
    [News fetchAppleNewsForPage:1 withPageSize:kPageSize completion:^(NSArray *response, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            if (errorMessage) {
                [self showErrorMessage:errorMessage];
            } else {
                self.tableData = response;
                [self.tableView reloadData];
            }
        });
    }];
}

// MARK: - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    News *news = [self.tableData objectAtIndex:indexPath.row];
    NSURL *url = [NSURL URLWithString:news.url];
    SFSafariViewController *safariViewControlller = [[SFSafariViewController alloc] initWithURL:url entersReaderIfAvailable:YES];
    [self presentViewController:safariViewControlller animated:YES completion:nil];
}



// MARK: - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    News *news = [self.tableData objectAtIndex:indexPath.row];
    [cell configureWithNews:news];
    
    BOOL isLastItem = (indexPath.row == self.tableData.count - 1);
    if (isLastItem) [self fetchNews];
    
    return cell;
}

// MARK: - Helpers
- (void)showErrorMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"ErrorTitle", nil)
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    
    [alert addAction:alertAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
