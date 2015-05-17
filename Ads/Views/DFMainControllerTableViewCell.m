//
//  DFMainControllerTableViewCell.m
//  Ads
//
//  Created by zhudf on 15/5/17.
//  Copyright (c) 2015年 Bebeeru. All rights reserved.
//

#import "DFMainControllerTableViewCell.h"
#import <Masonry/Masonry.h>

@interface DFMainControllerTableViewCell()

@property (nonatomic, strong) UIImageView   *image;
@property (nonatomic, strong) UILabel       *title;
@property (nonatomic, strong) UILabel       *desc;

@end
@implementation DFMainControllerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    [self.contentView addSubview:self.image];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.desc];
    
    return self;
}

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

// this is Apple's recommended place for adding/updating constraints
- (void)updateConstraints
{
    UIView *superView = self.contentView;
    CGFloat padding = 8.0f;
    
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(80));
        make.height.equalTo(@(60));
        
        make.top.equalTo(superView.mas_top).offset(padding);
        make.left.equalTo(superView.mas_left).offset(padding);
        make.bottom.equalTo(superView.mas_bottom).offset(padding);
        make.right.equalTo(self.title.mas_left).offset(-padding);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image.mas_top);
        make.left.equalTo(self.image.mas_right).offset(padding);
        make.bottom.equalTo(self.desc.mas_top).offset(-padding);
        make.right.equalTo(superView.mas_right).offset(-padding);
    }];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(padding);
        make.left.equalTo(self.title.mas_left);
        make.bottom.equalTo(superView.mas_bottom).offset(-padding);
        make.right.equalTo(self.title.mas_right);
    }];
    
    //according to apple super should be called at end of method
    [super updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

# pragma mark - Getters and Setters

- (UIImageView *)image
{
    if (_image == nil) {
        _image = [[UIImageView alloc] init];
        _image.backgroundColor = [UIColor greenColor];
        _image.layer.borderColor = [UIColor blackColor].CGColor;
        _image.layer.borderWidth = 2;
    }
    return _image;
}

- (UILabel *)title
{
    if (_title == nil) {
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor blueColor];
        _title.layer.borderColor = [UIColor blackColor].CGColor;
        _title.layer.borderWidth = 2.0f;
    }
    return _title;
}

- (UILabel *)desc
{
    if (_desc == nil) {
        _desc = [[UILabel alloc] init];
        _desc.backgroundColor = [UIColor redColor];
        _desc.layer.borderColor = [UIColor blackColor].CGColor;
        _desc.layer.borderWidth = 2.0f;
    }
    return _desc;
}
@end