//
//  DFVideoDao.m
//  Ads
//
//  Created by zhudf on 15/4/28.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoDao.h"
#import "DFVideo.h"
#import <AFNetworking/AFNetworking.h>

@implementation DFVideoDao


- (void)test {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //
    }];
}
@end
