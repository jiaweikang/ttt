//
//  US_GoodsRecommendCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/26.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_GoodsRecommendCell.h"
#import "UleControlView.h"
#import <UIView+SDAutoLayout.h>
#import <YYText/YYText.h>
#import "UleModulesDataToAction.h"
#import <UMAnalytics/MobClick.h>
#import "InsuranceAlertView.h"
//#import "CCPScrollView.h"
#import "FeaturedModel_HomeScrollBar.h"
#import "USGoodsPreviewManager.h"
#import "UIView+Shade.h"
#import "USDecimalTool.h"

#pragma mark - <样式1-推荐商品列表>

@interface US_GoodsHomeType1Cell ()
@property (nonatomic, strong) YYAnimatedImageView * prdImageView;
@property (nonatomic, strong) YYAnimatedImageView * cornerImageView;
@property (nonatomic, strong) YYLabel * prdNameLabel;
@property (nonatomic, strong) YYLabel * priceLabel;
@property (nonatomic, strong) UILabel * saleNumLabel;
@property (nonatomic, strong) UILabel * profitLabel;
@property (nonatomic, strong) UIButton * shareButton;
@property (nonatomic, strong) YYLabel * sharedLab;

@end

@implementation US_GoodsHomeType1Cell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(5,5)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        
        _cornerImageView = [[YYAnimatedImageView alloc] initWithFrame:CGRectMake(6, 0, KScreenScale(96), KScreenScale(79))];
        _cornerImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView sd_addSubviews:@[self.prdImageView,self.prdNameLabel,self.saleNumLabel,self.priceLabel,self.profitLabel,self.shareButton,self.sharedLab,_cornerImageView]];
        self.prdImageView.sd_layout.leftSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightEqualToWidth();
        
        _cornerImageView.sd_layout.leftSpaceToView(self.contentView, 6)
        .topSpaceToView(self.contentView, 0)
        .widthIs(KScreenScale(96))
        .heightIs(KScreenScale(79));
        
        self.prdNameLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(15))
        .topSpaceToView(self.prdImageView, KScreenScale(10))
        .rightSpaceToView(self.contentView, KScreenScale(15))
        .heightIs(KScreenScale(70));
        
        self.priceLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(15))
        .topSpaceToView(self.prdNameLabel, KScreenScale(5))
        .widthRatioToView(self.prdNameLabel, 0.5)
        .heightIs(KScreenScale(35));
        
        self.saleNumLabel.sd_layout.topSpaceToView(self.prdNameLabel, KScreenScale(5))
        .rightSpaceToView(self.contentView, KScreenScale(15))
        .heightIs(KScreenScale(35))
        .widthRatioToView(self.prdNameLabel, 0.5);
        
        self.shareButton.sd_layout.topSpaceToView(self.priceLabel, KScreenScale(15))
        .rightSpaceToView(self.contentView, 10)
        .widthIs(KScreenScale(50))
        .heightIs(KScreenScale(50));
        
        self.profitLabel.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.priceLabel, KScreenScale(22))
        .heightIs(KScreenScale(35))
//        .rightSpaceToView(self.shareButton, KScreenScale(15));
        .autoWidthRatio(0);
        
        self.sharedLab.sd_layout.topSpaceToView(self.profitLabel, KScreenScale(5))
        .leftSpaceToView(self.contentView, 10)
        .heightIs(0)
        .rightSpaceToView(self.shareButton, KScreenScale(15));
        
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
        [self.prdImageView addGestureRecognizer:tap];
    }
    return self;
}

