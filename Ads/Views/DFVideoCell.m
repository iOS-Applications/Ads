//
//  DFVideoCellTableViewCell.m
//  Ads
//
//  Created by zhudf on 15/4/19.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFVideoCell.h"
#import "DFVideo.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface DFVideoCell()

@property (retain, nonatomic) UIImageView    *image;
@property (retain, nonatomic) UILabel        *title;
@property (retain, nonatomic) UILabel        *desc;

@end

@implementation DFVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.image = [[UIImageView alloc] init];
        self.title = [[UILabel alloc] init];
        self.desc  = [[UILabel alloc] init];
        
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.desc];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideo:(DFVideo *)video {
    self.video = video;
    
    [self setData];
    [self setFrame];
}

- (void)setData {
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.video.videoImage] placeholderImage:[UIImage imageNamed:@"image_animal_1"]];
    self.title.text = self.video.videoTitle;
    self.desc.text = self.video.videoDesc;
}

- (void)setFrame {
    
}
@end
