//
//  DFParser.h
//  Ads
//
//  Created by zhudf on 15/5/10.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "TFHppleElement.h"

@class DFLatestPageAdsParser;
@class DFSearchedAdsParser;

typedef NS_ENUM(NSUInteger, DFParserType){
    kDFParserTypeParseLatestPageAds,
    kDFParserTypeParseCategoryPageAds,
    kDFParserTypeParseSearchResultPageAds,
    
    kDFParserTypeParseRelatedAds,
    kDFParserTypeParseRecommandedAds,
};

@interface DFParser : NSObject

- (void)parseData:(NSData *)data
          success:(void (^)(NSArray *result))success
          failure:(void (^)(NSError *error))failure;

+ (instancetype)parserWithType:(DFParserType)type;

@end
