//
//  InviterDetailCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/23.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterDetailCell.h"
#import <UIView+SDAutoLayout.h>
#import "InviterDetailCellModel.h"

@interface InviterDetailCell ()

@property (nonatomic, strong) UIImageView *inviteImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *commissionLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *orderCountLbl;
@property (nonatomic, strong) UILabel *orderSignLbl;

@end
@implementation InviterDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //商品图片
    _inviteImageView = [[UIImageView alloc] init];
    
    //标题
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
    _titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    _titleLabel.numberOfLines = 0;
    
    //收益
    _commissionLbl = [[UILabel alloc] init];
    _commissionLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
    _commissionLbl.textColor = [UIColor convertHexToRGB:@"ef3d39"];
    _commissionLbl.textAlignment = NSTextAlignmentLeft;
    
    //价格
    _priceLbl = [[UILabel alloc] init];
    _priceLbl.font = [UIFont systemFontOfSize:KScreenScale(26)];
    _priceLbl.textColor = [UIColor convertHexToRGB:@"999999"];
    _priceLbl.textAlignment = NSTextAlignmentRight;
    
    //竖线
    UIView *longView = [[UIView alloc] init];
    longView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    
    _orderCountLbl = [[UILabel alloc] init];
    _orderCountLbl.textColor = [UIColor convertHexToRGB:@"333333"];
    _orderCountLbl.font = [UIFont boldSystemFontOfSize:KScreenScale(56)];
    _orderCountLbl.textAlignment = NSTextAlignmentCenter;
    
    _orderSignLbl = [[UILabel alloc] init];
    _orderSignLbl.textColor = [UIColor convertHexToRGB:@"333333"];
    _orderSignLbl.font = [UIFont systemFontOfSize:KScreenScale(28)];
    _orderSignLbl.textAlignment = NSTextAlignmentCenter;
    
    //底横线
    UIView *bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    
    [self.contentView sd_addSubviews:@[_inviteImageView,_titleLabel,_commissionLbl,_priceLbl,longView,_orderCountLbl,_orderSignLbl,bottomLine]];
    _inviteImageView.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(20))
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .widthIs(KScreenScale(180))
    .heightIs(KScreenScale(180));
    _orderCountLbl.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(56))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .widthIs(KScreenScale(130))
    .heightIs(KScreenScale(62));

    _orderSignLbl.sd_layout
    .topSpaceToView(_orderCountLbl, KScreenScale(15))
    .rightEqualToView(_orderCountLbl)
    .widthRatioToView(_orderCountLbl, 1)
    .heightIs(KScreenScale(35));
    
    longView.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(30))
    .bottomSpaceToView(self.contentView, KScreenScale(30))
    .rightSpaceToView(_orderCountLbl, KScreenScale(20))
    .widthIs(1);
    _titleLabel.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(20))
    .leftSpaceToView(_inviteImageView, KScreenScale(20))
    .rightSpaceToView(longView, KScreenScale(20))
    .autoHeightRatio(0);
    _commissionLbl.sd_layout
    .bottomSpaceToView(self.contentView, KScreenScale(20))
    .leftEqualToView(_titleLabel)
    .widthIs(KScreenScale(160))
    .heightIs(KScreenScale(30));
    _priceLbl.sd_layout
    .bottomEqualToView(_commissionLbl)
    .rightSpaceToView(longView, KScreenScale(20))
    .leftSpaceToView(_commissionLbl, KScreenScale(10))
    .heightRatioToView(_commissionLbl, 1);
    bottomLine.sd_layout
    .topSpaceToView(_inviteImageView, KScreenScale(20))
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(1);
    [self setupAutoHeightWithBottomView:_inviteImageView bottomMargin:KScreenScale(20)+1];
    
    
}
- (void)setModel:(InviterDetailCellModel *)model{
    [_inviteImageView yy_setImageWithURL:[NSURL URLWithString:model.productPic] placeholder:[UIImage bundleImageNamed:@"bg_def_80x80_s"]];
    _titleLabel.text = model.listingName;
    _commissionLbl.text = [NSString stringWithFormat:@"收益¥%@", model.prdCommission];
    _priceLbl.text = [NSString stringWithFormat:@"价格¥%@", model.salePrice];
    _orderCountLbl.text = model.orderCount;
    _orderSignLbl.text = @"订单量";
}
@end
