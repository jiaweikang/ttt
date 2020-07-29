//
//  UpdateUserHeaderView.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserHeaderView.h"
#import <UIView+SDAutoLayout.h>
#import "UpdateUserHeaderModel.h"
#import "US_UpdateUserSwitchDefaultAlertView.h"
#import <UIView+ShowAnimation.h>

@interface UpdateUserHeaderView ()
@property (nonatomic, strong)UILabel    * titleLab;
@end

@implementation UpdateUserHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView sd_addSubviews:@[self.titleLab]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .bottomSpaceToView(self.contentView, 0);
}

- (void)setModel:(UpdateUserHeaderModel *)model{
    self.titleLab.text=model.titleStr;
}
#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        _titleLab.font=[UIFont systemFontOfSize:14];
    }
    return _titleLab;
}
@end


@interface UpdateUserHeaderView1 ()
@property (nonatomic, strong)UILabel    * titleLab;
@property (nonatomic, strong)UISwitch   * switchView;
@property (nonatomic, strong)UIButton   * switchCoverBtn;
@property (nonatomic, strong)UIView     * lineView;
@property (nonatomic, strong)UIView     * bgView;
@property (nonatomic, strong)UILabel    * contentLab;
@property (nonatomic, strong)UIButton   * quitTeamBtn;
@property (nonatomic, strong)UpdateUserHeaderModel  * mModel;
@end

@implementation UpdateUserHeaderView1

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView sd_addSubviews:@[self.titleLab,self.switchView,self.lineView,self.bgView]];
    [self.bgView sd_addSubviews:@[self.contentLab,self.quitTeamBtn]];
    self.titleLab.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.switchView, 10)
    .heightIs(50-1);
    self.switchView.sd_layout.centerYEqualToView(self.titleLab)
    .rightSpaceToView(self.contentView, 10)
    .widthIs(51)
    .heightIs(31);
    [self.switchView addSubview:self.switchCoverBtn];
    self.switchCoverBtn.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.lineView.sd_layout.topSpaceToView(self.titleLab, 0)
    .leftEqualToView(self.titleLab)
    .rightEqualToView(self.switchView)
    .heightIs(1.0);
    self.bgView.sd_layout.topSpaceToView(self.lineView, 0)
    .leftSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0);
    self.quitTeamBtn.sd_layout.topSpaceToView(self.bgView, 5)
    .rightSpaceToView(self.bgView, 10)
    .widthIs(70)
    .heightIs(25);
    self.contentLab.sd_layout.topSpaceToView(self.bgView, 0)
    .leftSpaceToView(self.bgView, 10)
    .rightSpaceToView(self.quitTeamBtn, 0)
    .bottomSpaceToView(self.bgView, 0);
    
}

- (void)setModel:(UpdateUserHeaderModel *)model{
    self.mModel=model;
    self.titleLab.text=model.titleStr;
    switch (model.switchStatus) {
        case UpdateUserSwitchStatusOn:
            self.switchView.on=YES;
            break;
        case UpdateUserSwitchStatusOff:
            self.switchView.on=NO;
            break;
        default:
            break;
    }
    self.contentLab.text=[NSString isNullToString:model.contentStr];
    if (model.userType==UpdateUserTypeNone||model.userType==UpdateUserTypeShuaiKang) {
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        self.titleLab.font=[UIFont systemFontOfSize:16];
        self.titleLab.sd_layout.heightIs(50-1);
        self.switchView.hidden=NO;
        self.quitTeamBtn.hidden=YES;
    }else if (model.userType==UpdateUserTypeTeam) {
        self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
        self.titleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        self.titleLab.font=[UIFont systemFontOfSize:14];
        self.titleLab.sd_layout.heightIs(35-1);
        self.switchView.hidden=YES;
        self.quitTeamBtn.hidden=NO;
    }else if (model.userType==UpdateUserTypeAuth || model.userType==UpdateUserTypeAuthInReview) {
        self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
        self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
        self.titleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        self.titleLab.font=[UIFont systemFontOfSize:14];
        self.titleLab.sd_layout.heightIs(35-1);
        self.switchView.hidden=YES;
        self.quitTeamBtn.hidden=YES;
    }
    if (self.quitTeamBtn.hidden) {
        self.contentLab.sd_layout.rightSpaceToView(self.bgView, 10);
    }else {
        self.contentLab.sd_layout.rightSpaceToView(self.quitTeamBtn, 0);
    }
}

- (void)switchCoverBtnAction{
    if (self.switchView.isOn) {
        //弹框
        US_UpdateUserSwitchDefaultAlertView *alertView=[[US_UpdateUserSwitchDefaultAlertView alloc]init];
        alertView.mConfirmBlock = ^{
            [self shiftSwitchStatus:self.switchView];
        };
        [alertView showViewWithAnimation:AniamtionAlert];
    }else {
        [self shiftSwitchStatus:self.switchView];
    }
}
- (void)shiftSwitchStatus:(UISwitch *)sw{
    if (self.mModel.switchShiftBlock) {
        self.mModel.switchShiftBlock(sw);
    }
}
- (void)quitTeamBtnAction{
    if (self.mModel.quitTeamBlock) {
        self.mModel.quitTeamBlock();
    }
}
#pragma mark - <getters>
- (UILabel *)titleLab{
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLab.font=[UIFont systemFontOfSize:16];
    }
    return _titleLab;
}
- (UISwitch *)switchView{
    if (!_switchView) {
        _switchView=[[UISwitch alloc]init];
    }
    return _switchView;
}
- (UIButton *)switchCoverBtn{
    if (!_switchCoverBtn) {
        _switchCoverBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _switchCoverBtn.backgroundColor=[UIColor clearColor];
        [_switchCoverBtn addTarget:self action:@selector(switchCoverBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchCoverBtn;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView=[[UIView alloc]init];
        _lineView.backgroundColor=[UIColor convertHexToRGB:@"f1f1f1"];
    }
    return _lineView;
}
- (UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc]init];
        _bgView.backgroundColor=[UIColor convertHexToRGB:@"fff1dc"];
    }
    return _bgView;
}
- (UILabel *)contentLab{
    if (!_contentLab) {
        _contentLab=[[UILabel alloc]init];
        _contentLab.textColor=[UIColor convertHexToRGB:@"ed4b4c"];
        _contentLab.font=[UIFont systemFontOfSize:14];
    }
    return _contentLab;
}
-(UIButton *)quitTeamBtn{
    if (!_quitTeamBtn) {
        _quitTeamBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_quitTeamBtn setTitle:@"立即前往" forState:UIControlStateNormal];
        [_quitTeamBtn setTitleColor:[UIColor convertHexToRGB:@"ed4b4c"] forState:UIControlStateNormal];
        _quitTeamBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_quitTeamBtn addTarget:self action:@selector(quitTeamBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _quitTeamBtn;
}
@end
