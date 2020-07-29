//
//  US_LocalAddressListVC.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/14.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_LocalAddressListVC.h"
#import "US_GoodsSectionModel.h"
#import "UleBaseViewModel.h"
#import <TencentLBS/TencentLBS.h>
#import "USLocationManager.h"
#import "US_LocationListCell.h"
#import "US_Api.h"
#import "US_SearchAddressModel.h"
#import "US_SearchBarView.h"
#import "USApplicationLaunchManager.h"
@interface US_LocalAddressListVC ()<UISearchBarDelegate,UleBaseViewModelDelegate,US_SearchBarViewDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UITableView * mResultTableView;
@property (nonatomic, strong) UIView * mMaskView;
@property (nonatomic, strong) UILabel * mBottomLabel;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) UleBaseViewModel * mResultViewModel;
@property (nonatomic, strong) NSArray <TencentLBSPoi *> * mAddresslist;
@property (nonatomic, strong) UIView * headView;
@property (nonatomic, strong) US_SearchBarView * searchBarView;
@property (nonatomic, copy) NSString * fromVC;

@end

@implementation US_LocalAddressListVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self iniData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didUpdateLocations:) name:@"updateLocation" object:nil];
}

- (void)initUI{
    [self.uleCustemNavigationBar customTitleLabel:@"选择收货地址"];
    
    [self.view sd_addSubviews:@[self.mTableView,self.mBottomLabel,self.searchBarView,self.mMaskView,self.mResultTableView,]];
    self.searchBarView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(50);
    self.mBottomLabel.sd_layout.leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, kIphoneX?34:10)
    .heightIs(35);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.searchBarView, 0).bottomSpaceToView(self.mBottomLabel, 0);
    self.mMaskView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mMaskView.sd_layout.topSpaceToView(self.searchBarView, 0);
    self.mResultTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mResultTableView.sd_layout.topSpaceToView(self.searchBarView, 0);
}

- (void)iniData{
    self.fromVC= [self.m_Params objectForKey:@"fromVC"];
    UleSectionBaseModel * sectionModel=[[UleSectionBaseModel alloc] init];
    sectionModel.headHeight=30;
    sectionModel.headData=@"当前定位";
    sectionModel.headViewName=@"US_locationHead";
    US_LocationListCellModel * currentLocal=[[US_LocationListCellModel alloc] initWithCellName:@"US_LocationListCell"];
    currentLocal.data=[USLocationManager sharedLocation].currentPoi;
    currentLocal.showBtn=YES;
    [sectionModel.cellArray addObject:currentLocal];
    [self.mViewModel.mDataArray addObject:sectionModel];
    
    UleSectionBaseModel * fujinModel=[[UleSectionBaseModel alloc] init];
    fujinModel.headHeight=30;
    fujinModel.headData=@"附近位置";
    fujinModel.headViewName=@"US_locationHead";
    for (int i=0; i<[USLocationManager sharedLocation].poiList.count; i++) {
        US_LocationListCellModel * cellModel=[[US_LocationListCellModel alloc] initWithCellName:@"US_LocationListCell"];
        cellModel.data=[USLocationManager sharedLocation].poiList[i];
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            TencentLBSPoi * poi=[USLocationManager sharedLocation].poiList[indexPath.row];
//            if ([USLocationManager checkContainCityCode:[USLocationManager sharedLocation].locationCode]) {
                [[USLocationManager sharedLocation] saveLocationPoi:poi andCode:[USLocationManager sharedLocation].locationCode];
                if ([self.fromVC isEqualToString:@"HomeVC"]) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateUserInfo object:nil userInfo:nil];
                }else{
                    [USLocationManager dismissFromVC:self];
                }
//            }else{
//               [USLocationManager showEmptyVC];
//            }
        };
        [fujinModel.cellArray addObject:cellModel];
    }
    [self.mViewModel.mDataArray addObject:fujinModel];

}

