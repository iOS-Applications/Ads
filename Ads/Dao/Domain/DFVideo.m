//
//  BBAdVideo.m
//  Ads
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideo.h"

@interface DFVideo ()

@end

@implementation DFVideo

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.videoTitle     = [dict objectForKey:@"Title"];
        self.videoImage     = [dict objectForKey:@"Image"];
        self.videoPageUrl   = [dict objectForKey:@"VideoPageUrl"];
        self.videoUri       = [dict objectForKey:@"VideoUri"];
    }
    return self;
}

- (NSString *)videoPageUrl {
    return [NSString stringWithFormat:@"http://www.adzop.com/%@", [_videoPageUrl stringByReplacingOccurrencesOfString:@"../" withString:@""]];
}

- (NSString *)videoUri {
    return [NSString stringWithFormat:@"http://www.adzop.com/%@", [_videoUri stringByReplacingOccurrencesOfString:@"../" withString:@""]];
}

- (NSString *)videoImage {
    return [NSString stringWithFormat:@"http://www.adzop.com/%@", [_videoImage stringByReplacingOccurrencesOfString:@"../" withString:@""]];
}
+ (instancetype)AdVideoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ \n%@ \n%@", self.videoTitle, self.videoImage, self.videoPageUrl];
}
@end
