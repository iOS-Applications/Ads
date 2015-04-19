//
//  BBHtmlParser.h
//  LoveAD
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "DFAdVideo.h"

@interface DFHtmlParser : NSObject

+ (NSMutableArray *)parseNewPage:(NSData *)data;
+ (NSMutableArray *)parseVideoPage:(NSData *)data;
+ (NSMutableArray *)parseCategoryPage:(NSData *)data;
+ (NSMutableArray *)parseSearchPage:(NSData *)data;

@end
