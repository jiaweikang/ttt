//
//  US_SearchGoodsRootVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SearchGoodsRootVC.h"
#import "US_GoodsSourceApi.h"
#import "UleSearchKeyObject.h"
#import "RecmdSearchView.h"
#import "UserDefaultManager.h"
#import "TopKeywordInfo.h"
#define heightHistorySearch 40
@interface US_SearchGoodsRootVC ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView * historyAndHotBG;
    //    UITableView * searchResultTB;
    NSMutableArray * historySearchArr;
    NSMutableArray * hotSearchArr;
    NSMutableArray * searchResultArr;
}
@property (nonatomic, strong) UITableView * searchReusltTableView;
@property (nonatomic, strong) UITextField * searchTextfield;
@property (nonatomic, strong) NSString * placeholdKeyWord;
//@property (nonatomic, strong) RecmdSearchView * mRecmdSearchView;
@end

@implementation US_SearchGoodsRootVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if (_mRecmdSearchView) {
//        [_mRecmdSearchView reloadHistorySearchView];
//    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_searchTextfield resignFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    [_searchTextfield becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.uleCustemNavigationBar.hidden=YES;
    [self setUI];
//    [self startRequestHotsearchKey];
    

}

- (void)setUI{
    
    UIButton * backBtn = [[UIButton alloc] initWithFrame:CGRectMake(__MainScreen_Width/2.0 - 12, 40, 24, 24)];
    [backBtn setBackgroundImage:[UIImage bundleImageNamed:@"goods_btn_searchClose.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];

    UIView * searchTextfieldBG = [[UIView alloc] initWithFrame:CGRectMake(20, 84, __MainScreen_Width-40, 38)];
    searchTextfieldBG.backgroundColor =  [UIColor whiteColor];
    searchTextfieldBG.layer.masksToBounds = YES;
    searchTextfieldBG.layer.cornerRadius = 19;

    UIImage * leftImg = [UIImage bundleImageNamed:@"goods_icon_search.png"];
    UIImageView * leftImgV = [[UIImageView alloc]initWithImage:leftImg];
    leftImgV.frame = CGRectMake(10, 11, 15, 15);
    [searchTextfieldBG addSubview:leftImgV];

    UIButton * rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(searchTextfieldBG.frame.size.width-80, 0, 80, 38)];
    [rightBtn setTitle:@"搜索" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightBtn setBackgroundColor:[UIColor redColor]];
    [rightBtn addTarget:self action:@selector(doSearchAction) forControlEvents:UIControlEventTouchUpInside];
    [searchTextfieldBG addSubview:rightBtn];
    [searchTextfieldBG addSubview:self.searchTextfield];

    self.searchTextfield.sd_layout.leftSpaceToView(leftImgV,5)
    .rightSpaceToView(rightBtn,0).topSpaceToView(searchTextfieldBG,0).bottomSpaceToView(searchTextfieldBG,0);
    [self.view addSubview:searchTextfieldBG];
    
    searchResultArr = [NSMutableArray array];
    
    [self.view addSubview:self.searchReusltTableView];
    self.searchReusltTableView.sd_layout.topSpaceToView(searchTextfieldBG,0)
    .leftSpaceToView(self.view,0)
    .rightSpaceToView(self.view,0)
    .bottomSpaceToView(self.view,0);
    
//    [self.view addSubview:self.mRecmdSearchView];
//    self.mRecmdSearchView.sd_layout.topSpaceToView(searchTextfieldBG,0)
//    .leftSpaceToView(self.view,0)
//    .rightSpaceToView(self.view,0)
//    .bottomSpaceToView(self.view,0);
    
    UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextfield)];
    tapGes.delegate = self;
    [self.view addGestureRecognizer:tapGes];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
    
}


- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_searchTextfield resignFirstResponder];
}


