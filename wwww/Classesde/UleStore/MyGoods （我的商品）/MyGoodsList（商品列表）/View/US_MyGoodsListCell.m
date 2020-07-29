//
//  US_MyGoodsListCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsListCell.h"
#import "UleControlView.h"
#import <UIView+SDAutoLayout.h>
#import "US_CommisionLabel.h"
#import "US_NetworkExcuteManager.h"
#import "US_MyGoodsApi.h"
#import "UleBaseViewController.h"
#import "USShareView.h"
#import <YYText.h>
#import "US_ShareApi.h"

#define kListMargin  KScreenScale(15)

@interface US_MyGoodsListCell ()
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, strong) YYLabel * mSaleNumLabel;
@property (nonatomic, strong) YYLabel * mAddTimeLabel;
@property (nonatomic, strong) YYLabel * mPriceLabel;
@property (nonatomic, strong) US_CommisionLabel * mCommissionLabel;
@property (nonatomic, strong) YYLabel * mProductIDLabel;
@property (nonatomic, strong) UIImageView * mPdImageView;
@property (nonatomic, strong) UleControlView * mAddButton;
@property (nonatomic, strong) UleControlView * mShareButton;
@property (nonatomic, strong) UIImageView * mGroupbuyView;
@property (nonatomic, strong) UIImageView   *mSaleStatusView;//销售状态（售完，下架）
@property (nonatomic, strong) UIImageView   *mSalePromImg;//促销提示
@property (nonatomic, strong) UIButton * mSelectButton;//选择图标
@property (nonatomic, strong) UILabel * mDidAddedFlage;//已添加标志
@property (nonatomic, strong) UIView * mAddedMaskView;//已添加的蒙版
@property (nonatomic, strong) UIImageView   * selfGoodsTypeImg;//自有商品 或者 代理商品标签
@property (nonatomic, strong) UILabel * mListMarkLab;//标签

@property (nonatomic, strong) UILongPressGestureRecognizer  *longPressGes;
//
@property (nonatomic, strong) UleNetworkExcute * client;
@property (nonatomic, assign) BOOL didAddTapGesture;
@end

@implementation US_MyGoodsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    UIView * splitLine=[[UIView alloc] init];
    splitLine.backgroundColor=kViewCtrBackColor;
    
    [self.contentView sd_addSubviews:@[self.mSelectButton, self.mTitleLabel,self.mSaleNumLabel,self.mListMarkLab,self.mAddTimeLabel,self.mPriceLabel,self.mCommissionLabel,self.mProductIDLabel,self.mPdImageView,self.mAddButton,self.mShareButton,self.mGroupbuyView,self.mSaleStatusView,self.mSalePromImg,splitLine,self.mAddedMaskView,self.mDidAddedFlage]];
    self.mSelectButton.sd_layout.centerYEqualToView(self.contentView)
    .leftSpaceToView(self.contentView, kListMargin)
    .widthIs(0)
    .heightEqualToWidth();
    
    self.mPdImageView.sd_layout.leftSpaceToView(self.mSelectButton, kListMargin)
    .topSpaceToView(self.contentView, kListMargin)
    .widthIs(KScreenScale(200))
    .heightEqualToWidth();
    [self.mPdImageView addSubview:self.selfGoodsTypeImg];
    self.selfGoodsTypeImg.sd_layout
    .topSpaceToView(self.mPdImageView, 0)
    .leftSpaceToView(self.mPdImageView, 0)
    .widthIs(KScreenScale(200)*0.45)
    .heightIs(KScreenScale(200)*0.45);

    
    self.mSaleStatusView.sd_layout.centerXEqualToView(self.mPdImageView)
    .centerYEqualToView(self.mPdImageView)
    .widthIs(KScreenScale(120)).heightIs(KScreenScale(120));
    
    self.mGroupbuyView.sd_layout.leftEqualToView(self.mPdImageView)
    .topSpaceToView(self.contentView, KScreenScale(24))
    .widthIs(KScreenScale(66)).heightIs(KScreenScale(40));
    
    self.mProductIDLabel.sd_layout.leftEqualToView(self.mPdImageView)
    .topSpaceToView(self.mPdImageView, 0)
    .heightIs(KScreenScale(35))
    .widthRatioToView(self.mPdImageView, 1);
    
    self.mTitleLabel.sd_layout.leftSpaceToView(self.mPdImageView, kListMargin)
    .topSpaceToView(self.contentView, kListMargin)
    .rightSpaceToView(self.contentView, kListMargin)
    .heightIs(KScreenScale(70));
    
    self.mSaleNumLabel.sd_layout.leftEqualToView(self.mTitleLabel)
    .topSpaceToView(self.mTitleLabel, KScreenScale(5))
    .heightIs(KScreenScale(35)).widthIs(0);
