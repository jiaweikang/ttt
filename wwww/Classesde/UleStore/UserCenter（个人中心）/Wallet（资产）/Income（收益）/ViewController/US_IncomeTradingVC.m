//
//  US_IncomeTradingVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/3/25.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_IncomeTradingVC.h"
#import "US_EmptyPlaceHoldView.h"
#import "UleBaseViewModel.h"
#import "US_UserCenterApi.h"
#import "IncomeTradeModel.h"
#import "IncomeTradingListCell.h"
#import "WBPopOverView.h"
@interface US_IncomeTradingVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) US_EmptyPlaceHoldView * mNoItemsBgView;
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, strong) UIView * headerView;
@property (nonatomic, strong) UILabel * incomeAmount;
@property (nonatomic, strong) UILabel * totalCountLab;
@property (nonatomic, copy) NSString * hintStrleft;
@property (nonatomic, copy) NSString * hintStrMiddle;
@property (nonatomic, copy) NSString * hintStrRight;
@end

@implementation US_IncomeTradingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"待结算金额"];
    }
    
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.alpha=0.0;
    [self.mTableView addSubview:self.mNoItemsBgView];
    //请求收支明细列表数据
    [self beginRefreshHeader];
}
#pragma mark - <上拉 下拉 刷新>
- (void)beginRefreshHeader{
    self.start=1;
    [self beginRequestIncomeTradingFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRefreshFooter{
    
    [self beginRequestIncomeTradingFromStartPage:[NSString stringWithFormat:@"%@",@(self.start)]];
}

- (void)beginRequestIncomeTradingFromStartPage:(NSString *)startPage{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetIncomeTradingRequestWithStartPage:startPage] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchIncomeTradingWithData:responseObject];
        
        
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
    }];
}

