//
//  ShareStorePosterView.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/11/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "ShareStorePosterView.h"
#import <UIView+SDAutoLayout.h>
#import "UIImage+USAddition.h"

@interface ShareStorePosterView ()
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UILabel *storeNameLbl;
@property (nonatomic, strong) UIImageView *tipBgImgView;
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *qrCodeImgView;
@end

@implementation ShareStorePosterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = KScreenScale(14);
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.alpha=0.0;
    [self sd_addSubviews:@[self.headImgView, self.storeNameLbl, self.bgView, self.tipBgImgView, self.qrCodeImgView]];
    
    self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    
    self.headImgView.sd_layout.topSpaceToView(self, KScreenScale(40))
    .leftSpaceToView(self, KScreenScale(40))
    .widthIs(KScreenScale(120))
    .heightEqualToWidth();
    
    self.storeNameLbl.sd_layout.topSpaceToView(self, KScreenScale(65))
    .leftSpaceToView(self.headImgView, KScreenScale(29))
    .rightEqualToView(self)
    .heightIs(KScreenScale(36));
    
    self.tipBgImgView.sd_layout.topEqualToView(self)
    .leftEqualToView(self)
    .widthIs(KScreenScale(590))
    .heightIs(KScreenScale(690));
    
    self.qrCodeImgView.sd_layout.topSpaceToView(self, KScreenScale(304))
    .leftSpaceToView(self, KScreenScale(179))
    .widthIs(KScreenScale(232))
    .heightIs(KScreenScale(232));
}

- (void)setModel:(ShareStorePosterModel *)model
{
    _bgView.image = [UIImage bundleImageNamed:@"share_store_bg"];
    _tipBgImgView.image = [UIImage bundleImageNamed:@"share_store_tip"];
    
    UIImage *headImage = [UIImage bundleImageNamed:@"my_img_head_default"];
    if ([US_UserUtility sharedLogin].m_userHeadImage) {
        headImage = [US_UserUtility sharedLogin].m_userHeadImage;
    }
    _headImgView.image = headImage;
    _storeNameLbl.text = [US_UserUtility sharedLogin].m_stationName;
    _qrCodeImgView.image = [UIImage uleQRCodeForString:[NSString isNullToString:model.qrCodeUrl] size:1000 fillColor:[UIColor blackColor] iconImage:[UIImage imageNamed:@"US_icon"]];
}

#pragma mark - getters
- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc] init];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = KScreenScale(30);
    }
    return _headImgView;
}

- (UILabel *)storeNameLbl
{
    if (!_storeNameLbl) {
        _storeNameLbl = [[UILabel alloc] init];
        _storeNameLbl.font = [UIFont boldSystemFontOfSize:KScreenScale(36)];
    }
    return _storeNameLbl;
}

- (UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
    }
    return _bgView;
}

- (UIImageView *)tipBgImgView
{
    if (!_tipBgImgView) {
        _tipBgImgView = [[UIImageView alloc] init];
    }
    return _tipBgImgView;
}

- (UIImageView *)qrCodeImgView
{
    if (!_qrCodeImgView) {
        _qrCodeImgView = [[UIImageView alloc] init];
    }
    return _qrCodeImgView;
}

@end
