//
//  US_WithdrawRecordVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/27.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_WithdrawRecordVC.h"
#import "US_EmptyPlaceHoldView.h"
#import "UleBaseViewModel.h"
#import "US_UserCenterApi.h"
#import "WithdrawRecordModel.h"
#import "WithdrawRecordListCell.h"
#import "UIView+Shade.h"
#import "UIImage+USAddition.h"

@interface US_WithdrawRecordVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) UIImageView * headerView;
@property (nonatomic, strong) UILabel * checkingAmountLab;
@property (nonatomic, strong) UILabel * successAmountLab;
@property (nonatomic, strong) UILabel * hintDescLab;
@property (nonatomic, strong) UIImage * topBgImage;
@end

@implementation US_WithdrawRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"提现记录"];
    }
    [self getTopBgImage];
    
    [self.view sd_addSubviews:@[self.headerView,self.mTableView,self.mNoItemsBgView]];

    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.headerView, 0);
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    self.mNoItemsBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mNoItemsBgView.sd_layout.topSpaceToView(self.headerView, KScreenScale(20));
    //请求收支明细列表数据
    [self beginRefreshHeader];
}

//生成顶部背景图片
- (void)getTopBgImage
{
    UIView *topBgImageView = [[UIView alloc] initWithFrame:CGRectMake(0, self.uleCustemNavigationBar.height, __MainScreen_Width, KScreenScale(260))];
    [topBgImageView.layer addSublayer:[UIView setGradualChangingColor:topBgImageView fromColor:[UIColor convertHexToRGB:@"EF3B39"] toColor:[UIColor convertHexToRGB:@"FE5F45"] gradualType:GradualTypeVertical]];
    _topBgImage = [self convertViewToImage:topBgImageView];
}

#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    self.start=1;
    [self beginRequestWithdrawRecordFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}
- (void)beginRefreshFooter{
    self.start++;
    [self beginRequestWithdrawRecordFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRequestWithdrawRecordFromStartPage:(NSString *)startPage{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetWithdrawRecordRequestWithStartPage:startPage accTypeId:self.m_Params[@"accTypeId"]] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchIncomeTradingWithData:responseObject];

    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_footer endRefreshing];
    }];
}

- (void)fetchIncomeTradingWithData:(NSDictionary *)dic{
    //首次加载要先清空数据
    if (self.start == 1) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    
    WithdrawRecordModel * recordData=[WithdrawRecordModel yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<recordData.data.list.count; i++) {
        WithdrawRecordList * detail=recordData.data.list[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"WithdrawRecordListCell"];
        cellModel.data=detail;
        
        [sectionModel.cellArray addObject:cellModel];
    }
    
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count == [recordData.data.totalCount integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
        self.mTableView.mj_footer.alpha=0.0;
    }else{
        self.mTableView.mj_footer.alpha=1.0;
        [self.mTableView.mj_footer endRefreshing];
    }
    self.mNoItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
    _checkingAmountLab.text = [NSString stringWithFormat:@"￥%.2lf",recordData.data.auditingAmount.length>0?[recordData.data.auditingAmount floatValue]:0.00];
    _successAmountLab.text = [NSString stringWithFormat:@"￥%.2lf",recordData.data.approvalAmount.length>0?[recordData.data.approvalAmount floatValue]:0.00];
    [self setAttributedCommissionNum:_checkingAmountLab];
    [self setAttributedCommissionNum:_successAmountLab];
    if (recordData.data.presentRecordHint.length > 0) {
        _hintDescLab.text = [NSString stringWithFormat:@"* %@",[[NSString isNullToString:recordData.data.presentRecordHint] stringByReplacingOccurrencesOfString:@"##" withString:@"\n"]];
        [self layoutTopView];
    }
    
    [self.mTableView reloadData];
}

- (void)layoutTopView
{
    CGFloat hintLblHeight = [_hintDescLab.text heightForFont:_hintDescLab.font width:__MainScreen_Width - 20];
    _headerView.frame = CGRectMake(0, self.uleCustemNavigationBar.height, __MainScreen_Width, KScreenScale(220) + hintLblHeight);
//    [_headerView.layer layoutSublayers];
//    [_headerView.layer addSublayer:[UIView setGradualChangingColor:_headerView fromColor:[UIColor convertHexToRGB:@"EF3B39"] toColor:[UIColor convertHexToRGB:@"FE5F45"] gradualType:GradualTypeVertical]];
//    [_headerView layoutIfNeeded];
//    [_headerView layoutSubviews];
}

