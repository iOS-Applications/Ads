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

@interface DFMainViewController ()<UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray    *data;
@property UITableView       *tableView;

@end

@implementation DFMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"最新更新";
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTableView];
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

- (void)setUpTableView {
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
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // GB2312
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        // test
        NSString *urlString = @"http://www.adzop.com/downinfo/29768.html";    // videp page
        urlString = @"http://www.adzop.com/downnew/0_1.html"; // latest page
//        *urlString = @"http://www.adzop.com/downlist/s_89_1.html"; // category page
//        urlString = @"http://www.adzop.com/downlist/s_62_1.html";
//        urlString = @"http://www.adzop.com/search.asp?keyword=%C1%D6%D6%BE%C1%E1&Submit.x=0&Submit.y=0&action=s&sType=ResName";// 下载搜索·
        
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString]
                                                  encoding:enc
                                                     error:nil];
        // 必须转换编码, 内部解析的时候会用到这个
        html = [html stringByReplacingOccurrencesOfString:@"charset=gb2312" withString:@"charset=utf-8"];

        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        
//        self.data = [DFHtmlParser parseVideoPage:data];
        self.data = [DFHtmlParser parseNewPage:data];
//        self.data = [BBHtmlParser parseCategoryPage:data];
//        self.data = [BBHtmlParser parseSearchPage:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
}
@end