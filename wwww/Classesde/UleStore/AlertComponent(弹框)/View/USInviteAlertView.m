//
//  USInviteAlertView.m
//  UleStoreApp
//
//  Created by xulei on 2019/3/6.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "USInviteAlertView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>

@interface USInviteAlertView ()
// 取消
@property (nonatomic, strong) UIButton *mCancelBtn;
// 文字内容
@property (nonatomic, strong) NSString *mCancelString;
// 确定1
@property (nonatomic, strong) UIButton *mSureBtn1;
// 确定2
@property (nonatomic, strong) UIButton *mSureBtn2;
// 文字内容1
@property (nonatomic, strong) NSString *mSureStr1;
// 文字内容2
@property (nonatomic, strong) NSString *mSureStr2;
// 标题
@property (nonatomic, strong) UILabel *mTitleLabel;
// 文字内容
@property (nonatomic, strong) NSString *mTitleString;
// 上半部分view
@property (nonatomic, strong) UIView *mTopView;

@end

@implementation USInviteAlertView

- (instancetype)initWithSure1:(NSString *)mSure1 withSure2:(NSString *)mSure2 withCancel:(NSString *)mCancel withTitle:(NSString *)mTitle
{
    if (self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kIphoneX ? KScreenScale(428)+34 : KScreenScale(428))]) {
        self.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        if (mTitle) {
            _mTitleString = mTitle;
        }
        if (mSure1) {
            _mSureStr1 = mSure1;
        }
        if (mSure2) {
            _mSureStr2 = mSure2;
        }
        if (mCancel) {
            _mCancelString = mCancel;
        }
        
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.mCancelBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor=[UIColor whiteColor];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(30.0f)];
        btn.clipsToBounds = YES;
        if (_mCancelString) {
            [btn setTitle:self.mCancelString forState:UIControlStateNormal];
        }
        if (kIphoneX) {
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 34, 0)];
        }
        [self addSubview:btn];
        btn.sd_layout.leftEqualToView(self)
        .bottomSpaceToView(self, 0)
        .rightEqualToView(self)
        .heightIs(kIphoneX?KScreenScale(100)+34:KScreenScale(100));
        btn;
    });
    // topView
    self.mTopView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        view.clipsToBounds = YES;
        [self addSubview:view];
        view.sd_layout.topEqualToView(self)
        .leftEqualToView(self)
        .rightEqualToView(self)
        .bottomSpaceToView(self.mCancelBtn, KScreenScale(10));
        
        // 确认按钮2
        self.mSureBtn2 = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=1000+2;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UIImageView *shareImg = [[UIImageView alloc] init];
            shareImg.image = [UIImage bundleImageNamed:@"invite_btn_shareUrl"];
            [btn addSubview:shareImg];
            
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.text = self.mSureStr2;
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor convertHexToRGB:@"333333"];
            titleLbl.textAlignment = 1;
            titleLbl.font = [UIFont systemFontOfSize:KScreenScale(32)];
            [btn addSubview:titleLbl];
            
            btn.sd_layout.topSpaceToView(view, KScreenScale(85))
            .leftSpaceToView(view, __MainScreen_Width*0.5)
            .bottomSpaceToView(view, 0)
            .rightSpaceToView(view, 0);
            shareImg.sd_layout.topSpaceToView(btn, KScreenScale(40))
            .leftSpaceToView(btn, (__MainScreen_Width*0.5-KScreenScale(100))*0.5-KScreenScale(50))
            .widthIs(KScreenScale(100))
            .heightIs(KScreenScale(100));
            titleLbl.sd_layout.topSpaceToView(shareImg, KScreenScale(10))
            .centerXEqualToView(shareImg)
            .widthIs(KScreenScale(200))
            .heightIs(KScreenScale(50));
            btn;
        });
        
        // 确认按钮1
        self.mSureBtn1 = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag=1000+1;
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UIImageView *shareImg = [[UIImageView alloc] init];
            shareImg.image = [UIImage bundleImageNamed:@"invite_btn_shareImage"];
            [btn addSubview:shareImg];
            
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.text = self.mSureStr1;
            titleLbl.backgroundColor = [UIColor clearColor];
            titleLbl.textColor = [UIColor convertHexToRGB:@"333333"];
            titleLbl.textAlignment = 1;
            titleLbl.font = [UIFont systemFontOfSize:KScreenScale(32)];
            [btn addSubview:titleLbl];
            
            btn.sd_layout.topSpaceToView(view, KScreenScale(85))
            .leftSpaceToView(view, 0)
            .bottomSpaceToView(view, 0)
            .rightSpaceToView(view, __MainScreen_Width*0.5);
            shareImg.sd_layout.topSpaceToView(btn, KScreenScale(40))
            .rightSpaceToView(btn, (__MainScreen_Width*0.5-KScreenScale(100))*0.5-KScreenScale(50))
            .widthIs(KScreenScale(100))
            .heightIs(KScreenScale(100));
            titleLbl.sd_layout.topSpaceToView(shareImg, KScreenScale(10))
            .centerXEqualToView(shareImg)
            .widthIs(KScreenScale(200))
            .heightIs(KScreenScale(50));
            btn;
        });
        view;
    });
    //蒙层
    if (![WXApi isWXAppInstalled]) {
        UIView *coverView=[[UIView alloc]init];
        coverView.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.7];
        [self.mTopView addSubview:coverView];
        coverView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    }
    
    //标题
    if (_mTitleString != nil && _mTitleString.length > 0) {
        self.mTitleLabel = ({
            UILabel *titleLbl = [[UILabel alloc] init];
            titleLbl.text = _mTitleString;
            titleLbl.textAlignment = 1;
            titleLbl.textColor = [UIColor convertHexToRGB:@"999999"];
            titleLbl.font = [UIFont systemFontOfSize:KScreenScale(30)];
            titleLbl.backgroundColor = [UIColor whiteColor];
            [self addSubview:titleLbl];
            titleLbl.sd_layout.topSpaceToView(self, KScreenScale(15))
            .leftSpaceToView(self, 0)
            .rightSpaceToView(self, 0)
            .heightIs(KScreenScale(70));
            
            // line
            {
                NSDictionary *dic  = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:KScreenScale(30)], NSFontAttributeName, nil];
                CGSize titleSize = [_mTitleString sizeWithAttributes:dic];
                CGFloat lintWidth = (self.frame.size.width - titleSize.width - KScreenScale(72) - 40) / 2;
                
                UIView *leftLine = [[UIView alloc] init];
                leftLine.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
                [self addSubview:leftLine];
                leftLine.sd_layout.topSpaceToView(self, KScreenScale(50))
                .leftSpaceToView(self, 20)
                .widthIs(lintWidth)
                .heightIs(1.0);
                
                UIView *rightLine = [[UIView alloc] init];
                rightLine.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
                [self addSubview:rightLine];
                rightLine.sd_layout.topSpaceToView(self, KScreenScale(50))
                .rightSpaceToView(self, 20)
                .widthIs(lintWidth)
                .heightIs(1.0);
            }
            titleLbl;
        });
    }
}



#pragma mark - <ACTIONS>
- (void)btnAction:(UIButton *)sender{
    // 取消
    if (sender == self.mCancelBtn) {
        [self hiddenView];
    }
    // 确定
    else if(sender == self.mSureBtn2||sender == self.mSureBtn1) {
        [self hiddenViewWithCompletion:^{
            if (self.btnActionBlock) {
                self.btnActionBlock(sender.tag-1000);
            }
        }];
    }
}


@end
