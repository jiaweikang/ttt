//
//  US_LocationListCell.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/14.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_LocationListCell.h"
#import <UIView+SDAutoLayout.h>
#import "USLocationManager.h"
#import "US_SearchAddressModel.h"
@implementation US_LocationListCellModel

@end

@interface US_LocationListCell ()
@property (nonatomic, strong) UILabel * mNameLabel;
@property (nonatomic, strong) UILabel * mAddressLabel;
@property (nonatomic, strong) UIButton * mReLocalBtn;

@end

@implementation US_LocationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView sd_addSubviews:@[self.mNameLabel,self.mReLocalBtn,self.mAddressLabel]];
        
        self.mNameLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 100)
        .heightIs(40);
        self.mAddressLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.mNameLabel, -10)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(40);
        
        self.mReLocalBtn.sd_layout.rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .heightIs(40).widthIs(80);
        
        [self setupAutoHeightWithBottomView:self.mAddressLabel bottomMargin:10];
    }
    return self;
}

- (void) setModel:(US_LocationListCellModel *)model{
    if ([model.data isKindOfClass:[TencentLBSPoi class]]) {
        TencentLBSPoi * poi=model.data;
        self.mNameLabel.text=poi.name;
        self.mAddressLabel.text=poi.address;
        self.mReLocalBtn.hidden=!model.showBtn;
    }else{
        US_AddressModel * poi=model.data;
        self.mNameLabel.text=poi.title;
        self.mAddressLabel.text=poi.address;
        self.mReLocalBtn.hidden=!model.showBtn;
    }
    
}

- (void)reLocalBtnClick:(id)sender{
    [USLocationManager sharedLocation].isManuaLocation=YES;
    [[USLocationManager sharedLocation] startTencentSingleLocation];
}

#pragma mark - <getter and setter>

- (UILabel *)mNameLabel{
    if (!_mNameLabel) {
        _mNameLabel=[UILabel new];
        _mNameLabel.textColor=[UIColor convertHexToRGB:kBlackTextColor];
        _mNameLabel.font=[UIFont boldSystemFontOfSize:15];
    }
    return _mNameLabel;
}

- (UILabel *)mAddressLabel{
    if (!_mAddressLabel) {
        _mAddressLabel=[UILabel new];
        _mAddressLabel.textColor=[UIColor convertHexToRGB:kLightTextColor];
        _mAddressLabel.font=[UIFont systemFontOfSize:15];
    }
    return _mAddressLabel;
}

- (UIButton *)mReLocalBtn{
    if (!_mReLocalBtn) {
        _mReLocalBtn=[UIButton new];
        [_mReLocalBtn setTitle:@"重新定位" forState:UIControlStateNormal];
        [_mReLocalBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _mReLocalBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_mReLocalBtn addTarget:self action:@selector(reLocalBtnClick:) forControlEvents: UIControlEventTouchUpInside];
    }
    return _mReLocalBtn;
}

@end

@interface US_locationHead ()
@property (nonatomic, strong) UILabel * mTitleLabel;
@end

@implementation US_locationHead

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.mTitleLabel];
        self.mTitleLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 10);
    }
    return self;
}

- (void)setModel:(UleSectionBaseModel *)model{
//    self.textLabel.text=model;
    self.mTitleLabel.text=model.headData;
}
#pragma mark - <getter>
- (UILabel * )mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[UILabel new];
        _mTitleLabel.textColor=[UIColor convertHexToRGB:kLightTextColor];
        _mTitleLabel.font=[UIFont systemFontOfSize:14];
    }
    return _mTitleLabel;
}
@end