- (void)fetchIncomeTradingWithData:(NSDictionary *)dic{
    //首次加载要先清空数据
    if (self.start == 1) {
        [self.mViewModel.mDataArray removeAllObjects];
    }
    
    IncomeTradeModel * incomeData=[IncomeTradeModel yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    for (int i=0; i<incomeData.data.result.orderDetail.count; i++) {
        IncomeTradeDetail * detail=incomeData.data.result.orderDetail[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"IncomeTradingListCell"];
        cellModel.data=detail;
        
        [sectionModel.cellArray addObject:cellModel];
    }
    
    [self.mTableView.mj_header endRefreshing];
    if (sectionModel.cellArray.count == [incomeData.data.result.Total integerValue]) {
        [self.mTableView.mj_footer endRefreshingWithNoMoreData];
        self.mTableView.mj_footer.alpha=0.0;
    }else{
        self.mTableView.mj_footer.alpha=1.0;
        [self.mTableView.mj_footer endRefreshing];
    }
    self.mNoItemsBgView.hidden=sectionModel.cellArray.count>0?YES:NO;
    _totalCountLab.text = [NSString stringWithFormat:@"共%@条",incomeData.data.result.Total];
    self.start++;
    NSString *sumIncome = incomeData.data.result.unIssueCms;
    self.incomeAmount.text = [NSString stringWithFormat:@"￥%.2lf",sumIncome.doubleValue?sumIncome.doubleValue:0.00];
    [self setAttributedIncomeNum:self.incomeAmount];
    [self.mTableView setTableHeaderView:self.headerView];
    [self.mTableView reloadData];
    self.hintStrleft = [NSString isNullToString:incomeData.data.incomeTransactionswenanHint];
    self.hintStrMiddle = [NSString isNullToString:incomeData.data.virutalTransactionswenanHint];
    self.hintStrRight = [NSString isNullToString:incomeData.data.multipleComissionHint];
}
-(void)setAttributedIncomeNum:(UILabel *)label{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attributedStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
    label.attributedText = attributedStr;
}

- (void)hintdesRightClick:(UIGestureRecognizer *)tap{
    NSString * str=@"";
    NSString * textColor=@"";
    WBArrowDirection direction=WBArrowDirectionUp2;
    UILabel * tapView=(UILabel *)tap.view;
    CGPoint point=CGPointMake(0, tapView.frame.size.height);//箭头点的位置
    CGPoint a = [tapView convertPoint:point toView:[UIApplication sharedApplication].keyWindow];
    if (tapView.tag==10000) {
        str=self.hintStrleft;
        direction=WBArrowDirectionUp1;
        textColor=@"2995E6";
        a.x=40;
    }else if (tapView.tag==10001) {
        str=self.hintStrMiddle;
        direction=WBArrowDirectionUp2;
        textColor=@"EF3A38";
        a.x=__MainScreen_Width*0.5;
    }else if (tapView.tag==10002) {
        str=self.hintStrRight;
        direction=WBArrowDirectionUp3;
        textColor=@"2995E6";
        a.x=__MainScreen_Width-40;
    }
    if (str.length<=0) return;
    tapView.textColor=[UIColor convertHexToRGB:textColor];
    //总宽
    CGFloat width = __MainScreen_Width-40;
    //总高
    CGFloat height = 100;
    
    CGFloat hintH = 0.;
    CGFloat hintW = width-10;
    if ([str rangeOfString:@"##"].location!=NSNotFound) {
        str = [NSString stringWithFormat:@"%@",NonEmpty([str stringByReplacingOccurrencesOfString:@"##" withString:@"\n"])];
        hintH = [str heightForFont:[UIFont systemFontOfSize:KScreenScale(26)] width:hintW];
        height = hintH+10;
    } else {
        str = [NSString stringWithFormat:@"%@",NonEmpty(str)];
        hintH = [str heightForFont:[UIFont systemFontOfSize:KScreenScale(26)] width:hintW];
        height = hintH+10;
    }
    
    WBPopOverView *view = [[WBPopOverView alloc]initWithOrigin:a Width:width Height:height Direction:direction];
    view.backView.layer.cornerRadius = 5.0;
    view.backView.backgroundColor = [UIColor convertHexToRGB:@"fff1db"];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, hintW, hintH)];
    lable.textColor = [UIColor convertHexToRGB:textColor];
    lable.textAlignment = NSTextAlignmentLeft;
    lable.font = [UIFont systemFontOfSize:KScreenScale(26)];
    lable.text = str;
    lable.numberOfLines = 0;
    
    view.dissmissBlock = ^{
        tapView.textColor=[UIColor convertHexToRGB:kLightTextColor];
    };
    [view.backView addSubview:lable];
    [view popViewAtSuperView:nil];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        _mTableView.tableHeaderView = self.headerView;
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
        _mNoItemsBgView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_bgNew"];
        _mNoItemsBgView.titleLabel.text=@"暂无待结算金额明细";
        _mNoItemsBgView.frame=CGRectMake(0, 120, __MainScreen_Width, __MainScreen_Height-self.uleCustemNavigationBar.height_sd-120);
    }
    return _mNoItemsBgView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 0)];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel * incomeDesc=[[UILabel alloc]init];
        incomeDesc.text=@"待结算金额";
        incomeDesc.font=[UIFont systemFontOfSize:16];
       UIImageView * incomeImg=[[UIImageView alloc]init];
        incomeImg.image=[UIImage bundleImageNamed:@"income_img_trading"];
        UILabel *hintDescLabLeft=[self getHintDescLabel];
        hintDescLabLeft.textColor=[UIColor convertHexToRGB:kLightTextColor];
        hintDescLabLeft.text=@"赚取金额发放规则";
        hintDescLabLeft.tag=10000;
        
        UILabel *hintDescLabMiddle=[self getHintDescLabel];
        hintDescLabMiddle.textColor=[UIColor convertHexToRGB:kLightTextColor];
        hintDescLabMiddle.text=@"虚拟商品发放规则";
        hintDescLabMiddle.tag=10001;
        
        UILabel *hintDescLabRight=[self getHintDescLabel];
        hintDescLabRight.textColor=[UIColor convertHexToRGB:kLightTextColor];
        hintDescLabRight.text=@"多阶佣金发放规则";
        hintDescLabRight.tag=10002;
        
        _incomeAmount=[UILabel new];
        _incomeAmount.text=@"￥0.00";
        _incomeAmount.textColor = [UIColor convertHexToRGB:@"ef3b39"];
        _incomeAmount.font=[UIFont systemFontOfSize:35];
        _incomeAmount.textAlignment=NSTextAlignmentCenter;

        UIView *lineView1 = [UIView new];
        lineView1.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
        UIView *lineView2 = [UIView new];
        lineView2.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
        UIView * bottomView=[self loadHeadBottomView];
        [_headerView sd_addSubviews:@[incomeDesc,incomeImg,_incomeAmount,hintDescLabLeft,hintDescLabMiddle,hintDescLabRight,bottomView,lineView1,lineView2]];
        incomeDesc.sd_layout
        .topSpaceToView(_headerView, 10)
        .leftSpaceToView(_headerView, __MainScreen_Width/2-15.25)
        .rightSpaceToView(_headerView, 10)
        .heightIs(20);
        incomeImg.sd_layout
        .centerYEqualToView(incomeDesc)
        .rightSpaceToView(incomeDesc, 3)
        .widthIs(30).heightIs(30);
        _incomeAmount.sd_layout
        .topSpaceToView(incomeDesc, 5)
        .leftSpaceToView(_headerView, 10)
        .rightSpaceToView(_headerView, 10)
        .heightIs(35);
        CGFloat hintLabWidth=(__MainScreen_Width-KScreenScale(5)*6-2)/3.0;
        hintDescLabLeft.sd_layout
        .topSpaceToView(_incomeAmount, 15)
        .leftSpaceToView(_headerView, KScreenScale(5))
        .widthIs(hintLabWidth)
        .heightIs(32);
        
        lineView1.sd_layout.centerYEqualToView(hintDescLabLeft)
        .leftSpaceToView(hintDescLabLeft, KScreenScale(5))
        .heightIs(20).widthIs(1);
        
        hintDescLabMiddle.sd_layout.leftSpaceToView(lineView1, KScreenScale(5))
        .topEqualToView(hintDescLabLeft)
        .widthIs(hintLabWidth)
        .heightIs(32);
        
        lineView2.sd_layout.centerYEqualToView(hintDescLabLeft)
        .leftSpaceToView(hintDescLabMiddle, KScreenScale(5))
        .heightIs(20).widthIs(1);
        
        hintDescLabRight.sd_layout.leftSpaceToView(lineView2, KScreenScale(5))
        .topEqualToView(hintDescLabLeft)
        .widthIs(hintLabWidth)
        .heightIs(32);
        
        bottomView.sd_layout.leftSpaceToView(_headerView, 0)
        .rightSpaceToView(_headerView, 0)
        .topSpaceToView(hintDescLabLeft, 15)
        .heightIs(40);
        [_headerView setupAutoHeightWithBottomView:bottomView bottomMargin:0];
    }
    return _headerView;
}

