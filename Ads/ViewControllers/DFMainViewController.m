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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // GB2312
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        // 热门
        NSString *url = [NSString stringWithFormat:HOT_ADS_URL, pageNumber];
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                  encoding:enc
                                                     error:nil];
        // 必须转换编码, 内部解析的时候会用到这个
        html = [html stringByReplacingOccurrencesOfString:@"charset=gb2312" withString:@"charset=utf-8"];

        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        
        if (!self.data) {
            self.data = [[NSMutableArray alloc] init];
        }
        [self.data addObjectsFromArray:[DFHtmlParser parseCategoryPage:data]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Getters and Setters

- (UITableView *)tableView {
    if (_tableView == nil) {
//        _tableView = [[UITableView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, 0)
//                                                              style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] init];
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