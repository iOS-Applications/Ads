//
//  ViewController.m
//  DFVitamioVideoPlayer
//
//  Created by zhudf on 15/5/29.
//  Copyright (c) 2015年 朱东方. All rights reserved.
//

#import "DFVideoPlayer.h"
#import "DFVideoControlView.h"
#import "Vitamio.h"

#define kTestVideoUrl @"http://krtv.qiniudn.com/150522nextapp"

@interface DFVideoPlayer ()<VMediaPlayerDelegate, DFVideoControlViewDelegate>
{
    CGFloat width;
}

@property (nonatomic, strong) VMediaPlayer *mediaPlayer;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *carrierView;

@property (nonatomic, strong) DFVideoControlView *videoControlView;

@property (nonatomic, assign) long duration;
@property (nonatomic, strong) NSTimer *durationTimer;

@property (nonatomic, assign) BOOL progressDragging;

@end

@implementation DFVideoPlayer

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    width = [UIScreen mainScreen].bounds.size.width;
    [self.backView addSubview:self.carrierView];
    [self.backView addSubview:self.videoControlView];
    [self.view addSubview:self.backView];
    
    [self layoutSubViewsUsingMasonry];
    
    [self startPlayerWithUrl:[NSURL URLWithString:kTestVideoUrl]];
}

- (void)viewDidAppear:(BOOL)animated {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)viewDidDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
#pragma mark - DFVideoControlView
- (void)videoControlView:(DFVideoControlView *)controlView didPlayButtonClicked:(UIButton *)playerButton {
    if (![self.mediaPlayer isPlaying]) {
        [self.mediaPlayer start];
    }
}

- (void)videoControlView:(DFVideoControlView *)controlView didPauseButtonClicked:(UIButton *)pauseButton {
    if ([self.mediaPlayer isPlaying]) {
        [self.mediaPlayer pause];
    }
}

- (void)videoControlView:(DFVideoControlView *)controlView didCloseButtonClicked:(UIButton *)closeButton {
    NSLog(@"close");
    [self stopPlayer];
}

- (void)videoControlView:(DFVideoControlView *)controlView didFullScreenButtonClicked:(UIButton *)fullScrrenButton {
    NSLog(@"fullScreen");
}

- (void)videoControlView:(DFVideoControlView *)controlView didShrinkScreenButtonClicked:(UIButton *)shrinkScreenButton {
    NSLog(@"shrinkScreen");
}

- (void)videoControlView:(DFVideoControlView *)controlView didProgressSliderDragBegan:(UISlider *)sener {
    self.progressDragging = YES;
}

- (void)videoControlView:(DFVideoControlView *)controlView didProgressSliderDragEnded:(UISlider *)sener {
    [self.mediaPlayer seekTo:sener.value * self.duration];
}

#pragma mark - VMediaPlayerDelegate required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg {
    [player start];
    [player setVideoFillMode:VMVideoFillModeFit];
    [player setVideoQuality:VMVideoQualityHigh];
    
    [self.videoControlView setStarted:YES];
    
    self.duration = [player getDuration];
    [self startDurationTimer];
}
- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg {
    [self.videoControlView setStarted:NO];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg {
    [self.videoControlView setStarted:NO];
}

#pragma mark - VMediaPlayerDelegate optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg {
	player.decodingSchemeHint = VMDecodingSchemeSoftware;
	player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg {
	// Set buffer size, default is 1024KB(1024*1024).
	[player setBufferSize:512*1024];
	[player setVideoQuality:VMVideoQualityHigh];
    
	player.useCache = YES;
	[player setCacheDirectory:[self cacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg {
    self.progressDragging = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg {
	self.progressDragging = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg {
    [self.mediaPlayer pause];
    
	self.progressDragging = YES;
    [self.videoControlView setBuffering:YES];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg {
    [self.videoControlView updateBufferedProgress:[arg intValue]];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg {
    [self.mediaPlayer start];
    
	self.progressDragging = NO;
    [self.videoControlView setBuffering:NO];
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg {
//	if (![Utilities isLocalMedia:self.videoURL]) {
//		self.downloadRate.text = [NSString stringWithFormat:@"%dKB/s", [arg intValue]];
//	} else {
//		self.downloadRate.text = nil;
//	}
}

#pragma mark - Event reponse

- (void)updateProgress {
	if (!self.progressDragging) {
        [self.videoControlView updateProgress:[self.mediaPlayer getCurrentPosition] totalTime:self.duration];
	}
}

#pragma mark - Private methods

- (void)layoutSubViewsUsingMasonry {
    
}

- (void)startPlayerWithUrl:(NSURL *)url {
    [self.mediaPlayer setDataSource:url];
    [self.mediaPlayer prepareAsync];
}

- (void)stopPlayer {
    [self.mediaPlayer reset];
    [self stopPlayer];
}

- (NSString *)cacheRootDirectory {
	NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
    }
	return cache;
}

- (void)startDurationTimer {
    self.durationTimer = [NSTimer timerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateProgress)
                                               userInfo:nil
                                                repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
}

- (void)stopDurationTimer {
    [self.durationTimer invalidate];
}

#pragma mark - Getters and Setters

- (DFVideoControlView *)videoControlView {
    if (!_videoControlView) {
        _videoControlView = [[DFVideoControlView alloc] init];
        _videoControlView.frame = CGRectMake(0, 0, width, width * (9.0 / 16.0));
        _videoControlView.userInteractionEnabled = YES;
        _videoControlView.delegate = self;
    }
    return _videoControlView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setClipsToBounds:YES];
        _backView.frame = CGRectMake(0, 80, width, width * (9.0 / 16.0));
        _backView.backgroundColor = [UIColor blackColor];
    }
    return _backView;
}

- (UIView *)carrierView {
    if (!_carrierView) {
        _carrierView = [[UIView alloc] init];
        _carrierView.frame = CGRectMake(0, 0, width, width * (9.0 / 16.0));
        _carrierView.backgroundColor = [UIColor greenColor];
    }
    return _carrierView;
}

- (VMediaPlayer *)mediaPlayer {
    if (!_mediaPlayer) {
        _mediaPlayer = [VMediaPlayer sharedInstance];
        [_mediaPlayer setupPlayerWithCarrierView:self.carrierView withDelegate:self];
    }
    return _mediaPlayer;
}
@end