//
//  DFLatestAdsParser.m
//  Ads
//
//  Created by zhudf on 15/5/10.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFLatestPageAdsParser.h"
#import "DFVideo.h"

@implementation DFLatestPageAdsParser

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

- (void)parseData:(NSData *)data
      addResultTo:(NSMutableArray *)result
{
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='newcontent']"];
    
    for (int i = 0; i < elements.count; i++) {
        @try {
            [self parseElement:[elements objectAtIndex:i] addResultTo:result];
        }
        @catch (NSException *exception) {
        }
    }
}

- (void)parseElement:(TFHppleElement *)element addResultTo:(NSMutableArray *)array
{
    NSArray *children = element.children;
    
    DFVideo *ad = [[DFVideo alloc] init];
    
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

@end
