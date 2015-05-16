//
//  DFParser.m
//  Ads
//
//  Created by zhudf on 15/5/10.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFParser.h"
#import "DFLatestPageParser.h"
#import "DFCategoryPageParser.h"
#import "DFSearchResultPageParser.h"
#import "DFVideoPageHotestVideoParser.h"
#import "DFVideoPageRecommandedVideoParser.h"

@implementation DFParser

//- (instancetype)init {
    // 抛出异常
//    @throw [NSException exceptionWithName:@"DFInitFailedException"
//                                   reason:@"不允许调用init方法, 使用类方法parserWithType."
//                                 userInfo:nil];
//}

+ (instancetype)parserWithType:(DFParserType)type {
    switch (type) {
        case kDFParserType_LatestPageVideoParser:
            // 最近更新页面 http://www.adzop.com/downnew/0_1.html
            return [DFLatestPageParser new];
        case kDFParserType_CategoryPageVideoParser:
            // 分类查询页面 http://www.adzop.com/downlist/r_3_1.html
            return [DFCategoryPageParser new];
        case kDFParserType_SearchResultPageVideoParser:
            /* 搜索结果 */
            return [DFSearchResultPageParser new];
        case kDFParserType_PlaybackPageRelatedVideoParser:
            /* 推荐视频 */
            return [DFVideoPageRecommandedVideoParser new];
        case kDFParserType_PlaybackPageHotestVideoParser:
            /* 推荐视频 */
            return [DFVideoPageHotestVideoParser new];
    }
    return nil;
}

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure{
    // 子类去实现
}
@end

