//
//  US_EnterpeiseWholeSaleVC.m
//  UleStoreApp
//
//  Created by lei xu on 2020/3/24.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_EnterpeiseWholeSaleVC.h"
#import "EnterpriseViewModel.h"
#import "US_EnterprisePlaceholderView.h"
#import "US_EnterpriseApi.h"
#import "US_EnterpriseWholeSaleModel.h"

@interface US_EnterpeiseWholeSaleVC ()
{
    NSInteger   currentPage;
}
@property (nonatomic, strong) UITableView       *mTableView;
@property (nonatomic, strong) EnterpriseViewModel   *mViewModel;
@property (nonatomic, strong)US_EnterprisePlaceholderView   *mPlaceHolderVeiw;

@end

@implementation US_EnterpeiseWholeSaleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeRight;
    currentPage=1;
    [self setUI];
    [self startRequestData];
}

- (void)setUI{
    if ([NSString isNullToString:[self.m_Params objectForKey:@"title"]].length>0) {
        [self.uleCustemNavigationBar customTitleLabel:[self.m_Params objectForKey:@"title"]];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"分销商品"];
    }
    [self.view sd_addSubviews:@[self.mTableView, self.mPlaceHolderVeiw]];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mTableView.mj_header = self.mRefreshHeader;
    self.mPlaceHolderVeiw.sd_layout.centerYEqualToView(self.view)
    .leftEqualToView(self.view)
    .rightEqualToView(self.view)
    .heightIs(kImageHeight+kLabelHeight+kButtonHeight+60);
//    @weakify(self);
//    self.mViewModel.recommendCellClickBlock = ^(NSString *listId, NSString *zoneId) {
//        @strongify(self);
//        [LogStatisticsManager shareInstance].srcid=Srcid_Enterprise_fxPrd;
//        NSString *urlStr=[NSString stringWithFormat:@"http://wholesale-static.beta.ule.com/yxd/vi/%@?storeid=%@&zoneId=%@", listId, [US_UserUtility sharedLogin].m_userId, zoneId];
//        NSMutableDictionary *params=@{@"key":urlStr,
//                                      KNeedShowNav:@"1",
//                                      @"title":@"预览"
//                                      }.mutableCopy;
//        [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:params];
//    };
}


- (void)beginRefreshHeader{
    currentPage=1;
    [self startRequestData];
}
- (void)beginRefreshFooter{
    [self startRequestData];
}
- (void)startRequestData{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    if ([US_UserUtility sharedLogin].pixiaoZoneId) {
        [self startRequestWholeSaleWithZoneIdList:[US_UserUtility sharedLogin].pixiaoZoneId];
    }else {
        [self startRequestWholeSaleZoneid];
    }
}

- (void)startRequestWholeSaleZoneid{
    @weakify(self);
    [self.networkClient_UstaticCDN beginRequest:[US_EnterpriseApi buildWholeSaleZoneId] success:^(id responseObject) {
        @strongify(self);
        NSMutableArray *zoneIdStrList=[NSMutableArray array];
        id zoneIdList=responseObject[@"data"];
        if ([zoneIdList isKindOfClass:[NSArray class]]) {
            NSArray *zoneIdArr=[NSArray arrayWithArray:zoneIdList];
            for (int i=0; i<zoneIdArr.count; i++) {
                NSString *zoneId=[NSString stringWithFormat:@"%@", zoneIdArr[i]];
                [zoneIdStrList addObject:zoneId];
            }
        }
        [US_UserUtility savePixiaoZoneId:zoneIdStrList];
        [self startRequestWholeSaleWithZoneIdList:zoneIdStrList];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)startRequestWholeSaleWithZoneIdList:(NSArray *)zoneIdList{
    if (zoneIdList.count>0) {
        @weakify(self);
        [self.networkClient_API beginRequest:[US_EnterpriseApi buildWholeSaleItemListByPageStart:@(currentPage)] success:^(id responseObject) {
            @strongify(self);
            [UleMBProgressHUD hideHUDForView:self.view];
            US_EnterpriseWholeSaleModel *responseModel=[US_EnterpriseWholeSaleModel yy_modelWithDictionary:responseObject];
            [self.mViewModel handleEnterpriseWholeSaleData:responseModel.data isFirstPage:self->currentPage==1];
            [self.mTableView reloadData];
            
            UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
            if (sectionModel.cellArray.count>=[responseModel.data.total integerValue]) {
                self.mTableView.mj_footer=nil;
            }else {
                self.mTableView.mj_footer=self.mRefreshFooter;
            }
            self->currentPage++;
            [self endHeaderFooterRefresh];
            [self showPlaceHolderView];
        } failure:^(UleRequestError *error) {
            @strongify(self);
            [UleMBProgressHUD hideHUDForView:self.view];
            [self showErrorHUDWithError:error];
            [self endHeaderFooterRefresh];
            [self showPlaceHolderView];
        }];
    }else {
        [UleMBProgressHUD hideHUDForView:self.view];
        [self endHeaderFooterRefresh];
//        [self showPlaceHolderView];
    }
}


- (void)showPlaceHolderView{
    if (self.mViewModel.mDataArray.count<=0) {
        self.mPlaceHolderVeiw.hidden=NO;
    }else self.mPlaceHolderVeiw.hidden=YES;
}

- (void)endHeaderFooterRefresh{
    [self.mTableView.mj_header endRefreshing];
    if (self.mTableView.mj_footer) {
        [self.mTableView.mj_footer endRefreshing];
    }
}
#pragma mark - <getters>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
        _mTableView.delegate = self.mViewModel;
        _mTableView.dataSource = self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.showsVerticalScrollIndicator = NO;
    }
    return _mTableView;
}

- (EnterpriseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel = [[EnterpriseViewModel alloc]init];
    }
    return _mViewModel;
}

- (US_EnterprisePlaceholderView *)mPlaceHolderVeiw{
    if (!_mPlaceHolderVeiw) {
        _mPlaceHolderVeiw = [[US_EnterprisePlaceholderView alloc] initWithFrame:CGRectZero];
        _mPlaceHolderVeiw.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _mPlaceHolderVeiw.hidden=YES;
        [_mPlaceHolderVeiw setPickButtonHidden:YES];
        @weakify(self);
        _mPlaceHolderVeiw.callback = ^{
            @strongify(self);
            [self.mTableView.mj_header beginRefreshing];
        };
    }
    return _mPlaceHolderVeiw;
}
@end
