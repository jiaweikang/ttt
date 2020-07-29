

//
//  US_MyGoodsManagerBottomView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsManagerBottomView.h"
#import <UIView+SDAutoLayout.h>
#import "UleControlView.h"

@interface US_MyGoodsManagerBottomView ()
@property (nonatomic, strong) UleControlView * mAllSelectBtn;
@property (nonatomic, strong) UleControlView * mDeleteBtn;
@property (nonatomic, strong) UleControlView * mUpTopBtn;
@property (nonatomic, assign) BOOL isAllSelect;
@end

@implementation US_MyGoodsManagerBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        self.layer.shadowColor =  [UIColor blackColor].CGColor;
        self.layer.masksToBounds = NO;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 0.25;
        
        [self sd_addSubviews:@[self.mAllSelectBtn,self.mDeleteBtn,self.mUpTopBtn]];
        
        self.mAllSelectBtn.sd_layout.topSpaceToView(self, 0)
        .heightIs(49)
        .leftSpaceToView(self, 15).autoWidthRatio(0);
        
        self.mUpTopBtn.sd_layout.centerYEqualToView(self.mAllSelectBtn)
        .rightSpaceToView(self, KScreenScale(30))
        .heightIs(35).widthIs(100);
        
        self.mDeleteBtn.sd_layout.centerYEqualToView(self.mAllSelectBtn)
        .rightSpaceToView(self.mUpTopBtn, KScreenScale(30))
        .heightIs(35).widthIs(100);
    }
    return self;
}

- (void) setAllSelected:(BOOL)isAllSelected{
    self.isAllSelect=isAllSelected;
    if (self.isAllSelect) {
        self.mAllSelectBtn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellSelected"];
    }else{
        self.mAllSelectBtn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellNoSelect"];
    }
}

- (void)allselectedBtnClick:(UleControlView *)btn{
    self.isAllSelect=!self.isAllSelect;
    if (self.isAllSelect) {
        btn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellSelected"];
    }else{
        btn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_img_cellNoSelect"];
    }
    if (self.delegate &&[self.delegate respondsToSelector:@selector(seletAllGoods:)]) {
        [self.delegate seletAllGoods:self.isAllSelect];
    }
}

- (void)deleteBtnClick:(UleControlView *)btn{
    if (_onlyDeleteGoods) {
        if (self.delegate&& [self.delegate respondsToSelector:@selector(removeSeletedGoods)]) {
            [self.delegate removeSeletedGoods];
        }
    }else{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(deleteSeletedGoods)]) {
            [self.delegate deleteSeletedGoods];
        }
    }
}

- (void)uptopBtnClick:(UleControlView *)btn{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(upTopSelectedGoods)]) {
        [self.delegate upTopSelectedGoods];
    }
}

#pragma mark - <setter and getter>
- (void)setOnlyDeleteGoods:(BOOL)onlyDeleteGoods{
    _onlyDeleteGoods=onlyDeleteGoods;
    if (_onlyDeleteGoods) {
        self.mDeleteBtn.mImageView.image=[UIImage bundleImageNamed:@"myGoods_btn_remove"];
        self.mDeleteBtn.mTitleLabel.text=@"移除";
        self.mDeleteBtn.sd_layout.centerYEqualToView(self.mAllSelectBtn)
        .rightSpaceToView(self, KScreenScale(30))
        .heightIs(35).widthIs(100);
        self.mUpTopBtn.hidden=YES;
    }
}

- (UleControlView *)buildButtonWithTitle:(NSString *)title andImage:(NSString *)imageName{
    UleControlView * button=[[UleControlView alloc] init];
    button.mImageView.image=[UIImage bundleImageNamed:imageName];
    button.mTitleLabel.text=title;
    button.mImageView.sd_layout.leftSpaceToView(button, 0)
    .centerYEqualToView(button)
    .widthIs(20)
    .heightIs(20);
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

- (UleControlView *)mAllSelectBtn{
    if (!_mAllSelectBtn) {
        _mAllSelectBtn=[self buildButtonWithTitle:@"全选" andImage:@"myGoods_img_cellNoSelect"];
        [_mAllSelectBtn addTouchTarget:self action:@selector(allselectedBtnClick:)];
    }
    return _mAllSelectBtn;
}

- (UleControlView *)mDeleteBtn{
    if (!_mDeleteBtn) {
        _mDeleteBtn=[self buildRoundButtonWithTitle:@"删除" andImage:@"myGoods_btn_delete"];;
        _mDeleteBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
        [_mDeleteBtn addTouchTarget:self action:@selector(deleteBtnClick:)];
    }
    return _mDeleteBtn;
}

- (UleControlView *)mUpTopBtn{
    if (!_mUpTopBtn) {
        _mUpTopBtn=[self buildRoundButtonWithTitle:@"置顶" andImage:@"myGoods_btn_upTop"];
        _mUpTopBtn.backgroundColor=[UIColor convertHexToRGB:@"ffaa3b"];
        [_mUpTopBtn addTouchTarget:self action:@selector(uptopBtnClick:)];
    }
    return _mUpTopBtn;
}

@end
