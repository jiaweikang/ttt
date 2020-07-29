//
//  AuthorizeRealNameCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/20.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "AuthorizeRealNameCell.h"
#import <UIView+SDAutoLayout.h>
#import "AuthorizeCellModel.h"
#import "MyUILabel.h"

@interface AuthorizeRealNameCell ()
@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) MyUILabel     *lab;
@property (nonatomic, strong) UIView        *lineView;

@end

@implementation AuthorizeRealNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.imgView,self.lab,self.lineView]];
    self.imgView.sd_layout.topSpaceToView(self.contentView, KScreenScale(30))
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .widthIs(KScreenScale(50))
    .heightIs(KScreenScale(50));
    self.lab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.imgView, KScreenScale(20))
    .rightSpaceToView(self.contentView, 0)
    .heightIs(KScreenScale(110));
    self.lineView.sd_layout.topSpaceToView(self.lab, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1.0);
    
    [self setupAutoHeightWithBottomView:self.lab bottomMargin:0];
}

- (void)setModel:(AuthorizeCellModel *)model
{
    [self.imgView setImage:[UIImage bundleImageNamed:model.imageName]];
    [self.lab setText:model.titleText];
}


#pragma mark - <getters>
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (MyUILabel *)lab
{
    if (!_lab) {
        _lab = [[MyUILabel alloc]init];
        _lab.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _lab.verticalAlignment = VerticalAlignmentMiddle;
    }
    return _lab;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor convertHexToRGB:kGrayLineColor];
    }
    return _lineView;
}
@end


@interface AuthorizeRealNameCell1 ()
@property (nonatomic, strong) UIImageView   *imgView;
@property (nonatomic, strong) MyUILabel     *titleLab;
@property (nonatomic, strong) MyUILabel     *contentLab;
@end

@implementation AuthorizeRealNameCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.imgView,self.titleLab,self.contentLab]];
    self.imgView.sd_layout.topSpaceToView(self.contentView, KScreenScale(20))
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .widthIs(KScreenScale(90))
    .heightIs(KScreenScale(90));
    self.titleLab.sd_layout.centerYEqualToView(self.imgView)
    .leftSpaceToView(self.imgView, KScreenScale(30))
    .rightSpaceToView(self.contentView, 0)
    .heightIs(KScreenScale(50));
    self.contentLab.sd_layout.topSpaceToView(self.imgView, KScreenScale(10))
    .leftSpaceToView(self.imgView, KScreenScale(30))
    .rightSpaceToView(self.contentView, 0)
    .heightIs(KScreenScale(40));
    
    [self setupAutoHeightWithBottomView:self.contentLab bottomMargin:KScreenScale(30)];
}

- (void)setModel:(AuthorizeCellModel *)model
{
    [self.imgView setImage:[UIImage bundleImageNamed:model.imageName]];
    [self.titleLab setText:model.titleText];
    [self.contentLab setText:model.contentText];
}

#pragma mark - <getters>
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
    }
    return _imgView;
}

- (MyUILabel *)titleLab
{
    if (!_titleLab) {
        _titleLab = [[MyUILabel alloc]init];
        _titleLab.textColor = [UIColor convertHexToRGB:@"666666"];
        _titleLab.font = [UIFont boldSystemFontOfSize:KScreenScale(30)];
        _titleLab.verticalAlignment = VerticalAlignmentMiddle;
    }
    return _titleLab;
}

- (MyUILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[MyUILabel alloc]init];
        _contentLab.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _contentLab.verticalAlignment = VerticalAlignmentMiddle;
    }
    return _contentLab;
}

@end
