//
//  US_MemberManageVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/25.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_MemberManageVC.h"
#import "MemberViewModel.h"
#import "US_MemberListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "US_UserCenterApi.h"
#import "UleBasePageViewController.h"
#import "US_EmptyPlaceHoldView.h"

@interface US_MemberManageVC ()<US_MemberListCellDelegate>
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) MemberViewModel * mViewModel;
@property (nonatomic, strong) NSString * keyword;
@property (nonatomic, strong) US_EmptyPlaceHoldView * placeHoldView;
@end

@implementation US_MemberManageVC

- (void)dealloc {
    NSLog(@"US_MemberDetailVC -- dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.placeHoldView];
    self.placeHoldView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.uleCustemNavigationBar, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData:) name:NOTI_RefreshMemberPage object:nil];
    self.keyword=@"";
    self.didScrollEndBlock=[self.m_Params objectForKey:@"didScrollEndBlock"];
//    [self requestMemberList:self.keyword];
    self.mTableView.mj_header=self.mRefreshHeader;
    self.mTableView.mj_footer=self.mRefreshFooter;
    self.mTableView.mj_footer.hidden=YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didSearchMember:) name:NOTI_MemberDidSearch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartLoadData:) name:PageViewClickOrScrollDidFinshNote object:self];
}

#pragma mark - <上拉下拉刷新>
- (void)beginRefreshHeader{
    self.mViewModel.startPage=1;
    [self requestMemberList:self.keyword];
}

- (void)beginRefreshFooter{
    [self requestMemberList:self.keyword];
}

//刷新数据
-(void)updateData:(NSNotification *)notification
{
    self.mViewModel.startPage=1;
    [self requestMemberList:self.keyword];
}

- (void)didSearchMember:(NSNotification *)noti{
    NSDictionary *params=noti.userInfo;
    NSString *currentPage=params[@"currentPage"];
    NSString *memberType=self.m_Params[@"memberType"];
    if ([currentPage isEqualToString:memberType]) {
        NSString *keyWord=params[@"keyWord"];
        self.mViewModel.startPage=1;
        [self requestMemberList:keyWord];
        self.keyword=keyWord;
    }
}

- (void)didStartLoadData:(NSNotification *)noti{
    if (self.didScrollEndBlock) {
        self.didScrollEndBlock();
    }
    NSString *oldKeyWord=[NSString isNullToString:self.keyword];
    self.keyword=@"";
    if (self.mViewModel.mDataArray.count<=0||oldKeyWord.length>0) {
        self.mViewModel.startPage=1;
        [self requestMemberList:self.keyword];
    }
}
#pragma mark - 网络请求
//获取客户列表
- (void) requestMemberList:(NSString *)name{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    
    [self.networkClient_API beginRequest:[US_UserCenterApi buildMemberListRequestWithStartPage:[NSString stringWithFormat:@"%ld",(long)self.mViewModel.startPage] PageSize:@"10" SearchType:[NSString isNullToString:self.m_Params[@"memberType"]] CustomerName:name] success:^(id responseObject) {
        
        [UleMBProgressHUD hideHUDForView:self.view];
        [self.mViewModel fetchValueSuccessWithModel:responseObject];
        
        [self.mTableView reloadData];
        
        NSMutableDictionary *dic = responseObject[@"data"];
        self.placeHoldView.hidden=dic.allKeys.count>0?YES:NO;
    } failure:^(UleRequestError *error) {
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        
        [self showErrorHUDWithError:error];
    }];
}

#pragma US_MemberListCellDelegate 回调
//发送短信
- (void)memberListCellSendMessage:(NSString *)phoneNum{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",phoneNum]]];
}
// 拨打电话
- (void)memberListCellCall:(NSString *)phoneNum{
    if (kSystemVersion>=10.2) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]] options:@{} completionHandler:nil];
        }
    }else{
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"拨打电话" message:[NSString stringWithFormat:@"请确认是否拨打 %@",phoneNum] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拨打电话" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //        拨打电话
            NSString *number=[NSString stringWithFormat:@"tel://%@",phoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:number]];
        }];
        [actionSheet addAction:action1];
        [actionSheet addAction:action2];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        _mTableView.backgroundColor=[UIColor clearColor];
    }
    return _mTableView;
}

- (MemberViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[MemberViewModel alloc] init];
        _mViewModel.rootVC=self;
        _mViewModel.rootTableView=self.mTableView;
    }
    return _mViewModel;
}

- (US_EmptyPlaceHoldView *)placeHoldView{
    if (!_placeHoldView) {
        _placeHoldView=[[US_EmptyPlaceHoldView alloc] init];
        _placeHoldView.hidden=YES;
        _placeHoldView.titleLabel.text = @"还没有客户记录哦~";
        _placeHoldView.iconImageView.image = [UIImage bundleImageNamed:@"placeholder_img_noClient"];
    }
    return _placeHoldView;
}
@end
