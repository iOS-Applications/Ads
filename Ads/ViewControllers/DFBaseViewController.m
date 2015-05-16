//
//  BaseViewController.m
//  Ads
//
//  Created by zhudf on 15/5/9.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFBaseViewController.h"
#import <UMengAnalytics/MobClick.h>

@interface DFBaseViewController ()

@end

@implementation DFBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", @"viewDidLoad");
}


- (void)viewWillAppear:(BOOL)animated {
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
    NSLog(@"%@", @"viewWillAppear");
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"%@", @"viewDidAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [MobClick endLogPageView:NSStringFromClass([self class])];
    NSLog(@"%@", @"viewWillDisappear");
}

- (void)viewDidDisappear:(BOOL)animated {
    NSLog(@"%@", @"viewDidDisAppear");
}

- (void)viewDidUnload {
    NSLog(@"%@", @"viewDidUnload");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"%@", @"didReceiveMemoryWarning");
}

- (void)showProgressViewWithMessage:(NSString *)message {
    
}

- (void)dismissProgressView {
    
}

@end