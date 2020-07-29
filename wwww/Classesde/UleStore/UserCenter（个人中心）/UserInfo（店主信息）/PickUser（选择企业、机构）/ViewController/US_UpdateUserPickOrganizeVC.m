//
//  US_UpdateUserPickOrganizeVC.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UpdateUserPickOrganizeVC.h"
#import "US_PresentAnimaiton.h"
#import "UpdateUserPickViewModel.h"
#import "UIView+Shade.h"
#import "NSString+Addition.h"

@interface US_UpdateUserPickOrganizeVC ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) US_PresentAnimaiton * animation;
@property (nonatomic, copy) NSString        *mOrgType;
@property (nonatomic, copy) NSString        *mOrgName;
@property (nonatomic, assign) UpdateUserType        mUserType;
@property (nonatomic, strong) UILabel       *mTopTitleLab;
@property (nonatomic, strong) UIButton      *closeBtn;
@property (nonatomic, strong) UILabel       *lastOrganLab;
@property (nonatomic, strong) UIButton      *lastOrganBtn;
@property (nonatomic, strong) UIButton      *mConfirmBtn;
@property (nonatomic, strong) UIButton      *nextOrganBtn;
@property (nonatomic, strong) CAGradientLayer *mConfirmBtnLayer;

@property (nonatomic, strong) UICollectionView  *mCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout    *layout;
@property (nonatomic, strong) UpdateUserPickViewModel   *mViewModel;

@property (nonatomic, strong) NSString      *identifierTips;
@end

@implementation US_UpdateUserPickOrganizeVC
- (instancetype)initWithOrgType:(NSString *)pickOrgType andOrgName:(NSString *)orgName andUserType:(UpdateUserType)userType identifierTips:(NSString *)identifierTips{
    self = [super init];
    if (self) {
        _mOrgType=pickOrgType;
        _mOrgName=orgName;
        _mUserType=userType;
        _identifierTips=identifierTips;
        _animation = [[US_PresentAnimaiton alloc] initWithAnimationType:AniamtionSheetType targetViewSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-0,kStatusBarHeight>20?KScreenScale(870)+34:KScreenScale(870))];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate=self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCornerCircle];
    self.uleCustemNavigationBar.height_sd=0;
    self.uleCustemNavigationBar.rightBarButtonItems=nil;
    self.uleCustemNavigationBar.leftBarButtonItems=nil;
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.lastOrganLab];
    [self.view addSubview:self.lastOrganBtn];
    [self.view addSubview:self.mTopTitleLab];
    self.closeBtn.sd_layout.topSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .widthIs(24)
    .heightIs(24);
    self.lastOrganLab.sd_layout.centerYEqualToView(self.closeBtn)
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.closeBtn, 5)
    .heightIs(20);
    self.lastOrganBtn.sd_layout.topSpaceToView(self.closeBtn, 15)
    .rightEqualToView(self.closeBtn)
    .widthIs(60)
    .heightIs(20);
    self.mTopTitleLab.sd_layout.topEqualToView(self.lastOrganBtn)
    .leftSpaceToView(self.view, 15)
    .bottomEqualToView(self.lastOrganBtn)
    .rightSpaceToView(self.lastOrganBtn, 5);
    [self.view addSubview:self.mConfirmBtn];
    [self.view addSubview:self.nextOrganBtn];
    CGFloat btnWidth=(__MainScreen_Width-45)*0.5;
    self.mConfirmBtn.sd_layout.bottomSpaceToView(self.view, kStatusBarHeight>20?7+34:7)
    .leftSpaceToView(self.view, 15)
    .widthIs(btnWidth)
    .heightIs(40);
    self.nextOrganBtn.sd_layout.topEqualToView(self.mConfirmBtn)
    .leftSpaceToView(self.mConfirmBtn, 15)
    .widthIs(btnWidth)
    .heightIs(40);
    [self.view addSubview:self.mCollectionView];
    self.mCollectionView.sd_layout.topSpaceToView(self.mTopTitleLab, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.mConfirmBtn, 5);
    self.mViewModel.postOrgType=[self getCurrentChinaPostOrgType];
    self.mTopTitleLab.text=@"所属机构";
    if ([NSString isNullToString:self.identifierTips].length > 0) {
        self.mTopTitleLab.text=[NSString stringWithFormat:@"所属机构  %@", [NSString isNullToString:self.identifierTips]];
        self.mTopTitleLab.attributedText=[self.mTopTitleLab.text setSubStrings:@[[NSString isNullToString:self.identifierTips]] showWithFont:[UIFont systemFontOfSize:12] color:@"ef3b39"];
    }
    @weakify(self);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        @strongify(self);
        if (returnValue==nil) {
            [self resetConfirmBtn:YES];
        }else{
            [self.mCollectionView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
                [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:sectionModel.cellArray.count-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
            });
        }
    } faildBlock:^(id errorCode) {
        @strongify(self);
        [self showErrorHUDWithError:errorCode];
    }];
    self.mViewModel.didEndScrollBlock = ^(CGFloat offsetX) {
        @strongify(self);
        NSUInteger currentPage=offsetX/__MainScreen_Width;
        BOOL isFirstPage=currentPage==0;
        self.lastOrganBtn.hidden=isFirstPage;
        if (isFirstPage) {
            self.lastOrganLab.text=[NSString stringWithFormat:@"所在企业：%@",self.mOrgName];
        }
        else {
            NSString *lastOrganName=[self.mViewModel getLastOrganizeName:currentPage-1];
            if (lastOrganName.length>0) {
                self.lastOrganLab.text=[NSString stringWithFormat:@"上级机构：%@",lastOrganName];
            }
        }
        UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
        if (currentPage<sectionModel.cellArray.count-1) {
            [self resetConfirmBtn:NO];
        }
    };
    self.mViewModel.didSelectNew = ^{
        @strongify(self);
        [self resetConfirmBtn:NO];
    };
    self.ignorePageLog=YES;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.mUserType==UpdateUserTypeAuth||self.mUserType==UpdateUserTypeAuthInReview) {
        [self.mViewModel addUserAuthDefaultData];
    }else {
        [self.mViewModel loadOrganizeInfoWithParentId:self.mOrgType andLevelName:@"省"];
    }
}

