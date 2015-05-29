//
//  ViewController.m
//  DFVitamioVideoPlayer
//
//  Created by zhudf on 15/5/29.
//  Copyright (c) 2015年 朱东方. All rights reserved.
//

#import "DFVideoPlayerController.h"
#import "KRVideoPlayerControlView.h"

@interface DFVideoPlayerController ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *carrierView;
@property (nonatomic, strong) KRVideoPlayerControlView *videoControlView;

@end

@implementation DFVideoPlayerController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.backView];
    [self.view addSubview:self.carrierView];
    [self.view addSubview:self.videoControlView];
    
    [self layoutSubViewsUsingMasonry];
}
#pragma mark - KRVideoPlayerControlViewDelegate

#pragma mark - Actions

#pragma mark - Private Methods

- (void)layoutSubViewsUsingMasonry {
    
}

#pragma mark - Getters and Setters

- (KRVideoPlayerControlView *)videoControlView {
    if (!_videoControlView) {
        _videoControlView = [[KRVideoPlayerControlView alloc] init];
    }
    return _videoControlView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIView *)carrierView {
    if (!_carrierView) {
        _carrierView = [[UIView alloc] init];
    }
    return _carrierView;
}
@end