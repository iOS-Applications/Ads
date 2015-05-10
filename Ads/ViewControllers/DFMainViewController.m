//
//  BBMainViewController.m
//  Ads
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFMainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import "DFConstants.h"
#import "DFVideoCell.h"
#import "DFVideoTableViewCell.h"

@interface DFMainViewController ()<UITableViewDataSource, UITableViewDelegate>

/* 在block里面修改也不需要加__block修饰· */
@property (nonatomic, retain) NSMutableArray    *data;
@property (nonatomic, retain) UITableView       *tableView;

@end

@implementation DFMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"热门";
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // 只做addSubViews
    [self.view addSubview:self.tableView];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    DFVideo *video = [self.data objectAtIndex:indexPath.row];
    [cell setVideo:video];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DFVideo *video = [self.data objectAtIndex:indexPath.row];
    DFVideoViewController *videoViewController = [[DFVideoViewController alloc] initWithNibName:nil bundle:nil];
    videoViewController.video = video;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
//    backBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [self.navigationController pushViewController:videoViewController animated:YES];
}

#pragma mark - Event response

#pragma mark - Private methods

- (void)loadData {
    [self loadDataWithPageNumber:1];
}

- (void)loadDataWithPageNumber:(int)pageNumber {
    NSString *url = [NSString stringWithFormat:HOT_ADS_URL, pageNumber];
    [DFVideo getCategoryVideoWithUrl:url
                             success:^(NSObject *result) {
                                 if (!self.data) {
                                     self.data = [[NSMutableArray alloc] init];
                                 }
                                 [self.data addObjectsFromArray:(NSArray *)result];
                                 [self.tableView reloadData];
                             } failure:^(NSError *error) {
                                 //
                             }];
}

#pragma mark - Getters and Setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, 0)
                                                              style:UITableViewStylePlain];
//        _tableView = [[UITableView alloc] init];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DFVideoTableViewCell class]) bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        _tableView.estimatedRowHeight = 0;
        _tableView.rowHeight = 76;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

@end