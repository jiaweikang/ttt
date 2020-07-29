//
//  US_MyGoodsListRootVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/18.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//
// 设备屏幕宽
#define kScreenW [[UIScreen mainScreen] bounds].size.width

#import "US_MyGoodsListRootVC.h"
#import "US_MyGoodsApi.h"
#import "US_GoodsCatergory.h"
#import "US_MyGoodsListVC.h"
#import "ProductManagerAlert.h"
#import "US_MenuPopOverView.h"


@interface US_MyGoodsListRootVC ()<US_MyGoodsListRootVCDelegate>
@property (nonatomic, strong) NSMutableArray * catergoryArray;
@property (nonatomic, strong) UIView * statusBarView;
@property (nonatomic, strong) UIButton * rightButton;
@property (nonatomic, assign) BOOL beginAnimation;
@property (nonatomic, strong) ProductManagerAlert * dropDownView;
@property (nonatomic, assign) BOOL showDropDownView;
@property (nonatomic, strong) UILabel * noteLabel;
@property (nonatomic, strong) UIButton * dropDownBtn;//
@property (nonatomic, assign) CGFloat lastOffsetX;
@property (nonatomic, strong) UIView * leftTitleView;//左边全部商品的底部view
@property (nonatomic, strong) UIImageView * leftTitleArrowView;
@property (nonatomic, assign) BOOL needUpdate;//
@end

@implementation US_MyGoodsListRootVC
#pragma mark - <LifeCyle>
- (instancetype)init{
    self = [super init];
    if (self) {
        self.hasNaviBar=YES;
        self.hasTabBar=NO;
        self.titleLayoutType=PageVCTitleAutoWidth;
        self.titleMarin=15;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.uleCustemNavigationBar customTitleLabel:@"我的商品"];
    self.uleCustemNavigationBar.rightBarButtonItems=@[self.rightButton];
    [self setTitleNormalColor:[UIColor convertHexToRGB:@"6D6D6D"] selectedColor:[UIColor redColor] andFont:[UIFont systemFontOfSize:15]];
    [self startRequestItemClassify];
    [self.view addSubview:self.statusBarView];
    
    [self.pageCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onCategoryUpdate:) name:NOTI_CategoryUpdate object:nil];
    self.ignorePageLog=NO;
}