//    .autoWidthRatio(0);
    
    self.mAddTimeLabel.sd_layout.leftSpaceToView(self.mSaleNumLabel, kListMargin)
    .topEqualToView(self.mSaleNumLabel)
    .heightIs(KScreenScale(35))
    .rightSpaceToView(self.contentView, KScreenScale(10));
    
    self.mListMarkLab.sd_layout.topSpaceToView(self.mSaleNumLabel, KScreenScale(5))
    .leftEqualToView(self.mSaleNumLabel)
    .widthIs(KScreenScale(400))
    .heightIs(KScreenScale(35));
    
    self.mCommissionLabel.sd_layout.leftEqualToView(self.mTitleLabel)
    .bottomEqualToView(self.mProductIDLabel)
    .heightIs(KScreenScale(35)).widthIs(0);
    
    self.mSalePromImg.sd_layout.leftEqualToView(self.mTitleLabel)
    .bottomSpaceToView(self.mCommissionLabel, KScreenScale(5))
    .widthIs(KScreenScale(35))
    .heightIs(KScreenScale(35));
    
    self.mPriceLabel.sd_layout.leftSpaceToView(self.mSalePromImg, 0)
    .bottomSpaceToView(self.mCommissionLabel, KScreenScale(10))
    .heightIs(KScreenScale(30)).rightSpaceToView(self.contentView, KScreenScale(100));
    
    self.mShareButton.sd_layout.rightSpaceToView(self.contentView, KScreenScale(20))
    .bottomSpaceToView(self.contentView, kListMargin)
    .widthIs(KScreenScale(60)).heightIs(KScreenScale(92));
    
    self.mAddButton.sd_layout.rightSpaceToView(self.mShareButton, KScreenScale(20))
    .bottomSpaceToView(self.contentView, kListMargin)
    .widthIs(KScreenScale(60)).heightIs(KScreenScale(92));
    
    splitLine.sd_layout.leftSpaceToView(self.contentView, 0)
    .topSpaceToView(self.mProductIDLabel, kListMargin)
    .rightSpaceToView(self.contentView, 0)
    .heightIs(5);
    
    self.mDidAddedFlage.sd_layout.rightSpaceToView(self.contentView, -5)
    .topSpaceToView(self.contentView, 0)
    .widthIs(55).heightIs(20);
    
    self.mAddedMaskView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mAddedMaskView.sd_layout.bottomSpaceToView(splitLine, 0);
    
    [self setupAutoHeightWithBottomView:splitLine bottomMargin:0];
    

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - <setModel>
- (void)setModel:(US_MyGoodsListCellModel *)model{
    _model=model;
    CGFloat prdNameWidth;
    if (_model.isEditStatus) {
        //编辑可选择状态
        if (_model.isMyGoodsSearch) {
            _mSelectButton.userInteractionEnabled=YES;
            [_mSelectButton addTarget:self action:@selector(cellClick:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            if (self.didAddTapGesture==NO) {
                UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
                [self addGestureRecognizer:tap];
                self.didAddTapGesture=YES;
            }
        }
        [self.mSelectButton setImage:[UIImage bundleImageNamed:@"myGoods_img_cellNoSelect"] forState:UIControlStateNormal];
        self.mSelectButton.sd_layout.widthIs(30);
        self.mSelectButton.selected=_model.isSelected;
        prdNameWidth=__MainScreen_Width-KScreenScale(255)-30;
    }else{
        prdNameWidth=__MainScreen_Width-KScreenScale(235);
        self.mPdImageView.sd_layout.leftSpaceToView(self.contentView,kListMargin);
    }
    NSString * imgUrlStr=_model.imgUrl;
    if ([imgUrlStr rangeOfString:@"ule.com"].location!=NSNotFound) {
        imgUrlStr = [NSString getImageUrlString:kImageUrlType_L withurl:imgUrlStr];
    }
    [self.mPdImageView yy_setImageWithURL:[NSURL URLWithString:imgUrlStr] placeholder:[UIImage bundleImageNamed:@"bg_placehold_80X80"]];
    self.mProductIDLabel.text=[NSString stringWithFormat:@"ID:%@",_model.listId];
//    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(prdNameWidth, KScreenScale(70))];
//    self.mTitleLabel.textLayout = [YYTextLayout layoutWithContainer:container text:_model.listNameAttribute];
//    if ([self.model.logPageName isEqualToString:kPageName_GoodsSearch]) {
        self.mTitleLabel.text=self.model.listName;
        self.mListMarkLab.attributedText=self.model.listMarkAttribute;
//    }else{
//        self.mTitleLabel.attributedText=self.model.listNameAttribute;
//        self.mListMarkLab.attributedText=[[NSAttributedString alloc]initWithString:@""];
//    }
    CGFloat price=_model.salePrice.length>0?[_model.salePrice floatValue]:0.0;
    self.mPriceLabel.text=[NSString stringWithFormat:@"￥%.2f",price];
    self.mCommissionLabel.text = _model.commissionStr;
    self.mCommissionLabel.sd_layout.widthIs(_model.commissionWidth);
    NSString * addtimeStr=_model.addTime.length>0?[NSString stringWithFormat:@"添加时间：%@",_model.addTime]:@"";
    self.mAddTimeLabel.text=addtimeStr;
    if (_model.isFenXiao) {
        self.mAddTimeLabel.textColor=[UIColor convertHexToRGB:@"EE3B39"];
        self.mAddTimeLabel.sd_resetLayout.topSpaceToView(self.mSaleNumLabel, KScreenScale(5))
        .leftEqualToView(self.mTitleLabel)
        .widthIs(KScreenScale(400))
        .heightIs(KScreenScale(35));
    }
    if ([NSString isNullToString:_model.packageSpec].length>0) {
        //规格
        self.mSaleNumLabel.text=[NSString isNullToString:_model.packageSpec];
    }else {
        //销量
        self.mSaleNumLabel.text=_model.sellTotal.length>0?[NSString stringWithFormat:@"销量：%@",_model.sellTotal]:@"";
    }
    CGSize size=[NSString getSizeOfString:self.mSaleNumLabel.text withFont:[UIFont systemFontOfSize:KScreenScale(24)] andMaxWidth:300];
    self.mSaleNumLabel.sd_layout.widthIs(size.width);

    self.mAddButton.hidden=_model.hiddenAddBtn;
    if (_model.hiddenShareBtn) {
        self.mShareButton.sd_layout.rightSpaceToView(self.contentView, -KScreenScale(60));
    }else{
        self.mShareButton.sd_layout.rightSpaceToView(self.contentView, KScreenScale(20));
    }
    self.mShareButton.hidden=_model.hiddenShareBtn;
    //显示商品的状态（售罄，下架，已同步）
    if ((self.model.listingState.length>0&&[self.model.listingState integerValue]==2) || self.model.isFenxiaoOutStock) {
        self.mSaleStatusView.image=[UIImage bundleImageNamed:@"myGoods_img_outofstock"];//下架
    }else if (self.model.instock.length>0&&[self.model.instock integerValue]<=0){
         self.mSaleStatusView.image=[UIImage bundleImageNamed:@"myGoods_img_soldout"];//售完
    }else if(self.model.synced.length>0&&self.model.listingState.length>0&&[self.model.listingState integerValue]==0){
        self.mSaleStatusView.image=[UIImage bundleImageNamed:@"myGoods_img_synced"];
        [self.mSelectButton setImage:[UIImage bundleImageNamed:@"myGoods_img_syncedSelected"] forState:UIControlStateNormal];
    }else{
        self.mSaleStatusView.image=nil;
    }
    //显示是否是团购商品
    if (self.model.groupbuyFlag&&[self.model.groupbuyFlag isEqualToString:@"1"] ) {
        self.mGroupbuyView.hidden=NO;
        self.selfGoodsTypeImg.hidden=YES;
    }else{
        self.mGroupbuyView.hidden=YES;
        if ([self.model.logPageName isEqualToString:kPageName_MyGoods]) {
            self.selfGoodsTypeImg.hidden=NO;
            //不是团购商品 再区分是自录商品还是代理商品
            if ([self.model.listingType isEqualToString:@"103"]) {
                [self.selfGoodsTypeImg setImage:[UIImage bundleImageNamed:@"myGoods_icon_selfGoods"]];
            }
            else{
                [self.selfGoodsTypeImg setImage:[UIImage bundleImageNamed:@"myGoods_icon_agentGoods"]];
            }
        }
        
    }
    //是否显示促销
    self.mSalePromImg.sd_layout.widthIs(self.model.showSalesPromotion?KScreenScale(35):0);
    //显示已添加以及半透明蒙版
    self.mDidAddedFlage.hidden=self.model.isAdded?NO:YES;
    self.mAddedMaskView.hidden=self.model.isAdded?NO:YES;
    self.delegate=self.model.delegate;
    if (self.model.myGoodsListType==US_MyGoodsListAllGoods||self.model.myGoodsListType==US_MyGoodsFenXiao) {
        [self.contentView addGestureRecognizer:self.longPressGes];
    }else if (_longPressGes){
        [self.contentView removeGestureRecognizer:self.longPressGes];
    }
}

- (void)cellClick:(UIGestureRecognizer *)recognizer{
    if (self.model.isAdded) {
        [UleMBProgressHUD showHUDWithText:@"商品已添加" afterDelay:1.5];
        return;
    }
    if (self.model.synced.length>0&&[self.model.listingState integerValue]==0) {
        return;
    }
    self.model.isSelected=!self.model.isSelected;
    [self.mSelectButton setSelected:self.model.isSelected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedListCellForModel:)]) {
        [self.delegate didSelectedListCellForModel:self.model];
    }
}

