//
//  US_LogisticDetailTitleCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_LogisticDetailTitleCell.h"
#import <UIView+SDAutoLayout.h>
@interface US_LogisticDetailTitleCell ()
@property (nonatomic, strong) UILabel * orderLabel;
@property (nonatomic, strong) UILabel * packageLabel;
@property (nonatomic, strong) UILabel * logisticLabel;
@property (nonatomic, strong) UIButton * copyNumberBtn;
@end

@implementation US_LogisticDetailTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (UILabel *)buildLabelWithTextColor:(NSString *)color andFontSize:(CGFloat)fontSize{
    UILabel * label=[[UILabel alloc] init];
    label.textColor=[UIColor convertHexToRGB:color];
    label.font=[UIFont systemFontOfSize:fontSize];
    return label;
}

- (void)setupView{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.packageLabel,self.logisticLabel,self.copyNumberBtn]];

    self.logisticLabel.sd_layout
    .topSpaceToView(self.contentView,10)
    .leftSpaceToView(self.contentView,15)
    .rightSpaceToView(self.contentView,15)
    .heightIs(15);
    
    self.packageLabel.sd_layout
    .topSpaceToView(self.logisticLabel, 5)
    .leftSpaceToView(self.contentView,28)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(15);
    
    self.copyNumberBtn.sd_layout.bottomSpaceToView(self.contentView, 10)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(23)
    .widthIs(55);
    
    [self setupAutoHeightWithBottomView:self.packageLabel bottomMargin:10];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(US_LogisticTitleCellModel *)model{
    if([NSString isNullToString:model.name].length > 0) {
        self.logisticLabel.text = [NSString stringWithFormat:@"物流公司：%@", model.name];
    } else {
        self.logisticLabel.text = @"物流公司：";
    }
    if([NSString isNullToString:model.packageId].length > 0) {
        self.packageLabel.text = [NSString stringWithFormat:@"包裹号：%@", model.packageId];
    } else {
        self.packageLabel.text = @"包裹号：";
    }
}

- (void)copyBtnClick:(id)sender{
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:[self.packageLabel.text substringFromIndex:4]];
    [UleMBProgressHUD showHUDWithText:@"包裹号已复制" afterDelay:1];
}

#pragma mark - setter and getter
- (UILabel *)orderLabel{
    if (!_orderLabel) {
        _orderLabel=[self buildLabelWithTextColor:kBlackTextColor andFontSize:13];
    }
    return _orderLabel;
}

- (UILabel *)packageLabel{
    if (!_packageLabel) {
        _packageLabel=[self buildLabelWithTextColor:kBlackTextColor andFontSize:13];
    }
    return _packageLabel;
}

- (UILabel *)logisticLabel{
    if (!_logisticLabel) {
        _logisticLabel = [self buildLabelWithTextColor:kBlackTextColor andFontSize:13];;
 
    }
    return _logisticLabel;
}
- (UIButton *)copyNumberBtn{
    if (!_copyNumberBtn) {
        _copyNumberBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [_copyNumberBtn setTitle:@"复制" forState:UIControlStateNormal];
        _copyNumberBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [_copyNumberBtn setTitleColor:[UIColor convertHexToRGB:@"666666"] forState:UIControlStateNormal];
        _copyNumberBtn.layer.cornerRadius = 2;
        _copyNumberBtn.layer.borderWidth = 0.5;
        _copyNumberBtn.layer.borderColor = [UIColor convertHexToRGB:@"999999"].CGColor;
        [_copyNumberBtn addTarget:self action:@selector(copyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _copyNumberBtn;
}

@end
