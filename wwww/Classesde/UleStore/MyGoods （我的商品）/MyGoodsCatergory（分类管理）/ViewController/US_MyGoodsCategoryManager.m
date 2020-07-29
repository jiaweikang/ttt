//
//  US_MyGoodsCategoryManager.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsCategoryManager.h"
#import "US_MyGoodsApi.h"
#import "US_MyGoodsCatergoryCell.h"
#import "XYRearrangeView.h"
#import "US_CatergoryBottomView.h"
#import "US_MyGoodsDeleteAlertView.h"
#import <UIView+ShowAnimation.h>
#import "FileController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "US_EmptyPlaceHoldView.h"
#import "US_AddNewCategoryAlert.h"
@interface US_MyGoodsCategoryManager ()<UITableViewDelegate,UITableViewDataSource,US_MyGoodsCatergoryCellDelegate,US_MyGoodsDeleteAlertViewDelegate,US_CatergoryBottomViewDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) NSMutableArray * mDataArray;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, assign) BOOL mCategoryEditing;
@property (nonatomic, strong) US_CatergoryBottomView * mBottomView;
@property (nonatomic, strong) NSString * deleteCategoryId;
@property (nonatomic, assign) BOOL sortsChanged;//是否有顺序改变，或者名字修改
@property (nonatomic, assign) BOOL isupdate;//是否有修改过分类，如果修改过则再消失时发送通知。
@property (nonatomic, assign) BOOL needrequestNewList;//接收通知，是否在页面显示时重新请求列表数据
@property (nonatomic, strong) US_EmptyPlaceHoldView * emptyPlaceHoldView;
@end

@implementation US_MyGoodsCategoryManager
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"我的商品"];
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
    [self.view sd_addSubviews:@[self.mTableView,self.mBottomView,self.emptyPlaceHoldView]];
    self.mBottomView.sd_layout.leftSpaceToView(self.view, 0)
    .bottomSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(kStatusBarHeight==20?49:83);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.mBottomView, 0);
    self.emptyPlaceHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.emptyPlaceHoldView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0)
    .bottomSpaceToView(self.mBottomView, 0);
    self.fd_interactivePopDisabled=YES;
   

    self.mCategoryEditing=NO;
    [self getCacheDetailData];
    if (self.mDataArray.count<=0) {
        [self startRequestItemClassify];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onTextChanged:) name:NOTI_CategroyNameChanged object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyrequestList) name:NOTI_MyGoodsListRefresh object:nil];
    [self.mTableView reloadData];
    @weakify(self);
    [self.mTableView xy_rollViewOriginalDataBlock:^NSArray * _Nonnull{
        @strongify(self);
        return self.mDataArray;
    } callBlckNewDataBlock:^(NSArray * _Nullable newData) {
        // 回调处理完成的数据给外界
        @strongify(self);
        [self.mDataArray removeAllObjects];
        [self.mDataArray addObjectsFromArray:newData];
        for (int i=0; i<self.mDataArray.count; i++) {
            CategroyItem *item=self.mDataArray[i];
            item.sortNum=[NSString stringWithFormat:@"%d",i];
        }
        self.sortsChanged=YES;
    }];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mTableView.mj_header=self.mRefreshHeader;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needrequestNewList==YES) {
        [self startRequestItemClassify];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.needrequestNewList=NO;
}

- (void)notifyrequestList{
    self.needrequestNewList=YES;
}

