//
//  DFVideoPageHotestVideoParser.m
//  Ads
//
//  Created by zhudf on 15/5/16.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoPageHotestVideoParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "DFVideo.h"

@implementation DFVideoPageHotestVideoParser

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure {
    
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    if (doc == nil) {
        failure(nil);
    }
    
    NSMutableArray *result = [NSMutableArray array];
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='inforank']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    [self parseVideoPageHotestVideoElement:element addTo:result];
    
    success([result copy]);
}

- (void)parseVideoPageHotestVideoElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
    if (!element.hasChildren) {
        return;
    }
    
    NSObject *obj;
    for (obj in element.children) {
        @autoreleasepool {
            TFHppleElement *e = (TFHppleElement *)obj;
            
            if ([e.tagName isEqualToString:@"a"]) {
                NSDictionary *attrs = e.attributes;
                
                DFVideo *video = [[DFVideo alloc] init];
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
            [self parseVideoPageHotestVideoElement:e addTo:array];
        }
    }
}
@end
