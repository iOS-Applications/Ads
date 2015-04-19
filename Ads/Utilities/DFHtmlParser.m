//
//  BBHtmlParser.m
//  Ads
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFHtmlParser.h"

@implementation DFHtmlParser

#pragma mark 解析最近更新页面
+ (NSMutableArray *)parseLatestPage:(NSData *)data {
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='newcontent']"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < elements.count; i++) {
        [DFHtmlParser parseLatestElement:[elements objectAtIndex:i] addTo:result];
    }
    return result;
}

+ (void)parseLatestElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
    
    NSArray *children = element.children;
    
    DFAdVideo *ad = [[DFAdVideo alloc] init];
    
    NSObject *obj;
    for (obj in children) {
        TFHppleElement *e = (TFHppleElement *)obj;
        // 标题 链接
        if ([[e.attributes objectForKey:@"class"] isEqualToString:@"newtitle"]) {
            TFHppleElement *e4 = (TFHppleElement *)[e.children objectAtIndex:4];
            NSString *videoPageUrl = [e4.attributes objectForKey:@"href"];
            NSString *videoTitle = ((TFHppleElement *)[e4.children firstObject]).content;
            
            ad.videoPageUrl = videoPageUrl;
            ad.videoTitle = videoTitle;
//            NSLog(@"%@",videoTitle);
//            NSLog(@"%@", videoPageUrl);
        }
        // 更新日期
        if ([[e.attributes objectForKey:@"class"] isEqualToString:@"newupdate"]) {
            NSString *videoUpdateDate = ((TFHppleElement *)[((TFHppleElement *)[e.children firstObject]).children firstObject]).content;
            ad.videoUpdateDate = videoUpdateDate;
//            NSLog(@"%@", videoUpdateDate);
            continue;
        }
    }
    [array addObject:ad];
}

#pragma mark 解析视频播放页 相关推荐视频
+ (NSMutableArray *)parseVideoPageRecommandedVideos:(NSData *)data {
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='infonew']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [DFHtmlParser parseVideoPageRecommandedVideoElement:element addTo:result];
    return result;
}

+ (void)parseVideoPageRecommandedVideoElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
    if (!element.hasChildren) {
        return;
    }
    NSObject *obj;
    for (obj in element.children) {
        TFHppleElement *e = (TFHppleElement *)obj;
        
        if ([e.tagName isEqualToString:@"a"]) {
            NSDictionary *attrs = e.attributes;
            
            DFAdVideo *video = [[DFAdVideo alloc] init];
            video.videoTitle = [attrs objectForKey:@"title"];
            video.videoPageUrl = [attrs objectForKey:@"href"];
            
            NSArray *children = e.children;
            if (children.count > 0) {
                TFHppleElement *e2 = [children firstObject];
                NSDictionary *attrs = e2.attributes;
                video.videoImage = [attrs objectForKey:@"src"];
            }
            
            [array addObject:video];
            break;
        }
        [DFHtmlParser parseVideoPageRecommandedVideoElement:e addTo:array];
    }
}

#pragma mark 解析视频播放页 本类最热视频
+ (NSMutableArray *)parseVideoPageHotestVideos:(NSData *)data {
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='inforank']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    [DFHtmlParser parseVideoPageHotestVideoElement:element addTo:result];
    return result;
}

+ (void)parseVideoPageHotestVideoElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
    if (!element.hasChildren) {
        return;
    }
    
    NSObject *obj;
    for (obj in element.children) {
        TFHppleElement *e = (TFHppleElement *)obj;
        
        if ([e.tagName isEqualToString:@"a"]) {
            NSDictionary *attrs = e.attributes;
            
            DFAdVideo *video = [[DFAdVideo alloc] init];
            video.videoTitle = [attrs objectForKey:@"title"];
            video.videoPageUrl = [attrs objectForKey:@"href"];
            
            NSArray *children = e.children;
            if (children.count > 0) {
                TFHppleElement *e2 = [children firstObject];
                NSDictionary *attrs = e2.attributes;
                video.videoImage = [attrs objectForKey:@"src"];
            }
            
            [array addObject:video];
            break;
        }
        [DFHtmlParser parseVideoPageHotestVideoElement:e addTo:array];
    }
}

#pragma mark 解析分类查询结果页面
+ (NSMutableArray *)parseCategoryPage:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='listinfo']"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < elements.count; i++) {
        [DFHtmlParser parseCategoryElement:[elements objectAtIndex:i] addTo:result];
    }
    return result;
}

