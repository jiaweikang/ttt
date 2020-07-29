//
//  UpdateUserListCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/23.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserListCell.h"
#import <UIView+SDAutoLayout.h>
#import "UpdateUserListCellModel.h"

@interface UpdateUserListCell ()
@property (nonatomic, strong)UILabel    *titleLab;
@property (nonatomic, strong)UILabel    *contentLab;
@property (nonatomic, strong)UIImageView    *arrowImgView;
@property (nonatomic, strong)UIView     *lineView;
@end

@implementation UpdateUserListCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.titleLab, self.contentLab, self.arrowImgView, self.lineView]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(__MainScreen_Width*0.4)
    .heightIs(50);
    self.arrowImgView.sd_layout.centerYEqualToView(self.titleLab)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(8)
    .heightIs(14);
    self.contentLab.sd_layout.topEqualToView(self.titleLab)
//    .bottomEqualToView(self.titleLab)
    .leftSpaceToView(self.titleLab, 0)
    .rightSpaceToView(self.arrowImgView, 10)
    .autoHeightRatio(0)
    .minHeightIs(50);
    self.lineView.sd_layout.topSpaceToView(self.contentLab, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.arrowImgView)
    .heightIs(1.0);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}

- (void)setModel:(UpdateUserListCellModel *)model{
    self.titleLab.text=[NSString isNullToString:model.titleStr];
    self.contentLab.text=[NSString isNullToString:model.contentStr];
    if (model.isHideArrow) {
        self.arrowImgView.sd_layout.widthIs(0);
    }else {
        self.arrowImgView.sd_layout.widthIs(8);
    }
    if (model.isHideLine) {
        self.lineView.sd_layout.heightIs(0);
    }else self.lineView.sd_layout.heightIs(1.0);
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLab.font=[UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab=[[UILabel alloc]init];
        _contentLab.numberOfLines=0;
        _contentLab.textColor=[UIColor convertHexToRGB:@"666666"];
        _contentLab.font=[UIFont systemFontOfSize:14];
        _contentLab.textAlignment=NSTextAlignmentRight;
    }
    return _contentLab;
}
- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"withdraw_img_bankcard_arrow"]];
    }
    return _arrowImgView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    }
    return _lineView;
}
@end

@interface UpdateUserListCell1 ()
@property (nonatomic, strong)UILabel    *titleLab;
@property (nonatomic, strong)UIImageView    *headImgView;
@property (nonatomic, strong)UIImageView    *arrowImgView;
@property (nonatomic, strong)UIView     *lineView;
@end

@implementation UpdateUserListCell1
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.titleLab, self.headImgView, self.arrowImgView, self.lineView]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .widthIs(__MainScreen_Width*0.5)
    .heightIs(60);
    self.arrowImgView.sd_layout.centerYEqualToView(self.titleLab)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(8)
    .heightIs(14);
    self.headImgView.sd_layout.centerYEqualToView(self.titleLab)
    .rightSpaceToView(self.arrowImgView, 10)
    .widthIs(45)
    .heightEqualToWidth();
    self.lineView.sd_layout.topSpaceToView(self.titleLab, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.arrowImgView)
    .heightIs(1.0);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}

- (void)setModel:(UpdateUserListCellModel *)model{
    self.titleLab.text=[NSString isNullToString:model.titleStr];
    if (model.headImg) {
        [self.headImgView setImage:model.headImg];
    }else {
        [self.headImgView yy_setImageWithURL:[NSURL URLWithString:model.headImgUrl] placeholder:[UIImage bundleImageNamed:@"mystore_icon_head_default"]];
    }
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLab.font=[UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (UIImageView *)headImgView{
    if (!_headImgView) {
        _headImgView=[[UIImageView alloc]init];
    }
    return _headImgView;
}
- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"withdraw_img_bankcard_arrow"]];
    }
    return _arrowImgView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    }
    return _lineView;
}
@end

@interface UpdateUserListCell2 ()
@property (nonatomic, strong)UILabel    *titleLab;
@property (nonatomic, strong)UILabel    *subTitleLab;
@property (nonatomic, strong)UIImageView    *arrowImgView;
@property (nonatomic, strong)UIView     *lineView;
@end

@implementation UpdateUserListCell2
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.titleLab, self.subTitleLab, self.arrowImgView, self.lineView]];
    self.arrowImgView.sd_layout.topSpaceToView(self.contentView, 28)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(8)
    .heightIs(14);
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 10)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.arrowImgView, 10)
    .heightIs(KScreenScale(50));
    self.subTitleLab.sd_layout.topSpaceToView(self.titleLab, 6)
    .leftEqualToView(self.titleLab)
    .autoHeightRatio(0);
    self.lineView.sd_layout.topSpaceToView(self.subTitleLab, 6)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.arrowImgView)
    .heightIs(1.0);
    
    [self setupAutoHeightWithBottomView:self.lineView bottomMargin:0];
}

- (void)setModel:(UpdateUserListCellModel *)model{
    self.titleLab.text=[NSString isNullToString:model.titleStr];
    self.subTitleLab.text=[NSString isNullToString:model.subTitleStr];
    [self.subTitleLab setSingleLineAutoResizeWithMaxWidth:(__MainScreen_Width-38)];
}

#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLab.font=[UIFont systemFontOfSize:15];
    }
    return _titleLab;
}
- (UILabel *)subTitleLab{
    if (!_subTitleLab) {
        _subTitleLab=[[UILabel alloc]init];
        _subTitleLab.numberOfLines=0;
        _subTitleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        _subTitleLab.font=[UIFont systemFontOfSize:13];
    }
    return _subTitleLab;
}
- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"withdraw_img_bankcard_arrow"]];
    }
    return _arrowImgView;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    }
    return _lineView;
}
@end
