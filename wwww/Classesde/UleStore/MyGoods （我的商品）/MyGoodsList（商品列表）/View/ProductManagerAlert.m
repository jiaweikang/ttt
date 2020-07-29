//
//  ProductManagerAlert.m
//  TestGif
//
//  Created by uleczq on 2017/6/21.
//  Copyright © 2017年 ule. All rights reserved.
//

#import "ProductManagerAlert.h"
#import <UIView+SDAutoLayout.h>
#import "US_GoodsCatergory.h"
//#import "UIButton+Extend.h"
#define kAlertHeight 380
#define kSearchBarHeight 34
#define kTitleButtonH 30
#define kGap 20   
#define kEmptyImageHeight 180   //分类数为0时，默认提示页面的高度
#define kTitleScrollMaxHeight 235  //分类ScrollView的最大高度，显示4行半
#define KBottomHeight kSearchBarHeight+kGap*2  //底部视图高度（搜索+未分类+中间间隔）
@interface ProductManagerAlert ()<UITextFieldDelegate>
@property (nonatomic, strong) UIScrollView * titleScrollView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIView * searchBar;
@property (nonatomic, strong) UIButton * noCategoryBtn;
@property (nonatomic, strong) UILabel * totalCountLabel;
@property (nonatomic, strong) NSArray * titelArray;
@property (nonatomic, strong) NSMutableArray * titleBtnArray;
@property (nonatomic, assign) CGRect btnRect;
@property (nonatomic, strong) UIView * emptyView;
@end

@implementation ProductManagerAlert

- (instancetype)initWithTitles:(NSArray *)titles andSelectTitle:(NSString *)selectTitle{
    self= [super initWithFrame:CGRectMake(0, [[NSUserDefaults standardUserDefaults] boolForKey:@"isHideNavigation"] ? 60 : 40, __MainScreen_Width, __MainScreen_Height)];
    if (self) {
        self.titelArray=titles;
        self.selectedTitle=selectTitle;
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    [self addSubview:self.bgView];
    [self addSubview:self.contentView];
    self.bgView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    [self layoutContentView];
    
}

- (void)layoutContentView{

    [self.contentView addSubview:self.titleScrollView];
    _bottomView=[[UIView alloc] initWithFrame:CGRectZero];

    [self.contentView addSubview:self.bottomView];
    self.bottomView.sd_layout.leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.contentView, 0)
    .heightIs(KBottomHeight);

    self.titleScrollView.sd_layout.topSpaceToView(self.contentView, 0)
    .leftSpaceToView(self.contentView, 0)
    .rightSpaceToView(self.contentView, 0)
    .bottomSpaceToView(self.bottomView, 0);
    
    [self layoutTitlesView];
    [self layoutBottomView];
}

- (void)layoutBottomView{
    UIView * line=[[UIView alloc] initWithFrame:CGRectZero];
    line.backgroundColor=[UIColor convertHexToRGB:@"E6E6E6"];
    UIView * line2=[[UIView alloc] initWithFrame:CGRectZero];
    line2.backgroundColor=[UIColor convertHexToRGB:@"E6E6E6"];
    [self.bottomView sd_addSubviews:@[self.noCategoryBtn,self.totalCountLabel,self.searchBar,line,line2]];

    self.searchBar.sd_layout.leftSpaceToView(self.bottomView, 20)
    .rightSpaceToView(self.bottomView, 20)
    .bottomSpaceToView(self.bottomView, 20)
    .heightIs(kSearchBarHeight);
    
//    self.noCategoryBtn.sd_layout.leftSpaceToView(self.bottomView, 10)
//    .bottomSpaceToView(self.searchBar, 40)
//    .widthRatioToView(self.bottomView, 0.5)
//    .heightIs(kTitleButtonH);
//    
//    self.totalCountLabel.sd_layout.rightSpaceToView(self.bottomView, 0)
//    .leftSpaceToView(self.noCategoryBtn, 0)
//    .bottomEqualToView(self.noCategoryBtn)
//    .heightIs(kTitleButtonH);
    
    line.sd_layout.leftSpaceToView(self.bottomView, 0)
    .rightSpaceToView(self.bottomView, 0)
    .topSpaceToView(self.bottomView, 0)
    .heightIs(0.5);
//    line2.sd_layout.leftSpaceToView(self.bottomView, 0)
//    .rightSpaceToView(self.bottomView, 0)
//    .topSpaceToView(self.noCategoryBtn, 20)
//    .heightIs(0.5);

}


