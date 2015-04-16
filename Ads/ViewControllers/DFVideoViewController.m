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

@property UIView *videoView;

@property VMediaPlayer *player;

@end

@implementation DFVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *videoView = [[UIView alloc] init];
    UIView *backView = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    label.text = self.video.videoPageUrl;
    [button setTitle:@"GoBack" forState:UIControlStateNormal];
    label.backgroundColor = [UIColor yellowColor];
    button.backgroundColor = [UIColor greenColor];
    button2.backgroundColor = [UIColor greenColor];
    
    [self.view addSubview:videoView];
    [self.view addSubview:label];
    [self.view addSubview:button];
    [self.view addSubview:button2];
    
    [backView.layer setMasksToBounds:YES];
    
    [videoView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button setTranslatesAutoresizingMaskIntoConstraints:NO];
    [button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.videoView = videoView;
    [self.videoView addSubview:backView];
    
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(label, button,videoView,button2,backView);
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[videoView(==180)]-[button2(>=50)]-(>=20)-[label(>=50)]-[button(==label)]-20-|"
                                                                      options:NSLayoutFormatAlignAllLeading | NSLayoutFormatAlignAllTrailing
                                                                      metrics:0
                                                                        views:viewDict]];
   [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[videoView]-20-|"
                                                                     options:0
                                                                     metrics:0
                                                                       views:viewDict]];
    
    [self.videoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[backView]|"
                                                                          options:0
                                                                          metrics:0
                                                                            views:viewDict]];
    [self.videoView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[backView]|"
                                                                          options:0
                                                                          metrics:0
                                                                            views:viewDict]];
    
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(changeMode) forControlEvents:UIControlEventTouchUpInside];
    
    
    // test
    self.videoView.layer.borderWidth = 4.0;
    self.videoView.layer.borderColor = [UIColor redColor].CGColor;
    [self getVideoUri];
    
}

#pragma mark - UI Actions

- (void)goBack {
    [self.player reset];
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getVideoUri {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.video.videoPageUrl]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //
        if (connectionError) {
            NSLog(@"Error");
        } else {
            // gb2312
//            kCFStringEncodingGB_2312_80 这个不是gb2312
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
//                    BBPlayerViewController *player = [[BBPlayerViewController alloc] initWithContentURL:[NSURL URLWithString:realUri]];
//                    [self presentMoviePlayerViewControllerAnimated:player];
                [self play:realVideoUri];
            }
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.player unSetupPlayer];
}

- (void)play:(NSString *)uri {
    self.player = [VMediaPlayer sharedInstance];
    [self.player setupPlayerWithCarrierView:self.videoView withDelegate:self];
    [self.player setDataSource:[NSURL URLWithString:uri]];
    [self.player prepareAsync];
}

#pragma mark - Vitamio Delegate

// 当'播放器准备完成'时, 该协议方法被调用, 我们可以在此调用 [player start] 来开始音视频的播放.
- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg {
    [player start];
    [player setVideoFillMode:VMVideoFillMode100];
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
