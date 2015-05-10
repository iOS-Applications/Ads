//
//  AdsTests.m
//  AdsTests
//
//  Created by zhudf on 15/4/14.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DFAppDelegate.h"
#import "DFMainViewController.h"

@interface AdsTests : XCTestCase

@end

@implementation AdsTests

// test开头
// 返回值void
// 没有参数
- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDao {
//    DFAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
//    UINavigationController *navigationController = delegate.window.rootViewController;
//    DFMainViewController *mainViewController = navigationController.topViewController;
//    XCTAssertNotNil(mainViewController);
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testABC {
    
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