- (void)setModel:(US_GoodsCellModel *)model{
    _model=model;
    
    [self.prdImageView yy_setImageWithURL:[NSURL URLWithString:model.imgeUrl] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    [self.cornerImageView yy_setImageWithURL:[NSURL URLWithString:model.iconImage] placeholder:nil];
    
    self.prdNameLabel.text=[NSString stringWithFormat:@"%@", model.listingName];
    self.priceLabel.text=[NSString stringWithFormat:@"￥%.2f", [model.minPrice floatValue]];
    NSString * soldstr=[NSString stringWithFormat:@"已售%@件", model.totalSold];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:soldstr];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"333333"] range:NSMakeRange(2, soldstr.length-3)];
    self.saleNumLabel.attributedText = attributedStr;
    NSString *commission = (model.commission) ? ([NSString stringWithFormat:@"%@", model.commission]) : (model.commission ? [NSString stringWithFormat:@"%@", model.commission] : @"0.00");
    if ([[NSString stringWithFormat:@"%.2f", [commission floatValue]] isEqualToString:@"0.00"]) {
//        self.profitLabel.sd_layout.widthIs(0);
        self.profitLabel.text=@"";
    }else{
        self.profitLabel.text = [NSString stringWithFormat:@"赚:¥%.2f", [commission floatValue]];
        if ([US_UserUtility commisionTitle].length>0) {
            self.profitLabel.text = [[US_UserUtility commisionTitle] stringByReplacingOccurrencesOfString:@"XXX" withString:[NSString stringWithFormat:@"%.2f", [commission floatValue]]];
        }
    }
    [self.profitLabel setSingleLineAutoResizeWithMaxWidth:KScreenScale(250)];
    //已推广
    if (model.isSharedToday) {
        self.profitLabel.sd_layout.topSpaceToView(self.priceLabel, KScreenScale(10));
        self.sharedLab.sd_layout.heightIs(KScreenScale(35));
    }else{
        self.profitLabel.sd_layout.topSpaceToView(self.priceLabel, KScreenScale(22));
        self.sharedLab.sd_layout.heightIs(0);
    }
    //积分商品
    if (model.isJifen) {
        self.priceLabel.textColor=[UIColor convertHexToRGB:@"FFA200"];
        self.priceLabel.text=[NSString isNullToString:model.jifenPrice];
        self.profitLabel.backgroundColor=[UIColor convertHexToRGB:@"FFA200"];
        self.profitLabel.textColor=[UIColor whiteColor];
        self.profitLabel.text=[NSString isNullToString:model.jifenTitle];
    }else{
        self.priceLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        self.profitLabel.backgroundColor=nil;
        self.profitLabel.textColor=[UIColor convertHexToRGB:@"ef3b39"];
    }
}
- (void)didShareClick:(id)sender{
    USShareModel * shareModel=[[USShareModel alloc] init];
    shareModel.listId=[NSString stringWithFormat:@"%@", self.model.listingId];
    shareModel.shareCommission=[USShareModel tranforCommitionStr:[NSString stringWithFormat:@"%@",self.model.commission]];
    shareModel.sharePrice=[NSString stringWithFormat:@"%@",self.model.minPrice];
    shareModel.marketPrice=[NSString stringWithFormat:@"%@",self.model.maxPrice];
    shareModel.listName=[NSString stringWithFormat:@"%@", self.model.listingName];
    shareModel.shareImageUrl=[NSString stringWithFormat:@"%@", self.model.imgeUrl];
    shareModel.isNeedSaveQRImage=YES;
    shareModel.logPageName=self.model.logPageName;
    shareModel.logShareFrom=self.model.logShareFrom;
    shareModel.shareChannel=self.model.shareChannel;
    shareModel.shareFrom=self.model.shareFrom;
    shareModel.isHome_jinxuan_GoodsShare=YES;
    //精选分享 动态可配 不传shareOptions 用接口返回的shareOptionsIndex
    shareModel.tel=@"FeaturedGoodShare";
    shareModel.srcid=Srcid_Index_prd;
    @weakify(self);
    [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
        @strongify(self);
        if ([response isEqualToString:SV_Success]) {
            if (![self.model saveSharedTodayByListID:self.model.listingId]) {
                self.model.isSharedToday=YES;
                self.profitLabel.sd_layout.topSpaceToView(self.priceLabel, KScreenScale(10));
                self.sharedLab.sd_layout.heightIs(KScreenScale(35));
            }
        }
    }];
    [MobClick event:@"homeShare_click" attributes:@{@"ID":[NSString stringWithFormat:@"%@", self.model.listingId]}];
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", self.model.listingId] moduleid:@"首页推荐商品" moduledesc:@"分享" networkdetail:@""];
}

