//
//  US_UleCardListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UleCardListCell.h"
#import <UIView+SDAutoLayout.h>
#import "USDecimalTool.h"

@interface US_UleCardListCell ()

@property (nonatomic, strong) UILabel * cardNumberLabel;
@property (nonatomic, strong) UILabel * cardTotalLabel;
@property (nonatomic, strong) UILabel * cardBalanceLabel;
@property (nonatomic, strong) UIImageView * cardBackgroud;

@end

@implementation US_UleCardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    [self.contentView sd_addSubviews:@[self.cardBackgroud]];
    [self.cardBackgroud sd_addSubviews:@[self.cardNumberLabel,self.cardTotalLabel,self.cardBalanceLabel]];
    self.cardBackgroud.sd_layout.leftSpaceToView(self.contentView, 10)
    .topSpaceToView(self.contentView, 5)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(KScreenScale(225));
    
    self.cardBalanceLabel.sd_layout.leftSpaceToView(self.cardBackgroud, 10)
    .topSpaceToView(self.cardBackgroud, KScreenScale(37))
    .heightIs(KScreenScale(60)).widthIs(__MainScreen_Width/2.0);
    
    self.cardTotalLabel.sd_layout.rightSpaceToView(self.cardBackgroud, 10)
    .centerYEqualToView(self.cardBalanceLabel)
    .heightIs(KScreenScale(60)).widthIs(__MainScreen_Width/2.0);
    
    self.cardNumberLabel.sd_layout.leftSpaceToView(self.cardBackgroud, 10)
    .bottomSpaceToView(self.cardBackgroud, KScreenScale(18))
    .rightSpaceToView(self.cardBackgroud, 10)
    .heightIs(KScreenScale(60));
    
    [self setupAutoHeightWithBottomView:self.cardBackgroud bottomMargin:5];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UleCellBaseModel *)model{
    _model=model;
    US_UleCardDetail *cardDetail=(US_UleCardDetail *)model.data;
//    self.cardNumberLabel.text=@"邮乐卡号:   4817 3233 5831";
//    self.cardBalanceLabel.text=@"余额: ￥29231.03";
//    self.cardTotalLabel.text=@"总面值: ￥1000.00";
    
    NSString *cardNumberString = [NSString stringWithFormat:@"%@",cardDetail.cardNo];
    self.cardNumberLabel.text = [NSString stringWithFormat:@"邮乐卡号： %@  %@  %@  %@",
                          [cardNumberString substringToIndex:4],
                          [cardNumberString substringWithRange:NSMakeRange(4, 4)],
                          [cardNumberString substringWithRange:NSMakeRange(8, 4)],
                          [cardNumberString substringWithRange:NSMakeRange(12, 4)]];
    self.cardTotalLabel.text = [NSString stringWithFormat:@"总面值  ¥%@",cardDetail.parValue];
    NSString * balanceString=@"0.00";
    if (cardDetail.balance) {
        if ([cardDetail.balance containsString:@"."]) {
            balanceString=[USDecimalTool decimalRoundNumber:cardDetail.balance pointNum:2];
        }
        else{
            balanceString=cardDetail.balance;
        }
    }
    self.cardBalanceLabel.text = [NSString stringWithFormat:@"余额  ¥%@",balanceString];
    
    [self setAttributed1:self.cardNumberLabel];
    [self setAttributed2:self.cardTotalLabel];
    [self setAttributed3:self.cardBalanceLabel];
    
}

- (void)setAttributed1:(UILabel *)label {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor convertHexToRGB:@"999999"]
                          range:NSMakeRange(0, 4)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(28)]
                          range:NSMakeRange(0, 4)];
    [label setAttributedText:attributedStr];
}

- (void)setAttributed2:(UILabel *)label {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:[UIColor convertHexToRGB:@"333333"]
                          range:NSMakeRange(0, 3)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(28)]
                          range:NSMakeRange(0, 3)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(24)]
                          range:NSMakeRange(5, 1)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(35)]
                          range:NSMakeRange(6, label.text.length - 6)];
    [label setAttributedText:attributedStr];
}

- (void)setAttributed3:(UILabel *)label {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(28)]
                          range:NSMakeRange(0, 3)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(24)]
                          range:NSMakeRange(4, 1)];
    [attributedStr addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:KScreenScale(44)]
                          range:NSMakeRange(5, label.text.length - 5)];
    [label setAttributedText:attributedStr];
}


#pragma mark - <setter and getter>
- (UILabel *)cardNumberLabel{
    if (!_cardNumberLabel) {
        _cardNumberLabel=[UILabel new];
        _cardNumberLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _cardNumberLabel.textColor=[UIColor convertHexToRGB:@"666666"];
    }
    return _cardNumberLabel;
}
- (UILabel *)cardTotalLabel{
    if (!_cardTotalLabel) {
        _cardTotalLabel=[UILabel new];
        _cardTotalLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _cardTotalLabel.textColor=[UIColor convertHexToRGB:@"666666"];
        _cardTotalLabel.textAlignment=NSTextAlignmentRight;
    }
    return _cardTotalLabel;
}
- (UILabel *)cardBalanceLabel{
    if (!_cardBalanceLabel) {
        _cardBalanceLabel=[UILabel new];
        _cardBalanceLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
        _cardBalanceLabel.textColor=[UIColor convertHexToRGB:@"333333"];
    }
    return _cardBalanceLabel;
}
- (UIImageView *)cardBackgroud{
    if (!_cardBackgroud) {
        _cardBackgroud=[UIImageView new];
        _cardBackgroud.image=[UIImage bundleImageNamed:@"ulecard_img_listbg"];
    }
    return _cardBackgroud;
}
@end