- (void)layoutTitlesView{
    float x=10;
    float y=20;
    float width=(__MainScreen_Width-40)/2.0;
    float height=kTitleButtonH;
    float maxHeight=30;
    if (self.titleBtnArray) {
        [self.titleBtnArray removeAllObjects];
    }else{
        _titleBtnArray=[NSMutableArray array];
    }
    NSInteger totoal=0;
    for (int i=1; i<self.titelArray.count; i++) {
        CategroyItem * item=self.titelArray[i];
        UIButton * titleButton=[self buildTitleButtonWithFrame:CGRectMake(x, y, width, height) andTitle:item.categoryName];
        titleButton.tag=i;
        [self.titleScrollView addSubview:titleButton];
        y=(i-1)%2!=0?titleButton.bottom_sd+kGap:y;
        x=(i-1)%2!=0?10:titleButton.right_sd+kGap;
        maxHeight=titleButton.bottom_sd+kGap;
        if ([self.selectedTitle isEqualToString:item.categoryName]) {
            titleButton.selected=YES;
            self.btnRect = titleButton.frame;
        }
        NSInteger records=[item.totalRecords integerValue];
        if (records>0) {
            totoal+=records;
        }
        [_titleBtnArray addObject:titleButton];
    }
    if (self.titelArray.count<=1) {
        [self.titleScrollView addSubview:self.emptyView];
        maxHeight=self.emptyView.height_sd;
    }
    CGFloat scroContentHeight=maxHeight;
    if (maxHeight>kTitleScrollMaxHeight) {
        maxHeight=kTitleScrollMaxHeight;
    }
    self.contentView.height_sd=maxHeight+KBottomHeight;
    self.titleScrollView.contentSize=CGSizeMake(__MainScreen_Width, scroContentHeight);
    
        [self.titleScrollView scrollRectToVisible:CGRectMake(0, self.btnRect.origin.y-50, __MainScreen_Width, 30) animated:YES];
    
}

- (void)setSelectedTitle:(NSString *)selectedTitle{
    _selectedTitle=selectedTitle;
    for (int i=0; i<self.titleBtnArray.count; i++) {
        UIButton * titleBtn=self.titleBtnArray[i];
        if ([_selectedTitle isEqualToString:titleBtn.titleLabel.text]) {
            titleBtn.selected=YES;
        }else{
            titleBtn.selected=NO;
        }
    }
}

- (UIButton *) buildTitleButtonWithFrame:(CGRect)frame andTitle:(NSString *)title{
    UIButton * titleButton=[[UIButton alloc] initWithFrame:frame];
    [titleButton setTitle:title forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor convertHexToRGB:@"6D6D6D"] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [titleButton addTarget:self action:@selector(titleSelect:) forControlEvents:UIControlEventTouchUpInside];
    titleButton.titleLabel.font=[UIFont systemFontOfSize:15];
    return titleButton;
}

- (void)titleSelect:(UIButton *)sender{
    for (int i=0; i<self.titleBtnArray.count; i++) {
        UIButton * btn=self.titleBtnArray[i];
        btn.selected=NO;
    }
    sender.selected=YES;
    NSInteger index=sender.tag;
    if (index==-100) {
        self.selectBlock(nil, ManageClickTypeNoCategory);
    }else{
        self.selectBlock(@(index), ManageClickTypeCategory);
    }
    
    [self hiddenView:nil];
}

- (void)showAtView:(UIView *)rootView belowView:(UIView *)topView{
    [rootView insertSubview:self belowSubview:topView];
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.top_sd=0;
        self.bgView.alpha=0.3;
    }];
}

- (void)hiddenView:(UIGestureRecognizer *)recognize{
    if (self.hiddenClick) {
        self.hiddenClick();
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.top_sd=-self.contentView.height_sd;
        self.bgView.alpha=0.0;
    } completion:^(BOOL finished) {
          [self removeFromSuperview];
    }];
  
}

- (void)addCategoryClick:(id)sender{
    if (self.selectBlock) {
        self.selectBlock(nil, ManageClickTypeAddCategory);
        [self hiddenView:nil];
    }
}

#pragma mark - TextField delegate
-(void)searchClick:(UIGestureRecognizer *)recognizer{
    self.selectBlock(nil, ManageClickTypeSearch);
    [self hiddenView:nil];
}

