
//
//  US_MyGoodsBatchDeleteVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsBatchDeleteVC.h"
#import "US_PresentAnimaiton.h"
#import "US_MyGoodsApi.h"
#import "MyFavoritesLists.h"
#import "US_MyGoodsDeleteCell.h"
#import "US_MyGoodsDeleteAlertView.h"
#import <UIView+ShowAnimation.h>
#import "US_EmptyPlaceHoldView.h"

@interface US_MyGoodsBatchDeleteVC ()<UIViewControllerTransitioningDelegate,UICollectionViewDataSource,UICollectionViewDelegate,US_MyGoodsDeleteAlertViewDelegate>
@property (nonatomic, strong) US_PresentAnimaiton * animation;
@property (nonatomic, strong) UICollectionView * mCollectionView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) NSMutableArray * mDataArray;
@property (nonatomic, strong) NSMutableArray * mDeletedIndexeArray;
@property (nonatomic, strong) NSMutableString * mDeletedListIdStr;
@property (nonatomic, assign) NSInteger totoalCount;
@property (nonatomic, strong) US_EmptyPlaceHoldView * noItemsBgView;
@property (nonatomic, assign) BOOL deleteSuccess;
@end

@implementation US_MyGoodsBatchDeleteVC
#pragma mark - <Life cycle>
- (instancetype)init {
    self = [super init];
    if (self) {
        _animation = [[US_PresentAnimaiton alloc] initWithAnimationType:AniamtionSheetType targetViewSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-0,kStatusBarHeight>20?KScreenScale(900)+34:KScreenScale(900))];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate=self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUI];
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    [self startrequestBatchDeleteListAtStart:@"0" pageSize:@"12"];
}

- (void)setUI{
    [self.uleCustemNavigationBar ule_setBackgroudColor:[UIColor whiteColor]];
    [self.uleCustemNavigationBar ule_setTintColor:[UIColor blackColor]];
    [self.uleCustemNavigationBar customTitleLabel:@"您有商品失效"];
    self.uleCustemNavigationBar.height_sd=44;
    [self.uleCustemNavigationBar ule_setBottomLineHidden:NO];
    UILabel * titleLabel=[self.uleCustemNavigationBar valueForKeyPath:@"titleLabel"];
    titleLabel.font=[UIFont systemFontOfSize:16];
    
    UIButton * dismissBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [dismissBtn setImage:[UIImage bundleImageNamed:@"myGoods_btn_close"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.uleCustemNavigationBar.rightBarButtonItems=@[dismissBtn];
    dismissBtn.sd_layout.bottomSpaceToView(self.uleCustemNavigationBar, 2)
    .heightIs(40);
    self.uleCustemNavigationBar.leftBarButtonItems=nil;
    [self.view sd_addSubviews:@[self.mCollectionView,self.bottomView]];
    self.bottomView.sd_layout.leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight>20?50+34:50);
    self.mCollectionView.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.bottomView, 0);
    [self.view addSubview:self.noItemsBgView];
    self.noItemsBgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.noItemsBgView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    self.mCollectionView.mj_footer=self.mRefreshFooter;
    self.mRefreshFooter.alpha=0.0;
}

- (void)btnClick:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.delegate &&[self.delegate respondsToSelector:@selector(didDismissed)]) {
            if (self.deleteSuccess) {
                [self.delegate didDismissed];
            }
        }
    }];
}
#pragma mark - <上拉加载更多>
- (void)beginRefreshFooter{
    NSString * start=[NSString stringWithFormat:@"%@",@(self.mDataArray.count)];
    [self startrequestBatchDeleteListAtStart:start pageSize:@"12"];
}
#pragma mark - <http 网络请求>
- (void)startrequestBatchDeleteListAtStart:(NSString *)start pageSize:(NSString *)pageSize{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildAllStoreItemsKeyword:@"" flag:@"1" listingType:@"" start:start andPageNum:pageSize] success:^(id responseObject) {
        @strongify(self);
        [self handleBatchDeleteDic:responseObject];
        [self.mCollectionView reloadData];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        self.noItemsBgView.hidden=NO;
        [self showErrorHUDWithError:error];
    }];
}

