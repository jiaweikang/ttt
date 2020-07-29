//
//  US_InsuranceCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_InsuranceCell.h"
#import <UIView+SDAutoLayout.h>
#import "FeatureModel_Insurance.h"
#import "UleMbLogOperate.h"
#import "InsuranceAlertView.h"
#import "UleModulesDataToAction.h"
#import "USShareView.h"

@interface US_InsuranceCell ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *iconImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *commissionLabel;
@property (nonatomic, strong) UILabel *descriptLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton * tipBtn;
@property (nonatomic, strong) UIButton * shareBtn;
@property (nonatomic, strong) UIButton * checkBtn;
@end

@implementation US_InsuranceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self loadUI];
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

- (void)loadUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    self.backgroundColor=[UIColor clearColor];
    self.contentView.backgroundColor=[UIColor clearColor];
    [self.contentView sd_addSubviews:@[self.bgView]];
    UIView * line=[UIView new];
    line.backgroundColor=[UIColor convertHexToRGB:@"e5e5e5"];
    [self.bgView sd_addSubviews:@[self.iconImgView,self.titleLabel,self.commissionLabel,self.descriptLabel,self.priceLabel,self.tipBtn,self.shareBtn,self.checkBtn,line]];
    self.bgView.sd_layout.leftSpaceToView(self.contentView, 5)
    .topSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 5)
    .autoHeightRatio(0);
    
    self.iconImgView.sd_layout.leftSpaceToView(self.bgView, 0)
    .topSpaceToView(self.bgView, 0)
    .heightIs(KScreenScale(180))
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
    
    
    line.sd_layout.leftSpaceToView(self.iconImgView, 5)
    .topSpaceToView(self.iconImgView, 0)
    .rightSpaceToView(self.bgView, 10)
    .heightIs(0.5);
    
    self.priceLabel.sd_layout.leftEqualToView(self.titleLabel)
    .bottomSpaceToView(line, KScreenScale(15))
    .heightIs(KScreenScale(30))
    .rightSpaceToView(self.bgView, 5);
    
    self.shareBtn.sd_layout.rightSpaceToView(self.bgView, 10)
    .topSpaceToView(self.iconImgView, 10)
    .widthIs(75).heightIs(28);
    
    self.checkBtn.sd_layout.rightSpaceToView(self.shareBtn, 10)
    .bottomEqualToView(self.shareBtn)
    .widthRatioToView(self.shareBtn, 1)
    .heightRatioToView(self.shareBtn, 1);
    
    [self.bgView setupAutoHeightWithBottomView:self.shareBtn bottomMargin:10];
    
    [self setupAutoHeightWithBottomView:self.bgView bottomMargin:10];
}

- (void)setModel:(US_InsuranceCellModel *)model{
    _model=model;
    InsuranceIndexInfo * item=(InsuranceIndexInfo *)model.data;
    if (item) {
        self.titleLabel.text = item.title;
        self.descriptLabel.text = item.insurance_content;
        self.priceLabel.text =  [item.insurance_price stringByAppendingString:item.insurance_unit];
        self.commissionLabel.text = item.insurance_income;
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:self.priceLabel.text];
        [text addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:@"333333"] range:NSMakeRange(text.length-item.insurance_unit.length, item.insurance_unit.length)];
        [text addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(20)] range:NSMakeRange(text.length-item.insurance_unit.length, item.insurance_unit.length)];
        self.priceLabel.attributedText = text;;
        
        [self.iconImgView yy_setImageWithURL:[NSURL URLWithString:item.imgUrl] placeholder:[UIImage bundleImageNamed:@"bg_def_80x80_s"]];
        [self.commissionLabel setSingleLineAutoResizeWithMaxWidth:200];
    }
}

- (void)tipBtnClicked{
    InsuranceIndexInfo * item=self.model.data;
    if (item&&item.insurance_commission.length>0) {
        [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.insurance_commission] moduleid:self.model.logPageName moduledesc:@"佣金说明" networkdetail:@""];
        InsuranceAlertView *alertView = [InsuranceAlertView insuranceAlertViewWithUrl:item.insurance_commission wh_rate:item.wh_rate confirmBlock:^{
            
        }];
        [alertView showViewWithAnimation:AniamtionAlert];
    }
}

- (void)shareBtnAction{
    InsuranceIndexInfo * item=self.model.data;
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.insurance_type] moduleid:self.model.logPageName moduledesc:@"分享" networkdetail:@""];
    USShareModel * shareModel=[[USShareModel alloc] init];
    shareModel.listId=[NSString stringWithFormat:@"%@", item.insurance_type];
    shareModel.shareCommission=[NSString stringWithFormat:@"%@",item.insurance_income];
    shareModel.sharePrice=[NSString stringWithFormat:@"%@",[item.insurance_price stringByAppendingString:item.insurance_unit]];
    shareModel.marketPrice=[NSString stringWithFormat:@"%@",@""];
    shareModel.listName=[NSString stringWithFormat:@"%@", item.title];
    shareModel.shareImageUrl=[NSString stringWithFormat:@"%@", item.imgUrl];
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

- (void)detailButtonClicked{
    InsuranceIndexInfo * item=self.model.data;
    [UleMbLogOperate addMbLogClick:[NSString stringWithFormat:@"%@", item.insurance_type]  moduleid:self.model.logPageName moduledesc:@"查看详情" networkdetail:@""];
    UleUCiOSAction *action=[UleModulesDataToAction resolveModulesActionStr:item.ios_action];
    NSString * linkurl=action.mParams[@"key"];
    NSString * urle=@"";
    if ([linkurl containsString:@"?"]) {
        urle=[NSString stringWithFormat:@"%@&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
    }else{
        urle=[NSString stringWithFormat:@"%@?&storeid=%@",linkurl,[US_UserUtility sharedLogin].m_userId];
    }
    [action.mParams setObject:urle forKey:@"key"];
        [[UIViewController currentViewController] pushNewViewController:action.mViewControllerName isNibPage:action.mIsXib withData:action.mParams];
}

#pragma mark - <setter and getter>
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [UIColor convertHexToRGB:@"ffffff"];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds=YES;
        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIImageView *)iconImgView {
    if (!_iconImgView) {
        _iconImgView = [[UIImageView alloc] init];
    }
    return _iconImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"百万医疗险百万医疗险百万医疗险百万医疗险百万医疗险百万医疗险";
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
        [_shareBtn addTarget:self action:@selector(shareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _shareBtn.layer.cornerRadius = 5;
        [_shareBtn setBackgroundColor:[UIColor convertHexToRGB:@"ef3b39"]];
        [_shareBtn setTitle:@"分享产品" forState:(UIControlStateNormal)];
        [_shareBtn setTitleColor:[UIColor convertHexToRGB:@"ffffff"] forState:(UIControlStateNormal)];

    }
    return _shareBtn;
}

- (UIButton *)checkBtn{
    if (!_checkBtn) {
        _checkBtn=[[UIButton alloc] init];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _checkBtn.layer.cornerRadius =5;
        _checkBtn.tintColor=[UIColor convertHexToRGB:@"999999"];
        _checkBtn.layer.borderWidth = 0.5;
        [_checkBtn setBackgroundColor:[UIColor convertHexToRGB:@"ffffff"]];
        [_checkBtn setTitle:@"查看产品" forState:(UIControlStateNormal)];
        [_checkBtn setTitleColor:[UIColor convertHexToRGB:@"999999"] forState:(UIControlStateNormal)];
        [_checkBtn addTarget:self action:@selector(detailButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

@end
