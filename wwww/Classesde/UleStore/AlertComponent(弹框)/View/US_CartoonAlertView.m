//
//  US_CartoonAlertView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/4/3.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_CartoonAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_CartoonAlertView ()

@property (nonatomic, copy) CartoonAlertBlock confirmBlock;
@property (nonatomic, copy) NSString    *alertMsg;
@property (nonatomic, strong) UIView    *bgView;

@end
@implementation US_CartoonAlertView

+(US_CartoonAlertView *)cartoonAlertViewWithMessage:(NSString *)msg confirmBlock:(CartoonAlertBlock)confirmBlock
{
    return [[self alloc]initWithAlertMessage:msg confirmBlock:confirmBlock];
}

-(instancetype)initWithAlertMessage:(NSString *)msg confirmBlock:(CartoonAlertBlock)confirmBlock{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]){
        _confirmBlock=confirmBlock;
        _alertMsg=msg;
        [self setUI];
    }
    return self;
}

-(void)setUI {
    self.clipsToBounds=NO;
    self.backgroundColor=[UIColor whiteColor];
    UIImageView *babyImgView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"alert_baby"]];
    
    UILabel *alertLab=[[UILabel alloc]init];
    alertLab.textAlignment=NSTextAlignmentCenter;
    alertLab.text=_alertMsg;
    alertLab.numberOfLines = 0;
    alertLab.textColor=[UIColor convertHexToRGB:@"333333"];
    alertLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor=[UIColor whiteColor];
    cancelBtn.layer.borderWidth=1.0;
    cancelBtn.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
    cancelBtn.layer.cornerRadius=5.0;
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(36)];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3c3a"];
    confirmBtn.layer.cornerRadius=5.0;
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=cancelBtn.titleLabel.font;
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self sd_addSubviews:@[babyImgView,alertLab,cancelBtn,confirmBtn]];
    babyImgView.sd_layout
    .topSpaceToView(self, -KScreenScale(46))
    .centerXEqualToView(self)
    .widthIs(KScreenScale(186))
    .heightIs(KScreenScale(188));
    alertLab.sd_layout
    .topSpaceToView(babyImgView, KScreenScale(42))
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(50));
    cancelBtn.sd_layout
    .bottomSpaceToView(self, KScreenScale(30))
    .leftSpaceToView(self, KScreenScale(20))
    .widthIs(__MainScreen_Width/2-KScreenScale(15)-KScreenScale(20))
    .heightIs(KScreenScale(90));
    confirmBtn.sd_layout
    .bottomEqualToView(cancelBtn)
    .rightSpaceToView(self, KScreenScale(20))
    .widthRatioToView(cancelBtn, 1)
    .heightRatioToView(cancelBtn, 1);
}

-(void)dismiss
{
    [self hiddenView];
}

-(void)confirmAction:(id)sender
{
    [self hiddenView];
    if (_confirmBlock) {
        _confirmBlock();
    }
}
@end