- (void)cellClick:(UIGestureRecognizer *)recognizer{
    NewHomeRecommendData * recommend=(NewHomeRecommendData *)self.model.data;
    if ([NSString isNullToString:recommend.listingId].length>0) {
        //日志
        [MobClick event:@"homeGood_click" attributes:@{
            @"ID":[NSString stringWithFormat:@"%@", recommend.listingId],
            @"location":[NSString stringWithFormat:@"%ld", (long)recommend.locationIndex]
        }];
        [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", recommend.listingId] moduleid:@"首页商品点击" moduledesc:recommend.log_title networkdetail:@""];
        //日志
        [LogStatisticsManager onClickLog:Home_IndexListing andTev:[NSString stringWithFormat:@"%@", recommend.listingId]];
        [LogStatisticsManager shareInstance].srcid=Srcid_Index_prd;
        [[USGoodsPreviewManager sharedManager] pushToPreviewControllerWithListId:[NSString isNullToString:recommend.listingId] andSearchKeyword:@"" andPreviewType:@"2" andHudVC:(UleBaseViewController *)[UIViewController currentViewController]];
    }
    
    
//    UleUCiOSAction *action=[UleModulesDataToAction resolveModulesActionStr:recommend.ios_action];
//    NSString * linkurl=action.mParams[@"key"];
//    NSString * urle=@"";
//    if ([linkurl containsString:@"?"]) {
//        urle=[NSString stringWithFormat:@"%@&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
//    }else{
//        urle=[NSString stringWithFormat:@"%@?&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
//    }
//    [action.mParams setObject:urle forKey:@"key"];
//    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

#pragma mark  <setter and getter>
- (YYAnimatedImageView *)prdImageView{
    if (!_prdImageView) {
        _prdImageView=[[YYAnimatedImageView alloc] init];
        _prdImageView.userInteractionEnabled=YES;
        _prdImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _prdImageView;
}

- (YYLabel *)prdNameLabel{
    if (!_prdNameLabel) {
        _prdNameLabel=[YYLabel new];
        _prdNameLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _prdNameLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _prdNameLabel.numberOfLines=2;
        _prdNameLabel.displaysAsynchronously=NO;
    }
    return _prdNameLabel;
}
- (UILabel *)saleNumLabel{
    if (!_saleNumLabel) {
        _saleNumLabel=[UILabel new];
        _saleNumLabel.textAlignment=NSTextAlignmentRight;
        _saleNumLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _saleNumLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _saleNumLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _saleNumLabel;
}
- (UILabel *)profitLabel{
    if (!_profitLabel) {
        _profitLabel=[[UILabel alloc]init];
        _profitLabel.textColor=[UIColor convertHexToRGB:@"ef3b39"];
        _profitLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(24)];
        _profitLabel.backgroundColor=[UIColor whiteColor];
        _profitLabel.textAlignment=NSTextAlignmentLeft;
//        _profitLabel.clipsToBounds=YES;
        
    }
    return _profitLabel;
}
- (YYLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel=[YYLabel new];
        _priceLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _priceLabel.font=[UIFont systemFontOfSize:KScreenScale(30)];
//        _priceLabel.adjustsFontSizeToFitWidth=YES;
    }
    return _priceLabel;
}

- (YYLabel *)sharedLab{
    if (!_sharedLab) {
        _sharedLab=[[YYLabel alloc]init];
        _sharedLab.textColor=[UIColor convertHexToRGB:@"ef3b39"];
        _sharedLab.font=[UIFont boldSystemFontOfSize:KScreenScale(24)];
        _sharedLab.text=@"已推广";
    }
    return _sharedLab;
}

- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton=[[UIButton alloc] init];
        [_shareButton setImage:[UIImage bundleImageNamed:@"goods_earnings_share"] forState:UIControlStateNormal];
        [_shareButton setBackgroundColor:[UIColor clearColor]];
        [_shareButton addTarget:self action:@selector(didShareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}


@end

#pragma mark - <样式2-底部商品>
@interface US_GoodsHomeType2Cell ()
@property (nonatomic, strong) UIView            *mBgView;
@property (nonatomic, strong) YYAnimatedImageView *acImgView;
@property (nonatomic, strong) NSMutableArray        *mViewsArray;
@end

@implementation US_GoodsHomeType2Cell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.mBgView];
        self.mBgView.sd_layout.topSpaceToView(self.contentView, 0)
        .leftSpaceToView(self.contentView, KScreenScale(20))
        .rightSpaceToView(self.contentView, KScreenScale(20))
        .bottomSpaceToView(self.contentView, 0);
        [self.mBgView sd_addSubviews:@[self.acImgView]];
        self.acImgView.sd_layout.topSpaceToView(self.mBgView, 0)
        .leftSpaceToView(self.mBgView, 0)
        .rightSpaceToView(self.mBgView, 0)
        .autoHeightRatio(0.4);
        CGFloat viewWidth=(KScreenScale(710)-KScreenScale(40))/3.0;
        for (int i=0; i<3; i++) {
            GoodsSourceType2View *view=[[GoodsSourceType2View alloc]init];
            view.clipsToBounds=YES;
            view.sd_cornerRadius=@(KScreenScale(5));
            [self.mBgView addSubview:view];
            [self.mViewsArray addObject:view];
            view.sd_layout.topSpaceToView(self.acImgView, KScreenScale(10))
            .leftSpaceToView(self.mBgView, KScreenScale(10)+i*(KScreenScale(10)+viewWidth))
            .widthIs(viewWidth)
            .bottomSpaceToView(self.mBgView, 0);
        }
    }
    return self;
}

