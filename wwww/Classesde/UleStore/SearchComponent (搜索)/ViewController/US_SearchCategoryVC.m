
//
//  US_SearchCategoryVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/19.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SearchCategoryVC.h"
#import "US_HistorySearchView.h"
#import "FileController.h"
#import "US_MyGoodsListVC.h"
#import "US_OrderListInfoVC.h"
#define kSearchBarHeight 30
@interface US_SearchCategoryVC ()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) UIView * searchBar;
@property (nonatomic, strong) UITextField * searchField;
@property (nonatomic, strong) US_HistorySearchView * hitoryListView;//历史搜索记录
@property (nonatomic, strong) NSString * keyWord;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, strong) NSMutableArray * keywordArray;
@property (nonatomic, strong) UleBaseViewController * searchListVC;
@property (nonatomic, strong) UleBaseViewController * orderSearchListVC;
@property (nonatomic, assign) BOOL  searchListHasGoods;
@property (nonatomic, assign) BOOL firstLoad;

@property (nonatomic, strong) NSString *searchListType; //""我的商品 0或1订单列表
@end

@implementation US_SearchCategoryVC

- (void)dealloc{
    if (_searchListVC) {
        [_searchListVC removeObserver:self forKeyPath:@"hasGoodsList"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    [self loadData];
    self.firstLoad=YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.firstLoad) {
        self.firstLoad=NO;
        [self.searchField becomeFirstResponder];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.searchField resignFirstResponder];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hasGoodsList"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        self.searchListHasGoods=newvalue;
    }
}

- (void)setUI{
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.searchBtn];
    [self.uleCustemNavigationBar setTitleView:self.searchBar];
    _searchListType = [NSString isNullToString:self.m_Params[@"orderType"]].length > 0 ? self.m_Params[@"orderType"] : @"";
    if (_searchListType.length > 0) {
        [self addChildViewController:self.orderSearchListVC];
        [self.orderSearchListVC didMoveToParentViewController:self];
        [self.view sd_addSubviews:@[self.orderSearchListVC.view,self.hitoryListView]];
        self.orderSearchListVC.view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        self.orderSearchListVC.view.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    } else {
        [self addChildViewController:self.searchListVC];
        [self.searchListVC didMoveToParentViewController:self];
        [self.view sd_addSubviews:@[self.searchListVC.view,self.hitoryListView]];
        self.searchListVC.view.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        self.searchListVC.view.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    }
    self.hitoryListView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.hitoryListView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    __weak typeof(self) weakself=self;
    self.hitoryListView.cancelClick = ^{
        weakself.searchField.text=@"";
        if (weakself.searchListType.length > 0) {
            [FileController saveOrderArrayList:[@[] mutableCopy] FileUrl:@"orderSearchKeyWodsFile"];
        } else {
            [FileController saveOrderArrayList:[@[] mutableCopy] FileUrl:@"searchKeyWodsFile"];
        }
    };
    self.hitoryListView.searchClick = ^(NSString *keywords) {
        [[UIApplication sharedApplication].delegate.window endEditing:YES];
        weakself.keyWord=keywords;
        weakself.searchField.text=keywords;
        [weakself saveSearchKeyword:keywords];
        if (keywords.length>0) {
            [LogStatisticsManager onSearchLog:keywords tel:Search_Normal];
        }
        if (weakself.searchListType.length > 0) {
            id instanceVC=weakself.orderSearchListVC;
            if ([instanceVC respondsToSelector:@selector(requestOrderListForKeyWords:)]) {
                [instanceVC requestOrderListForKeyWords:weakself.keyWord];
            }
        } else {
            id instanceVC=weakself.searchListVC;
            if ([instanceVC respondsToSelector:@selector(startSearchCategoryWithKeyWord:)]) {
                [instanceVC startSearchCategoryWithKeyWord:weakself.keyWord];
            }
        }
        weakself.hitoryListView.hidden=YES;
    };
}
- (void)loadData{
    _keywordArray=[[NSMutableArray alloc] init];
    NSArray * history= [NSArray array];
    if (_searchListType.length > 0) {
        history= [[FileController loadArrayList:@"orderSearchKeyWodsFile"] mutableCopy];
    } else {
        history= [[FileController loadArrayList:@"searchKeyWodsFile"] mutableCopy];
    }
    if (history.count>0) {
        _keywordArray=[history mutableCopy];
    }
    self.hitoryListView.keywordsArray=_keywordArray;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.hitoryListView.hidden=NO;
    self.hitoryListView.keywordsArray=self.keywordArray;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.searchListHasGoods) {
        self.hitoryListView.hidden=YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.text.length>0) {
        self.keyWord=textField.text;
        [LogStatisticsManager onSearchLog:self.keyWord tel:Search_Normal];
        if (_searchListType.length > 0) {
            id instanceVC=self.orderSearchListVC;
            if ([instanceVC respondsToSelector:@selector(requestOrderListForKeyWords:)]) {
                [instanceVC requestOrderListForKeyWords:self.keyWord];
            }
        } else {
            id instanceVC=self.searchListVC;
            if ([instanceVC respondsToSelector:@selector(startSearchCategoryWithKeyWord:)]) {
                [instanceVC startSearchCategoryWithKeyWord:self.keyWord];
            }
        }
        [self saveSearchKeyword:textField.text];
        self.hitoryListView.hidden=YES;
    }
    
    return YES;
}

