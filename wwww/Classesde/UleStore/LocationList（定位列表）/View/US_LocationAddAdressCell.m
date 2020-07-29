//
//  US_LocationAddAdressCell.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/16.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_LocationAddAdressCell.h"
#import <UIView+SDAutoLayout.h>
#import "USLocationManager.h"
@interface US_LocationAddAdressCell ()
@property (nonatomic, strong) UILabel * mAddrellLabel;
@end

@implementation US_LocationAddAdressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView sd_addSubviews:@[self.mAddrellLabel]];
        self.mAddrellLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 10)
        .heightIs(50);
        [self setupAutoHeightWithBottomView:self.mAddrellLabel bottomMargin:0];
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
    self.mAddrellLabel.text=model.data;
}

//- (void)tempOneBtnSelect:(id)sender{
//    [USLocationManager sharedLocation].cityName=@"北京";
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
//}
//
//- (void)tempTwoBtnSelect:(id)sender{
//    [USLocationManager sharedLocation].cityName=@"上海";
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateLocation" object:nil];
//
//}

#pragma mark - <getter>
- (UILabel *)mAddrellLabel{
    if (!_mAddrellLabel) {
        _mAddrellLabel=[UILabel new];
        _mAddrellLabel.textColor=[UIColor convertHexToRGB:kBlackTextColor];
        _mAddrellLabel.font=[UIFont systemFontOfSize:15];
    }
    return _mAddrellLabel;
}
@end
