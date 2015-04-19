//
//  DFAdVideoCellTableViewCell.m
//  Ads
//
//  Created by zhudf on 15/4/19.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoTableViewCell.h"

@implementation DFVideoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideo:(DFAdVideo *)video {
    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString:video.videoImage] placeholderImage: [UIImage imageNamed:@"image_animal_1"]];
    self.videoTitleLabel.text = video.videoTitle;
    self.videoDescLabel.text = video.videoDesc;
}

@end