- (void)setModel:(US_GoodsCellModel *)model{
    if ([_model isEqual:model]) {
        return;
    }
    _model=model;
    if (model.bottomBannerModel) {
        self.acImgView.hidden=NO;
        if ([model.bottomBannerModel.wh_rate floatValue]>0) {
            self.acImgView.sd_layout.autoHeightRatio(1/[model.bottomBannerModel.wh_rate floatValue]);
        }
        [self.acImgView yy_setImageWithURL:[NSURL URLWithString:model.bottomBannerModel.customImgUrl] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    }else{
        self.acImgView.hidden=YES;
    }
    
    if (model.btnsArray.count>=3) {
        for (int i=0; i<self.mViewsArray.count; i++) {
            GoodsSourceType2View *view=self.mViewsArray[i];
            view.hidden=NO;
            [view setModel:model.btnsArray[i]];
            view.logPageName=model.logPageName;
            view.logShareFrom=model.logShareFrom;
            view.shareFrom=model.shareFrom;
            view.shareChannel=model.shareChannel;
        }
    }else{
        for (int i=0; i<self.mViewsArray.count; i++) {
            GoodsSourceType2View *view=self.mViewsArray[i];
            view.hidden=YES;
        }
    }
}

- (void)clickAction:(UIGestureRecognizer *)recognizer{
    NewHomeRecommendData * indexInfo=self.model.bottomBannerModel;
    //日志
    [MobClick event:@"homeBottomBanner_click" attributes:@{@"ID":[NSString stringWithFormat:@"%@", indexInfo.ID]}];
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", indexInfo.ID] moduleid:@"首页底部推荐Banner" moduledesc:indexInfo.log_title networkdetail:@""];
    //action
    UleUCiOSAction *action=[UleModulesDataToAction resolveModulesActionStr:indexInfo.ios_action];
    if (indexInfo.log_title.length>0) {
        [LogStatisticsManager shareInstance].srcid=indexInfo.log_title;
    }
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

- (UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]init];
        _mBgView.backgroundColor=[UIColor whiteColor];
        _mBgView.sd_cornerRadius=@(5);
        _mBgView.clipsToBounds=YES;
    }
    return _mBgView;
}
- (YYAnimatedImageView *)acImgView{
    if (!_acImgView) {
        _acImgView=[YYAnimatedImageView new];
//        _acImgView.layer.cornerRadius = 5;
//        _acImgView.layer.masksToBounds = YES;
        _acImgView.userInteractionEnabled = YES;
        _acImgView.contentMode=UIViewContentModeScaleToFill;
        [_acImgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)]];
    }
    return _acImgView;
}
- (NSMutableArray *)mViewsArray{
    if (!_mViewsArray) {
        _mViewsArray=[NSMutableArray array];
    }
    return _mViewsArray;
}
@end
@interface GoodsSourceType2View ()
@property(nonatomic, strong)YYAnimatedImageView     *mImageView;
@property(nonatomic, strong)UILabel                 *mTitleLab;
@property(nonatomic, strong)UIButton                *mShareBtn;
@property(nonatomic, strong)UILabel                 *mPriceLab;
@property(nonatomic, strong)UILabel                 *mCommissionLab;
 
@end
@implementation GoodsSourceType2View

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.layer.cornerRadius=KScreenScale(10);
    self.layer.masksToBounds=YES;
    self.backgroundColor=[UIColor whiteColor];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction:)]];
    [self sd_addSubviews:@[self.mImageView,self.mTitleLab,self.mShareBtn,self.mPriceLab,self.mCommissionLab]];
    self.mImageView.sd_layout.topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightEqualToWidth();
    self.mTitleLab.sd_layout.topSpaceToView(self.mImageView, KScreenScale(10))
    .leftSpaceToView(self, 5)
    .rightSpaceToView(self, 5)
    .heightIs(KScreenScale(55));
    self.mShareBtn.sd_layout.centerXEqualToView(self)
    .bottomSpaceToView(self, KScreenScale(25))
    .widthIs(KScreenScale(120))
    .heightIs(KScreenScale(35));
    self.mPriceLab.sd_layout.bottomSpaceToView(self.mShareBtn, KScreenScale(10))
    .leftEqualToView(self.mTitleLab)
    .heightIs(KScreenScale(20))
//    .autoWidthRatio(0);
    .widthIs(KScreenScale(110));
    self.mCommissionLab.sd_layout.topEqualToView(self.mPriceLab)
    .heightRatioToView(self.mPriceLab, 1.0)
    .rightEqualToView(self.mTitleLab)
    .leftSpaceToView(self.mPriceLab, 0);
}

