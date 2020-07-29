//
//  WithdrawCashPromoteView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/7.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "WithdrawCashPromoteView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>
@interface WithdrawCashPromoteView ()
@property (nonatomic, assign) WithdrawCashPromoteType   type;
@property (nonatomic, copy) NSString                *num;
@property (nonatomic, copy) WithdrawCashConfirmBlock    confirmBlock;
@end

@implementation WithdrawCashPromoteView

+ (WithdrawCashPromoteView *)withdrawCashPromoteViewWithType:(WithdrawCashPromoteType)type andNum:(NSString *)num confirmBlock:(WithdrawCashConfirmBlock)block{
    return  [[WithdrawCashPromoteView alloc] initWithType:type andNum:num confirmBlock:block];
}

-(instancetype)initWithType:(WithdrawCashPromoteType)type andNum:(NSString *)num confirmBlock:(WithdrawCashConfirmBlock)block
{
    if (self=[super initWithFrame:CGRectMake(0, 0, KScreenScale(690), KScreenScale(420))]){
        _type=type;
        _num=num;
        _confirmBlock=[block copy];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=5;
     UIImageView *imgView=[[UIImageView alloc]init];
    [self addSubview:imgView];
    CGSize  imgSize=[self getImageViewSize:imgView WithPromotType:_type];
    imgView.sd_layout.leftSpaceToView(self, KScreenScale(70))
    .topSpaceToView(self, KScreenScale(104)).widthIs(imgSize.width).heightIs(imgSize.height);
    NSString * confirmTitle=@"";
    if (_type==WithdrawCashPromoteTypeWithdraw) {
        confirmTitle=@"确定";
        UILabel *withdrawTitle=[[UILabel alloc]init];
        withdrawTitle.textColor=[UIColor convertHexToRGB:@"333333"];
        withdrawTitle.font=[UIFont systemFontOfSize:KScreenScale(32)];
        withdrawTitle.text=@"此次申请的提现金额为";
        [self addSubview:withdrawTitle];
        withdrawTitle.sd_layout.leftSpaceToView(imgView, KScreenScale(40))
        .topSpaceToView(self, KScreenScale(66)).rightSpaceToView(self, 0)
        .heightIs(KScreenScale(40));
        
        UILabel *withdrawNum=[[UILabel alloc]init];
        withdrawNum.textColor=[UIColor convertHexToRGB:@"ef3b39"];
        withdrawNum.text=[NSString stringWithFormat:@"￥%@",_num];
        withdrawNum.font=[UIFont boldSystemFontOfSize:KScreenScale(50)];
        [self setAttributedWithdrawNum:withdrawNum];
        [self addSubview:withdrawNum];
        withdrawNum.sd_layout.leftEqualToView(withdrawTitle)
        .rightEqualToView(withdrawTitle)
        .heightRatioToView(withdrawTitle, 1).topSpaceToView(withdrawTitle, KScreenScale(15));
        
        UILabel *withdrawConfirm=[[UILabel alloc]init];
        withdrawConfirm.textColor=[UIColor convertHexToRGB:@"333333"];
        withdrawConfirm.text=@"请确认发送提现申请?";
        withdrawConfirm.font=[UIFont systemFontOfSize:KScreenScale(32)];
        [self addSubview:withdrawConfirm];
        withdrawConfirm.sd_layout.leftEqualToView(withdrawTitle)
        .rightEqualToView(withdrawTitle).heightRatioToView(withdrawTitle, 1).bottomSpaceToView(self, KScreenScale(156));
    }else{
        UILabel *titleLab=[[UILabel alloc]init];
        titleLab.textColor=[UIColor convertHexToRGB:@"333333"];
        titleLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
        titleLab.text=@"您还不能进行提现";
        [self addSubview:titleLab];
        titleLab.sd_layout.topSpaceToView(self, KScreenScale(100))
        .leftSpaceToView(imgView, KScreenScale(40)).rightSpaceToView(self, 0)
        .heightIs(KScreenScale(40));

        UILabel *descLab=[[UILabel alloc]init];
        descLab.textColor=[UIColor convertHexToRGB:@"333333"];
        descLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
        [self addSubview:descLab];
        if (_type==WithdrawCashPromoteTypeRealname) {
            confirmTitle=@"去认证";
            NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:@"请先进行实名认证您的身份"];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"ef3b39"] range:NSMakeRange(4, 4)];
            descLab.attributedText=attributedStr;
        }else if (_type==WithdrawCashPromoteTypeBindcard){
            confirmTitle=@"绑定银行卡";
            NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:@"请绑定一张邮储银行卡"];
            [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"ef3b39"] range:NSMakeRange(1, 2)];
            descLab.attributedText=attributedStr;
        }
        descLab.sd_layout.leftEqualToView(titleLab)
        .rightEqualToView(titleLab).heightRatioToView(titleLab, 1)
        .topSpaceToView(titleLab, KScreenScale(60));
    }
    
   
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
    backBtn.backgroundColor=[UIColor whiteColor];
    backBtn.layer.cornerRadius=5.0;
    backBtn.layer.borderColor=[UIColor convertHexToRGB:@"666666"].CGColor;
    backBtn.layer.borderWidth=0.5;
    [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    backBtn.sd_layout.leftSpaceToView(self, KScreenScale(50))
    .bottomSpaceToView(self, KScreenScale(20)).widthIs(KScreenScale(270)).heightIs(KScreenScale(88));
    
    UIButton *confirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    confirmBtn.backgroundColor=[UIColor convertHexToRGB:@"ef3b39"];
    confirmBtn.layer.cornerRadius=5.0;
    [confirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    confirmBtn.sd_layout.leftSpaceToView(backBtn, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(50))
    .heightRatioToView(backBtn, 1).topEqualToView(backBtn);
}

-(void)setAttributedWithdrawNum:(UILabel *)lab{
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:lab.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, 1)];
    lab.attributedText=attributedStr;
}


- (void)dismiss{
    [self hiddenView];
}

- (void)confirmBtnAction{
    [self hiddenView];
    if (self.confirmBlock) {
        self.confirmBlock(self.type);
    }
}

- (CGSize) getImageViewSize:(UIImageView *)imageView WithPromotType:(WithdrawCashPromoteType)type {
    CGSize   imgSize=CGSizeZero;
    NSString * imageName;
    switch (type) {
        case WithdrawCashPromoteTypeWithdraw:
            imageName=@"withdraw_icon_sure";
            imgSize=CGSizeMake(KScreenScale(150), KScreenScale(126));
            break;
        case WithdrawCashPromoteTypeRealname:
            imageName=@"withdraw_icon_realname";
            imgSize=CGSizeMake(KScreenScale(146), KScreenScale(140));
            break;
        case WithdrawCashPromoteTypeBindcard:
            imageName=@"withdraw_icon_bindcard";
            imgSize=CGSizeMake(KScreenScale(160), KScreenScale(160));
            break;
        default:
            break;
    }
    imageView.image=[UIImage bundleImageNamed:imageName];
    return imgSize;
}

@end
