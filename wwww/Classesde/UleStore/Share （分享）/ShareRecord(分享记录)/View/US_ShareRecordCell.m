//
//  US_ShareRecordCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_ShareRecordCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_TitleAndIconView.h"
#import "US_ShareRecordModel.h"
#define kShareCellMargin 10

@interface US_ShareRecordCell ()
@property (nonatomic, strong) UIImageView * mPrdImageView;
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, strong) UILabel * mPVLabel;//浏览
@property (nonatomic, strong) UILabel * mUVLabel;//访问
@property (nonatomic, strong) UIView * middleLine;
@property (nonatomic, strong) US_TitleAndIconView * sharePriceView;
@property (nonatomic, strong) US_TitleAndIconView * productIdView;
@property (nonatomic, strong) US_TitleAndIconView * shareTimeView;

@end

@implementation US_ShareRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.mPrdImageView,self.mTitleLabel,self.mPVLabel,self.mUVLabel,self.middleLine,self.sharePriceView,self.productIdView,self.shareTimeView]];
    self.mPrdImageView.sd_layout.leftSpaceToView(self.contentView, kShareCellMargin)
    .topSpaceToView(self.contentView, kShareCellMargin)
    .widthIs(80)
    .heightEqualToWidth();
    
    self.mTitleLabel.sd_layout.topEqualToView(self.mPrdImageView)
    .leftSpaceToView(self.mPrdImageView, kShareCellMargin)
    .rightSpaceToView(self.contentView, kShareCellMargin)
    .heightIs(40);
    
    
    self.mPVLabel.sd_layout.leftEqualToView(self.mTitleLabel)
    .bottomEqualToView(self.mPrdImageView)
    .heightIs(20).rightSpaceToView(self.contentView, kShareCellMargin);
    
    self.mUVLabel.sd_layout.leftEqualToView(self.mTitleLabel)
    .bottomSpaceToView(self.mPVLabel, 0)
    .heightIs(20).rightSpaceToView(self.contentView, kShareCellMargin);
    
    self.middleLine.sd_layout.leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .topSpaceToView(self.mPrdImageView, kShareCellMargin)
    .heightIs(0.5);
    
    self.sharePriceView.sd_layout.leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.middleLine, kShareCellMargin)
    .widthIs(__MainScreen_Width/3.0)
    .heightIs(45);
    
    self.productIdView.sd_layout.leftSpaceToView(self.sharePriceView, 0)
    .topEqualToView(self.sharePriceView)
    .widthRatioToView(self.sharePriceView, 1)
    .heightRatioToView(self.sharePriceView,1);
    
    self.shareTimeView.sd_layout.rightSpaceToView(self.contentView, 0)
    .topEqualToView(self.sharePriceView)
    .leftSpaceToView(self.productIdView, 0)
    .heightRatioToView(self.sharePriceView, 1);
    
    [self setupAutoHeightWithBottomView:self.sharePriceView bottomMargin:kShareCellMargin];
    
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
    ShareDetailInfo * detailInfo=(ShareDetailInfo *)model.data;
    [self.mPrdImageView yy_setImageWithURL:[NSURL URLWithString:detailInfo.imgUrl] placeholder:[UIImage bundleImageNamed:@"bg_def_80X80_s"]];
    self.mTitleLabel.text=detailInfo.listingName;
    //访问
    self.mUVLabel.text = [NSString stringWithFormat:@"%@ 人今日访问",detailInfo.uv];
    
    //浏览
    self.mPVLabel.text = [NSString stringWithFormat:@"%@ 次今日浏览",detailInfo.pv];
    
    [self attributedStringForLabel:self.mPVLabel];
    [self attributedStringForLabel:self.mUVLabel];
    
    //分享时间
    NSString *shareTimeStr=[NSString stringWithFormat:@"%@",detailInfo.createTime];
    if (shareTimeStr.length>10) {
        shareTimeStr=[shareTimeStr substringToIndex:10];
    }
    [self.shareTimeView setContent:shareTimeStr];
    
    NSString *shareType = [NSString stringWithFormat:@"%@", detailInfo.shareType];
    if ([shareType isEqualToString:@"11"] ||
        [shareType isEqualToString:@"15"]) {
        //如果是微保分享,则显示分享价格,商品ID取mInsuranceListingId字段
        //商品ID
        [self.productIdView setContent:[NSString stringWithFormat:@"%@", detailInfo.mInsuranceListingId?detailInfo.mInsuranceListingId:@""]];
        //分享价格
        [self.sharePriceView setContent:detailInfo.mInsuranceSharePrice];
    } else {
        //商品ID
        [self.productIdView setContent:[NSString stringWithFormat:@"%@",detailInfo.listingId?detailInfo.listingId:@""]];
        
        //售价
        NSString * salePrice=@"";
        if (!detailInfo.sharePrice || detailInfo.sharePrice.doubleValue == 0) {
            salePrice = [NSString stringWithFormat:@"¥%.2f",detailInfo.salPrice.doubleValue];
        } else {
            salePrice = [NSString stringWithFormat:@"¥%.2f",detailInfo.sharePrice.doubleValue];
        }
        [self.sharePriceView setContent:salePrice];
    }
}

/**
 *  给某个label设置属性字符串
 */
- (void)attributedStringForLabel:(UILabel *)label {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:[UIColor convertHexToRGB:@"999999"]} range:NSMakeRange(label.text.length - 5, 5)];
    [label setAttributedText:attributedStr];
}


#pragma mark - <setter and getter>
- (UIImageView *)mPrdImageView{
    if (!_mPrdImageView) {
        _mPrdImageView=[UIImageView new];
    }
    return _mPrdImageView;
}
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[UILabel new];
        _mTitleLabel.numberOfLines=0;
        _mTitleLabel.font = [UIFont systemFontOfSize:15];
        _mTitleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _mTitleLabel;
}
- (UILabel *)mPVLabel{
    if (!_mPVLabel) {
        _mPVLabel=[UILabel new];
        _mPVLabel.textColor = [UIColor convertHexToRGB:@"c80214"];
        _mPVLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mPVLabel;
}
- (UILabel *)mUVLabel{
    if (!_mUVLabel) {
        _mUVLabel=[UILabel new];
        _mUVLabel.textColor = [UIColor convertHexToRGB:@"c80214"];
        _mUVLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mUVLabel;
}
- (UIView *)middleLine{
    if (!_middleLine) {
        _middleLine=[UIView new];
        _middleLine.backgroundColor=[UIColor convertHexToRGB:@"e0e0e0"];
    }
    return _middleLine;
}
- (US_TitleAndIconView *)sharePriceView{
    if (!_sharePriceView) {
        _sharePriceView=[US_TitleAndIconView titleAndIconViewWithFrame:CGRectMake(0, 0, __MainScreen_Width/3.0, 50) icon:@"share_icon_RecordPrice" title:@"分享价格" content:@""];
    }
    return _sharePriceView;
}
- (US_TitleAndIconView *)productIdView{
    if (!_productIdView) {
        _productIdView=[US_TitleAndIconView titleAndIconViewWithFrame:CGRectMake(0, 0, __MainScreen_Width/3.0, 45) icon:@"share_icon_RecordID" title:@"商品ID" content:@""];
    }
    return _productIdView;
}
- (US_TitleAndIconView *)shareTimeView{
    if (!_shareTimeView) {
        _shareTimeView=[US_TitleAndIconView titleAndIconViewWithFrame:CGRectMake(0, 0, __MainScreen_Width/3.0, 45) icon:@"share_icon_RecordTime" title:@"分享时间" content:@""];
    }
    return _shareTimeView;
}

@end
