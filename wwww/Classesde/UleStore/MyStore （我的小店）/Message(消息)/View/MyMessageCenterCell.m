//
//  MyMessageCenterCell.m
//  u_store
//
//  Created by MickyChiang on 2019/5/16.
//  Copyright © 2019 yushengyang. All rights reserved.
//

#import "MyMessageCenterCell.h"
#import <UIView+SDAutoLayout.h>
@interface MyMessageCenterCell ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation MyMessageCenterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
        [self.contentView addSubview:[self imgView]];
        [self.contentView addSubview:[self titleLabel]];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor convertHexToRGB:@"eeeeee"];
        [self.contentView addSubview:lineView];
        
        self.imgView.sd_layout.centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView,10)
        .widthIs(37).heightEqualToWidth();
        
        self.titleLabel.sd_layout.centerYEqualToView(self.imgView)
        .leftSpaceToView(self.imgView, 10)
        .heightIs(30).rightSpaceToView(self.contentView, 10);
        
        lineView.sd_layout.bottomSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(0.5);
    }
    return self;
}

- (void)setMessage:(NSDictionary *)message {
    _message = message;
    self.titleLabel.text = message[@"title"];
    self.imgView.image = [UIImage bundleImageNamed:message[@"image"]];
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _titleLabel;
}

@end