#pragma mark - <button Action>
//添加到收藏
- (void)addFavor:(id)sender{
    if (self.model.isFenXiao) {
        //添加分销商品到收藏
        NSString *listId=[NSString isNullToString:[NSString stringWithFormat:@"%@", _model.listId]];
        NSString *zoneId=[NSString isNullToString:[NSString stringWithFormat:@"%@", _model.zoneId]];
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在添加"];
        [self.client beginRequest:[US_MyGoodsApi buildAddFenXiaoFavorProductWithListId:listId andGoodZoneId:zoneId] success:^(id responseObject) {
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
            [UleMBProgressHUD showHUDWithImage:[UIImage bundleImageNamed:@"myGoods_img_savesuccess"] afterDelay:1.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_FenxiaoMyGoodsListRefresh object:nil];
            
        } failure:^(UleRequestError *error) {
            UleBaseViewController * vc=(UleBaseViewController *)[UIViewController currentViewController];
            [vc showErrorHUDWithError:error];
        }];
        [UleMbLogOperate addMbLogClick:listId moduleid:self.model.logPageName moduledesc:@"添加到小店分销" networkdetail:@""];
    }else{
        //添加普通商品到收藏
        NSString * listID=[NSString isNullToString:[NSString stringWithFormat:@"%@", self.model.listId]];
        [UleMBProgressHUD showHUDAddedTo:[UIViewController currentViewController].view withText:@"正在添加"];
        [self.client beginRequest:[US_MyGoodsApi buildAddFavorProductWithListId:listID] success:^(id responseObject) {
            [UleMBProgressHUD hideHUDForView:[UIViewController currentViewController].view];
            [UleMBProgressHUD showHUDWithImage:[UIImage bundleImageNamed:@"myGoods_img_savesuccess"] afterDelay:1.5];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_MyGoodsListRefresh object:nil];
            
        } failure:^(UleRequestError *error) {
            UleBaseViewController * vc=(UleBaseViewController *)[UIViewController currentViewController];
            [vc showErrorHUDWithError:error];
        }];
        [UleMbLogOperate addMbLogClick:listID moduleid:self.model.logPageName moduledesc:@"添加到小店" networkdetail:@""];
    }
}

