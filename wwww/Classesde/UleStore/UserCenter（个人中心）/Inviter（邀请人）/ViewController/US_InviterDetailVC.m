//
//  US_InviterDetailVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/21.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_InviterDetailVC.h"
#import "US_UserCenterApi.h"
#import "InviterDetailViewModel.h"
#import "InviterDetailData.h"

@interface US_InviterDetailVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) InviterDetailViewModel * mViewModel;
@property (nonatomic, strong) UIView * placeHolderView;
@property (nonatomic, strong) NSString * inviterId;
@end

@implementation US_InviterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"邀请人详情"];
    self.inviterId = [self.m_Params objectForKey:@"inviterId"];
    [self.view addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self.view addSubview:self.placeHolderView];
    self.placeHolderView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.placeHolderView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    [self requestInviterDetail:self.inviterId];
}

#pragma mark - 网络请求
//获取客户列表
- (void) requestInviterDetail:(NSString *)inviterId{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    
    [self.networkClient_API beginRequest:[US_UserCenterApi buildGetInviterDetailRequestWithInviterId:inviterId] success:^(id responseObject) {
        [UleMBProgressHUD hideHUDForView:self.view];
        InviterDetailData *inviterDetailData = [InviterDetailData yy_modelWithDictionary:responseObject];
        if (inviterDetailData.data.storeDetail.count > 0) {
            [self.mViewModel fetchInviterDetailValueWithData:inviterDetailData];
            [self.mTableView reloadData];
            self.placeHolderView.hidden = YES;
        }
        else{
            self.placeHolderView.hidden = NO;
        }
        
    } failure:^(UleRequestError *error) {
        [self showErrorHUDWithError:error];
        self.placeHolderView.hidden = NO;
    }];
}

- (void)placeHolderTapAction:(UITapGestureRecognizer *)tap
{
    [self requestInviterDetail:self.inviterId];
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    }
    return _mTableView;
}

- (InviterDetailViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[InviterDetailViewModel alloc] init];
        _mViewModel.rootVC=self;
        _mViewModel.rootTableView=self.mTableView;
    }
    return _mViewModel;
}

- (UIView *)placeHolderView {
    if (!_placeHolderView) {
        _placeHolderView = [UIButton buttonWithType:UIButtonTypeCustom];
        _placeHolderView.backgroundColor = [UIColor convertHexToRGB:@"f2f2f2"];
        _placeHolderView.hidden = YES;
        _placeHolderView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(placeHolderTapAction:)];
        [_placeHolderView addGestureRecognizer:tap];
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage bundleImageNamed:@"message_placeholder"];
        
        UILabel *label = [[UILabel alloc]init];
        label.text = @"暂时没有邀请人信息";
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentCenter;

        [_placeHolderView sd_addSubviews:@[imageView,label]];
        imageView.sd_layout
        .centerXEqualToView(_placeHolderView)
        .centerYIs(__MainScreen_Height/3)
        .widthIs(__MainScreen_Width/3)
        .heightIs(__MainScreen_Width/3 *115/143);
        label.sd_layout
        .centerXEqualToView(_placeHolderView)
        .topSpaceToView(imageView, 10)
        .widthIs(__MainScreen_Width)
        .heightIs(30);
    }
    return _placeHolderView;
}
@end