- (void)resetConfirmBtn:(BOOL)isLengthen{
    if (isLengthen) {
        self.nextOrganBtn.hidden=YES;
        self.mConfirmBtn.sd_layout.widthIs(__MainScreen_Width-30);
        [self.mConfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.mConfirmBtn.layer addSublayer:self.mConfirmBtnLayer];
    }else {
        self.nextOrganBtn.hidden=NO;
        self.mConfirmBtn.sd_layout.widthIs((__MainScreen_Width-45)*0.5);
        [self.mConfirmBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
        [self.mConfirmBtnLayer removeFromSuperlayer];
    }
}

- (void)setCornerCircle{
    self.view.backgroundColor=[UIColor whiteColor];
    self.view.clipsToBounds=YES;
    //    绘制圆角 要设置的圆角 使用“|”来组合
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    //设置大小
    maskLayer.frame = self.view.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
}

- (void)closeBtnAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//返回上级
- (void)lastOrganBtnAction{
    NSInteger currentPage = self.mCollectionView.contentOffset.x/__MainScreen_Width;
    if (currentPage>0) {
        [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
    }
}
//确认修改
- (void)confirmBtnAction{
    if ([NSString isNullToString:self.mViewModel.org_provinceId].length==0) {
        [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择所属机构" afterDelay:1.5];
        return;
    }
    NSInteger currentPage = self.mCollectionView.contentOffset.x/__MainScreen_Width;
    switch (currentPage) {
        case 0:
            self.mViewModel.org_cityId=@"";
            self.mViewModel.org_countryId=@"";
            self.mViewModel.org_subStationId=@"";
            self.mViewModel.org_cityName=@"";
            self.mViewModel.org_countryName=@"";
            self.mViewModel.org_subStationName=@"";
            break;
        case 1:
            if ([NSString isNullToString:self.mViewModel.org_cityId].length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择所属机构" afterDelay:1.5];
                return;
            }
            self.mViewModel.org_countryId=@"";
            self.mViewModel.org_subStationId=@"";
            self.mViewModel.org_countryName=@"";
            self.mViewModel.org_subStationName=@"";
            break;
        case 2:
            if ([NSString isNullToString:self.mViewModel.org_countryId].length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择所属机构" afterDelay:1.5];
                return;
            }
            self.mViewModel.org_subStationId=@"";
            self.mViewModel.org_subStationName=@"";
            break;
        case 3:
            if ([NSString isNullToString:self.mViewModel.org_subStationId].length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择所属机构" afterDelay:1.5];
                return;
            }
            break;
        default:
            break;
    }
    
    NSString *currentOrganName=[self.mViewModel getCurrentOrganizationNameLowest];
    NSDictionary *userInfo=@{@"provinceId":[NSString isNullToString:self.mViewModel.org_provinceId],
                             @"cityId":[NSString isNullToString:self.mViewModel.org_cityId],
                             @"countryId":[NSString isNullToString:self.mViewModel.org_countryId],
                             @"subStationId":[NSString isNullToString:self.mViewModel.org_subStationId],
                             @"provinceName":[NSString isNullToString:self.mViewModel.org_provinceName],
                             @"cityName":[NSString isNullToString:self.mViewModel.org_cityName],
                             @"countryName":[NSString isNullToString:self.mViewModel.org_countryName],
                             @"subStationName":[NSString isNullToString:self.mViewModel.org_subStationName],
                             @"organizeName":[NSString isNullToString:currentOrganName]
                             };
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UpdateUserPickConfirm object:self userInfo:userInfo];
    }];
}
//我去下级
- (void)nextOrganBtnAction{
    NSInteger currentPage = self.mCollectionView.contentOffset.x/__MainScreen_Width;
    UleSectionBaseModel *sectionModel=[self.mViewModel.mDataArray firstObject];
    if (sectionModel.cellArray.count>currentPage+1) {
        [self.mCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:YES];
        return;
    }
    
    NSString *currentParentID=@"";
    NSString *currentLevelName=@"";
    switch (currentPage) {
        case 0:
        {
            NSString *provinceId=[NSString isNullToString:self.mViewModel.org_provinceId];
            if (provinceId.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
            currentParentID=provinceId;
            currentLevelName=@"市";
        }
            break;
        case 1:
        {
            NSString *cityId=[NSString isNullToString:self.mViewModel.org_cityId];
            if (cityId.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
            currentParentID=cityId;
            currentLevelName=@"县";
        }
            break;
        case 2:
        {
            NSString *countryId=[NSString isNullToString:self.mViewModel.org_countryId];
            if (countryId.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
            currentParentID=countryId;
            currentLevelName=@"支局";
        }
            break;
        case 3:
        {
            NSString *subStationId=[NSString isNullToString:self.mViewModel.org_subStationId];
            if (subStationId.length==0) {
                [UleMBProgressHUD showHUDAddedTo:self.view withText:@"请选择当前等级机构" afterDelay:1.5];
                return;
            }
//            [UleMBProgressHUD showHUDAddedTo:self.view withText:@"没有下一级机构" afterDelay:1.5];
            [self resetConfirmBtn:YES];
            return;
        }
            break;
            
        default:
            break;
    }
    [self.mViewModel loadOrganizeInfoWithParentId:currentParentID andLevelName:currentLevelName];
}
#pragma mark - <UIViewControllerTransitioningDelegate>
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  _animation;
}

#pragma mark - <getters>
- (NSString *)getCurrentChinaPostOrgType
{
    NSString *chinaPostOrgType=@"";
    if ([self.mOrgType isEqualToString:@"100"]) {
        chinaPostOrgType=@"0";
    }else {
        chinaPostOrgType=@"2";
    }
    return chinaPostOrgType;
}
- (UILabel *)mTopTitleLab{
    if (!_mTopTitleLab) {
        _mTopTitleLab=[[UILabel alloc]init];
        _mTopTitleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        _mTopTitleLab.font=[UIFont systemFontOfSize:14];
        _mTopTitleLab.adjustsFontSizeToFitWidth=YES;
    }
    return _mTopTitleLab;
}
-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage bundleImageNamed:@"UpdateUserInfo_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}
- (UIButton *)lastOrganBtn{
    if (!_lastOrganBtn) {
        _lastOrganBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_lastOrganBtn setTitle:@"返回上级" forState:UIControlStateNormal];
        [_lastOrganBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
        _lastOrganBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [_lastOrganBtn addTarget:self action:@selector(lastOrganBtnAction) forControlEvents:UIControlEventTouchUpInside];
        _lastOrganBtn.hidden=YES;
    }
    return _lastOrganBtn;
}
- (UILabel *)lastOrganLab{
    if (!_lastOrganLab) {
        _lastOrganLab=[[UILabel alloc]init];
        _lastOrganLab.textColor=[UIColor convertHexToRGB:@"333333"];
        _lastOrganLab.font=[UIFont systemFontOfSize:14];
        _lastOrganLab.text=[NSString stringWithFormat:@"所在企业：%@", self.mOrgName];
    }
    return _lastOrganLab;
}
- (UIButton *)mConfirmBtn{
    if (!_mConfirmBtn) {
        _mConfirmBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_mConfirmBtn setTitle:@"确认机构" forState:UIControlStateNormal];
        [_mConfirmBtn setTitleColor:[UIColor convertHexToRGB:@"ef3b39"] forState:UIControlStateNormal];
        _mConfirmBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _mConfirmBtn.sd_cornerRadiusFromHeightRatio=@(0.5);
        _mConfirmBtn.layer.borderColor=[UIColor convertHexToRGB:@"ef3b39"].CGColor;
        _mConfirmBtn.layer.borderWidth=1.0;
        [_mConfirmBtn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mConfirmBtn;
}
- (CAGradientLayer *)mConfirmBtnLayer{
    if (!_mConfirmBtnLayer) {
        _mConfirmBtnLayer=[UIView setGradualSizeChangingColor:CGSizeMake(__MainScreen_Width-30, 40) fromColor:[UIColor convertHexToRGB:@"FE5F45"] toColor:[UIColor convertHexToRGB:@"FD2448"] gradualType:GradualTypeHorizontal];
        _mConfirmBtnLayer.zPosition=-1;
    }
    return _mConfirmBtnLayer;
}
- (UIButton *)nextOrganBtn{
    if (!_nextOrganBtn) {
        _nextOrganBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _nextOrganBtn.frame=CGRectMake(0, 0, (__MainScreen_Width-45)*0.5, 40);
        [_nextOrganBtn setTitle:@"继续选择下级" forState:UIControlStateNormal];
        [_nextOrganBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nextOrganBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _nextOrganBtn.sd_cornerRadiusFromHeightRatio=@(0.5);
        CAGradientLayer * layer=[UIView setGradualChangingColor:_nextOrganBtn fromColor:[UIColor convertHexToRGB:@"FE5F45"] toColor:[UIColor convertHexToRGB:@"FD2448"] gradualType:GradualTypeHorizontal];
        [_nextOrganBtn.layer addSublayer:layer];
        layer.zPosition=-1;
        [_nextOrganBtn addTarget:self action:@selector(nextOrganBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextOrganBtn;
}
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        _mCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _mCollectionView.scrollEnabled=NO;
        _mCollectionView.pagingEnabled = YES;
        _mCollectionView.showsHorizontalScrollIndicator = NO;
        _mCollectionView.bounces = NO;
        _mCollectionView.delegate = self.mViewModel;
        _mCollectionView.dataSource = self.mViewModel;
        _mCollectionView.scrollsToTop = NO;
        if (@available(iOS 10.0, *)) {
            _mCollectionView.prefetchingEnabled=NO;
        }
        [_mCollectionView registerClass:NSClassFromString(@"UpdateUserPickCollectionCell") forCellWithReuseIdentifier:@"UpdateUserPickCollectionCell"];
        _mCollectionView.backgroundColor=[UIColor whiteColor];
        if (@available(iOS 11.0, *)) {
            _mCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _mCollectionView;
}
- (UICollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout=[[UICollectionViewFlowLayout alloc] init];
        _layout.minimumInteritemSpacing = 0;
        _layout.minimumLineSpacing = 0;
        CGFloat height=KScreenScale(870)-74-54;
        _layout.itemSize=CGSizeMake(__MainScreen_Width, kStatusBarHeight>20?height-34:height);
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}
- (UpdateUserPickViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UpdateUserPickViewModel alloc]init];
        _mViewModel.rootVC=self;
    }
    return _mViewModel;
}
@end