#pragma mark - setter and getter
- (UIView *)bgView{
    if (!_bgView) {
        _bgView=[[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor=[UIColor blackColor];
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenView:)];
        [_bgView addGestureRecognizer:tap];
        _bgView.alpha=0.0;
    }
    return _bgView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView=[[UIView alloc] initWithFrame:CGRectMake(0, -kAlertHeight, __MainScreen_Width, kAlertHeight)];
        _contentView.backgroundColor=[UIColor whiteColor];
    }
    return _contentView;
}

- (UIView *)searchBar{
    if (!_searchBar) {
        _searchBar=[[UIView alloc] init];
        UIImageView * icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 15, 15)];
        icon.image=[UIImage bundleImageNamed:@"goods_icon_search.png"];
        [_searchBar addSubview:icon];
        UITextField * searchField=[[UITextField alloc] initWithFrame:CGRectZero];
        searchField.placeholder=@"点击搜索商品";
        searchField.enabled=NO;
        [_searchBar addSubview:searchField];
        searchField.font=[UIFont systemFontOfSize:14];
        searchField.delegate=self;
        searchField.sd_layout.centerXEqualToView(_searchBar)
        .centerYEqualToView(_searchBar)
        .heightIs(30)
        .widthIs(90);
        icon.sd_layout.rightSpaceToView(searchField, 5)
        .centerYEqualToView(_searchBar)
        .widthIs(15)
        .heightIs(15);
        _searchBar.backgroundColor=[UIColor convertHexToRGB:@"EEEEEE"];
        _searchBar.layer.cornerRadius=kSearchBarHeight/2;
        UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchClick:)];
        [_searchBar addGestureRecognizer:tap];
    }
    return _searchBar;
}

- (UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        _titleScrollView=[[UIScrollView alloc] init];
    }
    return _titleScrollView;
}

- (UILabel *) buildCustemLabelWithTitle:(NSString *)title{
    UILabel * label=[[UILabel alloc] init];
    label.textColor=[UIColor convertHexToRGB:@"6D6D6D"];
    label.font=[UIFont systemFontOfSize:16];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=title;
    return label;
}

- (UIView *)emptyView{
    if (!_emptyView) {
        _emptyView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width, kEmptyImageHeight)];
        UIImageView * icon=[[UIImageView alloc] initWithFrame:CGRectZero];
        icon.image=[UIImage bundleImageNamed:@"myGoods_icon_openbox"];
        [_emptyView addSubview:icon];
        icon.sd_layout.centerXEqualToView(_emptyView)
        .topSpaceToView(_emptyView, 20)
        .widthIs(70)
        .heightIs(70);
        UILabel *titleLabel=[self buildCustemLabelWithTitle:@"您还没有分类"];
        [_emptyView addSubview:titleLabel];
        titleLabel.sd_layout.leftSpaceToView(_emptyView, 0)
        .rightSpaceToView(_emptyView, 0)
        .topSpaceToView(icon, 10)
        .heightIs(30);
        UIButton *subTitle=[[UIButton alloc]initWithFrame:CGRectZero];
        [subTitle addTarget:self action:@selector(addCategoryClick:) forControlEvents:UIControlEventTouchUpInside];
        [subTitle setTitle:@"添加分类" forState:UIControlStateNormal];
        [subTitle.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [subTitle setTitleColor:[UIColor convertHexToRGB:@"83B5F1"] forState:UIControlStateNormal];
        subTitle.layer.borderColor=[UIColor redColor].CGColor;
        subTitle.layer.borderWidth=1.0;
        subTitle.layer.cornerRadius=3.0;
        [subTitle setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_emptyView addSubview:subTitle];
        subTitle.sd_layout.centerXEqualToView(_emptyView)
        .topSpaceToView(titleLabel, 0)
        .heightIs(25)
        .widthIs(70);
    }
    return _emptyView;
}

- (UIButton *)noCategoryBtn{
    if (!_noCategoryBtn) {
        _noCategoryBtn=[self buildTitleButtonWithFrame:CGRectZero andTitle:@"未分类商品"];
        _noCategoryBtn.tag=-100;
    }
    return _noCategoryBtn;
}

- (UILabel *)totalCountLabel{
    if (!_totalCountLabel) {
        _totalCountLabel=[[UILabel alloc] init];
        _totalCountLabel.textAlignment=NSTextAlignmentCenter;
        _totalCountLabel.textColor=[UIColor convertHexToRGB:@"6D6D6D"];
        _totalCountLabel.font=[UIFont systemFontOfSize:15.0f];
    }
    return _totalCountLabel;
}
@end
