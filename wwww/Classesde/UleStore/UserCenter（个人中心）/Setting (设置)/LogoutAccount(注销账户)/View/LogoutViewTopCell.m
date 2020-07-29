//
//  LogoutViewTopCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "LogoutViewTopCell.h"
#import <UIView+SDAutoLayout.h>
#import "LogoutModel.h"

@interface LogoutViewTopCell ()
@property (nonatomic, strong) UILabel *tipsContentLab;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation LogoutViewTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"d9d9d9"];
    [self.contentView sd_addSubviews:@[self.tipsContentLab,self.iconImageView]];
    self.iconImageView.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(30))
    .centerXEqualToView(self.contentView)
    .widthIs(KScreenScale(82))
    .heightIs(KScreenScale(82));
    self.tipsContentLab.sd_layout
    .topSpaceToView(self.iconImageView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(20);
    [self setupAutoHeightWithBottomView:self.tipsContentLab bottomMargin:10];
}

- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    LogoutSectionData *info=(LogoutSectionData *)model.data;
    self.tipsContentLab.text = info.title;
    [self.iconImageView yy_setImageWithURL:[NSURL URLWithString:info.imageUrl] placeholder:[UIImage bundleImageNamed:@"logout_img_tips"]];
}
#pragma mark - <setter and getter>
- (UILabel *)tipsContentLab{
    if (!_tipsContentLab) {
        _tipsContentLab=[UILabel new];
        _tipsContentLab.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _tipsContentLab.textColor = [UIColor convertHexToRGB:@"333333"];
        _tipsContentLab.textAlignment = NSTextAlignmentCenter;

    }
    return _tipsContentLab;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]init];
    }
    return _iconImageView;
}

@end
