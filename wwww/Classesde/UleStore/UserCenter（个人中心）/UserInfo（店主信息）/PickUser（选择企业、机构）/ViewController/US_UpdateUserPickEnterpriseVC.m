//
//  US_UpdateUserPickEnterpriseVC.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UpdateUserPickEnterpriseVC.h"
#import "US_PresentAnimaiton.h"
#import "UpdateUserPickViewModel.h"
#import "US_LoginApi.h"
#import "UIView+Shade.h"
#import "UpdateUserHeaderModel.h"

@interface US_UpdateUserPickEnterpriseVC ()<UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) US_PresentAnimaiton * animation;
@property (nonatomic, strong) UIView    *mTopView;
@property (nonatomic, strong) UITableView   *mTableview;
@property (nonatomic, strong) UpdateUserPickViewModel   *mViewModel;
@property (nonatomic, strong) UIButton      *mBottomBtn;
@end

@implementation US_UpdateUserPickEnterpriseVC
- (instancetype)init {
    self = [super init];
    if (self) {
        _animation = [[US_PresentAnimaiton alloc] initWithAnimationType:AniamtionSheetType targetViewSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-0,kStatusBarHeight>20?KScreenScale(550)+34:KScreenScale(550))];
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate=self;
        @weakify(self);
        _animation.clicBlock = ^{
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        };
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setCornerCircle];
    self.uleCustemNavigationBar.height_sd=0;
    self.uleCustemNavigationBar.rightBarButtonItems=nil;
    self.uleCustemNavigationBar.leftBarButtonItems=nil;
    [self.view addSubview:self.mTopView];
    [self.view addSubview:self.mTableview];
    [self.view addSubview:self.mBottomBtn];
    self.mBottomBtn.sd_layout.leftSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, kStatusBarHeight>20?5+34:5)
    .widthIs(__MainScreen_Width-20)
    .heightIs(40);
    self.mTableview.sd_layout.topSpaceToView(self.mTopView,0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .bottomSpaceToView(self.mBottomBtn, 0);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        [self.mTableview reloadData];
    } faildBlock:^(id errorCode) {
    }];
    [self startRequestEnterpriseData];
    self.ignorePageLog=YES;
}

- (void)startRequestEnterpriseData{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@""];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_LoginApi buildPostEnterpriseInfo] success:^(id responseObject) {
        @strongify(self);
        [self.mViewModel fetchEnterpriseData:responseObject];
        [UleMBProgressHUD hideHUDForView:self.view];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
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

- (void)mBottomBtnAction{
    if (self.mViewModel.enter_lastSelectedCellModel) {
        NSString *entName=[NSString isNullToString:self.mViewModel.enter_lastSelectedCellModel.contentStr];
        NSString *entId=[NSString isNullToString:self.mViewModel.enter_lastSelectedCellModel._id];
        NSDictionary *params=@{@"enterpriseName":entName,
                               @"enterpriseID":entId};
        [self dismissViewControllerAnimated:YES completion:^{
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_UpdateUserPickConfirm object:self userInfo:params];
        }];
    }else {
        [UleMBProgressHUD showHUDWithText:@"请选择所属企业" afterDelay:1.5];
    }
    
}

#pragma mark - <UIViewControllerTransitioningDelegate>
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _animation;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  _animation;
}

#pragma mark - <getters>
- (UIView *)mTopView{
    if (!_mTopView) {
        _mTopView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KScreenScale(70))];
        UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, CGRectGetWidth(_mTopView.frame)-15, CGRectGetHeight(_mTopView.frame))];
        titleLab.text=@"所属企业";
        titleLab.textColor=[UIColor convertHexToRGB:@"666666"];
        titleLab.font=[UIFont systemFontOfSize:14];
        [_mTopView addSubview:titleLab];
    }
    return _mTopView;
}
- (UIButton *)mBottomBtn{
    if (!_mBottomBtn) {
        _mBottomBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _mBottomBtn.frame=CGRectMake(0, 0, __MainScreen_Width-20, 40);
        [_mBottomBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [_mBottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _mBottomBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        _mBottomBtn.sd_cornerRadiusFromHeightRatio=@(0.5);
        CAGradientLayer * layer=[UIView setGradualChangingColor:_mBottomBtn fromColor:[UIColor convertHexToRGB:@"FE5F45"] toColor:[UIColor convertHexToRGB:@"FD2448"] gradualType:GradualTypeHorizontal];
        [_mBottomBtn.layer addSublayer:layer];
        layer.zPosition=-1;
        [_mBottomBtn addTarget:self action:@selector(mBottomBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mBottomBtn;
}
- (UITableView *)mTableview{
    if (!_mTableview) {
        _mTableview=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableview.backgroundColor=[UIColor whiteColor];
        _mTableview.dataSource=self.mViewModel;
        _mTableview.delegate=self.mViewModel;
        _mTableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _mTableview;
}
- (UpdateUserPickViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UpdateUserPickViewModel alloc]init];
    }
    return _mViewModel;
}
@end