- (void)shareClick:(id)sender{
    if (self.model.isFenXiao) {
        USShareModel * shareModel=[[USShareModel alloc] init];
        shareModel.listId=[NSString stringWithFormat:@"%@", _model.listId];
        shareModel.zoneId=[NSString stringWithFormat:@"%@", _model.zoneId];
        shareModel.sharePrice=[NSString stringWithFormat:@"%@", _model.salePrice];
        shareModel.listName=[NSString stringWithFormat:@"%@", _model.listName];
        shareModel.shareImageUrl=[NSString stringWithFormat:@"%@", _model.imgUrl];
        shareModel.isNeedSaveQRImage=YES;
        shareModel.logPageName=_model.logPageName;
        shareModel.logShareFrom=_model.logShareFrom;
        shareModel.shareFrom=_model.shareFrom;
        shareModel.shareChannel=_model.shareChannel;
        shareModel.srcid=_model.srcid.length>0?_model.srcid:@"";
        //默认标题和内容
        shareModel.shareTitle=[US_UserUtility sharedLogin].m_stationName;
        shareModel.shareContent=shareModel.listName;
        [USShareView fenxiaoShareWithModel:shareModel success:^(id  _Nonnull response) {
            
        }];
        [UleMbLogOperate addMbLogClick:NonEmpty(self.model.listId) moduleid:NonEmpty(self.model.logPageName) moduledesc:@"分享" networkdetail:@""];
    }else {
        USShareModel * shareModel=[[USShareModel alloc] init];
        shareModel.listId=[NSString stringWithFormat:@"%@", _model.listId];
        shareModel.shareCommission=[USShareModel tranforCommitionStr:[NSString stringWithFormat:@"%@",_model.commission]];
        shareModel.sharePrice=_model.salePrice;
        shareModel.marketPrice=_model.marketPrice;
        shareModel.listName=_model.listName;
        shareModel.shareImageUrl=_model.imgUrl;
        shareModel.isNeedSaveQRImage=YES;
        shareModel.logPageName=_model.logPageName;
        shareModel.logShareFrom=_model.logShareFrom;
        shareModel.shareFrom=_model.shareFrom;//@"0";
        shareModel.shareChannel=_model.shareChannel;// @"1";
        shareModel.srcid=_model.srcid.length>0?_model.srcid:@"";
        //默认标题和内容
        shareModel.shareTitle=[US_UserUtility sharedLogin].m_stationName;
        shareModel.shareContent=shareModel.listName;
        [USShareView shareWithModel:shareModel success:^(id  _Nonnull response) {
            
        }];
        [UleMbLogOperate addMbLogClick:NonEmpty(self.model.listId) moduleid:NonEmpty(self.model.logPageName) moduledesc:@"分享" networkdetail:@""];
    }
}

