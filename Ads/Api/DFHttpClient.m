//
//  DFHttpClient.m
//  Ads
//
//  Created by zhudf on 15/5/8.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFHttpClient.h"
#import "DFConstants.h"

@implementation DFHttpClient

static const NSString *gbk = @"";

+ (instancetype)shareInstance
{
    static DFHttpClient *httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpClient = [[DFHttpClient alloc] init];
    });
    return httpClient;
}

- (void)requestWithUrl:(NSString *)url
            parserType:(DFParserType)parserType
               success:(DFHttpRequestSuccessBlock)success
               failure:(DFHttpRequestFailureBlock)failure
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // GB2312
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        // 热门
        NSString *html = [NSString stringWithContentsOfURL:[NSURL URLWithString:url]
                                                  encoding:enc
                                                     error:nil];
        // 必须转换编码, 内部解析的时候会用到这个
        html = [html stringByReplacingOccurrencesOfString:@"charset=gb2312" withString:@"charset=utf-8"];
        
        // 使用TFHpple解析必须是utf-8编码
        NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
        
        [[DFParser parserWithType:parserType] parseData:data
                                                success:^(NSArray *result) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        success(result);
                                                    });
                                                } failure:^(NSError *error) {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        failure(error);
                                                    });
                                                }];
        
    });
}

- (void)requestWithUrl:(NSString *)url
            parameters:(NSDictionary *)params
            parserType:(DFParserType)type
               success:(DFHttpRequestSuccessBlock)success
               failure:(DFHttpRequestFailureBlock)failure
{
    
}

@end

