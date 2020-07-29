//
//  US_RewardListCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_RewardListCell.h"
#import <UIView+SDAutoLayout.h>

@interface US_RewardListCell ()
@property (nonatomic, strong) UIImageView *statusIconImg;
@property (nonatomic, strong) UILabel *incomeDescLab;
@property (nonatomic, strong) UILabel *amountLab;   //金额
@property (nonatomic, strong) UILabel *timeLab;     //时间
//@property (nonatomic, strong) UILabel *orderIDLab;  //订水号
@property (nonatomic, strong) UILabel *timeTitleLab;
//@property (nonatomic, strong) UILabel *orderIDTitleLab;
@property (nonatomic, strong) UILabel *effectiveTimeLabel;
@end
@implementation US_RewardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
//    UIImageView *arrowImg = [UIImageView new];
//    [arrowImg setImage:[UIImage bundleImageNamed:@"enter_icon"]];
    UIView * lineView = [UIView new];
    lineView.backgroundColor = kViewCtrBackColor;
    [self.contentView sd_addSubviews:@[self.statusIconImg,self.incomeDescLab,self.amountLab,self.timeLab,self.timeTitleLab,self.effectiveTimeLabel,lineView]];
    
    self.statusIconImg.sd_layout
    .leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 10)
    .widthIs(20)
    .heightIs(20);
    self.amountLab.sd_layout
    .rightSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 8)
    .widthIs(__MainScreen_Width/2)
    .bottomSpaceToView(self.contentView, 0);
    self.incomeDescLab.sd_layout
    .leftSpaceToView(self.statusIconImg, 10)
    .rightSpaceToView(self.amountLab, 10)
    .topSpaceToView(self.contentView, 10)
    .heightIs(22);
    
    self.timeTitleLab.sd_layout
    .topSpaceToView(self.incomeDescLab, KScreenScale(16))
    .leftEqualToView(self.incomeDescLab)
    .widthRatioToView(self.incomeDescLab, 1)
    .heightIs(20);
    
    self.timeLab.sd_layout
    .leftEqualToView(self.timeTitleLab)
    .topSpaceToView(self.timeTitleLab, KScreenScale(12))
    .widthRatioToView(self.timeTitleLab, 1)
    .heightRatioToView(self.timeTitleLab, 1);
    self.effectiveTimeLabel.sd_layout.leftEqualToView(self.incomeDescLab)
    .topSpaceToView(self.incomeDescLab,5)
    .widthRatioToView(self.incomeDescLab, 1)
    .autoHeightRatio(0);
    
//    arrowImg.sd_layout
//    .centerYEqualToView(self.contentView)
//    .rightSpaceToView(self.contentView, 15)
//    .widthIs(9)
//    .heightIs(17);
    //    self.orderIDLab.sd_layout
    //    .topEqualToView(self.timeLab)
    //    .leftEqualToView(self.amountLab)
    //    .rightSpaceToView(arrowImg, 3)
    //    .heightRatioToView(self.amountLab, 1);
    //    self.orderIDTitleLab.sd_layout
    //    .topSpaceToView(self.orderIDLab, 0)
    //    .leftEqualToView(self.orderIDLab)
    //    .widthRatioToView(self.orderIDLab, 1)
    //    .heightIs(20);
    lineView.sd_layout.leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(1);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.timeLab, self.effectiveTimeLabel] bottomMargin:8];
}

- (void)setModel:(US_RewardCellModel *)model{
    _model=model;
    [self.statusIconImg yy_setImageWithURL:[NSURL URLWithString:_model.iconUrl] placeholder:nil];
    self.incomeDescLab.text = model.incomeDesc;
    
    NSArray *amountArr = [model.amount componentsSeparatedByString:@"."];
    
#warning 177 解析产生000001问题，暂时处理，下个版本可去掉
    NSString *amountStr = model.amount;
    if (amountArr.count > 1) {
        amountStr = [[amountArr[1] substringToIndex:1] isEqualToString:@"00"] ? amountArr[0] : [NSString stringWithFormat:@"%.2f", [model.amount floatValue]];
    }
    
    self.amountLab.text = [NSString stringWithFormat:@"%@%@",model.symbol,amountStr];
    self.amountLab.textColor = [UIColor convertHexToRGB:model.colorValue];
    self.timeLab.text = model.creatOrderTime;
    //    self.orderIDLab.text = model.orderID;
    self.timeTitleLab.text = model.timeTitle;
    //    self.orderIDTitleLab.text = @"流水号";
    if (model.effectiveTime.length>0) {
        self.effectiveTimeLabel.hidden=NO;
        self.effectiveTimeLabel.text=model.effectiveTime;
        self.timeTitleLab.hidden=YES;
        self.timeLab.hidden=YES;
    }else{
        self.effectiveTimeLabel.hidden=YES;
        self.timeTitleLab.hidden=NO;
        self.timeLab.hidden=NO;
    }
}

#pragma mark - <setter and getter>
- (UIImageView *)statusIconImg{
    if (!_statusIconImg) {
        _statusIconImg=[UIImageView new];
    }
    return _statusIconImg;
}
- (UILabel *)incomeDescLab{
    if (!_incomeDescLab) {
        _incomeDescLab=[UILabel new];
        _incomeDescLab.font = [UIFont boldSystemFontOfSize:15];
        _incomeDescLab.textColor = [UIColor blackColor];
    }
    return _incomeDescLab;
}
- (UILabel *)amountLab{
    if (!_amountLab) {
        _amountLab=[UILabel new];
        _amountLab.font = [UIFont systemFontOfSize:16];
        _amountLab.textAlignment = NSTextAlignmentRight;
    }
    return _amountLab;
}
- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab=[UILabel new];
        _timeLab.font = [UIFont systemFontOfSize:14];
        _timeLab.textColor = [UIColor blackColor];
    }
    return _timeLab;
}
//- (UILabel *)orderIDLab{
//    if (!_orderIDLab) {
//        _orderIDLab=[UILabel new];
//        _orderIDLab.font = [UIFont systemFontOfSize:14];
//        _orderIDLab.textColor = [UIColor blackColor];
//        _orderIDLab.adjustsFontSizeToFitWidth=YES;
//    }
//    return _orderIDLab;
//}
- (UILabel *)timeTitleLab{
    if (!_timeTitleLab) {
        _timeTitleLab=[UILabel new];
        _timeTitleLab.font = [UIFont systemFontOfSize:13];
        _timeTitleLab.textColor = [UIColor convertHexToRGB:kLightTextColor];
    }
    return _timeTitleLab;
}
//- (UILabel *)orderIDTitleLab{
//    if (!_orderIDTitleLab) {
//        _orderIDTitleLab=[UILabel new];
//        _orderIDTitleLab.font = [UIFont systemFontOfSize:13];
//        _orderIDTitleLab.textColor = [UIColor convertHexToRGB:kLightTextColor];
//    }
//    return _orderIDTitleLab;
//}
- (UILabel *)effectiveTimeLabel{
    if (!_effectiveTimeLabel) {
        _effectiveTimeLabel=[UILabel new];
        _effectiveTimeLabel.font=[UIFont systemFontOfSize:14];
        _effectiveTimeLabel.textColor= [UIColor blackColor];
        _effectiveTimeLabel.numberOfLines=2;
    }
    return _effectiveTimeLabel;
}
@end
