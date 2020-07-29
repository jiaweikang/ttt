//
//  MyStoreGroupFiveCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyStoreGroupFiveCell.h"
#import <UIView+SDAutoLayout.h>
#import "US_MystoreCellModel.h"
#import "US_HomeBtnData.h"
#import "UleModulesDataToAction.h"

@interface MyStoreGroupFiveView : UIView
@property (nonatomic, strong) YYAnimatedImageView   *mBgImgView;
@property (nonatomic, strong) UILabel   *mValueLabel;
@property (nonatomic, strong) UILabel   *mTitleLabel;
@property (nonatomic, copy) NSString    *myValue;
@property (nonatomic, copy)NSString   *functionId;
@end

@implementation MyStoreGroupFiveView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self sd_addSubviews:@[self.mBgImgView,self.mValueLabel,self.mTitleLabel]];
    self.mBgImgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mValueLabel.sd_layout.topSpaceToView(self, KScreenScale(20))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30));
    self.mTitleLabel.sd_layout.topSpaceToView(self.mValueLabel, KScreenScale(20))
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(KScreenScale(30));
}

- (void)setMyValue:(NSString *)myValue{
    _myValue=myValue;
    self.mValueLabel.text=myValue;
}

#pragma mark - <getters>
- (YYAnimatedImageView *)mBgImgView{
    if (!_mBgImgView) {
        _mBgImgView=[[YYAnimatedImageView alloc]init];
        _mBgImgView.contentMode=UIViewContentModeScaleAspectFit;
    }
    return _mBgImgView;
}
-(UILabel *)mValueLabel{
    if (!_mValueLabel) {
        _mValueLabel=[[UILabel alloc]init];
        _mValueLabel.text=@"0";
        _mValueLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _mValueLabel.textAlignment=NSTextAlignmentCenter;
        _mValueLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(32)];
    }
    return _mValueLabel;
}
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[[UILabel alloc]init];
        _mTitleLabel.textColor=[UIColor convertHexToRGB:@"999999"];
        _mTitleLabel.textAlignment=NSTextAlignmentCenter;
        _mTitleLabel.font=[UIFont boldSystemFontOfSize:KScreenScale(25)];
    }
    return _mTitleLabel;
}
@end


@interface MyStoreGroupFiveCell ()
@property (nonatomic, strong)UIView     *mBgView;
@property (nonatomic, strong)MyStoreGroupFiveView   *mFirstView;
@property (nonatomic, strong)UIImageView     *mShadowView;
@property (nonatomic, strong)US_MystoreCellModel    *mModel;
@property (nonatomic, strong)NSMutableArray *btnsArray;
@end

@implementation MyStoreGroupFiveCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor=[UIColor clearColor];
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.mBgView]];
    [self.mBgView sd_addSubviews:@[self.mFirstView,self.mShadowView]];
    self.mBgView.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(20))
    .heightIs(KScreenScale(140));
    self.mFirstView.sd_layout.topSpaceToView(self.mBgView, KScreenScale(20))
    .leftSpaceToView(self.mBgView, KScreenScale(20))
    .widthIs(KScreenScale(134))
    .heightIs(KScreenScale(100));
    self.mShadowView.sd_layout.topSpaceToView(self.mBgView, KScreenScale(20))
    .leftSpaceToView(self.mFirstView, KScreenScale(14))
    .widthIs(KScreenScale(20))
    .heightRatioToView(self.mFirstView, 1.0);
    
    [self setupAutoHeightWithBottomView:self.mBgView bottomMargin:KScreenScale(20)];
}

- (void)setModel:(US_MystoreCellModel*)mModel{
//    if (self.mModel&&!mModel.isNewData) return;
    self.mModel=mModel;
    for (UIView *subView in self.mBgView.subviews) {
        if (![subView isEqual:self.mFirstView]&&![subView isEqual:self.mShadowView]) {
            [subView removeFromSuperview];
        }
    }
    HomeBtnItem *firstItem=[mModel.indexInfo firstObject];
    if ([NSString isNullToString:firstItem.imgUrl].length>0) {
        [self.mFirstView setMyValue:@""];
        [self.mFirstView.mBgImgView yy_setImageWithURL:[NSURL URLWithString:[NSString isNullToString:firstItem.imgUrl]] placeholder:nil];
    }
    if (mModel.indexInfo.count>1) {
        [self.btnsArray removeAllObjects];
        CGFloat viewWidth=(CGFloat)(KScreenScale(710)-KScreenScale(188))/(mModel.indexInfo.count-1);
        for (int i=1; i<mModel.indexInfo.count; i++) {
            HomeBtnItem *viewDataItem=mModel.indexInfo[i];
            MyStoreGroupFiveView *fiveView=[[MyStoreGroupFiveView alloc]init];
            fiveView.tag=i+20000;
            fiveView.functionId=[NSString isNullToString:viewDataItem.functionId];
            UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
            [fiveView addGestureRecognizer:tapGes];
            [self.mBgView addSubview:fiveView];
            fiveView.sd_layout.topSpaceToView(self.mBgView, KScreenScale(20))
            .leftSpaceToView(self.mBgView, KScreenScale(188)+(i-1)*viewWidth)
            .widthIs(viewWidth)
            .heightIs(KScreenScale(100));
            fiveView.mTitleLabel.text=[NSString isNullToString:viewDataItem.title];
            [self.btnsArray addObject:fiveView];
            [self setCurrentOrderNumWithView:fiveView];
        }
    }
//    [self setCurrentOrderNumWithView:nil];
//    mModel.isNewData=NO;
}

- (void)setCurrentOrderNumWithView:(MyStoreGroupFiveView*)orderView{
    NSDictionary *orderDic=self.mModel.extentInfo;
    if (orderDic&&orderDic.allKeys.count>0) {
        for (NSString *key in orderDic.allKeys) {
            if ([key isEqualToString:orderView.functionId]) {
                NSString *orderValue=[NSString isNullToString:[orderDic[key] stringValue]];
                orderValue=orderValue.length>0?orderValue:@"0";
                [orderView setMyValue:orderValue];
            }
        }
    }
}

- (void)clickAction:(UIGestureRecognizer *)ges{
    NSInteger viewTag=ges.view.tag-20000;
    if (self.mModel.indexInfo&&self.mModel.indexInfo.count>viewTag) {
        HomeBtnItem *item=self.mModel.indexInfo[viewTag];
        UleUCiOSAction * action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
        if ([NSString isNullToString:item.log_title].length>0) {
            [LogStatisticsManager onClickLog:Store_Function andTev:[NSString isNullToString:item.log_title]];
        }
        [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
    }
}

#pragma mark - <getters>
- (UIView *)mBgView{
    if (!_mBgView) {
        _mBgView=[[UIView alloc]init];
        _mBgView.backgroundColor=[UIColor whiteColor];
        _mBgView.sd_cornerRadius=@(5);
    }
    return _mBgView;
}
- (MyStoreGroupFiveView *)mFirstView{
    if (!_mFirstView) {
        _mFirstView=[[MyStoreGroupFiveView alloc]init];
        _mFirstView.tag=20000;
        UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickAction:)];
        [_mFirstView addGestureRecognizer:tapGes];
    }
    return _mFirstView;
}
- (UIImageView *)mShadowView{
    if (!_mShadowView) {
        _mShadowView=[[UIImageView alloc]initWithImage:[UIImage bundleImageNamed:@"mystore_img_shareOrder_shadow"]];
    }
    return _mShadowView;
}
- (NSMutableArray *)btnsArray{
    if (!_btnsArray) {
        _btnsArray=[NSMutableArray array];
    }
    return _btnsArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