- (void)saveSearchKeyword:(NSString *)keyword{
    [self insertKeyword:keyword];
    if (self.keywordArray.count>50) {
        self.keywordArray=[[self.keywordArray subarrayWithRange:NSMakeRange(0, 50)] mutableCopy];
    }
    if (_searchListType.length > 0) {
        [FileController saveOrderArrayList:self.keywordArray FileUrl:@"orderSearchKeyWodsFile"];
    } else {
        [FileController saveOrderArrayList:self.keywordArray FileUrl:@"searchKeyWodsFile"];
    }
}

- (void)insertKeyword:(NSString *)keyword{
    int x=-1;
    for (int i=0;i<self.keywordArray.count;i++) {
        NSString * key=self.keywordArray[i];
        if ([key isEqualToString:keyword]) {
            x=i;
            break;
        }
    }
    if (x>=0&&x<self.keywordArray.count) {
        [self.keywordArray removeObjectAtIndex:x];
    }
    [self.keywordArray insertObject:keyword atIndex:0];
}

#pragma mark - <click Event>
- (void)searchClick:(id)sender{
    if (self.searchField.text.length>0) {
        [self.searchField resignFirstResponder];
        self.keyWord=self.searchField.text;
        if (_searchListType.length > 0) {
            id instanceVC=self.orderSearchListVC;
            if ([instanceVC respondsToSelector:@selector(requestOrderListForKeyWords:)]) {
                [instanceVC requestOrderListForKeyWords:self.keyWord];
            }
        } else {
            id instanceVC=self.searchListVC;
            if ([instanceVC respondsToSelector:@selector(startSearchCategoryWithKeyWord:)]) {
                [instanceVC startSearchCategoryWithKeyWord:self.keyWord];
            }
        }
        [self saveSearchKeyword:self.searchField.text];
        self.hitoryListView.hidden=YES;
    }
}
#pragma mark - <setter and getter>
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [_searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        _searchBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 0);
        [_searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchBtn addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (UIView *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width-110, kSearchBarHeight)];
        UIImageView * icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 15, 15)];
        icon.image=[UIImage bundleImageNamed:@"nav_icon_Search.png"];
        [_searchBar addSubview:icon];
        icon.sd_layout.leftSpaceToView(_searchBar, 20)
        .centerYEqualToView(_searchBar)
        .widthIs(15)
        .heightIs(15);
        UITextField * searchField=[[UITextField alloc] initWithFrame:CGRectZero];
        searchField.placeholder=@"请输入商品ID或关键字";
        _searchField=searchField;
        [_searchBar addSubview:searchField];
        _searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
        searchField.font=[UIFont systemFontOfSize:14];
        searchField.delegate=self;
        searchField.returnKeyType=UIReturnKeySearch;
        searchField.sd_layout.leftSpaceToView(icon, 10)
        .topSpaceToView(_searchBar, 0)
        .bottomSpaceToView(_searchBar, 0)
        .rightSpaceToView(_searchBar, 5);
        _searchBar.backgroundColor=[UIColor convertHexToRGB:@"EEEEEE"];
        _searchBar.layer.cornerRadius=kSearchBarHeight/2;
    }
    return _searchBar;
}
- (US_HistorySearchView *) hitoryListView{
    if (!_hitoryListView) {
        _hitoryListView=[[US_HistorySearchView alloc] init];
        [_hitoryListView setBackgroundColor:[UIColor convertHexToRGB:@"f2f2f2"]];
    }
    return _hitoryListView;
}

- (UleBaseViewController *)searchListVC{
    if (!_searchListVC) {
        Class class=[UIViewController getClassMapViewController:@"US_MyGoodsBatchManangerVC"];
        _searchListVC =[[class alloc] init];
        _searchListVC.m_Params=@{@"isSearchListVC":@YES}.mutableCopy;
        [_searchListVC hideCustomNavigationBar];
        _searchListVC.ignorePageLog=YES;
        [_searchListVC addObserver:self forKeyPath:@"hasGoodsList" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _searchListVC;
}
- (UleBaseViewController *)orderSearchListVC{
    if (!_orderSearchListVC) {
        Class class=[UIViewController getClassMapViewController:@"US_OrderListInfoVC"];
        _orderSearchListVC=[[class alloc] init];
        _orderSearchListVC.title=@"全部订单";
        _orderSearchListVC.m_Params=@{@"orderFlag":self.searchListType,@"orderListType":[self.m_Params objectForKey:@"orderListType"]}.mutableCopy;
        [_orderSearchListVC hideCustomNavigationBar];
        _orderSearchListVC.ignorePageLog=YES;
    }
    return _orderSearchListVC;
}
@end
