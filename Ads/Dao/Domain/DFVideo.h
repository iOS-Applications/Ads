//
//  BBAdVideo.h
//  Ads
//
//  Created by zhudf on 15/4/12.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFVideo : NSObject


/* 标题 */
@property (nonatomic, copy) NSString *videoTitle;
/* 预览图片 */
@property (nonatomic, copy) NSString *videoImage;
/* 视频所在网页（用来解析真实视频地址）*/
@property (nonatomic, copy) NSString *videoPageUrl;
/* 视频真实地址 */
@property (nonatomic, copy) NSString *videoUri;
/* 更新时间 */
@property (nonatomic, copy) NSString *videoUpdateDate;
/* 时长 */
@property (nonatomic, copy) NSString *videoDuration;
/* 视频简介 */
@property (nonatomic, copy) NSString *videoDesc;
/* 下载次数（热门） */
@property (nonatomic, copy) NSString *videoDownloadCount;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)AdVideoWithDict:(NSDictionary *)dict;

@end