- (void)setModel:(NewHomeRecommendData *)model{
    if (!model) {
        return;
    }
    _model=model;
    [self.mImageView yy_setImageWithURL:[NSURL URLWithString:model.customImgUrl] placeholder:nil];
    self.mTitleLab.text=[NSString stringWithFormat:@"%@",model.title];
    if ([NSString isNullToString:model.titlecolor].length>0) {
        self.mTitleLab.textColor=[UIColor convertHexToRGB:model.titlecolor];
    }
    
    NSString *priceNumStr=[NSString stringWithFormat:@"%@",model.salePrice.length>0?model.salePrice:@"0"];
    NSString *commissionNumStr=[NSString stringWithFormat:@"%@",model.commission.length>0?model.commission:@"0"];
    self.mPriceLab.text=[NSString stringWithFormat:@"¥%@",[USDecimalTool decimalDeleteInvalidNumber:priceNumStr]];
    if ([model.commission doubleValue]>0) {
        self.mCommissionLab.text=[NSString stringWithFormat:@"赚¥%@",[USDecimalTool decimalDeleteInvalidNumber:commissionNumStr]];
        [self addAttributedStringWithLabel:self.mCommissionLab andRange:NSMakeRange(0, 2) andFont:[UIFont systemFontOfSize:KScreenScale(18)]];
    }else self.mCommissionLab.text=@"";
//    [self.mPriceLab setSingleLineAutoResizeWithMaxWidth:KScreenScale(110)];
    
    [self addAttributedStringWithLabel:self.mPriceLab andRange:NSMakeRange(0, 1) andFont:[UIFont systemFontOfSize:KScreenScale(18)]];
}

- (void)addAttributedStringWithLabel:(UILabel *)lablel andRange:(NSRange)range andFont:(UIFont *)font {
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc]initWithString:lablel.text];
    [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    lablel.attributedText=attributedStr;
}

- (void)shareBtnAction{
    USShareModel * shareModel=[[USShareModel alloc] init];
    shareModel.listId=[NSString stringWithFormat:@"%@", self.model.listingId];
    shareModel.shareCommission=[USShareModel tranforCommitionStr:[NSString stringWithFormat:@"%@",self.model.commission]];
    shareModel.sharePrice=[NSString stringWithFormat:@"%@",self.model.salePrice];
//    shareModel.marketPrice=[NSString stringWithFormat:@"%@",self.model.salePrice];
    shareModel.listName=[NSString stringWithFormat:@"%@", self.model.title];
    shareModel.shareImageUrl=[NSString stringWithFormat:@"%@", self.model.customImgUrl];
    shareModel.isNeedSaveQRImage=YES;
    shareModel.logPageName=self.logPageName;
    shareModel.logShareFrom=self.logShareFrom;
    shareModel.shareChannel=self.shareChannel;
    shareModel.shareFrom=self.shareFrom;
    shareModel.isHome_jinxuan_GoodsShare=YES;
    shareModel.srcid=self.model.log_title.length>0?self.model.log_title:@"";
    //精选分享 动态可配 不传shareOptions 用接口返回的shareOptionsIndex
    shareModel.tel=@"FeaturedGoodShare";
    [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
    }];
    [MobClick event:@"homeShare_click" attributes:@{@"ID":[NSString stringWithFormat:@"%@", self.model.listingId]}];
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", self.model.listingId] moduleid:@"首页底部推荐商品" moduledesc:@"分享" networkdetail:@""];
}

