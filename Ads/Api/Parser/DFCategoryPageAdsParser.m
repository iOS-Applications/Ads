//
//  DFCategoryPageAdsParser.m
//  Ads
//
//  Created by zhudf on 15/5/10.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFCategoryPageAdsParser.h"
#import "DFVideo.h"

@implementation DFCategoryPageAdsParser

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    @try {
        [self parseData:data addResultTo:result];
        success([result copy]);
    }
    @catch (NSException *exception) {
        failure(nil);
    }
}

- (NSMutableArray *)parseData:(NSData *)data
                          addResultTo:(NSMutableArray *)result
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='listinfo']"];
    
    for (int i = 0; i < elements.count; i++) {
        [self parseElement:[elements objectAtIndex:i] addResultTo:result];
    }
    return result;
}

- (void)parseElement:(TFHppleElement *)element
         addResultTo:(NSMutableArray *)array
{
    NSArray *children = element.children;
    if (children == nil || children.count == 0) {
        return;
    }
    
    DFVideo *ad = [[DFVideo alloc] init];
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
@end