- (void)dealloc{
    [self.pageCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.needUpdate) {
        [self startRequestItemClassify];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.needUpdate=NO;
}

#pragma mark - <Notify>
- (void)onCategoryUpdate:(NSNotification *)notify{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//         [self startRequestItemClassify];
//    });
    self.needUpdate=YES;
    
}

#pragma mark - <http>
- (void)startRequestItemClassify{
//    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_MyGoodsApi buildItemClassifyRequest:YES] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self handleCatergoryDataInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
}

- (void)handleCatergoryDataInfo:(NSDictionary *)dic{
    US_GoodsCatergory * catergoryInfo=[US_GoodsCatergory yy_modelWithDictionary:dic];
    for (UIViewController * vc in self.childViewControllers) {
        [vc removeFromParentViewController];
    }
    self.catergoryArray=[catergoryInfo.data.categoryItems mutableCopy];
    CategroyItem * firstItem=[[CategroyItem alloc] init];
    firstItem.categoryName=@"全部商品";
    [self.catergoryArray insertObject:firstItem atIndex:0];
    
    for (int i=0; i<self.catergoryArray.count; i++) {
        CategroyItem * item=self.catergoryArray[i];
        Class class=[UIViewController getClassMapViewController:@"US_MyGoodsListVC"];
        UleBaseViewController *vcInstance = [[class alloc]init];
        [vcInstance hideCustomNavigationBar];
        NSMutableDictionary * dic=[[NSMutableDictionary alloc] init];
        if (item) {
            [dic setObject:item forKey:@"CategoryItem"];
            [dic setObject:self forKey:@"Delegate"];
        }
        [vcInstance setM_Params:dic];
        vcInstance.title=item.categoryName;
        vcInstance.ignorePageLog=YES;
        [self addChildViewController:vcInstance];
    }
    [self resetTabListVCAtCurrentPageIndex:0];
    //**重新布局tab 添加一个按键以及一个固定title**//
    [self relayoutTitleView];
}

- (void)relayoutTitleView{
    [self.leftTitleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UILabel * title=self.lablesArray.firstObject;
    title.backgroundColor=[UIColor whiteColor];
    CGRect rect=title.frame;
    title.frame=CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height-20);
    UIView * line=[[UIView alloc] init];
    line.backgroundColor= [UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1];
    
    [self.titleView addSubview:self.leftTitleView];
    self.leftTitleView.sd_layout
    .leftSpaceToView(self.titleView, 0)
    .centerYEqualToView(self.titleView)
    .heightIs(40);
    [self.leftTitleView sd_addSubviews:@[title,self.leftTitleArrowView,line]];
    title.userInteractionEnabled=NO;
    title.sd_layout.centerYEqualToView(self.leftTitleView);
    self.leftTitleArrowView.sd_layout
    .leftSpaceToView(title, 5)
    .centerYEqualToView(self.leftTitleView)
    .widthIs(9)
    .heightIs(5);
    line.sd_layout
    .leftSpaceToView(self.leftTitleArrowView, self.titleMarin)
    .centerYEqualToView(self.leftTitleView)
    .widthIs(0.6)
    .heightIs(44-14);
    [self.leftTitleView setupAutoWidthWithRightView:line rightMargin:0];
    [self.leftTitleView updateLayout];
    CGFloat x=self.leftTitleView.right_sd+self.titleMarin;
    for (int i=1; i<self.lablesArray.count; i++) {
        UILabel * catergoryTitleLabel=[self.lablesArray objectAtIndex:i];
        CGRect catergoryTitleRect=catergoryTitleLabel.frame;
        [catergoryTitleLabel setFrame:CGRectMake(x, catergoryTitleRect.origin.y, catergoryTitleRect.size.width, catergoryTitleRect.size.height)];
        x=catergoryTitleLabel.right_sd+self.titleMarin;
    }
    CGFloat contentWith= x<kScreenW?kScreenW:x;
    self.titleScrollView.contentSize=CGSizeMake(contentWith, self.titleScrollView.frame.size.height);
    
    UIView * underLine= [self valueForKeyPath:@"underline"];
    underLine.width = title.width;
    underLine.centerX = title.centerX;
    
    
    [self.titleView addSubview:self.dropDownBtn];
    self.dropDownBtn.sd_layout.rightSpaceToView(self.titleView, 0)
    .topSpaceToView(self.titleView, 0)
    .bottomSpaceToView(self.titleView, 0)
    .widthIs(35);
    
    self.titleScrollView.frame=CGRectMake(0, 0, __MainScreen_Width-35, 44);
    self.titleScrollView.sd_layout.leftSpaceToView(self.titleView, 0)
    .topSpaceToView(self.titleView, 0)
    .bottomSpaceToView(self.titleView, 0)
    .rightSpaceToView(self.dropDownBtn, 0);
    [self.titleView updateLayout];
    [self.titleScrollView updateLayout];
    
    NSMutableArray * titles=[self.catergoryArray mutableCopy];
    [self.titleView addSubview:self.noteLabel];
    _noteLabel.sd_layout.leftSpaceToView(line, 0)
    .topSpaceToView(self.titleView, 0)
    .rightSpaceToView(self.dropDownBtn, 0)
    .bottomSpaceToView(self.titleView, 0);
    self.noteLabel.hidden=self.catergoryArray.count>1?YES:NO;
    
    ProductManagerAlert * dropDownAlert=[[ProductManagerAlert alloc] initWithTitles:titles andSelectTitle:[self currentPageTitle]];
    @weakify(self);
    dropDownAlert.selectBlock = ^(id obj, ManageClickType clickType) {
        @strongify(self);
        [self manageAlertClickTyep:clickType andObj:obj];
    };
    dropDownAlert.hiddenClick = ^{
        @strongify(self);
        self.showDropDownView=NO;
        self.dropDownBtn.selected=NO;
    };
    self.dropDownView=dropDownAlert;
    
}

- (void)moreCategoryClick:(UIButton *)sender{
    self.dropDownView.top_sd=self.titleView.bottom_sd+0.5;
    self.dropDownView.selectedTitle=[self currentPageTitle];
    if (self.showDropDownView==NO) {
        sender.selected=YES;
        [self.dropDownView showAtView:self.view belowView:self.titleView];
        self.showDropDownView=YES;
    }else{
        [self.dropDownView hiddenView:nil];
    }
}
- (NSString *) currentPageTitle{
    if (self.catergoryArray.count>0) {
        if (self.catergoryArray.count>self.currentPageIndex) {
            CategroyItem * item=self.catergoryArray[self.currentPageIndex];
            return item.categoryName;
        }
    }
    return @"";
}

- (void)manageAlertClickTyep:(ManageClickType)type andObj:(id)obj{
    if (type==ManageClickTypeSearch) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [self pushNewViewController:@"US_SearchCategoryVC" isNibPage:NO withData:nil];
        });
    }else if(type ==ManageClickTypeAddCategory){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pushNewViewController:@"US_MyGoodsCategoryManager" isNibPage:NO withData:nil];
        });
    }else if(type == ManageClickTypeCategory){
        NSInteger index=[obj integerValue];
        if (self.lablesArray.count>index) {
            [self pageSelect:index];
        }
    }
}

