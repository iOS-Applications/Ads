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

#pragma mark - Init

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.videoTitle     = [dict objectForKey:@"Title"];
        self.videoImage     = [dict objectForKey:@"Image"];
        self.videoPageUrl   = [dict objectForKey:@"VideoPageUrl"];
        self.videoUri       = [dict objectForKey:@"VideoUri"];
    }
    return self;
}

+ (instancetype)videoWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

#pragma mark - Getters and Setters

- (NSString *)videoPageUrl {
    return [NSString stringWithFormat:@"http://www.adzop.com/%@", [_videoPageUrl stringByReplacingOccurrencesOfString:@"../" withString:@""]];
}

- (NSString *)videoUri {
    return [NSString stringWithFormat:@"http://www.adzop.com/%@", [_videoUri stringByReplacingOccurrencesOfString:@"../" withString:@""]];
}

- (NSString *)videoImage {
    return [NSString stringWithFormat:@"http://www.adzop.com/%@", [_videoImage stringByReplacingOccurrencesOfString:@"../" withString:@""]];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ \n%@ \n%@", self.videoTitle, self.videoImage, self.videoPageUrl];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    DFVideo *result = [[[self class] allocWithZone:zone] init];
    result -> _videoUri     = _videoUri;
    result -> _videoTitle   = _videoTitle;
    result -> _videoImage   = _videoImage;
    result -> _videoPageUrl = _videoPageUrl;
    return result;
}

#pragma mark - 获取数据

+ (void)getLatestVideoWithUrl:(NSString *)url success:(successBlock)success failure:(failureBlock)failure {
    [[DFApi shareDFApi] requestWithUrl:url
                            parserType:kDFParserTypeParseLatestPageAds
                               success:success
                               failure:false];
}

+ (void)getCategoryVideoWithUrl:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    [[DFApi shareDFApi] requestWithUrl:url
                            parserType:kDFParserTypeParseCategoryPageAds
                               success:success
                               failure:false];
}

+ (void)getRecommandedVideoWithUrl:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    [[DFApi shareDFApi] requestWithUrl:url
                            parserType:kDFParserTypeParseRecommandedAds
                               success:success
                               failure:false];
}

+ (void)getRelatedVideoWithUrl:(NSString *)url success:(successBlock)success failure:(failureBlock)failure
{
    [[DFApi shareDFApi] requestWithUrl:url
                            parserType:kDFParserTypeParseRelatedAds
                               success:success
                               failure:false];
}

+ (void)getVideoWithName:(NSString *)name success:(successBlock)success failure:(failureBlock)failure {
    
}
@end