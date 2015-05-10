//
//  DFApi.h
//  Ads
//
//  Created by zhudf on 15/5/8.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFHttpClient.h"
#import "DFParser.h"

@interface DFApi : NSObject

+ (instancetype)shareDFApi;

- (void)requestWithUrl:(NSString *)url
            parserType:(DFParserType)parserType
               success:(successBlock)success
               failure:(failureBlock)failure;

- (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)params
            parserType:(DFParserType)parserType
               success:(successBlock)success
               failure:(failureBlock)failure;

@end