- (void)longPressGesAction:(UIGestureRecognizer *)ges{
    if (ges.state!=UIGestureRecognizerStateBegan) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didLongPressedForModel:)]) {
        [self.delegate didLongPressedForModel:self.model];
    }
}
#pragma mark - <setter and getter>
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[UILabel new];
        _mTitleLabel.numberOfLines=0;
        _mTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _mTitleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        [_mTitleLabel sizeToFit];
//        _mTitleLabel.displaysAsynchronously = YES;
    }
    return _mTitleLabel;
}
- (YYLabel *)mSaleNumLabel{
    if (!_mSaleNumLabel) {
        _mSaleNumLabel=[YYLabel new];
        _mSaleNumLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _mSaleNumLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _mSaleNumLabel.displaysAsynchronously=YES;
    }
    return _mSaleNumLabel;
}
- (YYLabel *)mAddTimeLabel{
    if (!_mAddTimeLabel) {
        _mAddTimeLabel=[YYLabel new];
        _mAddTimeLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _mAddTimeLabel.textColor=[UIColor convertHexToRGB:@"999999"];
//        _mAddTimeLabel.displaysAsynchronously=YES;
    }
    return _mAddTimeLabel;
}
- (UILabel *)mListMarkLab{
    if (!_mListMarkLab) {
        _mListMarkLab=[UILabel new];
        _mListMarkLab.font=[UIFont systemFontOfSize:KScreenScale(26)];
        _mListMarkLab.textColor=[UIColor convertHexToRGB:@"333333"];
        [_mListMarkLab sizeToFit];
    }
    return _mListMarkLab;
}
- (YYLabel *)mPriceLabel{
    if (!_mPriceLabel) {
        _mPriceLabel=[YYLabel new];
        _mPriceLabel.font=[UIFont systemFontOfSize:KScreenScale(28)];
        _mPriceLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _mPriceLabel.displaysAsynchronously=YES;
    }
    return _mPriceLabel;
}
- (US_CommisionLabel *)mCommissionLabel{
    if (!_mCommissionLabel) {
        _mCommissionLabel=[US_CommisionLabel new];
        _mCommissionLabel.textColor=[UIColor whiteColor];
        _mCommissionLabel.backgroundColor= kNavBarBackColor;
        _mCommissionLabel.textAlignment=NSTextAlignmentCenter;
        _mCommissionLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
//        [_mCommissionLabel addCorner:KScreenScale(35)/2.0 toSize:CGSizeMake(KScreenScale(35), KScreenScale(35))];
    }
    return _mCommissionLabel;
}
- (YYLabel *)mProductIDLabel{
    if (!_mProductIDLabel) {
        _mProductIDLabel=[YYLabel new];
        _mProductIDLabel.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _mProductIDLabel.textColor=[UIColor convertHexToRGB:@"808080"];
        _mProductIDLabel.displaysAsynchronously=YES;
    }
    return _mProductIDLabel;
}
- (UIImageView *)mPdImageView{
    if (!_mPdImageView) {
        _mPdImageView=[[UIImageView alloc] init];;
    }
    return _mPdImageView;
}

