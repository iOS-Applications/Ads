//
//  BBVideoViewController.m
//  LoveAD
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoViewController.h"
#import "VMediaPlayer.h"

@interface DFVideoViewController ()<VMediaPlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *carrierView;

@property (nonatomic) VMediaPlayer *player;

@end

@implementation DFVideoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

#pragma  mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.video.videoTitle;
    [self getVideoUri];
}

- (void)viewWillDisappear:(BOOL)animated {
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player reset];
    [self.player unSetupPlayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Actions

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - Vitamio

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

// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start] 来开始音视频的播放.
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg {
    [player start];
    [player setVideoFillMode:VMVideoFillMode100];
    [player setVideoQuality:VMVideoQualityHigh];
}

// 当'该音视频播放完毕'时, 该协议方法被调用, 我们可以在此作一些播放器善后  操作, 如: 重置播放器, 准备播放下一个音视频等
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg {
    [player reset];
}

// 如果播放由于某某原因发生了错误, 导致无法正常播放, 该协议方法被调用, 参数 arg 包含了错误原因.
- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg {
    NSLog(@"NAL 1RRE &&&& VMediaPlayer Error: %@", arg);
}
@end
