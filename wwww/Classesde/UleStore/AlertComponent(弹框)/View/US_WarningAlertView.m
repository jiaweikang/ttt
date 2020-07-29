//
//  US_WarningAlertView.m
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_WarningAlertView.h"
#import <UIView+ShowAnimation.h>
#import <UIView+SDAutoLayout.h>
#import "UIView+Shade.h"

#define CancelBtnTag  1000
#define ConfirmBtnTag 2000

@interface US_WarningAlertView ()
@property (nonatomic, strong) UIImageView *warningImgView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *desLbl;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation US_WarningAlertView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width - KScreenScale(152), KScreenScale(496))];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = KScreenScale(16);
    
    [self sd_addSubviews:@[self.warningImgView, self.titleLbl, self.desLbl, self.cancelBtn, self.confirmBtn]];
    
    self.warningImgView.sd_layout.topSpaceToView(self, KScreenScale(32))
    .leftSpaceToView(self, KScreenScale(228))
    .rightSpaceToView(self, KScreenScale(228))
    .heightEqualToWidth();
    
    self.titleLbl.sd_layout.topSpaceToView(self.warningImgView, KScreenScale(26))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(34));
    
    self.desLbl.sd_layout.topSpaceToView(self.titleLbl, KScreenScale(40))
    .leftSpaceToView(self, KScreenScale(40))
    .rightSpaceToView(self, KScreenScale(40))
    .heightIs(KScreenScale(90));
    
    self.confirmBtn.sd_layout.bottomSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .widthIs(self.frame.size.width / 2)
    .heightIs(KScreenScale(90));
    
    self.cancelBtn.sd_layout.bottomSpaceToView(self, 0)
    .leftSpaceToView(self.confirmBtn, 0.5)
    .widthIs(self.frame.size.width / 2)
    .heightIs(KScreenScale(90));
    
    [UIView setDirectionBorderWithView:_confirmBtn top:YES left:NO bottom:NO right:YES borderColor:[UIColor lightGrayColor] withBorderWidth:0.5];
    [UIView setDirectionBorderWithView:_cancelBtn top:YES left:NO bottom:NO right:NO borderColor:[UIColor lightGrayColor] withBorderWidth:0.5];
}

- (void)btnAction:(UIButton *)btn
{
    if (btn.tag == ConfirmBtnTag) {
        if (self.confirmBlock) {
            self.confirmBlock();
        }
    }
    [self hiddenView];
}

#pragma mark - setter and getter
- (UIImageView *)warningImgView
{
    if (!_warningImgView) {
        _warningImgView = [[UIImageView alloc] init];
        _warningImgView.image = [UIImage bundleImageNamed:@"updateUsrInfoWarn"];
    }
    return _warningImgView;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.text = @"修改确认";
        _titleLbl.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
        _titleLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLbl;
}

- (UILabel *)desLbl
{
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.text = @"改为帅康用户后将无法再修改企业信息，是否确认修改";
        _desLbl.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _desLbl.textAlignment = NSTextAlignmentCenter;
        _desLbl.numberOfLines = 2;
    }
    return _desLbl;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"再想想" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _cancelBtn.tag = CancelBtnTag;
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _confirmBtn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(32)];
        _confirmBtn.tag = ConfirmBtnTag;
        [_confirmBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _confirmBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
