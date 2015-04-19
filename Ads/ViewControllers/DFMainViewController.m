//
//  BBMainViewController.m
//  LoveAD
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFMainViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIView+WebCacheOperation.h>
#import "DFConstants.h"

@interface DFMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray    *data;
@property UITableView       *tableView;

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
    // Do any additional setup after loading the view.
    [self setUpViews];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidAppear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma  mark - Private Methods

- (void)setUpViews {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectOffset(self.view.frame, 0, 8)
                                                          style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 60;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.dataSource   = self;
    self.tableView.delegate     = self;
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:self.tableView];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *Identifier = @"Identifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }

    DFAdVideo *video = [self.data objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:video.videoImage]
                      placeholderImage:[UIImage imageNamed:@"image_animal_2"]];
    cell.textLabel.text         = video.videoTitle;
    cell.detailTextLabel.text   = video.videoPageUrl;
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DFAdVideo *video = [self.data objectAtIndex:indexPath.row];
    DFVideoViewController *videoViewController = [[DFVideoViewController alloc] initWithNibName:nil bundle:nil];
    videoViewController.video = video;
    [self.navigationController pushViewController:videoViewController animated:YES];
}

#pragma mark - Load Data

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
@end