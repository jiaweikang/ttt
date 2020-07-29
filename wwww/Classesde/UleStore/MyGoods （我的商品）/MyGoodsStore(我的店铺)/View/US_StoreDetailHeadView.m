//
//  US_StoreDetailHeadView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/8.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_StoreDetailHeadView.h"
#import <UIView+SDAutoLayout.h>
#import "ShopStarView.h"
@interface US_StoreDetailHeadView ()
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) ShopStarView *starView;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UILabel *serviceLabel;
@property (nonatomic, strong) UILabel *spaceLabel;
@end

@implementation US_StoreDetailHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.layer.contents=(__bridge id)[UIImage bundleImageNamed:@"mystore_img_detailBackgroud"].CGImage;
    [self sd_addSubviews:@[self.imgView,self.titleLabel,self.starView, self.descriptLabel,self.serviceLabel,self.spaceLabel]];
    
    self.descriptLabel.sd_layout
    .leftSpaceToView(self, 10)
    .bottomSpaceToView(self, 2)
    .widthIs(KScreenScale(200.0))
    .heightIs(25);
    
    self.serviceLabel.sd_layout
    .centerXEqualToView(self)
    .bottomSpaceToView(self, 2)
    .widthIs(KScreenScale(200.0))
    .heightIs(25);
    
    self.spaceLabel.sd_layout
    .rightSpaceToView(self, 10)
    .bottomSpaceToView(self, 2)
    .widthIs(KScreenScale(200.0))
    .heightIs(25);
    
    self.imgView.sd_layout.leftSpaceToView(self, 10)
    .bottomSpaceToView(self.descriptLabel, KScreenScale(20))
    .widthIs(KScreenScale(90))
    .heightEqualToWidth();
    
    self.titleLabel.sd_layout.leftSpaceToView(self.imgView, 10)
    .topEqualToView(self.imgView)
    .rightSpaceToView(self, 10)
    .heightIs(KScreenScale(45));
    
    self.starView.sd_layout.leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, KScreenScale(10))
    .heightIs(KScreenScale(28))
    .widthIs(KScreenScale(140));
}

- (void)setStoreName:(NSString *)storeName {
    _storeName = storeName;
    self.titleLabel.text = storeName;
}

- (void)setStoreInfo:(USStoreDetailInfo *)storeInfo {
    _storeInfo = storeInfo;
    NSString *imgUrlStr = _storeInfo.storeLogo;
    if ([imgUrlStr rangeOfString:@"ule.com"].location!=NSNotFound) {
        imgUrlStr = [NSString getImageUrlString:kImageUrlType_L withurl:imgUrlStr];
    }
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:[UIImage bundleImageNamed:@"bg_def_80x80_s"]];
    [self.starView showStars:[_storeInfo.totalRate floatValue]];
    self.descriptLabel.text = [NSString stringWithFormat:@"描述相符：%@", _storeInfo.productRate];
    self.serviceLabel.text = [NSString stringWithFormat:@"服务态度：%@", _storeInfo.serviceRate];
    self.spaceLabel.text = [NSString stringWithFormat:@"发货速度：%@", _storeInfo.logisticsRate];
    
}

- (void)tapTitle{
    if (self.storeInfo.storeUrl.length > 0) {
        NSMutableDictionary *data = [NSMutableDictionary new];
        [data setValue:@"证照信息" forKey:@"title"];
        [data setObject:NonEmpty(self.storeInfo.storeUrl) forKey:@"key"];
        [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:data];
    }
}

#pragma mark - <setter and getter>
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.layer.borderWidth = KScreenScale(1);
        _imgView.layer.borderColor = [UIColor convertHexToRGB:@"ffffff"].CGColor;
    }
    return _imgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor convertHexToRGB:@"ffffff"];
        _titleLabel.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.userInteractionEnabled = YES;
        [_titleLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitle)]];
//        _titleLabel.text = @"店铺名字";
    }
    return _titleLabel;
}

- (ShopStarView *)starView {
    if (!_starView) {
        _starView = [[ShopStarView alloc] initWithStarHeight:KScreenScale(28) StarNumber:5];
    }
    return _starView;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [[UILabel alloc] init];
        _descriptLabel.textColor = [UIColor convertHexToRGB:@"ffffff"];
        _descriptLabel.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _descriptLabel.textAlignment = NSTextAlignmentLeft;
                _descriptLabel.text = @"描述相符：5.0";
    }
    return _descriptLabel;
}

- (UILabel *)serviceLabel {
    if (!_serviceLabel) {
        _serviceLabel = [[UILabel alloc] init];
        _serviceLabel.textColor = [UIColor convertHexToRGB:@"ffffff"];
        _serviceLabel.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _serviceLabel.textAlignment = NSTextAlignmentCenter;
                _serviceLabel.text = @"服务态度：5.0";
    }
    return _serviceLabel;
}

- (UILabel *)spaceLabel {
    if (!_spaceLabel) {
        _spaceLabel = [[UILabel alloc] init];
        _spaceLabel.textColor = [UIColor convertHexToRGB:@"ffffff"];
        _spaceLabel.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _spaceLabel.textAlignment = NSTextAlignmentRight;
                _spaceLabel.text = @"发货速度：5.0";
    }
    return _spaceLabel;
}
@end