- (UILabel *)getHintDescLabel{
    UILabel *hintDescLab=[[UILabel alloc]init];
    hintDescLab.adjustsFontSizeToFitWidth=YES;
    hintDescLab.font=[UIFont systemFontOfSize:KScreenScale(30)>15?15:KScreenScale(30)];
    hintDescLab.textAlignment=NSTextAlignmentCenter;
    hintDescLab.userInteractionEnabled=YES;
    [hintDescLab addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hintdesRightClick:)]];
    return hintDescLab;
}

- (UIView *)loadHeadBottomView{
    UIView * bottomView=[UIView new];
    bottomView.backgroundColor=[UIColor convertHexToRGB:@"f2f2f2"];
    UILabel *leftLab = [[UILabel alloc]init];
    leftLab.textColor = [UIColor convertHexToRGB:@"333333"];
    leftLab.font = [UIFont systemFontOfSize:15];
    leftLab.text = @"待结算金额明细";
    
    _totalCountLab = [UILabel new];
    _totalCountLab.textColor = [UIColor convertHexToRGB:@"333333"];
    _totalCountLab.font = [UIFont systemFontOfSize:15];
    _totalCountLab.textAlignment = NSTextAlignmentRight;
    _totalCountLab.text = @"共0条";
    
    UIView *lineView = [UIView new];
    lineView.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    
    [bottomView sd_addSubviews:@[leftLab,_totalCountLab,lineView]];
    
    leftLab.sd_layout
    .topSpaceToView(bottomView, 10)
    .leftSpaceToView(bottomView, 10)
    .widthIs(__MainScreen_Width/2-10)
    .heightIs(20);
    _totalCountLab.sd_layout
    .topEqualToView(leftLab)
    .rightSpaceToView(bottomView, 10)
    .widthRatioToView(leftLab, 1)
    .heightIs(20);
    lineView.sd_layout
    .leftSpaceToView(bottomView, 0)
    .rightSpaceToView(bottomView, 0)
    .topSpaceToView(leftLab, 10)
    .heightIs(1);
    
    return bottomView;
}

@end
