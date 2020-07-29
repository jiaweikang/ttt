//
//  US_OrderDetailCarListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/5/30.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailCarListCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_OrderDetailCarModel.h"
#define kOrderDetailMargin 8
@interface US_OrderDetailCarListCell ()
@property (nonatomic, strong) UILabel * mTitlelabel;
@property (nonatomic, strong) UILabel * namelabel;
@property (nonatomic, strong) UILabel * addresslabel;
@property (nonatomic, strong) UIImageView *logoImageview;
@end

@implementation US_OrderDetailCarListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView sd_addSubviews:@[self.mTitlelabel,self.namelabel,self.addresslabel,self.logoImageview]];
        self.mTitlelabel.sd_layout.leftSpaceToView(self.contentView, kOrderDetailMargin)
        .topSpaceToView(self.contentView, kOrderDetailMargin)
        .heightIs(20).rightSpaceToView(self.contentView, kOrderDetailMargin);
        
        self.logoImageview.sd_layout.topSpaceToView(self.mTitlelabel, 5)
        .rightSpaceToView(self.contentView, 2*kOrderDetailMargin)
        .widthIs(50).heightEqualToWidth();
        
        self.namelabel.sd_layout.leftEqualToView(self.mTitlelabel)
        .topSpaceToView(self.mTitlelabel, 5)
        .rightSpaceToView(self.logoImageview, kOrderDetailMargin)
        .heightIs(20);
        
        self.addresslabel.sd_layout.leftEqualToView(self.mTitlelabel)
        .topSpaceToView(self.namelabel, 5)
        .rightSpaceToView(self.logoImageview, kOrderDetailMargin)
        .autoHeightRatio(0);
        
        [self setupAutoHeightWithBottomViewsArray:@[self.addresslabel,self.logoImageview] bottomMargin:kOrderDetailMargin];
        
    }
    return self;
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
    OrderDetailCarList * carModel=(OrderDetailCarList *)model.data;
    self.namelabel.text=carModel.storeName;
    self.addresslabel.text=carModel.storeAddr;
    [self.logoImageview yy_setImageWithURL:[NSURL URLWithString:carModel.storeLogo] placeholder:nil];
}

#pragma mark - <setter and getter>

- (UILabel *)mTitlelabel{
    if (!_mTitlelabel) {
        _mTitlelabel=[UILabel new];
        _mTitlelabel.font = [UIFont systemFontOfSize:14];
        _mTitlelabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _mTitlelabel.text = @"服务门店";
    }
    return _mTitlelabel;
}
- (UILabel *)namelabel{
    if (!_namelabel) {
        _namelabel=[UILabel new];
        _namelabel.font = [UIFont boldSystemFontOfSize:13];
        _namelabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _namelabel;
}
- (UILabel *)addresslabel{
    if (!_addresslabel) {
        _addresslabel=[UILabel new];
        _addresslabel.font = [UIFont systemFontOfSize:13];
        _addresslabel.textColor = [UIColor convertHexToRGB:@"999999"];
    }
    return _addresslabel;
}
- (UIImageView *)logoImageview{
    if (!_logoImageview) {
        _logoImageview=[UIImageView new];
    }
    return _logoImageview;
}

@end
