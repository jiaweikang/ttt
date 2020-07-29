//
//  US_BankCardListCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/12.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_BankCardListCell.h"
#import <UIView+SDAutoLayout.h>

@interface US_BankCardListCell ()
@property (nonatomic, strong) UIImageView *cellBackView;
@property (nonatomic, strong) UIImageView *bankIconImageView;
@property (nonatomic, strong) UILabel *bankNameLab;
@property (nonatomic, strong) UILabel *cardNumLab;  //卡号
@property (nonatomic, strong) UILabel *nameLab;     //姓名
@property (nonatomic, strong) UILabel *mobileNumLab;//手机号
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation US_BankCardListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor= [UIColor clearColor];
    [self.contentView sd_addSubviews:@[self.cellBackView,self.deleteButton]];
    self.cellBackView.sd_layout
    .topSpaceToView(self.contentView, 15)
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .heightIs(130);
    self.deleteButton.sd_layout
    .centerYEqualToView(self.cellBackView)
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .widthIs(KScreenScale(110))
    .heightIs(KScreenScale(110));
    [self.cellBackView sd_addSubviews:@[self.bankIconImageView,self.bankNameLab,self.cardNumLab,self.nameLab,self.mobileNumLab]];
    self.bankIconImageView.sd_layout
    .topSpaceToView(self.cellBackView, 15)
    .leftSpaceToView(self.cellBackView, 10)
    .widthIs(50)
    .heightIs(50);
    self.bankNameLab.sd_layout
    .topEqualToView(self.bankIconImageView)
    .leftSpaceToView(self.bankIconImageView, 10)
    .rightSpaceToView(self.cellBackView, 10)
    .heightIs(25);
    self.cardNumLab.sd_layout
    .centerYEqualToView(self.cellBackView)
    .leftEqualToView(self.bankNameLab)
    .rightSpaceToView(self.cellBackView, 10)
    .heightIs(25);
    self.nameLab.sd_layout
    .bottomSpaceToView(self.cellBackView, 15)
    .leftEqualToView(self.bankNameLab)
    .widthIs(90)
    .heightIs(25);
    self.mobileNumLab.sd_layout
    .bottomEqualToView(self.nameLab)
    .leftSpaceToView(self.nameLab, 10)
    .rightSpaceToView(self.cellBackView, 10)
    .heightIs(25);
    
    [self setupAutoHeightWithBottomView:self.cellBackView bottomMargin:0];
    self.deleteButton.hidden = YES;
}

- (void)setModel:(US_BankCardListCellModel *)model{
    _model=model;
    self.bankNameLab.attributedText=model.bankName;
    self.cardNumLab.attributedText=model.cardNum;
    self.nameLab.text=model.name;
    self.mobileNumLab.text=model.mobileNum;
    if (model.isEditing) {
        self.cellBackView.sd_layout
        .leftSpaceToView(self.contentView, -KScreenScale(140))
        .rightSpaceToView(self.contentView, KScreenScale(160))
        .topSpaceToView(self.contentView, 15)
        .heightIs(130);
        self.deleteButton.hidden = NO;
    }
    else{
        self.cellBackView.sd_layout
        .topSpaceToView(self.contentView, 15)
        .leftSpaceToView(self.contentView, KScreenScale(20))
        .rightSpaceToView(self.contentView, KScreenScale(20))
        .heightIs(130);
        self.deleteButton.hidden = YES;
    }
    [self.cellBackView updateLayout];
}
#pragma mark - click event
- (void)deleteButtonClicked{
    if ([self.delegate respondsToSelector:@selector(deleteCardWithCardNum:)]) {
        [self.delegate deleteCardWithCardNum:_model.cardNumber];
    }
}

#pragma mark - <setter and getter>
- (UIImageView *)cellBackView{
    if (!_cellBackView) {
        _cellBackView=[UIImageView new];
        [_cellBackView setImage:[UIImage bundleImageNamed:@"bankCardList_img_card_bg"]];
    }
    return _cellBackView;
}

- (UIImageView *)bankIconImageView{
    if (!_bankIconImageView) {
        _bankIconImageView=[UIImageView new];
        [_bankIconImageView setImage:[UIImage bundleImageNamed:@"bankCardList_icon_PSBC"]];
    }
    return _bankIconImageView;
}

- (UILabel *)bankNameLab{
    if (!_bankNameLab) {
        _bankNameLab=[UILabel new];
        _bankNameLab.font = [UIFont boldSystemFontOfSize:KScreenScale(42)];
        _bankNameLab.textColor = [UIColor convertHexToRGB:@"ffffff"];
    }
    return _bankNameLab;
}

- (UILabel *)cardNumLab{
    if (!_cardNumLab) {
        _cardNumLab=[UILabel new];
        _cardNumLab.font = [UIFont systemFontOfSize:KScreenScale(46)];
        _cardNumLab.textColor = [UIColor convertHexToRGB:@"d9d9d9"];
    }
    return _cardNumLab;
}

- (UILabel *)nameLab{
    if (!_nameLab) {
        _nameLab=[UILabel new];
        _nameLab.font = [UIFont systemFontOfSize:KScreenScale(36)];
        _nameLab.textColor = [UIColor convertHexToRGB:@"d9d9d9"];
    }
    return _nameLab;
}

- (UILabel *)mobileNumLab{
    if (!_mobileNumLab) {
        _mobileNumLab=[UILabel new];
        _mobileNumLab.font = [UIFont systemFontOfSize:KScreenScale(36)];
        _mobileNumLab.textColor = [UIColor convertHexToRGB:@"d9d9d9"];
        _mobileNumLab.textAlignment = NSTextAlignmentRight;
    }
    return _mobileNumLab;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _deleteButton.backgroundColor = [UIColor whiteColor];
        _deleteButton.layer.masksToBounds = YES;
        _deleteButton.layer.cornerRadius = KScreenScale(55);
        _deleteButton.titleLabel.font = [UIFont systemFontOfSize:KScreenScale(28)];
        [_deleteButton setTitle:@"解绑" forState:(UIControlStateNormal)];
        [_deleteButton setTitleColor:[UIColor convertHexToRGB:@"ff3030"] forState:(UIControlStateNormal)];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _deleteButton;
}
@end
