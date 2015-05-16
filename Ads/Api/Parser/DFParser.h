//
//  DFParser.h
//  Ads
//
//  Created by zhudf on 15/5/10.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DFParserType){
    kDFParserType_LatestPageVideoParser,    // 最近更新
    kDFParserType_CategoryPageVideoParser,  // 分类视频 （主要用这个）
    kDFParserType_SearchResultPageVideoParser,  // 搜索结果
    
    kDFParserType_PlaybackPageRelatedVideoParser, // 相关视频
    kDFParserType_PlaybackPageHotestVideoParser,  // 本类最热
};

@interface DFParser : NSObject

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *result))success
          failure:(void (^)(NSError *error))failure;

+ (instancetype)parserWithType:(DFParserType)type;

@end