- (void)startBatchDeleteSelectedList{
    @weakify(self);
    [self.networkClient_API beginRequest:[US_MyGoodsApi buildBatchDeleteWithListIds:self.mDeletedListIdStr] success:^(id responseObject) {
        @strongify(self);
        self.deleteSuccess=YES;
        NSMutableArray *backupArr=[NSMutableArray array];
        for (int i=0; i<self.mDeletedIndexeArray.count; i++) {
            NSIndexPath *indexP=self.mDeletedIndexeArray[i];
            if (self.mDataArray.count>indexP.row) {
                    [backupArr addObject:self.mDataArray[indexP.row]];
            }
        }
        //剩余未加载的商品
        NSInteger unloads=self.totoalCount-self.mDataArray.count;
        [self.mDataArray removeObjectsInArray:backupArr];
        [self.mCollectionView deleteItemsAtIndexPaths:self.mDeletedIndexeArray];
        if (self.mDataArray.count<=0&&unloads==0) {
            //显示已经没有可以删除的商品了。
            self.noItemsBgView.hidden=NO;
        }else if(unloads>=self.mDeletedIndexeArray.count) {
            //如果剩余的商品超过删除的商品数目，则补齐删除的个数
            [self startrequestBatchDeleteListAtStart:[NSString stringWithFormat:@"%@",@(self.mDataArray.count+backupArr.count)] pageSize:[NSString stringWithFormat:@"%@",@(self.mDeletedIndexeArray.count)]];
        }else if (unloads<self.mDeletedIndexeArray.count&&unloads>0){
            //如果剩余的商品少于删除商品的数目，则全部请求完成
            [self startrequestBatchDeleteListAtStart:[NSString stringWithFormat:@"%@",@(self.mDataArray.count+backupArr.count)] pageSize:[NSString stringWithFormat:@"%@",@(unloads)]];
        }
        [UleMBProgressHUD showHUDAddedTo:self.view withImage:[UIImage bundleImageNamed:@"hub_batchDelete_clear"] afterDelay:1.5];
        
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

#pragma mark - <数据处理>
- (void)handleBatchDeleteDic:(NSDictionary *)dic{
    MyFavoritesLists * favoritesData=[MyFavoritesLists yy_modelWithDictionary:dic];
    self.totoalCount=[favoritesData.data.totalRecords integerValue];
    for (int i=0; i<favoritesData.data.result.count; i++) {
        Favorites * favorite=favoritesData.data.result[i];
        favorite.isSelected=YES;
        [self.mDataArray addObject:favorite];
    }
    self.noItemsBgView.hidden=self.mDataArray.count>0?YES:NO;
    self.mRefreshFooter.alpha=1.0;
    if (self.mDataArray.count>=self.totoalCount) {
        [self.mCollectionView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.mCollectionView.mj_footer endRefreshing];
    }
}

#pragma mark - <Collection Delegate and datasource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.mDataArray.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    US_MyGoodsDeleteCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"US_MyGoodsDeleteCell" forIndexPath:indexPath];
    [cell setModel:self.mDataArray[indexPath.row]];
    return cell;
}

#pragma mark - <UIViewControllerTransitioningDelegate>
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animation;
}


- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  _animation;
}

#pragma mark - <click event>
- (void)batchDeletClick:(id)sender{
    [self.mDeletedIndexeArray removeAllObjects];
    _mDeletedListIdStr=[[NSMutableString alloc]initWithString:@""];;
    for (int i=0; i<self.mDataArray.count; i++) {
        Favorites * favorites=self.mDataArray[i];
        if (favorites.isSelected) {
            [self.mDeletedIndexeArray addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [_mDeletedListIdStr appendString:[NSString stringWithFormat:@"%@,",favorites.listId]];
        }
    }
    if (_mDeletedListIdStr.length>0) {
        [_mDeletedListIdStr deleteCharactersInRange:NSMakeRange(_mDeletedListIdStr.length-1, 1)];
    }
    if (self.mDeletedIndexeArray.count<=0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择要删除的商品" afterDelay:2];
    }else {
        US_MyGoodsDeleteAlertView * sheetAlert=[[US_MyGoodsDeleteAlertView alloc] initWithTitle:@"提示" message:@"确定删除选中的商品吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
        [sheetAlert showViewWithAnimation:AniamtionPresentBottom];
        [UleMbLogOperate addMbLogClick:NonEmpty(self.mDeletedListIdStr) moduleid:@"批量删除" moduledesc:@"删除" networkdetail:@""];
    }

}
#pragma mark - <Alert delegate>
- (void)alertView:(US_MyGoodsDeleteAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self startBatchDeleteSelectedList];
    }else{
        [self.mDeletedIndexeArray removeAllObjects];
    }
}

#pragma mark - <setter and getter>
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        UICollectionViewFlowLayout * layout=[[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 20;
        layout.minimumLineSpacing = 20;
        CGFloat width=((__MainScreen_Width-20*4)/3.0);
        layout.itemSize=CGSizeMake(width, KScreenScale(260));
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mCollectionView.dataSource=self;
        _mCollectionView.delegate=self;
        [_mCollectionView registerClass:[US_MyGoodsDeleteCell class] forCellWithReuseIdentifier:@"US_MyGoodsDeleteCell"];
        _mCollectionView.backgroundColor=[UIColor whiteColor];
    }
    return _mCollectionView;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView=[[UIView alloc] init];
        _bottomView.backgroundColor=[UIColor whiteColor];
        UIButton * deletBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [deletBtn addTarget:self action:@selector(batchDeletClick:) forControlEvents:UIControlEventTouchUpInside];
        [deletBtn setTitle:@"删除选中商品" forState:UIControlStateNormal];
        [deletBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        deletBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        deletBtn.layer.borderColor=[UIColor redColor].CGColor;
        deletBtn.layer.borderWidth=0.6;
        deletBtn.layer.cornerRadius=18;
        [_bottomView addSubview:deletBtn];
        deletBtn.sd_layout.centerXEqualToView(_bottomView)
        .topSpaceToView(_bottomView, 7)
        .widthIs(140)
        .heightIs(36);
        UIView * line=[UIView new];
        line.backgroundColor=kViewCtrBackColor;
        [_bottomView addSubview:line];
        line.sd_layout.leftSpaceToView(_bottomView, 0)
        .topSpaceToView(_bottomView, 0)
        .rightSpaceToView(_bottomView, 0)
        .heightIs(0.6);
    }
    return _bottomView;
}
- (NSMutableArray *)mDataArray{
    if (!_mDataArray) {
        _mDataArray=[[NSMutableArray alloc] init];
    }
    return _mDataArray;
}
- (NSMutableArray *)mDeletedIndexeArray{
    if (!_mDeletedIndexeArray) {
        _mDeletedIndexeArray=[[NSMutableArray alloc] init];
    }
    return _mDeletedIndexeArray;
}
- (US_EmptyPlaceHoldView *)noItemsBgView{
    if (!_noItemsBgView) {
        _noItemsBgView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _noItemsBgView.iconImageView.image=[UIImage bundleImageNamed:@"myGoods_icon_empty"];
        _noItemsBgView.titleLabel.text=@"暂无可管理商品";;
        _noItemsBgView.hidden=YES;
    }
    return _noItemsBgView;
}

@end