- (void)titleClickEventAtIndex:(NSInteger)index{
      [self.dropDownView hiddenView:nil];
}

#pragma mark - <ScrollerView delegate>
- (void) didScrollOlderOffset:(CGFloat)oldOffset newOffset:(CGFloat) newOffset{
    CGFloat newoffset_y =ceilf(newOffset);
    CGFloat oldOffset_y= oldOffset;
    if (self.beginAnimation==NO) {
        if (newoffset_y==0||(newoffset_y<0&&oldOffset_y<0)) {
            if (self.uleCustemNavigationBar.top_sd<0) {
                [self moveCustemNavigationBarTopY:0 hidden:NO];
            }
            return;
        }
        if (newoffset_y-oldOffset_y>15) {
            if (self.uleCustemNavigationBar.top_sd>=0) {
                [self moveCustemNavigationBarTopY:-self.uleCustemNavigationBar.height_sd hidden:YES];
            }
        }else if(oldOffset_y- newOffset>15) {
            if (self.uleCustemNavigationBar.top_sd<0) {
                [self moveCustemNavigationBarTopY:0 hidden:NO];
            }
        }

    }
}
//监听如果横向滑动页面，则显示导航栏
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        NSValue *newvalue = change[NSKeyValueChangeNewKey];
        CGFloat newoffsetX = newvalue.UIOffsetValue.horizontal;
        //如果是横向滑动时，将导航栏显示出来
        if (self.uleCustemNavigationBar.top_sd<0&&fabs(newoffsetX-self.lastOffsetX)>0) {
            [self moveCustemNavigationBarTopY:0 hidden:NO];
        }
        self.lastOffsetX=newoffsetX;
    }
}
#pragma mark - <button click>
- (void)rightClick:(UIButton *)sender{
    [self pushNewViewController:@"US_MyGoodsCategoryManager" isNibPage:NO withData:nil];
}

- (void)leftTitleSelect{
    if (self.currentPageIndex==0) {
        [self showCategoryListView];
    }
    else{
        [self pageSelect:0];
    }
}

- (void)showCategoryListView{
    UILabel * titleLab=self.lablesArray.firstObject;
    [self.leftTitleArrowView setImage:[UIImage bundleImageNamed:@"myGoods_icon_up"]];
    US_MenuPopOverView * view =[[US_MenuPopOverView alloc]initWithSuperView:self.leftTitleView MunuListArray:@[@"全部商品",@"自录商品",@"代理商品"] SelectTitle:titleLab.text];
    @weakify(self)
    view.clickBlock = ^(NSString * clickTitle) {
        titleLab.text=clickTitle;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"allMyCategoryListSelect" object:@{@"selectTitle":NonEmpty(clickTitle)}];
    };
    view.dismissBlock = ^{
        @strongify(self);
        [self.leftTitleArrowView setImage:[UIImage bundleImageNamed:@"myGoods_icon_down"]];
    };
}