- (void)ule_toLastViewController{
    if (self.mCategoryEditing||self.sortsChanged) {
        US_MyGoodsDeleteAlertView * alert=[[US_MyGoodsDeleteAlertView alloc] initWithTitle:@"提示" message:@"分类已编辑\n\n是否保存编辑记录" delegate:self cancelButtonTitle:@"不保存" otherButtonTitles:@"保存"];
        alert.tag=1001;
        [alert showViewWithAnimation:AniamtionPresentBottom];
    }else{
        if (self.isupdate) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_CategoryUpdate object:nil];
            self.isupdate=NO;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - <下拉刷新>
- (void)beginRefreshHeader{
    [self startRequestItemClassify];
}

#pragma mark - <http>
//请求全部分类
- (void)startRequestItemClassify{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyGoodsApi buildItemClassifyRequest:NO] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self handleCatergoryDataInfo:responseObject];
        [self.mTableView.mj_header endRefreshing];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
        [self.mTableView.mj_header endRefreshing];
    }];
}
//删除分类
- (void)startComfirmDeleteCategory{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyGoodsApi buildDeleteCategoryForId:self.deleteCategoryId] success:^(id responseObject) {
        @strongify(self);
        [self handleDeletedCatergoryInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}
//分类排序
- (void)startBatchSortCategory{
    NSMutableArray * array=[[NSMutableArray alloc] init];
    for (int i=0; i<self.mDataArray.count; i++) {
        CategroyItem * item=self.mDataArray[i];
        NSDictionary * dic=[item yy_modelToJSONObject];
        [array addObject:dic];
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyGoodsApi buildBatchSortCatergoryByInfo:jsonString] success:^(id responseObject) {
//        @strongify(self);
        NSString * message=responseObject[@"returnMessage"];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:message afterDelay:2];
        self.isupdate=YES;
        //缓存本地
        [NSKeyedArchiver archiveRootObject:self.mDataArray toFile:[FileController fullpathOfFilename:kCacheFile_DetailCategoryCache]];
    } failure:^(UleRequestError *error) {
//        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}
//添加新分类
- (void)addNewCatergoryWithName:(NSString *)catergoryName{
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyGoodsApi buildAddNewCategoryWithName:catergoryName] success:^(id responseObject) {
        @strongify(self);
        NSString * message=responseObject[@"returnMessage"];
        [UleMBProgressHUD showHUDAddedTo:self.view withText:message afterDelay:2];
        [self startRequestItemClassify];
        self.isupdate=YES;
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}
#pragma mark - <数据处理>
- (void)handleCatergoryDataInfo:(NSDictionary *)dic{
    US_GoodsCatergory * catergory=[US_GoodsCatergory yy_modelWithDictionary:dic];
    [self.mDataArray removeAllObjects];
    for (int i=0; i<catergory.data.categoryItems.count; i++) {
        CategroyItem * item=catergory.data.categoryItems[i];
        [self.mDataArray addObject:item];
    }
    [self.mTableView reloadData];
    if (self.mDataArray.count>0) {
        self.emptyPlaceHoldView.hidden=YES;
        self.mBottomView.hidden = NO;
        //缓存本地
        [NSKeyedArchiver archiveRootObject:self.mDataArray toFile:[FileController fullpathOfFilename:kCacheFile_DetailCategoryCache]];
    }else{
        self.emptyPlaceHoldView.hidden=NO;
        self.mBottomView.hidden = YES;
    }
}
- (void)handleDeletedCatergoryInfo:(NSDictionary *)dic{
    NSInteger deleteItemIndex=-1;
    for (int i=0; i<self.mDataArray.count; i++) {
        CategroyItem *item=self.mDataArray[i];
        if ([item.idForCate isEqualToString:self.deleteCategoryId]) {
            [self.mDataArray removeObjectAtIndex:i];
            deleteItemIndex=i;
            break;
        }
    }
    if (deleteItemIndex>-1) {
        [self.mTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:deleteItemIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    if (self.mDataArray.count<=0) {
        self.rightButton.hidden=YES;
    }else{
        self.rightButton.hidden=NO;
    }
    self.isupdate=YES;
    //缓存本地
    [NSKeyedArchiver archiveRootObject:self.mDataArray toFile:[FileController fullpathOfFilename:kCacheFile_DetailCategoryCache]];
}
- (void)getCacheDetailData{

    NSMutableArray *cacheArr=[NSKeyedUnarchiver unarchiveObjectWithFile:[FileController fullpathOfFilename:kCacheFile_DetailCategoryCache]];
    [self.mDataArray removeAllObjects];
    for (int i=0; i<cacheArr.count; i++) {
        CategroyItem * item=cacheArr[i];
        [self.mDataArray addObject:item];
    }
    [self.mTableView reloadData];

}

#pragma mark - <UITableView>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    US_MyGoodsCatergoryCell * cell= [tableView dequeueReusableCellWithIdentifier:@"US_MyGoodsCatergoryCell"];
    if (cell==nil) {
        cell=[[US_MyGoodsCatergoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"US_MyGoodsCatergoryCell"];
    }
    cell.delegate=self;
    [cell setModel:self.mDataArray[indexPath.row]];
    [cell setIsEditType:self.mCategoryEditing];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategroyItem * item=self.mDataArray[indexPath.row];
    if (item) {
        NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
        [dic setObject:item forKey:@"CategoryItem"];
        [dic setObject:@(YES) forKey:@"AddNewGoods"];
        [self pushNewViewController:@"US_MyGoodsListVC" isNibPage:NO withData:dic];
    }
}
- (void)cellDidDeletecatergoryId:(NSString *)categoryId{
    US_MyGoodsDeleteAlertView * alert=[[US_MyGoodsDeleteAlertView alloc] initWithTitle:@"提示" message:@"确定要删除分类吗？\n删除分类后分类下的商品会一并移出" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定"];
    alert.tag=1000;
    self.deleteCategoryId=categoryId;
    [alert showViewWithAnimation:AniamtionPresentBottom];
}
#pragma mark - <Alert delegate>
-(void)alertView:(US_MyGoodsDeleteAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==1000) {
        if (buttonIndex==1) {
            //确认删除
            [self startComfirmDeleteCategory];
        }
    }
    if (alertView.tag==1001) {
        if (buttonIndex==1) {
            self.sortsChanged=NO;
            [self startBatchSortCategory];
            [self editClick:self.rightButton];
        }
    }
}
#pragma mark - <button action>
- (void)editClick:(UIButton *)btn{
    self.mCategoryEditing=!self.mCategoryEditing;
    if (self.mCategoryEditing) {
        //进入编辑模式
        [self.mTableView intoEditMode:YES];
        //不允许单击cell
        self.mTableView.allowsSelection=NO;
        [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    }else{
        //遍历所有商品分类名称只要有一个为空就不能通过
        if ([self isHasEmptyCategoryName]) {
            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"商品分类名称不能为空" afterDelay:2];
            return;
        }
        //关闭编辑模式
        [self.mTableView intoEditMode:NO];
        //不允许单击cell
        self.mTableView.allowsSelection=YES;
        [self.rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        if (self.sortsChanged) {
            self.sortsChanged=NO;
            [self startBatchSortCategory];
        }
    }
    [self.mTableView reloadData];
}

#pragma mark -- 点击创建分类
- (void)showAddNewCategoryAlert{
    @weakify(self);
    US_AddNewCategoryAlert * alert=[US_AddNewCategoryAlert creatAlertWithConfirmBlock:^(NSString *categoryName) {
        @strongify(self);
        if (categoryName.length>0) {
            [self addNewCatergoryWithName:categoryName];
        }
    }];
    [alert showViewWithAnimation:AniamtionAlert];
}

#pragma mark - <private function>
- (BOOL)isHasEmptyCategoryName{
    BOOL isEmpty=NO;
    for (int i=0 ; i<self.mDataArray.count; i++) {
        CategroyItem * item=self.mDataArray[i];
        if ([item.categoryName isEqualToString:@""] || item.categoryName.length <= 0 || item.categoryName == nil) {
            isEmpty = YES;
            break;
        }
    }
    return isEmpty;
}
#pragma mark - <notify>
- (void)onTextChanged:(NSNotification*)noti{
    NSDictionary *dic = noti.userInfo;
    self.sortsChanged = [[dic objectForKey:@"isChanged"] boolValue];
    self.isupdate=YES;
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self;
        _mTableView.dataSource=self;
        _mTableView.rowHeight=50;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.backgroundColor=[UIColor clearColor];
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _mTableView.contentInsetAdjustmentBehavior =UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mTableView;
}
- (NSMutableArray *)mDataArray{
    if (!_mDataArray) {
        _mDataArray=[[NSMutableArray alloc] init];
    }
    return _mDataArray;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_rightButton setTitle:@"编辑" forState:UIControlStateNormal];
        _rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
        _rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [_rightButton addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}
- (US_CatergoryBottomView *)mBottomView{
    if (!_mBottomView) {
        _mBottomView=[[US_CatergoryBottomView alloc] initWithFrame:CGRectZero];
        _mBottomView.delegate=self;
    }
    return _mBottomView;
}
- (US_EmptyPlaceHoldView *)emptyPlaceHoldView{
    if (!_emptyPlaceHoldView) {
        _emptyPlaceHoldView=[[US_EmptyPlaceHoldView alloc] initWithFrame:CGRectZero];
        _emptyPlaceHoldView.iconImageView.image=[UIImage bundleImageNamed:@"placeholder_img_noCategory"];
        _emptyPlaceHoldView.titleLabel.text=@"您还没有分类哦~";
        _emptyPlaceHoldView.clickBtnText = @"创建分类";
        @weakify(self);
        _emptyPlaceHoldView.btnClickBlock = ^{
            @strongify(self);
            [self showAddNewCategoryAlert];
        };
        _emptyPlaceHoldView.hidden=YES;
    }
    return _emptyPlaceHoldView;
}
@end