- (void)didUpdateLocations:(id)sender{
    [self.mViewModel.mDataArray removeAllObjects];
    [self iniData];
    [self.mTableView reloadData];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - <http>
- (void)searchAddressWithKeyWord:(NSString *)keyword{
    NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
    [dic setValue:NonEmpty(keyword) forKey:@"keyword"];
    [dic setValue:NonEmpty([UleStoreGlobal shareInstance].config.tencentAppKey) forKey:@"key"];
    [dic setValue:NonEmpty([USLocationManager sharedLocation].lastCity) forKey:@"region"];
    UleRequest * request =[[UleRequest alloc] initWithApiName:API_suggestAdress andParams:dic requsetMethod:RequestMethod_Get];
    request.baseUrl=[UleStoreGlobal shareInstance].config.tencentDomain;
    [self.networkClient_API beginRequest:request success:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self frechSearchAddressInfo:responseObject];
    } failure:^(UleRequestError *error) {
        
    }];
}
- (void)frechSearchAddressInfo:(NSDictionary *)dic{
    [self.mResultViewModel.mDataArray removeAllObjects];
    US_SearchAddressModel * addressList= [US_SearchAddressModel yy_modelWithDictionary:dic];
    NSLog(@"===");
    UleSectionBaseModel * fujinModel=[[UleSectionBaseModel alloc] init];
    for (int i=0; i<addressList.data.count; i++) {
        US_LocationListCellModel * cellModel=[[US_LocationListCellModel alloc] initWithCellName:@"US_LocationListCell"];
        cellModel.data=addressList.data[i];
        @weakify(self);
        cellModel.cellClick = ^(UITableView * _Nonnull tableView, NSIndexPath * _Nonnull indexPath) {
            @strongify(self);
            US_AddressModel * data=[addressList.data objectAt:indexPath.row];
            if (data) {
                TencentLBSPoi * poi=[[TencentLBSPoi alloc] init];
                poi.name=data.title;
                poi.address=data.address;
                poi.latitude=[data.location.lat floatValue];
                poi.longitude=[data.location.lng floatValue];
//                if ([USLocationManager checkContainCityCode:data.adcode]) {
                    [[USLocationManager sharedLocation] saveLocationPoi:poi andCode:data.adcode];
                    if ([self.fromVC isEqualToString:@"HomeVC"]) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_UpdateUserInfo object:nil userInfo:nil];
                    }else{
                        [USLocationManager dismissFromVC:self];
                    }
//                }else{
//                    [USLocationManager showEmptyVC];
//                }
            }
 
        };
        [fujinModel.cellArray addObject:cellModel];
    }
    [self.mResultViewModel.mDataArray addObject:fujinModel];
    [self.mResultTableView reloadData];

}
#pragma mark - <delegare>
- (void)searchBarTextDidBeginEditing:(US_SearchBarView *)searchBar{
    NSLog(@"====begin===edit");
    self.mMaskView.hidden=NO;
}
- (void)searchBarTextDidEndEditing:(US_SearchBarView *)searchBar{
    NSLog(@"====end===edit");
    self.mMaskView.hidden=YES;
}

- (void)searchBar:(US_SearchBarView *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"%@",searchText);
//    self.mMaskView.hidden=YES;
    [self searchAddressWithKeyWord:searchText];
    self.mResultTableView.hidden=searchText.length>0?NO:YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - <getter and setter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.backgroundColor=kViewCtrBackColor;
    }
    return _mTableView;
}
- (UITableView *)mResultTableView{
    if (!_mResultTableView) {
        _mResultTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mResultTableView.dataSource=self.mResultViewModel;
        _mResultTableView.delegate=self.mResultViewModel;
        _mResultTableView.hidden=YES;
    }
    return _mResultTableView;
}
- (UIView *)mMaskView{
    if (!_mMaskView) {
        _mMaskView=[UIView new];
        _mMaskView.backgroundColor=[UIColor blackColor];
        _mMaskView.alpha=0.6;
        _mMaskView.hidden=YES;
    }
    return _mMaskView;
}
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}

- (UIView *)headView{
    if (!_headView) {
        _headView=[UIView new];
        _headView.backgroundColor=[UIColor whiteColor];
        UISearchBar * searchBar=[[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.placeholder=@"搜索地址";
        searchBar.delegate=self;
        [_headView addSubview:searchBar];
        searchBar.sd_layout.leftSpaceToView(_headView, 0)
        .topSpaceToView(_headView, 0)
        .rightSpaceToView(_headView, 0)
        .heightIs(50);
    }
    return _headView;
}
- (UleBaseViewModel *)mResultViewModel{
    if (!_mResultViewModel) {
        _mResultViewModel=[[UleBaseViewModel alloc] init];
        _mResultViewModel.delegate= self;
    }
    return _mResultViewModel;
}
- (US_SearchBarView *)searchBarView{
    if (!_searchBarView) {
        _searchBarView=[[US_SearchBarView alloc] initWithFrame:CGRectZero];
        _searchBarView.delegate=self;
    }
    return _searchBarView;
}
- (UILabel *)mBottomLabel{
    if (!_mBottomLabel) {
        _mBottomLabel=[UILabel new];
        _mBottomLabel.textColor=[UIColor convertHexToRGB:kLightTextColor];
        _mBottomLabel.font=[UIFont systemFontOfSize:15];
        _mBottomLabel.text=@"现已开通北京，更多城市陆续开通中，敬请期待！";
        _mBottomLabel.numberOfLines=0;
        _mBottomLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _mBottomLabel;
}
@end
