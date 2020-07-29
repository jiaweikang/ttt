//
//  InviterMemberCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/18.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "InviterMemberCell.h"
#import <UIView+SDAutoLayout.h>
#import "InviterMemberCellModel.h"
@interface InviterMemberCell ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *storeNameLbl; //店铺名
@property (nonatomic, strong) UILabel *lastShareTime; //开店时间
//@property (nonatomic, strong) UILabel *userName; //姓名
@property (nonatomic, strong) UILabel *mobileLbl; //手机号
@property (nonatomic, strong) UILabel *enterpriseName; //所属企业
@property (nonatomic, strong) UILabel *saleCountLbl; //成交单量

@end
@implementation InviterMemberCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews
{
    _iconView = [[UIImageView alloc] init];
    _iconView.layer.cornerRadius = KScreenScale(144) / 2;
    _iconView.layer.masksToBounds = YES;
    [_iconView yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:@"Inviter_img_placeholder"]];
    
    _storeNameLbl = [[UILabel alloc] init];
    _storeNameLbl.font = [UIFont systemFontOfSize:KScreenScale(30)];
    
    _mobileLbl = [[UILabel alloc] init];
    _mobileLbl.font = [UIFont systemFontOfSize:KScreenScale(21)];
    _mobileLbl.textColor = [UIColor convertHexToRGB:@"999999"];
    
    _lastShareTime = [[UILabel alloc] init];
    _lastShareTime.font = [UIFont systemFontOfSize:KScreenScale(22)];
    _lastShareTime.textColor = [UIColor convertHexToRGB:@"666666"];
    
    _saleCountLbl = [[UILabel alloc] init];
    _saleCountLbl.font = [UIFont systemFontOfSize:KScreenScale(24)];
    _saleCountLbl.backgroundColor = [UIColor convertHexToRGB:@"FFF1EF"];
    _saleCountLbl.textColor = [UIColor convertHexToRGB:@"ef3d39"];
    _saleCountLbl.layer.masksToBounds = YES;
    _saleCountLbl.layer.cornerRadius = KScreenScale(15);
    _saleCountLbl.textAlignment = 1;
    
    UIImageView *detailIcon = [[UIImageView alloc] init];
    detailIcon.image = [UIImage bundleImageNamed:@"inviterEnterIcon"];
    
    UIView * line = [UIView new];
    line.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
    [self.contentView sd_addSubviews:@[_iconView,_storeNameLbl,_mobileLbl,_lastShareTime,_saleCountLbl,detailIcon,line]];;
    
   
    _iconView.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(24))
    .leftSpaceToView(self.contentView, KScreenScale(30))
    .heightIs(KScreenScale(130))
    .widthEqualToHeight();
    _storeNameLbl.sd_layout
    .topSpaceToView(self.contentView, KScreenScale(34))
    .leftSpaceToView(_iconView, 15)
    .widthIs(120)
    .heightIs(KScreenScale(36));
    _saleCountLbl.sd_layout
    .centerYEqualToView(_storeNameLbl)
    .leftSpaceToView(_storeNameLbl, 5)
    .heightIs(ceil(KScreenScale(30)))
    .widthIs(KScreenScale(60));
    _mobileLbl.sd_layout
    .topSpaceToView(_storeNameLbl, 8)
    .leftEqualToView(_storeNameLbl)
    .rightEqualToView(self.contentView)
    .heightIs(KScreenScale(24));
    _lastShareTime.sd_layout
    .topSpaceToView(_mobileLbl, 8)
    .leftEqualToView(_storeNameLbl)
    .rightSpaceToView(self.contentView, 40)
    .heightIs(KScreenScale(24));
    detailIcon.sd_layout
    .centerYEqualToView(_iconView)
    .rightSpaceToView(self.contentView, KScreenScale(30))
    .widthIs(15)
    .heightIs(15);
    line.sd_layout
    .leftSpaceToView(self.contentView, KScreenScale(170))
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(_iconView, 11)
    .heightIs(1);
    [self setupAutoHeightWithBottomView:_iconView bottomMargin:11];
    
}

- (void)setModel:(InviterMemberCellModel *)model
{
    if (model.imageUrl.length > 0) {
        [_iconView yy_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholder:[UIImage bundleImageNamed:@"inviteMemberIcon"]];
    }
    else{
        [_iconView yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:@"inviteMemberIcon"]];
    }
    
    if (model.lastShareTime.length > 9) {
        _lastShareTime.text = [NSString stringWithFormat:@"最近分享时间：%@", [model.lastShareTime substringToIndex:10]];
    } else {
        _lastShareTime.text = @"该用户最近暂无分享，快去帮帮他一起赚钱吧～";

    }
    
    if ([NSString isNullToString:model.mobile].length > 0) {
        _mobileLbl.text = [NSString stringWithFormat:@"手机号  %@", model.mobile];
        if (model.provinceName.length > 0) {
            _mobileLbl.text = [NSString stringWithFormat:@"手机号  %@  |  %@", model.mobile, model.provinceName];
        }
    } else {
        if ([NSString isNullToString:model.provinceName].length > 0) {
            _mobileLbl.text = [NSString stringWithFormat:@"%@", model.provinceName];
        }
    }
    
    _storeNameLbl.text = model.storeName;
    
    CGFloat storeNameWidth = [self getWitdthForString:_storeNameLbl.text];
    _storeNameLbl.sd_layout.widthIs(storeNameWidth);
    
    CGFloat saleCountWidth = KScreenScale(60);
    if (model.saleCount.length > 0) {
        _saleCountLbl.text = model.saleCount;
        if ([self getWitdthForString:_saleCountLbl.text] > KScreenScale(60)) {
            saleCountWidth = [self getWitdthForString:_saleCountLbl.text];
            _saleCountLbl.sd_layout.leftSpaceToView(_storeNameLbl, 5).widthIs(saleCountWidth);
        }
    } else {
        _saleCountLbl.hidden = YES;
    }
}

//自适应宽度
- (CGFloat)getWitdthForString:(NSString *)string {
    return [string boundingRectWithSize:CGSizeMake(0, KScreenScale(35)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:KScreenScale(30)]} context:nil].size.width;
}
@end
