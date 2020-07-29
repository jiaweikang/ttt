//
//  InviterDetailHeadView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/22.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterDetailHeadView.h"
#import <UIView+SDAutoLayout.h>

@interface InviterDetailHeadView ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *userNameLbl;
@property (nonatomic, strong) UILabel *storeNameLbl;
@property (nonatomic, strong) UILabel *missionLabel;
@property (nonatomic, strong) UILabel *orderCountLabel;
@property (nonatomic, strong) UILabel *uvLabel;
@property (nonatomic, strong) UILabel *cellHeaderLabel;
@property (nonatomic, strong) InviterDetailStoreData * inviterDetail;
@end

@implementation InviterDetailHeadView
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setUI];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}
- (void)setUI{
    UIImageView * topBackImgView = [[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"inviterDetail_img_topBg"]];
    UIView * backView = [[UIView alloc] init];
    UIView * grayView=[UIView new];
    grayView.backgroundColor=[UIColor convertHexToRGB:@"ebebeb"];
    UIView * lineView=[UIView new];
    lineView.backgroundColor=[UIColor convertHexToRGB:@"e6e6e6"];
    [self sd_addSubviews:@[topBackImgView,self.headImageView,self.userNameLbl,self.storeNameLbl,self.missionLabel,self.orderCountLabel,self.uvLabel,backView,grayView,lineView,self.cellHeaderLabel]];
    topBackImgView.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(278));
    self.headImageView.sd_layout
    .topSpaceToView(self, KScreenScale(20))
    .centerXEqualToView(self)
    .heightIs(KScreenScale(150))
    .widthIs(KScreenScale(150));
    self.userNameLbl.sd_layout
    .topSpaceToView(self.headImageView, KScreenScale(20))
    .centerXEqualToView(self)
    .widthRatioToView(self, 1)
    .heightIs(KScreenScale(30));
    self.storeNameLbl.sd_layout
    .topSpaceToView(self.userNameLbl, KScreenScale(10))
    .leftSpaceToView(self, 10)
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(26));
    self.missionLabel.sd_layout
    .topSpaceToView(topBackImgView, KScreenScale(20))
    .leftSpaceToView(self, 0)
    .widthIs(__MainScreen_Width / 3)
    .heightIs(KScreenScale(42));
    self.orderCountLabel.sd_layout
    .topSpaceToView(topBackImgView, KScreenScale(20))
    .leftSpaceToView(self.missionLabel, 0)
    .widthIs(__MainScreen_Width / 3)
    .heightIs(KScreenScale(42));
    self.uvLabel.sd_layout
    .topSpaceToView(topBackImgView, KScreenScale(20))
    .leftSpaceToView(self.orderCountLabel, 0)
    .widthIs(__MainScreen_Width / 3)
    .heightIs(KScreenScale(42));
    
    NSArray *signStrArr = @[@"月收益（元）", @"月订单（单）", @"访客量（人）"];
    for (int i = 0; i < 3; i++) {
        UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(__MainScreen_Width / 3 * i, 0, __MainScreen_Width / 3, KScreenScale(30))];
        signLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        signLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        signLabel.textAlignment = NSTextAlignmentCenter;
        signLabel.text = signStrArr[i];
        [backView addSubview:signLabel];
    }
    backView.sd_layout
    .topSpaceToView(self.uvLabel, KScreenScale(5))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30));
    grayView.sd_layout
    .topSpaceToView(backView, KScreenScale(10))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(15));
    self.cellHeaderLabel.sd_layout
    .topSpaceToView(grayView, KScreenScale(10))
    .leftSpaceToView(self, KScreenScale(20))
    .rightSpaceToView(self, KScreenScale(20))
    .heightIs(KScreenScale(50));
    lineView.sd_layout
    .topSpaceToView(self.cellHeaderLabel, KScreenScale(10))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(1);
    [self setupAutoHeightWithBottomView:lineView bottomMargin:0];
}

- (void)setModel:(InviterDetailStoreData *)model
{
    self.uvLabel.text = model.uv;
    self.missionLabel.text = model.prdCommissionCount;
    self.orderCountLabel.text = model.orderCount;
    
    self.userNameLbl.text = model.usrTrueName;
    self.storeNameLbl.text = model.storeName;
    self.cellHeaderLabel.text = model.top;
    [self.headImageView yy_setImageWithURL:[NSURL URLWithString:model.storeLogo] placeholder:[UIImage bundleImageNamed:@"Inviter_img_placeholder"]];
}
#pragma mark - <setter and getter>
-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.layer.masksToBounds = YES;
        _headImageView.layer.cornerRadius = KScreenScale(75);
        _headImageView.backgroundColor = [UIColor whiteColor];
    }
    return _headImageView;
}
-(UILabel *)userNameLbl{
    if (!_userNameLbl) {
        _userNameLbl = [[UILabel alloc] init];
        _userNameLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
        _userNameLbl.textColor = [UIColor whiteColor];
        _userNameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _userNameLbl;
}
-(UILabel *)storeNameLbl{
    if (!_storeNameLbl) {
        _storeNameLbl = [[UILabel alloc] init];
        _storeNameLbl.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _storeNameLbl.textColor = [UIColor whiteColor];
        _storeNameLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _storeNameLbl;
}
-(UILabel *)missionLabel{
    if (!_missionLabel) {
        _missionLabel = [[UILabel alloc] init];
        _missionLabel.font = [UIFont systemFontOfSize:KScreenScale(38)];
        _missionLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _missionLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _missionLabel;
}
-(UILabel *)orderCountLabel{
    if (!_orderCountLabel) {
        _orderCountLabel = [[UILabel alloc] init];
        _orderCountLabel.font = [UIFont systemFontOfSize:KScreenScale(38)];
        _orderCountLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _orderCountLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _orderCountLabel;
}
-(UILabel *)uvLabel{
    if (!_uvLabel) {
        _uvLabel = [[UILabel alloc] init];
        _uvLabel.font = [UIFont systemFontOfSize:KScreenScale(38)];
        _uvLabel.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _uvLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _uvLabel;
}
-(UILabel *)cellHeaderLabel{
    if (!_cellHeaderLabel) {
        _cellHeaderLabel = [[UILabel alloc] init];
        _cellHeaderLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _cellHeaderLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _cellHeaderLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _cellHeaderLabel;
}
@end
