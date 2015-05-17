//
//  BBVideoViewController.m
//  Ads 
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoViewController.h"
#import <Masonry/Masonry.h>
#import "VMediaPlayer.h"
#import "DFHtmlParser.h"
#import "DFVideoTableViewCell.h"
#import "DFConstants.h"

static NSString *CellIdentifier = @"CellIdentifier";

@interface DFVideoViewController ()<VMediaPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIView        *backView;
@property (nonatomic, strong) UIView        *carrierView;
@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) UILabel       *categoryLable;

@property (nonatomic, retain) NSMutableArray *data;

@property (nonatomic, retain) VMediaPlayer   *player;

@property (nonatomic, assign) BOOL           videoHasStopped;

@end

@implementation DFVideoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.videoHasStopped = NO;
    }
    return self;
}

#pragma  mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.video.videoTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.backView addSubview:self.carrierView];
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.categoryLable];
    [self.view addSubview:self.tableView];
    
    [self layoutPageSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self getVideoUri];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopPlayback];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Vitamio control

- (void)play:(NSString *)uri {
    self.player = [VMediaPlayer sharedInstance];
    [self.player setupPlayerWithCarrierView:self.carrierView withDelegate:self];
    [self.player setDataSource:[NSURL URLWithString:uri]];
    [self.player prepareAsync];
}

- (void)changeMode {
    static emVMVideoFillMode modes[] = {
        VMVideoFillModeFit,
        VMVideoFillMode100,
        VMVideoFillModeCrop,
        VMVideoFillModeStretch,
    };
    static int curModeIdx = 0;
    
    curModeIdx = (curModeIdx + 1) % (int)(sizeof(modes)/sizeof(modes[0]));
    [self.player setVideoFillMode:modes[curModeIdx]];
    NSLog(@"Mode Index: %d", curModeIdx);
}

#pragma mark - Vitamio delegate

// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start] 来开始音视频的播放.
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg {
    [player start];
    [player setVideoFillMode:VMVideoFillMode100];
    [player setVideoQuality:VMVideoQualityHigh];
    
    // 加载完后，获取相关视频
    [self loadData];
}

// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后  操作, 如: 重置播放器, 准备播放下一个音视频等
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg {
    [player reset];
}

// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参数 arg 包含了错误原因.
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg {
    NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    DFVideo *video = [self.data objectAtIndex:indexPath.row];
    [cell setVideo:video];
    return cell;
}

#pragma mark - UITableViewelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopPlayback];
    DFVideo *video = [self.data objectAtIndex:indexPath.row];
    DFVideoViewController *videoViewController = [[DFVideoViewController alloc] initWithNibName:nil bundle:nil];
    videoViewController.video = video;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
    // 修改NavigationControl的Stack
    self.navigationController.viewControllers = [NSArray arrayWithObjects:[self.navigationController.viewControllers firstObject], videoViewController, nil];
    NSLog(@"%@", self.navigationController.viewControllers);
}
#pragma mark - Private methods

- (void)getVideoUri {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.video.videoPageUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"Error");
        } else {
            // kCFStringEncodingGB_2312_80 这个不是gb2312
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *html = [[NSString alloc] initWithData:data encoding:enc];
            
            NSRange range = [html rangeOfString:@"var vMp4url.*;"
                                        options:NSRegularExpressionSearch];
            
            if (range.location == NSNotFound) {
                range = [html rangeOfString:@"so.addVariable.+\"http://v.adzop.com.+\""
                                    options:NSRegularExpressionSearch];
            }
            
            if (range.location == NSNotFound) {
                // TODO 关闭当前页面
                return;
            }
            
            NSString *result = [html substringWithRange:range];
            range = [result rangeOfString:@"http://.+\"" options:NSRegularExpressionSearch];
            
            if (range.location != NSNotFound) {
                range.length--;
                NSString *realVideoUri = [result substringWithRange:range];
                [self play:realVideoUri];
            }
        }
    }];
}

- (void)loadData {
    [DFVideo getHotestVideoWithUrl:self.video.videoPageUrl
                           success:^(NSObject *result) {
                               [self.data addObjectsFromArray:(NSArray *)result];
                               [self.tableView reloadData];
                           } failure:^(NSError *error) {
                               // TODO
                           }];
}

- (void)stopPlayback {
    if (!self.videoHasStopped) {
        [self.player reset];
        [self.player unSetupPlayer];
    }
    self.videoHasStopped = YES;
}

- (void)layoutPageSubviews
{
    UIView *superView = self.view;
    CGFloat padding = 8.0;
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(superView.mas_leading).offset(padding * 2);
        make.trailing.equalTo(superView.mas_trailing).offset(-padding * 2);
        make.top.equalTo(superView.mas_top).offset(padding + 20 + 44);
        make.bottom.equalTo(self.categoryLable.mas_top).offset(-padding);
        
        make.height.equalTo(@135);
    }];
    
    [self.carrierView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
    
    [self.categoryLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.and.trailing.equalTo(self.backView);
        make.top.equalTo(self.backView.mas_bottom).offset(padding);
        make.bottom.equalTo(self.tableView.mas_top).offset(-padding);
        
        make.height.greaterThanOrEqualTo(@20);
    }];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_leading);
        make.trailing.equalTo(superView.mas_trailing).offset(-padding * 2);
        make.top.equalTo(self.categoryLable.mas_bottom).offset(padding);
        make.bottom.equalTo(superView.mas_bottom).offset(-padding);
    }];
}

#pragma mark - Getters and Setters
- (UIView *)backView
{
    if (_backView == nil) {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor blackColor];
        [_backView setClipsToBounds:YES];
    }
    return _backView;
}

- (UIView *)carrierView
{
    if (_carrierView == nil) {
        _carrierView = [UIView new];
    }
    return _carrierView;
}

- (UIView *)tableView
{
    if (_tableView == nil) {
        _tableView = [UITableView new];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([DFVideoTableViewCell class]) bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        _tableView.rowHeight    = 66.0;
        _tableView.dataSource   = self;
        _tableView.delegate     = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 8, 0, 8);
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (UILabel *)categoryLable
{
    if (_categoryLable == nil) {
        _categoryLable = [UILabel new];
        _categoryLable.textColor = [UIColor blueColor];
        _categoryLable.text = @"推荐视频";
    }
    return _categoryLable;
}
- (NSMutableArray *)data
{
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}
@end