//
//  BBVideoViewController.m
//  LoveAD
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoViewController.h"
#import "VMediaPlayer.h"
#import "DFHtmlParser.h"

@interface DFVideoViewController ()<VMediaPlayerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView         *backView;
@property (weak, nonatomic) IBOutlet UIView         *carrierView;

@property (weak, nonatomic) IBOutlet UITableView    *tableView;
@property (nonatomic) NSMutableArray                            *data;

@property (nonatomic) VMediaPlayer *player;

@property (nonatomic) BOOL videoHasStopped;

@end

@implementation DFVideoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.videoHasStopped = NO;
    }
    return self;
}

#pragma  mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.video.videoTitle;
    
    [self setUpViews];
    [self getVideoUri];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self stopPlayback];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private methods

- (void)setUpViews {
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

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
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // GB2312
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        // 热门
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:self.video.videoPageUrl]
                                                  encoding:enc
                                                     error:nil];
        // 必须转换编码, 内部解析的时候会用到这个
        html = [html stringByReplacingOccurrencesOfString:@"charset=gb2312" withString:@"charset=utf-8"];
        
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        
        self.data = [DFHtmlParser parseVideoPage:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (void)stopPlayback {
    if (!self.videoHasStopped) {
        [self.player reset];
        [self.player unSetupPlayer];
    }
    self.videoHasStopped = YES;
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

#pragma mark - UITableView datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *RelatedCellIdentifier = @"RelatedCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RelatedCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:RelatedCellIdentifier];
    }
    
    DFAdVideo *video = [self.data objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:video.videoImage]
                      placeholderImage:[UIImage imageNamed:@"image_animal_2"]];
    cell.textLabel.text = video.videoTitle;
    cell.detailTextLabel.text = video.videoPageUrl;
    
    return cell;
}

#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self stopPlayback];
    DFAdVideo *video = [self.data objectAtIndex:indexPath.row];
    DFVideoViewController *videoViewController = [[DFVideoViewController alloc] initWithNibName:nil bundle:nil];
    videoViewController.video = video;
    [self.navigationController pushViewController:videoViewController animated:YES];
    
    // 修改NavigationControl的Stack
    self.navigationController.viewControllers = [NSArray arrayWithObjects:[self.navigationController.viewControllers firstObject], videoViewController, nil];
    NSLog(@"%@", self.navigationController.viewControllers);
}
@end