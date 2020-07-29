//
//  US_LogisticListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_LogisticListCell.h"
#import <UIView+SDAutoLayout.h>
#import "MyWaybillOrderInfo.h"
#define kLogisticMargin 8
@interface US_LogisticListCell ()
@property (nonatomic, strong) UILabel * packegeLabel;
@property (nonatomic, strong) UIImageView * mImageView;
@property (nonatomic, strong) UILabel * mProductLabel;
@property (nonatomic, strong) UILabel * mNumberLabel;
@property (nonatomic, strong) UILabel * mStatusLabel;

@end

@implementation US_LogisticListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self.contentView sd_addSubviews:@[self.packegeLabel,self.mImageView,self.mProductLabel,self.mNumberLabel,self.mStatusLabel]];
        self.packegeLabel.sd_layout.leftSpaceToView(self.contentView, kLogisticMargin)
        .topSpaceToView(self.contentView, kLogisticMargin)
        .heightIs(20).autoWidthRatio(0);
        
        self.mImageView.sd_layout.leftEqualToView(self.packegeLabel)
        .topSpaceToView(self.packegeLabel, kLogisticMargin)
        .widthIs(KScreenScale(130))
        .heightEqualToWidth();
        
        self.mProductLabel.sd_layout.leftSpaceToView(self.mImageView, kLogisticMargin)
        .topEqualToView(self.mImageView)
        .rightSpaceToView(self.contentView, kLogisticMargin)
        .heightIs(45);
        
        self.mStatusLabel.sd_layout.leftEqualToView(self.mProductLabel)
        .bottomEqualToView(self.mImageView)
        .rightSpaceToView(self.contentView, kLogisticMargin)
        .heightIs(20);
        
        self.mNumberLabel.sd_layout.leftEqualToView(self.mImageView)
        .bottomEqualToView(self.mImageView)
        .heightIs(20).widthRatioToView(self.mImageView, 1);
        
        [self setupAutoHeightWithBottomView:self.mImageView bottomMargin:kLogisticMargin];
        
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
    DeleveryInfo * delevery=(DeleveryInfo *)model.data;
    if ([NSString isNullToString:delevery.package_id].length > 0) {
        self.packegeLabel.text = [NSString stringWithFormat:@"%@：%@", delevery.logisticsName, delevery.package_id];
    } else {
        self.packegeLabel.text = @"暂无物流信息";
    }
    
    [self.packegeLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    NSInteger count = 0;
    for (PrdInfo * prdInfo in delevery.prd) {
        count += prdInfo.product_num.intValue;
    }
    self.mNumberLabel.text = [NSString stringWithFormat:@"共%ld件商品", count];
    PrdInfo * prdInfo=delevery.prd.firstObject;
    [self.mImageView yy_setImageWithURL:[NSURL URLWithString:[self getImageUrlString:[NSString stringWithFormat:@"%@",prdInfo.product_pic]]] placeholder:[UIImage bundleImageNamed:@"home_img_default_l"]];
    self.mProductLabel.text = [NSString stringWithFormat:@"%@",prdInfo.product_name];
    
    self.mStatusLabel.text=[NSString stringWithFormat:@"%@", delevery.order_status_text];
}

//根据返回的图片url获取分隔符|*|分割的第一个imageUrl
- (NSString *)getImageUrlString:(NSString *)imageUrl {
    NSArray * imgUrlArr = [imageUrl componentsSeparatedByString:@"|*|"];
    return imgUrlArr.firstObject;
}

#pragma mark - <setter and getter>
- (UILabel *)packegeLabel{
    if (!_packegeLabel) {
        _packegeLabel=[UILabel new];
        _packegeLabel.font = [UIFont systemFontOfSize:12];
        _packegeLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _packegeLabel;
}

- (UIImageView *)mImageView{
    if (!_mImageView) {
        _mImageView=[UIImageView new];
    }
    return _mImageView;
}
- (UILabel *)mNumberLabel{
    if (!_mNumberLabel) {
        _mNumberLabel=[UILabel new];
        _mNumberLabel.backgroundColor = [UIColor blackColor];
        _mNumberLabel.alpha = 0.7;
        _mNumberLabel.textColor = [UIColor whiteColor];
        _mNumberLabel.font = [UIFont systemFontOfSize:12.0];
        _mNumberLabel.textAlignment = NSTextAlignmentCenter;
        _mNumberLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _mNumberLabel;
}
- (UILabel *)mProductLabel{
    if (!_mProductLabel) {
        _mProductLabel=[UILabel new];
        _mProductLabel.font = [UIFont systemFontOfSize:14];
        _mProductLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _mProductLabel.numberOfLines=0;
    }
    return _mProductLabel;
}
- (UILabel *)mStatusLabel{
    if (!_mStatusLabel) {
        _mStatusLabel=[UILabel new];
        _mStatusLabel.textColor = [UIColor convertHexToRGB:@"ec3d3f"];
        _mStatusLabel.font = [UIFont systemFontOfSize:13];
    }
    return _mStatusLabel;
}
@end