#pragma mark - <setter and getter>
- (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}

- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}

- (US_EmptyPlaceHoldView *)mNoItemsBgView{
    if (!_mNoItemsBgView) {
        _mNoItemsBgView=[[US_EmptyPlaceHoldView alloc] init];
        _mNoItemsBgView.hidden=YES;
        _mNoItemsBgView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noWithdraw"];
        _mNoItemsBgView.titleLabel.text=@"暂无提现记录";
//        _mNoItemsBgView.describe=@"请点击重试";
        @weakify(self);
        _mNoItemsBgView.clickEvent = ^{
            @strongify(self);
            [self beginRefreshHeader];
        };
    }
    return _mNoItemsBgView;
}

-(void)setAttributedCommissionNum:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:KScreenScale(28)] range:NSMakeRange(0, 1)];
    label.attributedText = attributedStr;
}

- (UIImageView *)headerView{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.uleCustemNavigationBar.height, __MainScreen_Width, KScreenScale(240))];
//        [_headerView.layer addSublayer:[UIView setGradualChangingColor:_headerView fromColor:[UIColor convertHexToRGB:@"EF3B39"] toColor:[UIColor convertHexToRGB:@"FE5F45"] gradualType:GradualTypeVertical]];
        _headerView.image = _topBgImage;
        
        UILabel *leftLab = [[UILabel alloc]init];
        leftLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        leftLab.font = [UIFont systemFontOfSize:KScreenScale(28)];
        leftLab.text = @"待结算金额";
        _checkingAmountLab = [UILabel new];
        _checkingAmountLab.textColor = [UIColor whiteColor];
        _checkingAmountLab.font = [UIFont systemFontOfSize:KScreenScale(64)];
        _checkingAmountLab.textAlignment = NSTextAlignmentCenter;
        _checkingAmountLab.text = @"￥0.00";
       
        UILabel *rightLab = [[UILabel alloc]init];
        rightLab.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        rightLab.font = [UIFont systemFontOfSize:KScreenScale(28)];
        rightLab.text = @"提现成功（总）";
        _successAmountLab=[UILabel new];
        _successAmountLab.text=@"￥0.00";
        _successAmountLab.textColor = [UIColor whiteColor];
        _successAmountLab.font=[UIFont systemFontOfSize:KScreenScale(64)];
        _successAmountLab.textAlignment=NSTextAlignmentCenter;
        
        _hintDescLab=[[UILabel alloc]init];
        _hintDescLab.textColor=[UIColor whiteColor];
        _hintDescLab.font=[UIFont systemFontOfSize:KScreenScale(24)];
        _hintDescLab.numberOfLines=0;
        [_headerView addSubview:_hintDescLab];
        [self setAttributedCommissionNum:_checkingAmountLab];
        [self setAttributedCommissionNum:_successAmountLab];
        [_headerView sd_addSubviews:@[_successAmountLab,_hintDescLab,leftLab,rightLab,_checkingAmountLab]];
        leftLab.sd_layout
        .topSpaceToView(_headerView, KScreenScale(30))
        .leftSpaceToView(_headerView, KScreenScale(117))
        .widthIs(KScreenScale(160))
        .heightIs(KScreenScale(30));
        _checkingAmountLab.sd_layout
        .topSpaceToView(leftLab, KScreenScale(32))
        .leftEqualToView(_headerView)
        .widthIs(__MainScreen_Width / 2)
        .heightIs(KScreenScale(50));
        rightLab.sd_layout
        .topSpaceToView(_headerView, KScreenScale(30))
        .rightSpaceToView(_headerView, KScreenScale(83))
        .widthIs(KScreenScale(210))
        .heightIs(KScreenScale(30));
        _successAmountLab.sd_layout
        .topSpaceToView(rightLab, KScreenScale(32))
        .rightSpaceToView(_headerView, KScreenScale(18))
        .widthIs(__MainScreen_Width / 2)
        .heightIs(KScreenScale(50));
        _hintDescLab.sd_layout
        .topSpaceToView(_checkingAmountLab, KScreenScale(50))
        .leftSpaceToView(_headerView, 10)
        .rightSpaceToView(_headerView, 10)
        .autoHeightRatio(0);
    }
    return _headerView;
}

@end