- (UleControlView *)creatButtonTitle:(NSString *)title andImage:(UIImage *)image{
    UleControlView * btn=[UleControlView new];
    btn.mImageView.sd_layout.leftSpaceToView(btn, 0)
    .topSpaceToView(btn, 0)
    .rightSpaceToView(btn, 0).heightEqualToWidth();
    btn.mTitleLabel.sd_layout.leftSpaceToView(btn, 0)
    .rightSpaceToView(btn, 0)
    .topSpaceToView(btn.mImageView, 0)
    .bottomSpaceToView(btn, 0);
    btn.mTitleLabel.textAlignment=NSTextAlignmentCenter;
    btn.mTitleLabel.font=[UIFont systemFontOfSize:KScreenScale(22)];
    btn.mImageView.image=image;
    btn.mTitleLabel.text=title;
    return btn;
}

- (UleControlView *)mAddButton{
    if (!_mAddButton) {
        _mAddButton=[self creatButtonTitle:@"添加" andImage:[UIImage bundleImageNamed:@"myGoods_btn_add"]];
        [_mAddButton addTouchTarget:self action:@selector(addFavor:)];
    }
    return _mAddButton;
}
- (UleControlView *)mShareButton{
    if (!_mShareButton) {
        _mShareButton=[self creatButtonTitle:@"分享" andImage:[UIImage bundleImageNamed:@"myGoods_btn_share"]];
        _mShareButton.mTitleLabel.textColor= [UIColor convertHexToRGB:@"ef3b39"];
        [_mShareButton addTouchTarget:self action:@selector(shareClick:)];
    }
    return _mShareButton;
}
- (UIImageView *)mGroupbuyView{
    if (!_mGroupbuyView) {
        _mGroupbuyView=[UIImageView new];
        _mGroupbuyView.image=[UIImage bundleImageNamed:@"myGoods_img_groupbuy"];
    }
    return _mGroupbuyView;
}
- (UIImageView *)mSaleStatusView{
    if (!_mSaleStatusView) {
        _mSaleStatusView=[UIImageView new];
    }
    return _mSaleStatusView;
}
- (UIImageView *)mSalePromImg{
    if (!_mSalePromImg) {
        _mSalePromImg=[UIImageView new];
        _mSalePromImg.image=[UIImage bundleImageNamed:@"myGoods_img_saleprom"];
    }
    return _mSalePromImg;
}
- (UIButton *)mSelectButton{
    if (!_mSelectButton) {
        _mSelectButton=[UIButton new];
        [_mSelectButton setImage:[UIImage bundleImageNamed:@"myGoods_img_cellNoSelect"] forState:UIControlStateNormal];
        [_mSelectButton setImage:[UIImage bundleImageNamed:@"myGoods_img_cellSelected"] forState:UIControlStateSelected];
        _mSelectButton.userInteractionEnabled=NO;
    }
    return _mSelectButton;
}
- (UILabel *)mDidAddedFlage{
    if (!_mDidAddedFlage) {
        _mDidAddedFlage=[[UILabel alloc]initWithFrame:CGRectMake(__MainScreen_Width - 55, 0, 50, 20)];
        _mDidAddedFlage.backgroundColor = [UIColor clearColor];
        _mDidAddedFlage.text = @"已添加";
        _mDidAddedFlage.textColor = [UIColor whiteColor];
        _mDidAddedFlage.textAlignment = NSTextAlignmentCenter;
        _mDidAddedFlage.font = [UIFont systemFontOfSize:12];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_mDidAddedFlage.bounds byRoundingCorners:UIRectCornerTopLeft
                                  | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _mDidAddedFlage.bounds;
        maskLayer.path = maskPath.CGPath;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        maskLayer.opacity=0.7;
        [_mDidAddedFlage.layer addSublayer:maskLayer];
    }
    return _mDidAddedFlage;
}
- (UIView *)mAddedMaskView{
    if (!_mAddedMaskView) {
        _mAddedMaskView=[UIView new];
        _mAddedMaskView.backgroundColor=[UIColor whiteColor];
        _mAddedMaskView.alpha=0.7;
    }
    return _mAddedMaskView;
}
- (UIImageView *)selfGoodsTypeImg{
    if (!_selfGoodsTypeImg) {
        _selfGoodsTypeImg=[UIImageView new];
        [_selfGoodsTypeImg setHidden:YES];
    }
    return _selfGoodsTypeImg;
}
- (UILongPressGestureRecognizer *)longPressGes{
    if (!_longPressGes) {
        _longPressGes=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesAction:)];
    }
    return _longPressGes;
}
- (UleNetworkExcute *)client{
    if (!_client) {
        _client=[US_NetworkExcuteManager uleAPIRequestClient];
    }
    return _client;
}
@end
