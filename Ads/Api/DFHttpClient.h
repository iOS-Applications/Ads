//
//  DFHttpClient.h
//  Ads
//
//  Created by zhudf on 15/5/8.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFParser.h"

typedef void (^DFHttpRequestSuccessBlock)(NSObject *result);
typedef void (^DFHttpRequestFailureBlock)(NSError *error);

@interface DFHttpClient : NSObject

+ (instancetype)shareInstance;

- (void)requestWithUrl:(NSString *)url
            parserType:(DFParserType)parserType
               success:(DFHttpRequestSuccessBlock)success
               failure:(DFHttpRequestFailureBlock)failure;

- (void)requestWithUrl:(NSString *)url
             parameters:(NSDictionary *)params
            parserType:(DFParserType)type
               success:(DFHttpRequestSuccessBlock)success
               failure:(DFHttpRequestFailureBlock)failure;
@end
