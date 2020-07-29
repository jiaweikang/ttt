//
//  QRShareTemplateCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "QRShareTemplateCell.h"
#import <UIView+SDAutoLayout.h>

@interface QRShareTemplateCell ()
@property (nonatomic, strong)UIView                 *topView;//
@property (nonatomic, strong)UILabel                *leftLabel;
@property (nonatomic, strong)UIImageView            *rightImgView;
@property (nonatomic, strong)UIImageView            *shareView;


@end

@implementation QRShareTemplateCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f2f2f2"];
    [self.contentView sd_addSubviews:@[self.shareView,self.topView]];
    self.topView.sd_layout.centerXEqualToView(self.contentView)
    .topSpaceToView(self.contentView, 0)
    .widthIs(KScreenScale(240)).heightIs(KScreenScale(60));
    
    [self.topView sd_addSubviews:@[self.leftLabel,self.rightImgView]];
    self.leftLabel.sd_layout.leftSpaceToView(self.topView, KScreenScale(30))
    .centerYEqualToView(self.topView).heightIs(KScreenScale(30))
    .widthIs(KScreenScale(150));
    
    self.rightImgView.sd_layout.rightSpaceToView(self.topView, KScreenScale(10))
    .centerYEqualToView(self.topView)
    .widthIs(KScreenScale(38)).heightEqualToWidth();
    
    self.shareView.sd_layout.leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .topSpaceToView(self.topView, -KScreenScale(30));
                                        
}

- (void)setTemplateModel:(ShareTemplateList *)templateModel{
    _templateModel=templateModel;
    self.leftLabel.text=_templateModel.title;
    [self.shareView yy_setImageWithURL:[NSURL URLWithString:_templateModel.imgUrl] placeholder:nil];
    if (_templateModel.cellSelected) {
        _topView.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
        _leftLabel.textColor=[UIColor whiteColor];
        _rightImgView.image=[UIImage bundleImageNamed:@"share_icon_template_selected"];
        _shareView.layer.borderWidth=1.0;
        _shareView.layer.borderColor=[UIColor convertHexToRGB:@"ef3b39"].CGColor;
    }else {
        _topView.backgroundColor=[UIColor whiteColor];
        _leftLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _rightImgView.image=[UIImage bundleImageNamed:@"share_icon_template_normal"];
        _shareView.layer.borderWidth=0;
    }

}

#pragma mark - <setter and getter>
- (UIView *)topView{
    if (!_topView) {
        _topView=[[UIView alloc] init];
        _topView.backgroundColor=[UIColor whiteColor];
        _topView.layer.cornerRadius=KScreenScale(30);
    }
    return _topView;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel=[UILabel new];
        _leftLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _leftLabel.font=[UIFont systemFontOfSize:KScreenScale(23)];
    }
    return _leftLabel;
}

- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView=[UIImageView new];
        _rightImgView.image=[UIImage bundleImageNamed:@"share_icon_template_normal"];
    }
    return _rightImgView;
}
- (UIImageView *)shareView{
    if (!_shareView) {
        _shareView=[UIImageView new];
    }
    return _shareView;
}

@end
