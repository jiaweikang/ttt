//
//  UpdateUserConfirmAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserConfirmAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface UpdateUserConfirmAlertView ()
@property (nonatomic, strong) UILabel   *contentLab;
@property (nonatomic, strong) UIView    *topBgView;

@end

@implementation UpdateUserConfirmAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    //线
    UIView *lineView=[[UIView alloc]init];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"cccccc"];
    [self addSubview:lineView];
    lineView.sd_layout.topEqualToView(self)
    .leftEqualToView(self)
    .rightEqualToView(self)
    .heightIs(1);
    self.topBgView=[[UIView alloc]init];
    self.topBgView.backgroundColor=[UIColor convertHexToRGB:@"f3f3f3"];
    [self addSubview:self.topBgView];
    self.topBgView.sd_layout.topSpaceToView(self, 1)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(100));
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.text=@"提示";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    titleLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
    [self.topBgView addSubview:titleLab];
    titleLab.sd_layout.topEqualToView(self.topBgView)
    .leftEqualToView(self.topBgView)
    .bottomEqualToView(self.topBgView)
    .rightEqualToView(self.topBgView);
    UIButton *dismissBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [dismissBtn setBackgroundImage:[UIImage bundleImageNamed:@"regis_btn_alert_cancel"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.topBgView addSubview:dismissBtn];
    dismissBtn.sd_layout.centerYEqualToView(titleLab)
    .rightSpaceToView(self.topBgView, 20)
    .widthIs(20)
    .heightIs(20);
    
    _contentLab=[[UILabel alloc]init];
    _contentLab.textAlignment=NSTextAlignmentCenter;
    _contentLab.textColor=[UIColor convertHexToRGB:@"333333"];
    _contentLab.font=[UIFont systemFontOfSize:KScreenScale(30)];
    [self addSubview:_contentLab];
    _contentLab.sd_layout.topSpaceToView(self.topBgView, KScreenScale(40))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(60));
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"不保存" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    cancelBtn.layer.borderWidth=1.0;
    cancelBtn.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
    cancelBtn.layer.cornerRadius=5.0;
    [cancelBtn addTarget:self action:@selector(notConfirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"保存" forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor convertHexToRGB:@"ee3b39"]];
    confirmBtn.layer.cornerRadius=5.0;
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    CGFloat btnWidth = (__MainScreen_Width-KScreenScale(110))*0.5;
    cancelBtn.sd_layout.leftSpaceToView(self, KScreenScale(40))
    .bottomSpaceToView(self, KScreenScale(40))
    .widthIs(btnWidth)
    .heightIs(KScreenScale(90));
    confirmBtn.sd_layout.centerYEqualToView(cancelBtn)
    .leftSpaceToView(cancelBtn, KScreenScale(30))
    .widthRatioToView(cancelBtn, 1.0)
    .heightRatioToView(cancelBtn, 1.0);
}

#pragma mark - <ACTION>
-(void)setContentLabStr:(NSString *)str
{
//    if (str.length<=0) {
//        return;
//    }
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:KScreenScale(16)];
//    [paragraphStyle setAlignment:NSTextAlignmentCenter];
//    NSDictionary *attributeDic=@{NSParagraphStyleAttributeName:paragraphStyle};
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str attributes:attributeDic];
//    [_contentLab setAttributedText:attributedString];
    self.contentLab.text = str;
}

//添加提示描述
- (void)addHintMessage
{
    _contentLab.textColor = [UIColor blackColor];
    _contentLab.font = [UIFont boldSystemFontOfSize:KScreenScale(32)];
    _contentLab.sd_layout.topSpaceToView(self.topBgView, KScreenScale(10));
    
    UILabel *hintTextLbl1 = [[UILabel alloc] init];
    hintTextLbl1.textColor = [UIColor convertHexToRGB:@"666666"];
    hintTextLbl1.font = [UIFont systemFontOfSize:KScreenScale(28)];
    hintTextLbl1.numberOfLines = 0;
    hintTextLbl1.textAlignment = NSTextAlignmentCenter;
    hintTextLbl1.text = @"帅康用户确认后不可修改";
    [self addSubview:hintTextLbl1];
    
    UILabel *hintTextLbl2 = [[UILabel alloc] init];
    hintTextLbl2.textColor = [UIColor convertHexToRGB:@"666666"];
    hintTextLbl2.font = [UIFont systemFontOfSize:KScreenScale(28)];
    hintTextLbl2.numberOfLines = 0;
    hintTextLbl2.textAlignment = NSTextAlignmentCenter;
    hintTextLbl2.text = @"如需调整请联系该集团";
    [self addSubview:hintTextLbl2];
    hintTextLbl1.sd_layout.topSpaceToView(_contentLab, KScreenScale(10))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30));
    hintTextLbl2.sd_layout.topSpaceToView(hintTextLbl1, KScreenScale(10))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30));
}

- (void)dismiss{
    [self hiddenView];
}

-(void)confirmBtnAction {
    [self hiddenView];
    if (_mConfirmBlock) {
        _mConfirmBlock();
    }
}
- (void)notConfirmBtnAction {
    [self hiddenView];
    if (_mCancelBlock) {
        _mCancelBlock();
    }
}


@end
