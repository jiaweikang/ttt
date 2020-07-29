//
//  US_UleCardListVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_UleCardListVC.h"
#import "UleBaseViewModel.h"
#import "US_UserCenterApi.h"
#import "US_UleCardListInfo.h"

@interface US_UleCardListVC ()
@property (nonatomic, strong) UITableView * mTableView;
@property (nonatomic, strong) UleBaseViewModel * mViewModel;
@property (nonatomic, strong) UILabel * titleLabel;
@end

@implementation US_UleCardListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.uleCustemNavigationBar customTitleLabel:@"我的邮乐卡"];
    [self.view sd_addSubviews:@[self.titleLabel,self.mTableView]];
    self.titleLabel.sd_layout.leftSpaceToView(self.view, 0)
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(49);
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
    self.mTableView.sd_layout.topSpaceToView(self.titleLabel, 0);
    [self startRequestUleCardListInfo];
    [self setAttributeFroLabel:self.titleLabel];
}

#pragma mark - <http>
- (void)startRequestUleCardListInfo{
    [UleMBProgressHUD showHUDAddedTo:self.view withText:@"正在加载"];
    @weakify(self);
    [self.networkClient_VPS beginRequest:[US_UserCenterApi buildGetUleCardListRequest] success:^(id responseObject) {
        @strongify(self);
        [UleMBProgressHUD hideHUDForView:self.view];
        [self fetchUleCardListDicInfo:responseObject];
    } failure:^(UleRequestError *error) {
        @strongify(self);
        [self showErrorHUDWithError:error];
    }];
    
}

- (void)fetchUleCardListDicInfo:(NSDictionary *)dic{
    US_UleCardListInfo * cardData=[US_UleCardListInfo yy_modelWithDictionary:dic];
    UleSectionBaseModel * sectionModel=self.mViewModel.mDataArray.firstObject;
    if (sectionModel==nil) {
        sectionModel=[[UleSectionBaseModel alloc] init];
        sectionModel.headHeight=5;
        [self.mViewModel.mDataArray addObject:sectionModel];
    }
    CGFloat total = 0.0;
    for (int i=0; i<cardData.data.uleCardList.count; i++) {
        US_UleCardDetail * detail=cardData.data.uleCardList[i];
        UleCellBaseModel * cellModel=[[UleCellBaseModel alloc] initWithCellName:@"US_UleCardListCell"];
        cellModel.data=detail;
        [sectionModel.cellArray addObject:cellModel];
        total += detail.balance.doubleValue;
    }
    if (sectionModel.cellArray.count<=0) {
        [self showAlertNormal:@"无邮乐卡信息"];
    }
    NSString *str = [NSString stringWithFormat:@"邮乐卡总余额  ￥%.2lf",total];
    self.titleLabel.text=str;
    [self setAttributeFroLabel:self.titleLabel];
    [self.mTableView reloadData];

}

- (void)setAttributeFroLabel:(UILabel *)lable{
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:lable.text];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0,5)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(8,1)];
    [attributeStr addAttribute:NSKernAttributeName value:@-2.f range:NSMakeRange(8, 1)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:27] range:NSMakeRange(9,lable.text.length - 9)];
    lable.attributedText=attributeStr;
}
#pragma mark - <alert>
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - <setter and getter>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.dataSource=self.mViewModel;
        _mTableView.delegate=self.mViewModel;
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
- (UleBaseViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UleBaseViewModel alloc] init];
    }
    return _mViewModel;
}
- (UILabel * )titleLabel{
    if (!_titleLabel) {
        _titleLabel=[UILabel new];
        _titleLabel.backgroundColor=[UIColor whiteColor];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.textColor=[UIColor convertHexToRGB:@"333333"];
        _titleLabel.text=@"邮乐卡总余额  ￥0.00";
        
    }
    return _titleLabel;
}
@end
