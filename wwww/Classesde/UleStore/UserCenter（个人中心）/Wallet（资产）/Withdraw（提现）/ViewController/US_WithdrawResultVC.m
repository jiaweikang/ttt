//
//  US_WithdrawResultVC.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/28.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_WithdrawResultVC.h"
#import "MyUILabel.h"

@interface US_WithdrawResultVC ()
@property (nonatomic, assign) NSInteger     resultType;//0-失败  1-成功

@end

@implementation US_WithdrawResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"提现"];
    self.resultType = [[self.m_Params objectForKey:@"resultType"] integerValue];
    [self setUI];
}

//返回
-(void)ule_toLastViewController{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"US_IncomeManageVC"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_RefreshIncomeData object:nil];
            [self.navigationController popToViewController:vc animated:YES];
            return;
        }
    }
    [super ule_toLastViewController];
}



- (void)setUI{
    CGFloat topViewHeight = 0.0;
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *topView=[[UIView alloc]init];
    topView.backgroundColor=kViewCtrBackColor;
    [self.view addSubview:topView];
    UIImageView *imageView=[[UIImageView alloc]init];
    if (self.resultType == 1) {
        imageView.image=[UIImage bundleImageNamed:@"withdraw_img_success"];
    }else{
        imageView.image=[UIImage bundleImageNamed:@"withdraw_img_fail"];
    }
    [topView addSubview:imageView];
    UILabel *titleLab=[[UILabel alloc]init];
    titleLab.numberOfLines=0;
    titleLab.adjustsFontSizeToFitWidth = YES;
    titleLab.textColor=[UIColor convertHexToRGB:kBlackTextColor];
    titleLab.text=self.resultType==1?@"提现申请发送成功!":self.m_Params[@"resultMessage"]?self.m_Params[@"resultMessage"]:@"";
    titleLab.font=[UIFont boldSystemFontOfSize:KScreenScale(50)];
    [topView addSubview:titleLab];
    CGFloat titleW=[titleLab.text widthForFont:titleLab.font]+5;
    if (titleW>__MainScreen_Width-KScreenScale(190)) {
        CGFloat titleH=[titleLab.text heightForFont:titleLab.font width:__MainScreen_Width-KScreenScale(190)]+5;
        titleLab.sd_layout.topSpaceToView(topView, KScreenScale(60))
        .rightSpaceToView(topView, KScreenScale(30))
        .widthIs(__MainScreen_Width-KScreenScale(190))
        .heightIs(titleH);
        topViewHeight+=(titleH+KScreenScale(60));
    }else{
        titleLab.sd_layout.topSpaceToView(topView, KScreenScale(60))
        .rightSpaceToView(topView, (__MainScreen_Width-titleW-KScreenScale(130))*0.5)
        .widthIs(titleW)
        .heightIs(KScreenScale(50));
        topViewHeight+=(KScreenScale(60)+KScreenScale(50));
    }
    imageView.sd_layout.topEqualToView(titleLab)
    .rightSpaceToView(titleLab, KScreenScale(30))
    .widthIs(KScreenScale(100))
    .heightIs(KScreenScale(100));
    UILabel *subTitleLab=[[UILabel alloc]init];
    subTitleLab.textColor=[UIColor convertHexToRGB:kBlackTextColor];
    subTitleLab.text=@"申请提现金额";
    subTitleLab.font=[UIFont systemFontOfSize:KScreenScale(30)];
    [topView addSubview:subTitleLab];
    subTitleLab.sd_layout.topSpaceToView(titleLab, KScreenScale(30))
    .leftEqualToView(titleLab)
    .rightEqualToView(titleLab)
    .heightIs(20);
    topViewHeight+=(KScreenScale(30)+20);
    MyUILabel *withdrawNumLab=[[MyUILabel alloc]init];
    withdrawNumLab.verticalAlignment=VerticalAlignmentBottom;
    withdrawNumLab.textColor=kCommonRedColor;
    withdrawNumLab.font=[UIFont systemFontOfSize:KScreenScale(50)];
    NSString *num=self.m_Params[@"withdrawNum"];
    withdrawNumLab.text=[NSString stringWithFormat:@"￥%.2lf",num.doubleValue];
    [self setAttributedWithdrawNum:withdrawNumLab];
    [topView addSubview:withdrawNumLab];
    withdrawNumLab.sd_layout.topSpaceToView(subTitleLab, 0)
    .leftEqualToView(subTitleLab)
    .rightEqualToView(subTitleLab)
    .heightIs(KScreenScale(45));
    topViewHeight+=KScreenScale(45);
    topView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(topViewHeight+KScreenScale(50));
    
    //提示
    UILabel *contentLab=[[UILabel alloc]init];
    contentLab.adjustsFontSizeToFitWidth = YES;
    contentLab.textColor=[UIColor convertHexToRGB:kBlackTextColor];
    contentLab.font=[UIFont systemFontOfSize:KScreenScale(32)];
    contentLab.numberOfLines=0;
    [self.view addSubview:contentLab];
    //    [self setAttributedContentLab:contentLab];
    
    CGFloat contentH=0.0;
    NSString *subStr=[NSString isNullToString:self.m_Params[@"resultSubs"]?self.m_Params[@"resultSubs"]:@""];
    if ([subStr rangeOfString:@"##"].location!=NSNotFound) {
        contentLab.text = [NSString stringWithFormat:@"*%@",[subStr stringByReplacingOccurrencesOfString:@"##" withString:@"\n"]];
        contentH=[subStr heightForFont:contentLab.font width:__MainScreen_Width-KScreenScale(60)]+5;
    }else if (subStr.length>0){
        contentLab.text = [NSString stringWithFormat:@"*%@",subStr];
        contentH=[subStr heightForFont:[UIFont systemFontOfSize:KScreenScale(32)] width:__MainScreen_Width-20]+5;
    }
    
    contentLab.sd_layout.topSpaceToView(topView, KScreenScale(30))
    .leftSpaceToView(self.view, KScreenScale(30))
    .rightSpaceToView(self.view, KScreenScale(30))
    .heightIs(contentH);
    
    //按钮
    UIButton *myWalletBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [myWalletBtn setTitle:@"返回我的收益" forState:UIControlStateNormal];
    myWalletBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(39)];
    [myWalletBtn setTitleColor:[UIColor convertHexToRGB:kBlackTextColor] forState:UIControlStateNormal];
    myWalletBtn.layer.cornerRadius=5;
    myWalletBtn.layer.borderWidth=0.5;
    myWalletBtn.layer.borderColor=[UIColor convertHexToRGB:kDarkTextColor].CGColor;
    [myWalletBtn addTarget:self action:@selector(backToCommissionVC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myWalletBtn];
    myWalletBtn.sd_layout.bottomSpaceToView(self.view, KScreenScale(80))
    .leftSpaceToView(self.view, KScreenScale(70))
    .rightSpaceToView(self.view, KScreenScale(70))
    .heightIs(KScreenScale(88));
    
    UIButton *recordBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [recordBtn setTitle:self.resultType==1?@"查看提现记录":@"重新提现" forState:UIControlStateNormal];
    recordBtn.titleLabel.font=[UIFont systemFontOfSize:KScreenScale(39)];
    [recordBtn setTitleColor:[UIColor convertHexToRGB:kBlackTextColor] forState:UIControlStateNormal];
    recordBtn.layer.cornerRadius=5;
    recordBtn.layer.borderWidth=0.5;
    recordBtn.layer.borderColor=[UIColor convertHexToRGB:kDarkTextColor].CGColor;
    [recordBtn addTarget:self action:@selector(btn0Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recordBtn];
    recordBtn.sd_layout.bottomSpaceToView(myWalletBtn, KScreenScale(44))
    .leftSpaceToView(self.view, KScreenScale(70))
    .rightSpaceToView(self.view, KScreenScale(70))
    .heightIs(KScreenScale(88));
}


-(void)setAttributedWithdrawNum:(UILabel *)lab{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:lab.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(32)] range:NSMakeRange(0, 1)];
    lab.attributedText=attributedStr;
}


-(void)setAttributedContentLab:(UILabel *)lab{
    if (lab.text.length==0) {
        return;
    }
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:lab.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributedStr length])];
    lab.attributedText=attributedStr;
}


-(void)btn0Action:(UIButton *)sender{
    if (self.resultType == 1) {//查看提现记录
        NSString *accTypeId = self.m_Params[@"accTypeId"];
        NSMutableDictionary *params = @{
                                        @"accTypeId":[NSString isNullToString:accTypeId].length > 0 ? accTypeId : @""
                                        }.mutableCopy;
        [self pushNewViewController:@"US_WithdrawRecordVC" isNibPage:NO withData:params];
    }else{//重新提现
        //刷新提现页面
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_RefreshWithdrawView object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)backToCommissionVC:(UIButton *)sender{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([NSStringFromClass([vc class]) isEqualToString:@"US_IncomeManageVC"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_RefreshIncomeData object:nil];
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
        if ([NSStringFromClass([vc class]) isEqualToString:@"OwnGoodsDetailListVC"]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}


@end