- (void)clickAction:(UIGestureRecognizer *)recognizer{
    NewHomeRecommendData * recommend=self.model;
    if ([NSString isNullToString:self.model.listingId].length>0) {
        //日志
        [MobClick event:@"homeGood_click" attributes:@{
            @"ID":[NSString stringWithFormat:@"%@", recommend.listingId],
            @"location":[NSString stringWithFormat:@"%ld", (long)recommend.locationIndex]
        }];
        [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", recommend.listingId] moduleid:@"首页底部商品点击" moduledesc:recommend.log_title networkdetail:@""];
        if (self.model.log_title.length>0) {
             [LogStatisticsManager shareInstance].srcid=self.model.log_title;
        }
        [[USGoodsPreviewManager sharedManager]pushToPreviewControllerWithListId:[NSString isNullToString:self.model.listingId] andSearchKeyword:@"" andPreviewType:@"2" andHudVC:[UIViewController currentViewController]];
    }
}

#pragma mark - <getters>
- (YYAnimatedImageView *)mImageView{
    if (!_mImageView) {
        _mImageView=[[YYAnimatedImageView alloc]init];
        _mImageView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _mImageView;
}
-(UILabel *)mTitleLab{
    if (!_mTitleLab) {
        _mTitleLab=[[UILabel alloc]init];
        _mTitleLab.numberOfLines=2;
        _mTitleLab.font=[UIFont systemFontOfSize:KScreenScale(22)];
        _mTitleLab.textColor=[UIColor convertHexToRGB:@"333333"];
    }
    return _mTitleLab;
}
- (UIButton *)mShareBtn{
    if (!_mShareBtn) {
        _mShareBtn=[UIButton buttonWithType:UIButtonTypeSystem];
        [_mShareBtn setTitle:@"立即分享" forState:UIControlStateNormal];
        _mShareBtn.titleLabel.font=[UIFont systemFontOfSize:10];
        [_mShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mShareBtn.sd_cornerRadiusFromHeightRatio=@(0.5);
        CAGradientLayer * layer=[UIView setGradualSizeChangingColor:CGSizeMake(KScreenScale(120), KScreenScale(35)) fromColor:[UIColor convertHexToRGB:@"FF7D43"] toColor:[UIColor convertHexToRGB:@"FE5F45"] gradualType:GradualTypeHorizontal];
        [_mShareBtn.layer addSublayer:layer];
        layer.zPosition=-1;
        [_mShareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mShareBtn;
}
- (UILabel *)mPriceLab{
    if (!_mPriceLab) {
        _mPriceLab=[[UILabel alloc]init];
        _mPriceLab.font=[UIFont systemFontOfSize:KScreenScale(23)];
        _mPriceLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _mPriceLab.adjustsFontSizeToFitWidth=YES;
    }
    return _mPriceLab;
}
- (UILabel *)mCommissionLab{
    if (!_mCommissionLab) {
        _mCommissionLab=[[UILabel alloc]init];
        _mCommissionLab.textAlignment=NSTextAlignmentRight;
        _mCommissionLab.font=[UIFont systemFontOfSize:KScreenScale(23)];
        _mCommissionLab.textColor=[UIColor convertHexToRGB:@"ec3d3f"];
        _mCommissionLab.adjustsFontSizeToFitWidth=YES;
    }
    return _mCommissionLab;
}
@end

#pragma mark - <样式3-有料商品>
@interface US_GoodsHomeType3Cell ()
@property (nonatomic, strong) UIView *bdView;
@property (nonatomic, strong) YYAnimatedImageView *imgView;
@property (nonatomic, strong) YYLabel *titLabel;
@property (nonatomic, strong) YYLabel *despLabel;
@end

@implementation US_GoodsHomeType3Cell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor=[UIColor clearColor];
        [self.contentView sd_addSubviews:@[self.bdView]];
        [self.bdView sd_addSubviews:@[self.imgView,self.titLabel,self.despLabel]];
        self.bdView.sd_layout.topSpaceToView(self.contentView, KScreenScale(10))
        .leftSpaceToView(self.contentView, KScreenScale(20))
        .rightSpaceToView(self.contentView, KScreenScale(20))
        .bottomSpaceToView(self.contentView, KScreenScale(10));
        
        UIImageView *youliaoImgView = [[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"goods_icon_youliao"]];
        [self.bdView addSubview:youliaoImgView];
        youliaoImgView.sd_layout.rightSpaceToView(self.bdView, KScreenScale(34))
        .bottomSpaceToView(self.bdView, 0)
        .widthIs(KScreenScale(164)).heightIs(KScreenScale(62));
        
        self.imgView.sd_layout.leftSpaceToView(self.bdView, 0)
        .topSpaceToView(self.bdView, 0)
        .bottomSpaceToView(self.bdView, 0)
        .widthEqualToHeight();
        
        self.titLabel.sd_layout.topSpaceToView(self.bdView, KScreenScale(24))
        .leftSpaceToView(self.imgView, 5)
        .rightSpaceToView(self.bdView, 5)
        .heightIs(KScreenScale(35));
        
        self.despLabel.sd_layout.topSpaceToView(self.titLabel, KScreenScale(16))
        .leftEqualToView(self.titLabel)
        .rightEqualToView(self.titLabel)
        .heightIs(KScreenScale(60));
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)]];
    }
    return self;
}

#pragma mark - event response
- (void)tapClick {
    UleIndexInfo * item=(UleIndexInfo *)self.model.data;
    //日志
    [MobClick event:@"homeYouliao_click" attributes:@{@"ID":[NSString stringWithFormat:@"%@", item.mid]}];
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.mid] moduleid:@"首页有料点击" moduledesc:item.title networkdetail:@""];
    
    NSMutableDictionary *dic = @{
                                 @"title": @"有料",
                                 @"key": item.link,
                                 }.mutableCopy;
    if (item.logtitle.length>0) {
        [LogStatisticsManager shareInstance].srcid=item.logtitle;
    }
    [[UIViewController currentViewController] pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
}

#pragma mark - getters and setters
- (void)setModel:(US_GoodsCellModel *) model {
    _model = model;
    UleIndexInfo * item=(UleIndexInfo *)model.data;
    self.titLabel.text = item.title;
    self.despLabel.text = item.attribute1;
    NSMutableAttributedString *desp = [[NSMutableAttributedString alloc] initWithString:item.attribute1];
    desp.yy_lineSpacing = KScreenScale(8);
    desp.yy_font = [UIFont systemFontOfSize:KScreenScale(24)];
    desp.yy_color = [UIColor convertHexToRGB:@"999999"];
    self.despLabel.attributedText = desp;
    [self.imgView yy_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholder:[UIImage bundleImageNamed:@"bg_def_80x80_s"]];
}