#pragma mark - <UleNavigationBar Animal>
- (void) moveCustemNavigationBarTopY:(CGFloat)top hidden:(BOOL)isHidden{
    self.beginAnimation=YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.uleCustemNavigationBar.top_sd=top;
        self.titleView.top_sd=top==0?self.uleCustemNavigationBar.height_sd: kStatusBarHeight;
        self.titleView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, top==0?0:kStatusBarHeight);
        self.pageCollectionView.top_sd=self.titleView.bottom_sd;
    } completion:^(BOOL finished) {
        self.beginAnimation=NO;
    }];
    [self scrollViewToHiddenNavigationBar:isHidden];
}
- (void)noteClick:(UIGestureRecognizer *)reconizer{
    [self pushNewViewController:@"US_MyGoodsCategoryManager" isNibPage:NO withData:nil];
}

#pragma mark - <setter and getter>
- (NSMutableArray *)catergoryArray{
    if (!_catergoryArray) {
        _catergoryArray=[[NSMutableArray alloc] init];
    }
    return _catergoryArray;
}
- (UIView *)statusBarView{
    if (!_statusBarView) {
        _statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kStatusBarHeight)];
        _statusBarView.backgroundColor=kNavBarBackColor;
    }
    return _statusBarView;
}
- (UIButton *)rightButton{
    if (!_rightButton) {
        UIButton * btn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 65, 35)];
        [btn setTitle:@"我的分类" forState:UIControlStateNormal];
        btn.titleLabel.textAlignment=NSTextAlignmentRight;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightButton=btn;
    }
    return _rightButton;
}
- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel=[UILabel new];
        _noteLabel.textColor=[UIColor convertHexToRGB:@"6D6D6D"];
        _noteLabel.textAlignment=NSTextAlignmentCenter;
        _noteLabel.text=@"您还没有分类，快去添加分类吧";
        _noteLabel.font=[UIFont systemFontOfSize:14];
        _noteLabel.adjustsFontSizeToFitWidth=YES;
        _noteLabel.userInteractionEnabled=YES;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noteClick:)];
        [_noteLabel addGestureRecognizer:tap];
    }
    return _noteLabel;
}
- (UIButton *)dropDownBtn{
    if (!_dropDownBtn) {
        _dropDownBtn=[[UIButton alloc] initWithFrame:CGRectZero];
        [_dropDownBtn setImage:[UIImage bundleImageNamed:@"myGoods_btn_moreCategory"] forState:UIControlStateNormal];
        [_dropDownBtn setImage:[UIImage bundleImageNamed:@"myGoods_btn_categoryClose"] forState:UIControlStateSelected];
        [_dropDownBtn addTarget:self action:@selector(moreCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView * line2=[[UIView alloc] initWithFrame:CGRectZero];
        line2.backgroundColor=[UIColor colorWithRed:0xD0/255.0f green:0xD0/255.0f blue:0xD0/255.0f alpha:1];
        [_dropDownBtn addSubview:line2];
        line2.sd_layout.leftSpaceToView(_dropDownBtn, 0)
        .topSpaceToView(_dropDownBtn, 0)
        .bottomSpaceToView(_dropDownBtn, 0)
        .widthIs(0.6);
        
    }
    return _dropDownBtn;
}
- (UIView *)leftTitleView{
    if (!_leftTitleView) {
        _leftTitleView=[[UIView alloc] initWithFrame:CGRectZero];
        _leftTitleView.backgroundColor=[UIColor whiteColor];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTitleSelect)];
        _leftTitleView.userInteractionEnabled=YES;
        [_leftTitleView addGestureRecognizer:tap];
    }
    return _leftTitleView;
}
- (UIImageView *)leftTitleArrowView{
    if (!_leftTitleArrowView) {
        _leftTitleArrowView=[[UIImageView alloc] initWithImage:[UIImage bundleImageNamed:@"myGoods_icon_down"]];
    }
    return _leftTitleArrowView;
}

@end
