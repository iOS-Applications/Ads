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

@interface DFVideoPlayer ()<VMediaPlayerDelegate, DFVideoControlViewDelegate>

@property (nonatomic, strong) VMediaPlayer *mediaPlayer;

@property (nonatomic, weak)     UIView *parentView;

@property (nonatomic, assign)   long duration;
@property (nonatomic, strong)   NSTimer *durationTimer;

@property (nonatomic, assign)   BOOL progressDragging;
@property (nonatomic, copy)     NSURL *videoUrl;

@property (nonatomic, copy) NSArray *constraints;
@end

@implementation DFVideoPlayer

#pragma mark - Life Cycle

- (instancetype)initWithURL:(NSURL *)videoUrl
{
    if (self = [super init]) {
        self.videoUrl = videoUrl;
    }
    return self;
}

- (void)showInWindow
{
    UIWindow *windown = [UIApplication sharedApplication].keyWindow;
    if (!windown) {
        windown = [[UIApplication sharedApplication].windows firstObject];
    }
    [self.backView addSubview:self.carrierView];
    [self.backView addSubview:self.videoControlView];
    [windown addSubview:self.backView];
    
    self.parentView = windown;
    [self addFixedConstraintsForSubviews];
    [self updateConstraints];
}

- (void)showInParentView:(UIView *)parentView
{
    [self.backView addSubview:self.carrierView];
    [self.backView addSubview:self.videoControlView];
    [parentView addSubview:self.backView];
    
    self.parentView = parentView;
    [self addFixedConstraintsForSubviews];
    [self updateConstraints];
}

- (void)start
{
    [self startPlayerWithUrl:self.videoUrl];
}

- (void)updateConstraints
{
    UIInterfaceOrientation interfaceOrientaion = [UIApplication sharedApplication].statusBarOrientation;
    [self updateConstraintsForInterfaceOrientation:interfaceOrientaion];
}

/* 这块的处理是从AdaptivePhoto项目中学到的 */
- (void)updateConstraintsForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    NSDictionary *views = @{@"backView":self.backView};
    NSMutableArray *newConstraints = [NSMutableArray array];
    
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[backView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
        [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-64-[backView]"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
        [newConstraints addObject:[NSLayoutConstraint constraintWithItem:self.backView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.parentView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:(9.0 / 16.0)
                                                                constant:0.0]];
    } else {
        [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[backView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
        [newConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[backView]|"
                                                                                    options:0
                                                                                    metrics:nil
                                                                                      views:views]];
    }
    
    if (self.constraints) {
        [self.parentView removeConstraints:self.constraints];
    }
    self.constraints = newConstraints;
    [self.parentView addConstraints:self.constraints];
    
    // 强制刷新，必须要得到carrierView的frame。因为Vitamio不支持autolayout
    // How can I get a view's current width and height when using autolayout constraints
    // http://stackoverflow.com/a/13542580/3355097
    [self.parentView layoutIfNeeded];
}

- (void)addFixedConstraintsForSubviews
{
    NSDictionary *views = @{@"carrierView":self.carrierView, @"videoControlView":self.videoControlView};
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[carrierView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[videoControlView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[carrierView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
    [self.backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[videoControlView]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views]];
}

#pragma mark - DFVideoControlView

- (void)videoControlView:(DFVideoControlView *)controlView didPlayButtonClicked:(UIButton *)playerButton
{
    if (![self.mediaPlayer isPlaying]) {
        [self.mediaPlayer start];
    }
}

- (void)videoControlView:(DFVideoControlView *)controlView didPauseButtonClicked:(UIButton *)pauseButton
{
    if ([self.mediaPlayer isPlaying]) {
        [self.mediaPlayer pause];
    }
}

- (void)videoControlView:(DFVideoControlView *)controlView didCloseButtonClicked:(UIButton *)closeButton
{
    [self stopPlayer];
}

- (void)videoControlView:(DFVideoControlView *)controlView didFullScreenButtonClicked:(UIButton *)fullScrrenButton
{
}

- (void)videoControlView:(DFVideoControlView *)controlView didShrinkScreenButtonClicked:(UIButton *)shrinkScreenButton
{
    NSLog(@"shrinkScreen");
    [self.backView layoutIfNeeded];
}

- (void)videoControlView:(DFVideoControlView *)controlView didProgressSliderDragBegan:(UISlider *)sener
{
    self.progressDragging = YES;
}

- (void)videoControlView:(DFVideoControlView *)controlView didProgressSliderDragEnded:(UISlider *)sener
{
    [self.mediaPlayer seekTo:sener.value * self.duration];
}

#pragma mark - VMediaPlayerDelegate required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    [player start];
    [player setVideoFillMode:VMVideoFillModeFit];
    [player setVideoQuality:VMVideoQualityHigh];
    
    [self.videoControlView setStarted:YES];
    
    self.duration = [player getDuration];
    [self startDurationTimer];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
    [self.videoControlView setStarted:NO];
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    [self.videoControlView setStarted:NO];
}

#pragma mark - VMediaPlayerDelegate optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
	player.decodingSchemeHint = VMDecodingSchemeSoftware;
	player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
	// Set buffer size, default is 1024KB(1024*1024).
	[player setBufferSize:512*1024];
	[player setVideoQuality:VMVideoQualityHigh];
    
	player.useCache = YES;
	[player setCacheDirectory:[self cacheRootDirectory]];
}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    self.progressDragging = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
	self.progressDragging = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
    [self.mediaPlayer pause];
    
	self.progressDragging = YES;
    [self.videoControlView setBuffering:YES];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    [self.videoControlView updateBufferedProgress:[arg intValue]];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
    [self.mediaPlayer start];
    
	self.progressDragging = NO;
    [self.videoControlView setBuffering:NO];
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
//	if (![Utilities isLocalMedia:self.videoURL]) {
//		self.downloadRate.text = [NSString stringWithFormat:@"%dKB/s", [arg intValue]];
//	} else {
//		self.downloadRate.text = nil;
//	}
}

#pragma mark - Event reponse

- (void)updateProgress
{
	if (!self.progressDragging) {
        [self.videoControlView updateProgress:[self.mediaPlayer getCurrentPosition] totalTime:self.duration];
	}
}

#pragma mark - Private methods

- (void)startPlayerWithUrl:(NSURL *)url
{
    [self.mediaPlayer setDataSource:url];
    [self.mediaPlayer prepareAsync];
}

- (void)stopPlayer
{
    [self.mediaPlayer reset];
    [self stopDurationTimer];
}

- (NSString *)cacheRootDirectory
{
	NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
								  withIntermediateDirectories:YES
												   attributes:nil
														error:NULL];
    }
	return cache;
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer timerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(updateProgress)
                                               userInfo:nil
                                                repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

#pragma mark - Getters and Setters

- (DFVideoControlView *)videoControlView
{
    if (!_videoControlView) {
        _videoControlView = [[DFVideoControlView alloc] init];
        _videoControlView.userInteractionEnabled = YES;
        _videoControlView.delegate = self;
        _videoControlView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _videoControlView;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setClipsToBounds:YES];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backView;
}

- (UIView *)carrierView
{
    if (!_carrierView) {
        _carrierView = [[UIView alloc] init];
        _carrierView.backgroundColor = [UIColor clearColor];
        _carrierView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _carrierView;
}

- (VMediaPlayer *)mediaPlayer
{
    if (!_mediaPlayer) {
        _mediaPlayer = [VMediaPlayer sharedInstance];
        [_mediaPlayer setupPlayerWithCarrierView:self.carrierView withDelegate:self];
    }
    return _mediaPlayer;
}
@end