- (UIView *)bdView {
    if (!_bdView) {
        _bdView = [[UIView alloc] initWithFrame:CGRectZero];
        _bdView.layer.cornerRadius = 5;
        _bdView.backgroundColor = [UIColor whiteColor];
        _bdView.clipsToBounds=YES;
    }
    return _bdView;
}

- (YYAnimatedImageView *)imgView {
    if (!_imgView) {
        _imgView = [[YYAnimatedImageView alloc] initWithFrame:CGRectZero];
        _imgView.backgroundColor = [UIColor whiteColor];
        _imgView.contentMode = UIViewContentModeScaleAspectFit;
        _imgView.clipsToBounds = YES;
    }
    return _imgView;
}

- (YYLabel *)titLabel {
    if (!_titLabel) {
        _titLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _titLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _titLabel.font = [UIFont systemFontOfSize:KScreenScale(30)];
        _titLabel.textAlignment = NSTextAlignmentLeft;
        _titLabel.numberOfLines = 1;
    }
    return _titLabel;
}

- (YYLabel *)despLabel {
    if (!_despLabel) {
        _despLabel = [[YYLabel alloc] initWithFrame:CGRectZero];
        _despLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _despLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _despLabel.numberOfLines = 2;
        _despLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-KScreenScale(24)-KScreenScale(24)-KScreenScale(20)-KScreenScale(180);
    }
    return _despLabel;
}


@end
/*******************微保模块**********************/
#pragma mark - <样式4 - 微保模块>

@interface US_GoodsHomeType4Cell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) YYAnimatedImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *commissionLabel;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton * tipBtn;
@property (nonatomic, strong) UIButton * shareBtn;
@end

@implementation US_GoodsHomeType4Cell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadUI];
    }
    return self;
}
- (void)loadUI{
    [self.contentView sd_addSubviews:@[self.bgView]];
    [self.bgView sd_addSubviews:@[self.iconImgView,self.titleLabel,self.commissionLabel,self.descriptLabel,self.priceLabel,self.tipBtn,self.shareBtn]];
    self.bgView.sd_layout.leftSpaceToView(self.contentView, KScreenScale(20))
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .bottomSpaceToView(self.contentView, 0);

    self.iconImgView.sd_layout.leftSpaceToView(self.bgView, 0)
    .topSpaceToView(self.bgView, 0)
    .bottomSpaceToView(self.bgView, 0)
    .widthEqualToHeight();

    self.tipBtn.sd_layout.rightSpaceToView(self.bgView, 10)
    .widthIs(KScreenScale(30)).heightIs(KScreenScale(30))
    .topSpaceToView(self.bgView, KScreenScale(26));
    
    self.commissionLabel.sd_layout.centerYEqualToView(self.tipBtn)
    .rightSpaceToView(self.tipBtn, 5)
    .heightIs(KScreenScale(30));
    
    self.titleLabel.sd_layout.centerYEqualToView(self.tipBtn)
    .leftSpaceToView(self.iconImgView, 5)
    .heightIs(KScreenScale(30)).rightSpaceToView(self.commissionLabel, 5);
    
    self.descriptLabel.sd_layout.leftEqualToView(self.titleLabel)
    .topSpaceToView(self.titleLabel, KScreenScale(5))
    .autoHeightRatio(0).rightSpaceToView(self.bgView, 5);
    
    self.priceLabel.sd_layout.leftEqualToView(self.titleLabel)
    .bottomSpaceToView(self.bgView, KScreenScale(15))
    .heightIs(KScreenScale(30))
    .rightSpaceToView(self.bgView, 5);
    self.shareBtn.sd_layout.rightSpaceToView(self.bgView, 10)
    .bottomSpaceToView(self.bgView, 10)
    .widthIs(KScreenScale(50)).heightEqualToWidth();
    
}

- (void)setModel:(US_GoodsCellModel *)model{
    _model=model;
    NewHomeRecommendData * item=model.data;
    
    self.titleLabel.text = item.customTitle;
    self.descriptLabel.text = item.customDesc;
    self.priceLabel.text = item.salePrice;
    self.commissionLabel.text = item.commission;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:item.salePrice];
    if (text.length>3) {
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"333333"] range:NSMakeRange(text.length-3, 3)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(20)] range:NSMakeRange(text.length-3, 3)];
    }
    self.priceLabel.attributedText = text;
    
    NSString *imgUrlStr = [NSString isNullToString:item.imageList.firstObject];
    if ([imgUrlStr rangeOfString:@"ule.com"].location!=NSNotFound) {
        imgUrlStr = [NSString getImageUrlString:kImageUrlType_L withurl:imgUrlStr];
    }
    [self.iconImgView yy_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:[UIImage bundleImageNamed:@"bg_def_80x80_s"]];
    [self.commissionLabel setSingleLineAutoResizeWithMaxWidth:200];
