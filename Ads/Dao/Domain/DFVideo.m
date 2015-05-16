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

#pragma mark -

#pragma mark 最近更新
+ (void)getLatestVideoWithUrl:(NSString *)url
                      success:(DFHttpRequestSuccessBlock)success
                      failure:(DFHttpRequestFailureBlock)failure {
    [[DFApi shareInstance] requestWithUrl:url
                            parserType:kDFParserType_LatestPageVideoParser
                               success:success
                               failure:false];
}

#pragma mark 分类视频
+ (void)getCategoryVideoWithUrl:(NSString *)url
                        success:(DFHttpRequestSuccessBlock)success
                        failure:(DFHttpRequestFailureBlock)failure
{
    [[DFApi shareInstance] requestWithUrl:url
                            parserType:kDFParserType_CategoryPageVideoParser
                               success:success
                               failure:false];
}

+ (void)getSearchedVideosWithUrl:(NSString *)url
                   success:(DFHttpRequestSuccessBlock)success
                   failure:(DFHttpRequestFailureBlock)failure
{
    [[DFApi shareInstance] requestWithUrl:url
                            parserType:kDFParserType_SearchResultPageVideoParser
                               success:success
                               failure:false];
    
}

#pragma mark 本类最热
+ (void)getHotestVideoWithUrl:(NSString *)url
                           success:(DFHttpRequestSuccessBlock)success
                           failure:(DFHttpRequestFailureBlock)failure
{
    [[DFApi shareInstance] requestWithUrl:url
                            parserType:kDFParserType_PlaybackPageHotestVideoParser
                               success:success
                               failure:false];
}

#pragma mark 相关视频
+ (void)getRelatedVideoWithUrl:(NSString *)url
                       success:(DFHttpRequestSuccessBlock)success
                       failure:(DFHttpRequestFailureBlock)failure
{
    [[DFApi shareInstance] requestWithUrl:url
                            parserType:kDFParserType_PlaybackPageRelatedVideoParser
                               success:success
                               failure:false];
}

+ (void)getVideoWithName:(NSString *)name
                 success:(DFHttpRequestSuccessBlock)success
                 failure:(DFHttpRequestFailureBlock)failure {
    
}
@end