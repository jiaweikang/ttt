//
//  MyStoreGroupSevenCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupSevenCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_MystoreCellModel.h"
#import "UleControlView.h"
#import "UleModulesDataToAction.h"

@interface MyStoreGroupSevenCell ()
@property (nonatomic, strong)UIView     *mBgView;
@property (nonatomic, strong)US_MystoreCellModel    *mModel;
@end

@implementation MyStoreGroupSevenCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:self.mBgView];
    self.mBgView.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .heightIs(KScreenScale(200));
    [self setupAutoHeightWithBottomView:self.mBgView bottomMargin:0];
}

- (void)setModel:(US_MystoreCellModel *)model{
    if ([self.mModel isEqual:model]) return;
    self.mModel=model;
    if (model.indexInfo.count<=0) return;
    for (UIView *subView in self.mBgView.subviews) {
        [subView removeFromSuperview];
    }
    
    CGFloat btnWidth=(CGFloat)KScreenScale(710)/model.indexInfo.count;
    for (int i=0; i<model.indexInfo.count; i++) {
        HomeBtnItem *item=model.indexInfo[i];
        UleControlView *btn = [[UleControlView alloc]initWithFrame:CGRectMake(i*btnWidth, 0, btnWidth, KScreenScale(200))];
        btn.mTitleLabel.font=[UIFont systemFontOfSize:13];
        btn.mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        btn.mTitleLabel.text=[NSString isNullToString:item.title];
        [btn.mImageView  yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:item.imgUrl]] placeholder:nil];
        if ([NSString isNullToString:item.titlecolor].length>0) {
            btn.mTitleLabel.textColor=[UIColor convertHexToRGB:[NSString isNullToString:item.titlecolor]];
        }
        btn.tag=20000+i;
        [btn addTouchTarget:self action:@selector(btnClick:)];
        btn.mImageView.sd_layout.centerXEqualToView(btn)
        .topSpaceToView(btn, KScreenScale(25))
        .widthIs(KScreenScale(120))
        .heightIs(KScreenScale(120));
        btn.mTitleLabel.sd_layout.topSpaceToView(btn.mImageView, 0)
        .leftSpaceToView(btn, 0)
        .rightSpaceToView(btn, 0)
        .heightIs(KScreenScale(25));
        [self.mBgView addSubview:btn];
        if (i!=model.indexInfo.count-1) {
            UIView *lineView=[[UIView alloc]init];
            lineView.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
            [self.mBgView addSubview:lineView];
            lineView.sd_layout.centerYEqualToView(btn)
            .rightEqualToView(btn)
            .widthIs(0.5)
            .heightIs(KScreenScale(60));
        }
    }
}

- (void)btnClick:(UleControlView*)sender{
    NSInteger tag=sender.tag-20000;
    if (self.mModel.indexInfo&&self.mModel.indexInfo.count>tag) {
        HomeBtnItem * item=self.mModel.indexInfo[tag];
        //日志
        if ([NSString isNullToString:item.log_title].length>0) {
            [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
        }
        //自录商品
        if ([item.functionId isEqualToString:@"PostSeller"]) {
            if (![[US_UserUtility sharedLogin].qualificationFlag  isEqualToString:@"1"]) {
                //跳转注册
                NSString *urlStr=[NSString stringWithFormat:@"%@/mxiaodian/user/merchant/reg.html#/",[UleStoreGlobal shareInstance].config.mUleDomain];
                NSMutableDictionary *params=@{@"key":urlStr,
                                              @"hasnavi":@"1",
                                              @"title":@"自有商品注册"}.mutableCopy;
                [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
            }else{
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"uleMerchant://"]]){
                    //编辑
                    NSString *str = @"uleMerchant://EditGoodsViewController";
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
                }else{
                    //跳转到应用市场
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id684673362"]];
                }
            }
        }else {
            UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
            [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
        }
    }
}
#pragma mark - <getters>
-(UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenScale(710), KScreenScale(200))];
        _mBgView.backgroundColor=[UIColor whiteColor];
        _mBgView.userInteractionEnabled=YES;
        _mBgView.sd_cornerRadius=@(5);
    }
    return _mBgView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