//    [self.priceLabel setSingleLineAutoResizeWithMaxWidth:200];
}

- (void)tipBtnClicked{
    NewHomeRecommendData * item=self.model.data;
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.mInsuranceListingId] moduleid:@"精选医保推荐" moduledesc:@"佣金说明" networkdetail:@""];
    InsuranceAlertView *alertView = [InsuranceAlertView insuranceAlertViewWithUrl:item.customImgUrl wh_rate:item.wh_rate confirmBlock:^{
        
    }];
    [alertView showViewWithAnimation:AniamtionAlert];
}

- (void)tap{
    NewHomeRecommendData * item=self.model.data;
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.mInsuranceListingId]  moduleid:@"精选医保推荐" moduledesc:@"查看详情" networkdetail:@""];
    UleUCiOSAction *action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
    NSString * linkurl=action.mParams[@"key"];
    NSString * urle=@"";
    if ([linkurl containsString:@"?"]) {
        urle=[NSString stringWithFormat:@"%@&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
    }else{
        urle=[NSString stringWithFormat:@"%@?&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
    }
    [action.mParams setObject:urle forKey:@"key"];
    if (item.log_title.length>0) {
        [LogStatisticsManager shareInstance].srcid=item.log_title;
    }
    [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

- (void)shareBtnAction{
    NewHomeRecommendData * item=self.model.data;
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.mInsuranceListingId] moduleid:@"精选医保推荐" moduledesc:@"分享" networkdetail:@""];
    USShareModel * shareModel=[[USShareModel alloc] init];
    shareModel.listId=[NSString stringWithFormat:@"%@", item.mInsuranceListingId];
    shareModel.shareCommission=[NSString stringWithFormat:@"%@",item.commission];
    shareModel.sharePrice=[NSString stringWithFormat:@"%@",item.salePrice];
    shareModel.marketPrice=[NSString stringWithFormat:@"%@",self.model.maxPrice];
    shareModel.listName=[NSString stringWithFormat:@"%@", item.customTitle];
    shareModel.shareImageUrl=[NSString stringWithFormat:@"%@", item.imageList.firstObject];
    shareModel.isNeedSaveQRImage=YES;
    shareModel.logPageName=self.model.logPageName;
    shareModel.logShareFrom=self.model.logShareFrom;
    shareModel.shareChannel=self.model.shareChannel;
    shareModel.shareFrom=self.model.shareFrom;
    //shareModel.shareType=@"1100";
    shareModel.shareOptions=@"0##1";
    shareModel.insuranceFlag=@(1);
    [USShareView insuranceShareWithModel:shareModel success:^(id  _Nonnull response) {
        
    }];
}

#pragma mark - <setter and getter>
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds=YES;
        _bgView.userInteractionEnabled = YES;
        [_bgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    return _bgView;
}

- (YYAnimatedImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[YYAnimatedImageView alloc] init];
        _iconImgView.backgroundColor = [UIColor convertHexToRGB:@"999999"];
        _iconImgView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(26)];
        _titleLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _titleLabel;
}

- (UILabel *)commissionLabel {
    if (!_commissionLabel) {
        _commissionLabel = [[UILabel alloc] init];
//        _commissionLabel.text = @"收益￥2.00起";
        _commissionLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(20)];
        _commissionLabel.textColor = [UIColor convertHexToRGB:@"EF3B39"];
    }
    return _commissionLabel;
}

- (UILabel *)descriptLabel {
    if (!_descriptLabel) {
        _descriptLabel = [[UILabel alloc] init];
        _descriptLabel.numberOfLines=2;
//                _descriptLabel.text = @"800万保额，报销医疗费";
        _descriptLabel.font = [UIFont systemFontOfSize:KScreenScale(20)];
        _descriptLabel.textColor = [UIColor convertHexToRGB:@"999999"];
    }
    return _descriptLabel;
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
//                _priceLabel.text = @"￥11/月起";
        _priceLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _priceLabel.textColor = [UIColor convertHexToRGB:@"F3950F"];
        _priceLabel.textAlignment=NSTextAlignmentLeft;
    }
    return _priceLabel;
}

- (UIButton *)tipBtn{
    if (!_tipBtn) {
        _tipBtn=[[UIButton alloc] init];
        [_tipBtn setImage:[UIImage bundleImageNamed:@"goods_btn_secureTips"] forState:UIControlStateNormal];
        [_tipBtn addTarget:self action:@selector(tipBtnClicked) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _tipBtn;
}

- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn=[[UIButton alloc] init];
        [_shareBtn setImage:[UIImage bundleImageNamed:@"goods_earnings_share"] forState:UIControlStateNormal];
        [_shareBtn setBackgroundColor:[UIColor clearColor]];
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}

@end

