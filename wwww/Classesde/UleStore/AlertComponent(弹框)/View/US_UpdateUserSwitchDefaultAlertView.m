//
//  US_UpdateUserSwitchDefaultAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/27.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UpdateUserSwitchDefaultAlertView.h"
#import <UIView+ShowAnimation.h>
#import <UIView+SDAutoLayout.h>

@implementation US_UpdateUserSwitchDefaultAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width-KScreenScale(120), KScreenScale(260))]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=5.0;
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.text=@"关闭企业信息";
    titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    titleLab.font=[UIFont systemFontOfSize:14];
    titleLab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:titleLab];
    titleLab.sd_layout.topSpaceToView(self, KScreenScale(30))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(35));
    UILabel *contentLab=[[UILabel alloc]init];
    contentLab.text=@"关闭后您将没有挂靠机构，确认关闭？";
    contentLab.textColor=[UIColor convertHexToRGB:@"333333"];
    contentLab.font=[UIFont systemFontOfSize:13];
    contentLab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:contentLab];
    contentLab.sd_layout.topSpaceToView(titleLab, KScreenScale(40))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(35));
    UIView *horiLine=[[UIView alloc]init];
    horiLine.backgroundColor=[UIColor convertHexToRGB:@"999999"];
    [self addSubview:horiLine];
    horiLine.sd_layout.topSpaceToView(contentLab, KScreenScale(40))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1.0);
    UIView *verticalLine=[[UIView alloc]init];
    verticalLine.backgroundColor=[UIColor convertHexToRGB:@"999999"];
    [self addSubview:verticalLine];
    verticalLine.sd_layout.centerXEqualToView(horiLine)
    .topSpaceToView(horiLine, 0)
    .widthIs(1.0)
    .bottomSpaceToView(self, 0);
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"999999"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确认关闭" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    cancelBtn.sd_layout.topSpaceToView(horiLine, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(verticalLine, 0)
    .bottomSpaceToView(self, 0);
    confirmBtn.sd_layout.topSpaceToView(horiLine, 0)
    .leftSpaceToView(verticalLine, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
}

- (void)cancelBtnAction{
    [self hiddenView];
}
- (void)confirmBtnAction{
    [self hiddenView];
    if (self.mConfirmBlock) {
        self.mConfirmBlock();
    }
}

@end
