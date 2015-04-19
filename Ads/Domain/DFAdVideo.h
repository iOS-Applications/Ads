//
//  BBAdVideo.h
//  Ads
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFAdVideo : NSObject


/* 标题 */
@property NSString *videoTitle;     
/* 预览图片 */
@property (nonatomic) NSString *videoImage;     
/* 视频所在网页（用来解析真实视频地址）*/
@property (nonatomic) NSString *videoPageUrl;
/* 视频真实地址 */
@property (nonatomic) NSString *videoUri;
/* 更新时间 */
@property NSString *videoUpdateDate;
/* 时长 */
@property NSString *videoDuration;
/* 视频简介 */
@property NSString *videoDesc;
/* 下载次数（热门） */
@property NSString *videoDownloadCount;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)AdVideoWithDict:(NSDictionary *)dict;


@end
