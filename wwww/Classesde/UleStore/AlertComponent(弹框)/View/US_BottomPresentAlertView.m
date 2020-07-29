//
//  US_BottomPresentAlertView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/6/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_BottomPresentAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface US_BottomPresentAlertView ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *confirmTitle;

@property (nonatomic, copy) ConfirmActionBlock confirmBlock;

@end


@implementation US_BottomPresentAlertView

+(US_BottomPresentAlertView *)BottomPresentAlertViewWithTitle:(NSString *)title
                                                      Message:(NSString *)message
                                                  cancelTitle:(NSString *)cancelTitle
                                                 ConfirmTitle:(NSString *)confirmTitle
                                                confirmAction:(ConfirmActionBlock)confirmBlock{
    return [[self alloc] initWithTitle:title Message:message cancelTitle:cancelTitle ConfirmTitle:confirmTitle confirmAction:confirmBlock];
    
}
-(instancetype)initWithTitle:(NSString *)title
                     Message:(NSString *)message
                 cancelTitle:(NSString *)cancelTitle
                ConfirmTitle:(NSString *)confirmTitle
               confirmAction:(ConfirmActionBlock)confirmBlock
{
    if (self=[super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(400))]){
        _title=title;
        _message=message;
        _cancelTitle=cancelTitle;
        _confirmTitle=confirmTitle;
        _confirmBlock = confirmBlock;
        [self setUI];
    }
    return self;
}

-(void)setUI{
    
    self.backgroundColor=[UIColor whiteColor];
    UIView * titleBackView=[UIView new];
    titleBackView.backgroundColor=[UIColor convertHexToRGB:@"f3f3f3"];
    [self addSubview:titleBackView];
    
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
    titleLab.text=self.title;
    titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    
    UILabel * messageLab=[[UILabel alloc]init];
    messageLab.textAlignment=NSTextAlignmentCenter;
    messageLab.font=[UIFont systemFontOfSize:KScreenScale(30)];
    messageLab.text=self.message;
    messageLab.textColor=titleLab.textColor;
    messageLab.numberOfLines = 0;

    UIButton * cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.backgroundColor=[UIColor whiteColor];
    cancelBtn.layer.borderWidth=1.0;
    cancelBtn.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
    cancelBtn.layer.cornerRadius=5.0;
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(36)];
    [cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.backgroundColor=[UIColor whiteColor];
    confirmBtn.layer.borderWidth=1.0;
    confirmBtn.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
    confirmBtn.layer.cornerRadius=5.0;
    [confirmBtn setTitle:self.confirmTitle forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    confirmBtn.titleLabel.font=cancelBtn.titleLabel.font;
    [confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self sd_addSubviews:@[titleLab,messageLab,cancelBtn,confirmBtn]];
     titleBackView.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .heightIs(KScreenScale(100));
    titleLab.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30))
    .centerYEqualToView(titleBackView);
    
    messageLab.sd_layout
    .topSpaceToView(titleBackView, KScreenScale(20))
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(100));
    
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
