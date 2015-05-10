//
//  DFApi.m
//  Ads
//
//  Created by zhudf on 15/5/8.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFApi.h"

@interface DFApi()

@end

@implementation DFApi

+ (instancetype)shareDFApi
{
    static DFApi *api = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        api = [[self alloc] init];
    });
    return api;
}

- (void)requestWithUrl:(NSString *)url
            parserType:(DFParserType)parserType
               success:(successBlock)success
               failure:(failureBlock)failure
{
    [[DFHttpClient shareDFHttpClient] requestWithUrl:url
                                          parserType:parserType
                                             success:success
                                             failure:failure];
}

- (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)params
            parserType:(DFParserType)parserType
               success:(successBlock)success
               failure:(failureBlock)failure
{
    [[DFHttpClient shareDFHttpClient] requestWithUrl:url
                                          parameters:params
                                          parserType:parserType
                                             success:success
                                             failure:failure];
    
}
@end
