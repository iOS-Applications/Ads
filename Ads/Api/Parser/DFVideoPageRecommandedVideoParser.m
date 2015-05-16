//
//  DFRecommandedVideoParser.m
//  Ads
//
//  Created by zhudf on 15/5/16.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoPageRecommandedVideoParser.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "DFVideo.h"

@implementation DFVideoPageRecommandedVideoParser

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *))success
          failure:(void (^)(NSError *))failure {
    
    TFHpple * doc = [[TFHpple alloc] initWithHTMLData:data];
    if (doc == nil) {
        failure(nil);
    }
    
    NSArray *elements = [doc searchWithXPathQuery:@"//div[@class='infonew']"];
    TFHppleElement *element = [elements objectAtIndex:0];
    
    NSMutableArray *result = [NSMutableArray array];
    [self parseVideoPageRecommandedVideoElement:element addTo:result];
    
    success([result copy]);
}

- (void)parseVideoPageRecommandedVideoElement:(TFHppleElement *)element addTo:(NSMutableArray *)array {
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
            [self parseVideoPageRecommandedVideoElement:e addTo:array];
        }
    }
}
@end
