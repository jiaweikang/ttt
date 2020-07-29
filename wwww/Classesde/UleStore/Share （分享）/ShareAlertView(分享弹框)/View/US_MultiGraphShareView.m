//
//  US_MultiGraphShareView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/14.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "US_MultiGraphShareView.h"
#import <UIView+ShowAnimation.h>
#import <UIView+SDAutoLayout.h>
@implementation US_MultiGraphShareView

- (instancetype)initWithFrame:(CGRect)frame{
    CGFloat viewHeight = kIphoneX ? KScreenScale(500) : KScreenScale(500) + 24;
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, viewHeight)];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor=[UIColor whiteColor];
    UILabel *titleLbl = [[UILabel alloc] init];
    titleLbl.textAlignment = 1;
    titleLbl.backgroundColor = [UIColor convertHexToRGB:@"ef3b39"];
    titleLbl.font = [UIFont systemFontOfSize:18];
    titleLbl.textColor = [UIColor whiteColor];
    titleLbl.text = @"多图分享操作步骤";
    [self addSubview:titleLbl];
    titleLbl.sd_layout.leftSpaceToView(self, 0)
    .topSpaceToView(self, 0).rightSpaceToView(self, 0)
    .heightIs(KScreenScale(100));
    
    UILabel *desLbl1 = [[UILabel alloc] init];
    desLbl1.numberOfLines = 0;
    desLbl1.textColor = [UIColor lightGrayColor];
    desLbl1.font = [UIFont systemFontOfSize:14];
    desLbl1.text = @"  描述文字已复制，可以长按或双击粘贴";
    desLbl1.attributedText = [self AttributedString:desLbl1.text];
    [self addSubview:desLbl1];
    desLbl1.sd_layout.leftSpaceToView(self, KScreenScale(60))
    .rightSpaceToView(self, KScreenScale(60))
    .topSpaceToView(titleLbl, KScreenScale(30))
    .heightIs(KScreenScale(50));
    
    UILabel *desLbl2 = [[UILabel alloc] init];
    desLbl2.numberOfLines = 0;
    desLbl2.textColor = [UIColor lightGrayColor];
    desLbl2.font = [UIFont systemFontOfSize:14];
    desLbl2.text = @"  图片已自动下载至手机相册";
    desLbl2.attributedText = [self AttributedString:desLbl2.text];
    [self addSubview:desLbl2];
    desLbl2.sd_layout.leftSpaceToView(self, KScreenScale(60))
    .rightSpaceToView(self, KScreenScale(60))
    .topSpaceToView(desLbl1, KScreenScale(30))
    .heightIs(KScreenScale(50));
    
    UILabel *desLbl3 = [[UILabel alloc] init];
    desLbl3.numberOfLines = 0;
    desLbl3.textColor = [UIColor lightGrayColor];
    desLbl3.font = [UIFont systemFontOfSize:14];
    desLbl3.text = @"  打开微信，从手机相册中选择图片发布";
    desLbl3.attributedText = [self AttributedString:desLbl3.text];
    [self addSubview:desLbl3];
    desLbl3.sd_layout.leftSpaceToView(self, KScreenScale(60))
    .rightSpaceToView(self, KScreenScale(60))
    .topSpaceToView(desLbl2, KScreenScale(30))
    .heightIs(KScreenScale(50));
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:[UIColor convertHexToRGB:@"eeeeee"]];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 6;
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    cancelBtn.tag = 2000;
    [cancelBtn addTarget:self action:@selector(cancBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
     CGFloat btnWidth = (__MainScreen_Width - KScreenScale(60)) / 2 - 20;
    cancelBtn.sd_layout.leftSpaceToView(self, KScreenScale(60))
    .bottomSpaceToView(self, KScreenScale(30)).widthIs(btnWidth).heightIs(40);
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"去分享" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
    confirmBtn.layer.masksToBounds = YES;
    confirmBtn.layer.cornerRadius = 6;
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [confirmBtn addTarget:self action:@selector(guideBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.tag = 2001;
    [self addSubview:confirmBtn];
    confirmBtn.sd_layout.rightSpaceToView(self, KScreenScale(60))
    .bottomEqualToView(cancelBtn)
    .widthRatioToView(cancelBtn, 1)
    .heightRatioToView(cancelBtn, 1);
}

- (NSMutableAttributedString *)AttributedString:(NSString *)text
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage bundleImageNamed:@"share_icon_multiok"];
    attach.bounds = CGRectMake(0, 0, 14, 14);
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    //将图片插入到合适的位置
    [string insertAttributedString:attachString atIndex:0];
    
    return string;
    
}

- (void)guideBtnAction:(UIButton *)btn{
    NSURL * url = [NSURL URLWithString:@"weixin://"];
    BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
    //先判断是否能打开该url
    if (canOpen)
    {   //打开微信
        [[UIApplication sharedApplication] openURL:url];
    }
    [self hiddenView];
}
- (void)cancBtnAction:(UIButton *)btn{
    [self hiddenView];
}
@end