+ (void)parseCategoryElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
    NSArray *children = element.children;
    if (children == nil || children.count == 0) {
        return;
    }
    
    DFAdVideo *ad = [[DFAdVideo alloc] init];
    // 开始解析
    NSObject *obj;
    for (obj in children) {
        
        TFHppleElement *e1 = (TFHppleElement *)obj;
        
        for (obj in e1.children) {
//            TFHppleElement *e2 = (TFHppleElement *)obj;
            // 标题 链接 图片
            if ([[e1 objectForKey:@"class"] isEqualToString:@"listimg"]) {
                //po
                NSString *videoPageUrl = [((TFHppleElement *)[e1.children firstObject]).attributes objectForKey:@"href"];
                NSString *videoTitle = [((TFHppleElement *)[((TFHppleElement *)[e1.children firstObject]).children lastObject]) objectForKey:@"alt"];
                NSString *videoImage = [((TFHppleElement *)[((TFHppleElement *)[e1.children firstObject]).children lastObject]) objectForKey:@"src"];
                
                ad.videoPageUrl = videoPageUrl;
                ad.videoTitle   = videoTitle;
                ad.videoImage   = videoImage;
                continue;
            }
            // 更新时间
            if ([[e1 objectForKey:@"class"] isEqualToString:@"listtime"]) {
                // 更新时间
                if (e1.children.count == 1) {
                    NSString *videoUpdateTime = ((TFHppleElement *)[e1.children firstObject]).content;
                    ad.videoUpdateDate = videoUpdateTime;
                }
                // 时长 人气
                else if (e1.children.count == 2) {  // 没完全分开
                    if ([[((TFHppleElement *)[e1.children lastObject]) objectForKey:@"color"] isEqualToString:@"#FF00FF"]) {
                        // 时长：30s 人气
                        NSString *videoDuration = ((TFHppleElement *)[e1.children firstObject]).content;
                        // 301
                        NSString *videoWatchCount = ((TFHppleElement *)[((TFHppleElement *)[e1.children lastObject]).children firstObject]).content;
                        
                        ad.videoDuration = [NSString stringWithFormat:@"%@ %@", videoDuration, videoWatchCount];
                        ad.videoDesc = videoDuration;
                    } else if ([[((TFHppleElement *)[e1.children lastObject]) objectForKey:@"color"] isEqualToString:@"red"]) {
                        
                        // 时长：30s 人气
                        NSString *videoDuration = ((TFHppleElement *)[e1.children firstObject]).content;
                        // 301
                        NSString *videoWatchCount = ((TFHppleElement *)[((TFHppleElement *)[e1.children lastObject]).children firstObject]).content;
                        
                        ad.videoUpdateDate = [NSString stringWithFormat:@"%@ %@", videoDuration, videoWatchCount];
                        ad.videoDesc = ad.videoUpdateDate;
                    }
                }
                break;
            }
        }
    }
    [array addObject:ad];
}

#pragma mark 解析搜索结果页面
+ (NSMutableArray *)parseSearchPage:(NSData *)data {
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='searchbox']"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (int i = 0; i < elements.count; i++) {
        [DFHtmlParser parseSearchElement:[elements objectAtIndex:i] addTo:result];
    }
    return result;
}

+ (void)parseSearchElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
    NSArray *children = element.children;
    if (children == nil || children.count == 0) {
        return;
    }
    
    DFAdVideo *ad = [[DFAdVideo alloc] init];
    // 开始解析
    NSObject *obj;
    for (obj in children) {
        TFHppleElement *e = (TFHppleElement *)obj;
        
        if ([[e objectForKey:@"class"] isEqualToString:@"setop"]) {
            //
            NSString *videoPageUrl = [((TFHppleElement *)[e.children objectAtIndex:6]) objectForKey:@"href"];
            NSString *videoTitle = ((TFHppleElement *)[((TFHppleElement *)[((TFHppleElement *)[e.children objectAtIndex:6]).children firstObject]).children firstObject]).content;
            NSString *videoUpdateDate = ((TFHppleElement *)[e.children objectAtIndex:8]).content;
            NSString *videoDuration = ((TFHppleElement *)[((TFHppleElement *)[e.children objectAtIndex:9]).children objectAtIndex:2]).content;
            NSString *videoDownloadCount = ((TFHppleElement *)[((TFHppleElement *)[((TFHppleElement *)[e.children objectAtIndex:9]).children objectAtIndex:3]).children objectAtIndex:2]).content;
            
            ad.videoPageUrl         = videoPageUrl;
            ad.videoTitle           = videoTitle;
            ad.videoDuration        = videoDuration;
            ad.videoUpdateDate      = videoUpdateDate;
            ad.videoDownloadCount   = videoDownloadCount;
        }
        
        if ([[e objectForKey:@"class"] isEqualToString:@"seleft"]) {
            //
            NSString *videoPageUrl = [((TFHppleElement *)[e.children objectAtIndex:1]) objectForKey:@"href"];
            NSString *videoImage = [((TFHppleElement *)[((TFHppleElement *)[e.children objectAtIndex:1]).children firstObject]) objectForKey:@"src"];
            
            ad.videoPageUrl = videoPageUrl;
            ad.videoImage   = videoImage;
        }
        
        if ([[e objectForKey:@"class"] isEqualToString:@"seright"]) {
            NSString *videoDesc = [NSString stringWithFormat:@"%@%@", ((TFHppleElement *)[e.children objectAtIndex:0]).content, ((TFHppleElement *)[e.children objectAtIndex:2]).content];
            
            ad.videoDesc = videoDesc;
        }
    }
    [array addObject:ad];
}
@end
