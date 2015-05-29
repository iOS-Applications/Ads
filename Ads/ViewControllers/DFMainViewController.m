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
#import <MJRefresh/UIView+MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

#import "DFConstants.h"
#import "DFVideoCell.h"
#import "DFVideoViewController.h"
#import "DFVideoTableViewCell.h"
#import "DFVideo.h"
#import "DFMainControllerTableViewCell.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface DFMainViewController ()<UITableViewDataSource, UITableViewDelegate>

/* 在block里面修改也不需要加__block修饰· */
@property (nonatomic, retain) UITableView       *tableView;
@property (nonatomic, retain) NSMutableArray    *data;

@property (nonatomic, assign) int               currentPage;

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
    [self layoutPageSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self loadNewData];
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
//    DFVideoViewController *videoViewController = [[DFVideoViewController alloc] initWithNibName:nil bundle:nil];
    DFVideoViewController *videoViewController = [DFVideoViewController new];
    videoViewController.video = video;
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] init];
//    backBarButtonItem.title = @"";
    self.navigationItem.backBarButtonItem = backBarButtonItem;
    [self.navigationController pushViewController:videoViewController animated:YES];
}

#pragma mark - Event response

#pragma mark - Private methods

- (void)loadNewData {
    [self loadDataWithPageNumber:1];
    self.currentPage = 1;
}

- (void)loadMoreData {
    self.currentPage++;
    [self loadDataWithPageNumber:self.currentPage];
}

- (void)loadDataWithPageNumber:(int)pageNumber {
    __weak typeof(self) weakSelf = self;
    
    NSString *url = [NSString stringWithFormat:HOT_ADS_URL, pageNumber];
    [DFVideo getCategoryVideoWithUrl:url
                             success:^(NSObject *result) {
                                 NSArray *newData = (NSArray *)result;
                                 if (pageNumber == 1 && [newData count] != 0) {
                                     [weakSelf.data removeAllObjects];
                                 }
                                 [weakSelf.data addObjectsFromArray:newData];
                                 [weakSelf.tableView reloadData];
                                 
                                 if ([weakSelf.tableView.header isRefreshing]) {
                                     [weakSelf.tableView.header endRefreshing];
                                 }
                                 if ([weakSelf.tableView.footer isRefreshing]) {
                                     [weakSelf.tableView.footer endRefreshing];
                                 }
                             } failure:^(NSError *error) {
                                 if ([weakSelf.tableView.header isRefreshing]) {
                                     [weakSelf.tableView.header endRefreshing];
                                 }
                                 if ([weakSelf.tableView.footer isRefreshing]) {
                                     [weakSelf.tableView.footer endRefreshing];
                                 }
                                 weakSelf.currentPage--;
                             }];
}

- (void)layoutPageSubviews {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 16));
    }];
}

#pragma mark - Getters and Setters

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DFVideoTableViewCell class]) bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        _tableView.rowHeight = 76;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
       
        // 下拉刷新
        // 添加动画图片的下拉刷新
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
        [_tableView addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        
        // 设置普通状态的动画图片
        NSMutableArray *idleImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=60; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
            [idleImages addObject:image];
        }
        [_tableView.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
        
        // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
            [refreshingImages addObject:image];
        }
        [_tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStatePulling];
        
        // 设置正在刷新状态的动画图片
        [_tableView.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
        // 在这个例子中，即将刷新 和 正在刷新 用的是一样的动画图片
        
        // 马上进入刷新状态
        [_tableView.gifHeader beginRefreshing];
        
        // 此时self.tableView.header == self.tableView.gifHeader
        
        
        __weak typeof(self) weakSelf = self;
        // 上拉刷新
        // 添加传统的上拉刷新
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        [self.tableView addLegendFooterWithRefreshingBlock:^{
            [weakSelf loadMoreData];
        }];
    }
    return _tableView;
}

- (NSMutableArray *)data {
    if (_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
}
@end