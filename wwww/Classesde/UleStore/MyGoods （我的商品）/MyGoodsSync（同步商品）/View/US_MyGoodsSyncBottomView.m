//
//  US_MyGoodsSyncBottomView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/14.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsSyncBottomView.h"
#import "UleControlView.h"
#import <UIView+SDAutoLayout.h>

@interface US_MyGoodsSyncBottomView ()
@property (nonatomic, strong) UleControlView * mAllSelectBtn;
@property (nonatomic, strong) UleControlView * mSyncBtn;
@property (nonatomic, assign) BOOL isAllSelect;
@end

@implementation US_MyGoodsSyncBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 0.25;
        
        [self sd_addSubviews:@[self.mAllSelectBtn,self.mSyncBtn]];
        
        self.mAllSelectBtn.sd_layout.topSpaceToView(self, 0)
        .heightIs(49)
        .leftSpaceToView(self, 15).autoWidthRatio(0);
        
        self.mSyncBtn.sd_layout.centerYEqualToView(self.mAllSelectBtn)
        .rightSpaceToView(self, KScreenScale(30))
        .heightIs(35).widthIs(140);
        
    }
    return self;
}
- (UleControlView *)buildRoundButtonWithTitle:(NSString *)title andImage:(NSString *)imageName{
    UleControlView * button=[[UleControlView alloc] init];
    button.mImageView.image=[UIImage bundleImageNamed:imageName];
    button.mTitleLabel.text=title;
    button.mImageView.sd_layout.leftSpaceToView(button, 26)
    .centerYEqualToView(button)
    .widthIs(18)
    .heightIs(17);
    button.mTitleLabel.sd_layout.leftSpaceToView(button.mImageView, KScreenScale(15))
    .topSpaceToView(button, 0)
    .bottomSpaceToView(button, 0)
    .autoWidthRatio(0);
    button.mTitleLabel.textColor=[UIColor whiteColor];
    button.mTitleLabel.font=[UIFont systemFontOfSize:13];
    [button.mTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    button.layer.cornerRadius=35/2.0;
    return button;
}

- (UleControlView *)buildButtonWithTitle:(NSString *)title andImage:(NSString *)imageName{
    UleControlView * button=[[UleControlView alloc] init];
    button.mImageView.image=[UIImage bundleImageNamed:imageName];
    button.mTitleLabel.text=title;
    button.mImageView.sd_layout.leftSpaceToView(button, 0)
    .centerYEqualToView(button)
    .widthIs(KScreenScale(36))
    .heightIs(KScreenScale(36));
    button.mTitleLabel.sd_layout.leftSpaceToView(button.mImageView, 10)
    .topSpaceToView(button, 0)
    .bottomSpaceToView(button, 0)
    .autoWidthRatio(0);
    button.mTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
    button.mTitleLabel.font=[UIFont systemFontOfSize:14];
    [button.mTitleLabel setSingleLineAutoResizeWithMaxWidth:100];
    [button setupAutoWidthWithRightView:button.mTitleLabel rightMargin:20];
    return button;
}
#pragma mark - <>
- (void) setAllSelected:(BOOL)isAllSelected{
    self.isAllSelect=isAllSelected;
    if (self.isAllSelect) {
        self.mAllSelectBtn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellSelected"];
    }else{
        self.mAllSelectBtn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellNoSelect"];
    }
}
#pragma mark - <button action>
- (void)allselectedBtnClick:(UleControlView *)btn{
    self.isAllSelect=!self.isAllSelect;
    if (self.isAllSelect) {
        btn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellSelected"];
    }else{
        btn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellNoSelect"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(seletAllGoods:)]) {
        [self.delegate seletAllGoods:self.isAllSelect];
    }
}

- (void)syncBtnClick:(UleControlView *)btn{
    if (self.delegate&& [self.delegate respondsToSelector:@selector(syncSeletedGoods)]) {
        [self.delegate syncSeletedGoods];
    }
}

#pragma mark - <setter and getter>
- (UleControlView *)mAllSelectBtn{
    if (!_mAllSelectBtn) {
        _mAllSelectBtn=[self buildButtonWithTitle:@"全选" andImage:@"myGoods_img_cellNoSelect"];
        [_mAllSelectBtn addTouchTarget:self action:@selector(allselectedBtnClick:)];
    }
    return _mAllSelectBtn;
}

- (UleControlView *)mSyncBtn{
    if (!_mSyncBtn) {
        _mSyncBtn=[self buildRoundButtonWithTitle:@"同步到小店" andImage:@"myGoods_btn_bottomsync"];;
        _mSyncBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        [_mSyncBtn addTouchTarget:self action:@selector(syncBtnClick:)];
    }
    return _mSyncBtn;
}
@end