- (void)doSearchAction{
    NSString * searchStr=[_searchTextfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (searchStr.length == 0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请输入要查询的关键字" afterDelay:showDelayTime];
    } else {
        [LogStatisticsManager onSearchLog:searchStr tel:Search_Normal];
        [UserDefaultManager saveRecordSearchText:searchStr];
        [_searchTextfield resignFirstResponder];
        NSMutableDictionary *   dic = [[NSMutableDictionary alloc]init];
        [dic setObject:searchStr forKey:@"searchName"];
        [dic setObject:@"0" forKey:@"levelClassified"];
        [self pushNewViewController:@"US_SearchGoodsSourceVC" isNibPage:NO withData:dic];
    }
}

- (void)resignTextfield{
    [_searchTextfield resignFirstResponder];
}

#pragma mark - Table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return searchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"cell";
    UITableViewCell * cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [[searchResultArr objectAt:indexPath.row] keyWord];
    cell.textLabel.textColor = [UIColor convertHexToRGB:kBlackTextColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return heightHistorySearch +1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[searchResultArr objectAt:indexPath.row] keyWord].length > 0) {
        [UserDefaultManager saveRecordSearchText:[[searchResultArr objectAt:indexPath.row] keyWord]];
        NSMutableDictionary *   dic = [[NSMutableDictionary alloc]init];
        [dic setObject:[[searchResultArr objectAt:indexPath.row] keyWord] forKey:@"searchName"];
        [dic setObject:@"0" forKey:@"levelClassified"];
        [LogStatisticsManager onSearchLog:[[searchResultArr objectAt:indexPath.row] keyWord] tel:Search_Normal];
        [self pushNewViewController:@"US_SearchGoodsSourceVC" isNibPage:NO withData:dic];
        
    } else {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"搜索有误" afterDelay:showDelayTime];
    }
}

#pragma mark - <http>

//- (void)startRequestHotsearchKey{
//    @weakify(self);
//    [self.networkClient_Ule beginRequest:[US_GoodsSourceApi buildGetHotSearchWord] success:^(id responseObject) {
//        @strongify(self);
//        UleSearchKeyObject * searchKey=[UleSearchKeyObject yy_modelWithDictionary:responseObject];
////        [self.mRecmdSearchView reloadHotSearchViewWithData:searchKey.wap_searchkeyword];
//
//    } failure:^(UleRequestError *error) {
//
//    }];
//}

- (void)startRequest_getSimilarWord{
    @weakify(self);
    [self.networkClient_Ule beginRequest:[US_GoodsSourceApi buildGetSimilarWord:_searchTextfield.text] success:^(id responseObject) {
        @strongify(self);
         [self parseSearchResultDictionary:(NSDictionary *)responseObject];
    } failure:^(UleRequestError *error) {
        
    }];
}

//解析搜索返回字典数据
- (void)parseSearchResultDictionary:(NSDictionary *)dic{
    [searchResultArr removeAllObjects];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"returnMessage"]||[key isEqualToString:@"returnCode"]) {
            
        }else{
            TopKeywordInfo * info=[[TopKeywordInfo alloc] init];
            info.keyWord=(NSString *)key;
            info.requestNum=(NSString *)obj;
            [self->searchResultArr addObject:info];
        }
    }];
    [self.searchReusltTableView reloadData];
}

#pragma mark - Textfield delegate
- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length>0) {
        self.searchReusltTableView.hidden = NO;
//        self.mRecmdSearchView.hidden=YES;
        [self startRequest_getSimilarWord];
    }else{
        self.searchReusltTableView.hidden = YES;
//        self.mRecmdSearchView.hidden=NO;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [self doSearchAction];
    return YES;
}

#pragma mark - tap手势 delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]||[NSStringFromClass([touch.view class]) isEqualToString:@"UleControlView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - <setter and getter>

- (UITableView *)searchReusltTableView{
    if (!_searchReusltTableView) {
        _searchReusltTableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _searchReusltTableView.delegate = self;
        _searchReusltTableView.dataSource = self;
        _searchReusltTableView.backgroundColor =  [UIColor clearColor];
        _searchReusltTableView.tableFooterView=[[UIView alloc]init];
        //        _searchReusltTableView.hidden = YES;
    }
    return _searchReusltTableView;
}

- (UITextField *)searchTextfield{
    if (!_searchTextfield) {
        _searchTextfield=[UITextField new];
        _searchTextfield.backgroundColor = [UIColor clearColor];
        _searchTextfield.delegate = self;
        _searchTextfield.placeholder = @"请输入关键字";
        _searchTextfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextfield.returnKeyType = UIReturnKeySearch;
        [_searchTextfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _searchTextfield;
}

//- (RecmdSearchView *)mRecmdSearchView{
//    if (!_mRecmdSearchView) {
//        _mRecmdSearchView=[[RecmdSearchView alloc] initWithFrame:CGRectZero];
//        _mRecmdSearchView.backgroundColor=kViewCtrBackColor;
//    }
//    return _mRecmdSearchView;
//}


@end
