//
//  US_UserHeadView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/11/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_UserHeadView.h"
#import "UleControlView.h"
#import <SDAutoLayout/UIView+SDAutoLayout.h>
#import "NSString+Utility.h"
#import "UIView+Shade.h"

static CGFloat USUserHeadOffset = 10.0;
static CGFloat USUserHeadImageSize = 65.0;
static CGFloat USUserHeadPhoneLabHeight = 20.0;
@interface US_UserHeadView ()
@property (nonatomic, strong) UIImageView       * mBGImageView;
@property (nonatomic, strong) UleControlView    * mPhotoView;
@property (nonatomic, strong) UILabel           * mShopNameTitleLab;
@property (nonatomic, strong) UILabel           * mShopNameLab;
@property (nonatomic, strong) UILabel           * mPhoneLab;
@property (nonatomic, strong) UILabel           * mEnterpriseNameLab;
@property (nonatomic, strong) UIImageView       * mRightArrowImg;

@end
@implementation US_UserHeadView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled=YES;
        
        [self setUI];
        [self setContentData];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setContentData) name:NOTI_UpdateUserCenter object:nil];
    }
    return self;
}

- (void)setUI{
    [self.layer addSublayer:[UIView setGradualChangingColor:self fromColor:[UIColor convertHexToRGB:@"EC3D3F"] toColor:[UIColor convertHexToRGB:@"FF7462"] gradualType:GradualTypeVertical]];
    [self sd_addSubviews:@[self.mBGImageView,self.mPhotoView,self.mShopNameTitleLab,self.mShopNameLab,self.mPhoneLab,self.mEnterpriseNameLab,self.mRightArrowImg]];
    self.mBGImageView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mPhotoView.sd_layout
    .leftSpaceToView(self, USUserHeadOffset)
    .topSpaceToView(self, 44+kStatusBarHeight+USUserHeadOffset/2)
    .heightIs(USUserHeadImageSize)
    .widthEqualToHeight();
    self.mShopNameTitleLab.sd_layout
    .leftSpaceToView(self.mPhotoView, USUserHeadOffset)
    .topEqualToView(self.mPhotoView)
    .autoWidthRatio(0)
    .heightIs(30);
    [self.mShopNameTitleLab setSingleLineAutoResizeWithMaxWidth:80];
    self.mShopNameLab.sd_layout
    .leftSpaceToView(self.mShopNameTitleLab, 0)
    .topEqualToView(self.mShopNameTitleLab)
    .rightSpaceToView(self, 50)
    .heightIs(30);
    self.mPhoneLab.sd_layout
    .topSpaceToView(self.mShopNameTitleLab, USUserHeadOffset)
    .leftEqualToView(self.mShopNameTitleLab)
    .widthIs(90)
    .heightIs(USUserHeadPhoneLabHeight);
    self.mEnterpriseNameLab.sd_layout
    .centerYEqualToView(self.mPhoneLab)
    .leftSpaceToView(self.mPhoneLab, USUserHeadOffset)
    .rightSpaceToView(self, USUserHeadOffset)
    .autoHeightRatio(0);
    self.mRightArrowImg.sd_layout
    .rightSpaceToView(self, 0)
    .widthIs(35)
    .heightIs(20)
    .centerYEqualToView(self);
    
}

- (void)setContentData{
    if ([US_UserUtility sharedLogin].m_userHeadImage) {
        [self.mPhotoView.mImageView setImage:[US_UserUtility sharedLogin].m_userHeadImage];
    }else {
        [self.mPhotoView.mImageView yy_setImageWithURL:[NSURL URLWithString:NonEmpty([US_UserUtility sharedLogin].m_userHeadImgUrl)] placeholder:[UIImage bundleImageNamed:@"mystore_icon_head_default"]];
    }
    self.mShopNameLab.text=[US_UserUtility sharedLogin].m_stationName;
    NSString * starPhoneNum=[NSString mosaicMobilePhone:[US_UserUtility sharedLogin].m_mobileNumber];
    self.mPhoneLab.text=starPhoneNum;
    self.mEnterpriseNameLab.text=[NSString stringWithFormat:@"%@",[US_UserUtility sharedLogin].m_lastOrgName];
}

#pragma mark - <setter getter>
- (UIImageView *)mBGImageView{
    if (!_mBGImageView) {
        _mBGImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _mBGImageView;
}
- (UleControlView *)mPhotoView {
    if (!_mPhotoView) {
        _mPhotoView = [[UleControlView alloc] initWithFrame:CGRectMake(0, 0, USUserHeadImageSize, USUserHeadImageSize)];
        _mPhotoView.mImageView.frame = _mPhotoView.bounds;
        _mPhotoView.mImageView.contentMode=UIViewContentModeScaleAspectFill;
        _mPhotoView.mImageView.image = [UIImage bundleImageNamed:@"mystore_icon_head_default"];
        _mPhotoView.mImageView.layer.borderWidth = 1.0;
        _mPhotoView.mImageView.layer.borderColor = [UIColor whiteColor].CGColor;
        _mPhotoView.mImageView.layer.cornerRadius = USUserHeadImageSize/2.0;
    }
    return _mPhotoView;
}
- (UILabel *)mShopNameTitleLab {
    if (!_mShopNameTitleLab) {
        _mShopNameTitleLab = [UILabel new];
        _mShopNameTitleLab.backgroundColor = [UIColor clearColor];
        _mShopNameTitleLab.textColor = [UIColor whiteColor];
        _mShopNameTitleLab.font = [UIFont systemFontOfSize:12];
        _mShopNameTitleLab.text = @"店铺：";
    }
    return _mShopNameTitleLab;
}
- (UILabel *)mShopNameLab {
    if (!_mShopNameLab) {
        _mShopNameLab = [UILabel new];
        _mShopNameLab.backgroundColor = [UIColor clearColor];
        _mShopNameLab.textColor = [UIColor whiteColor];
        _mShopNameLab.font = [UIFont systemFontOfSize:17];
    }
    return _mShopNameLab;
}
- (UILabel *)mPhoneLab {
    if (!_mPhoneLab) {
        _mPhoneLab = [UILabel new];
        _mPhoneLab.backgroundColor = [UIColor clearColor];
        _mPhoneLab.textColor = [UIColor whiteColor];
        _mPhoneLab.font = [UIFont systemFontOfSize:9.5];
        _mPhoneLab.layer.cornerRadius = USUserHeadPhoneLabHeight/2.0;
        _mPhoneLab.layer.masksToBounds = YES;
        _mPhoneLab.backgroundColor = [UIColor convertHexToRGB:@"EE3B39"];
        _mPhoneLab.textAlignment = NSTextAlignmentCenter;
    }
    return _mPhoneLab;
}
- (UILabel *)mEnterpriseNameLab {
    if (!_mEnterpriseNameLab) {
        _mEnterpriseNameLab = [UILabel new];
        _mEnterpriseNameLab.backgroundColor = [UIColor clearColor];
        _mEnterpriseNameLab.textColor = [UIColor whiteColor];
        _mEnterpriseNameLab.font = [UIFont systemFontOfSize:11.5];
        _mEnterpriseNameLab.numberOfLines = 2;
    }
    return _mEnterpriseNameLab;
}
- (UIImageView *)mRightArrowImg {
    if (!_mRightArrowImg) {
        _mRightArrowImg = [UIImageView new];
        [_mRightArrowImg setImage:[UIImage bundleImageNamed:@"icon_userHead_arrow"]];
    }
    return _mRightArrowImg;
}
@end
