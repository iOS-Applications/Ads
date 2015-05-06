//
//  DFVideoCellTableViewCell.h
//  Ads
//
//  Created by zhudf on 15/4/19.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFVideo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DFVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoDescLabel;

- (void)setVideo:(DFVideo *)video;

@end
