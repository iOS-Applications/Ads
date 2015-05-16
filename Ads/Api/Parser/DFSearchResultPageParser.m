//
//  DFSearchResultPageParser.m
//  Ads
//
//  Created by zhudf on 15/5/16.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFSearchResultPageParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "DFVideo.h"

@implementation DFSearchResultPageParser

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure {
    
    TFHpple *doc = [[TFHpple alloc] initWithHTMLData:data];
    if (doc == nil) {
        failure(nil);
    }
    
    NSMutableArray *result = [NSMutableArray array];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='searchbox']"];
    for (int i = 0; i < elements.count; i++) {
        @autoreleasepool {
            [self parseElement:[elements objectAtIndex:i] addResultTo:result];
        }
    }
    
    success([result copy]);
}

- (void)parseElement:(TFHppleElement *)element addResultTo:(NSMutableArray *)array {
    NSArray *children = element.children;
    if (children == nil || children.count == 0) {
        return;
    }
    
    DFVideo *ad = [[DFVideo alloc] init];
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
