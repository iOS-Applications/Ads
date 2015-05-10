//
//  DFHttpClient.h
//  Ads
//
//  Created by zhudf on 15/5/8.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "DFParser.h"

typedef void (^successBlock)(NSObject *result);
typedef void (^failureBlock)(NSError *error);

@interface DFHttpClient : NSObject

+ (instancetype)shareDFHttpClient;

- (void)requestWithUrl:(NSString *)url
            parserType:(DFParserType)parserType
               success:(successBlock)success
               failure:(failureBlock)failure;

- (void)requestWithUrl:(NSString *)url
             parameters:(NSDictionary *)params
            parserType:(DFParserType)type
               success:(successBlock)success
               failure:(failureBlock)failure;
@end
