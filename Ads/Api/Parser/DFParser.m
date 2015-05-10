//
//  DFParser.m
//  Ads
//
//  Created by zhudf on 15/5/10.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFParser.h"
#import "DFLatestPageAdsParser.h"
#import "DFCategoryPageAdsParser.h"

@implementation DFParser

- (void)parseData:(NSData *)data success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
}

+ (instancetype)parserWithType:(DFParserType)type {
    switch (type) {
        case kDFParserTypeParseLatestPageAds:
            return [[DFLatestPageAdsParser alloc] init];
        case kDFParserTypeParseCategoryPageAds:
            return [[DFCategoryPageAdsParser alloc] init];
        case kDFParserTypeParseRelatedAds:
            return nil;
        case kDFParserTypeParseRecommandedAds:
            return nil;
        case kDFParserTypeParseSearchResultPageAds:
            return nil;
    }
    return nil;
}
@end

