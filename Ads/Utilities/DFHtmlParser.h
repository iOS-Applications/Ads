//
//  BBHtmlParser.h
//  Ads
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "DFAdVideo.h"

@interface DFHtmlParser : NSObject

// 解析最近更新视频
+ (NSMutableArray *)parseLatestPage:(NSData *)data;
// 解析视频播放页：相关视频
+ (NSMutableArray *)parseVideoPageRecommandedVideos:(NSData *)data;
// 解析视频播放页：本类最热视频
+ (NSMutableArray *)parseVideoPageHotestVideos:(NSData *)data;
// 解析分类视频页
+ (NSMutableArray *)parseCategoryPage:(NSData *)data;
// 解析搜索结果页
+ (NSMutableArray *)parseSearchPage:(NSData *)data;

@end
