//
//  OrganizeCollectionViewCell.m
//  UleStoreApp
//
//  Created by xulei on 2018/12/21.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "OrganizeCollectionViewCell.h"
#import <UIView+SDAutoLayout.h>
#import "AttributionPickSideBar.h"

@interface OrganizeCollectionViewCell ()
@property (nonatomic, strong)UITableView                           *mTableView;
@property (nonatomic, strong)AttributionPickSideBar                *sideBar;
@property (nonatomic, strong)OrganizeCollectionCellViewModel       *mViewModel;

@end

@implementation OrganizeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI
{
    self.backgroundColor=[UIColor convertHexToRGB:@"f0f0f0"];
    [self.contentView addSubview:self.mTableView];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}



#pragma mark - <action>
- (void)setTableviewData:(NSMutableArray *)mData
{
    @weakify(self);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        @strongify(self);
        [self.mTableView reloadData];
    } faildBlock:^(id errorCode) {
        
    }];
    self.mViewModel.mViewModelCellDidSelectBlock = ^(NSString * _Nonnull organizeName, NSString * _Nonnull organizeId, NSIndexPath * _Nonnull tableIndexPath, NSIndexPath * _Nonnull lastTableIndexPath) {
        @strongify(self);
        [self.mTableView reloadData];
        if (self.tableCellDidSelectBlock) {
            self.tableCellDidSelectBlock(organizeName, organizeId, tableIndexPath, lastTableIndexPath);
        }
    };
    
    NSMutableArray *sideBarDataArr = [self.mViewModel setCollectionCellViewTableviewData:mData];
    if (sideBarDataArr.count>0&&self.sideBar==nil) {
        CGFloat sideBarHeight = CGRectGetHeight(self.frame)-(kIphoneX ? KScreenScale(300)+34 : KScreenScale(300))-10;
        self.sideBar=[[AttributionPickSideBar alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-KScreenScale(60), 10, KScreenScale(60), sideBarHeight) dataArr:sideBarDataArr];
        [self.contentView addSubview:self.sideBar];
        self.sideBar.didSelectBlock = ^(NSInteger index) {
            @strongify(self);
            [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
    }
}

#pragma mark - <action>


#pragma mark - <getter>
-(UITableView *)mTableView
{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.backgroundColor = [UIColor convertHexToRGB:@"f0f0f0"];
        _mTableView.delegate = self.mViewModel;
        _mTableView.dataSource = self.mViewModel;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.showsVerticalScrollIndicator = NO;
    }
    return _mTableView;
}

- (OrganizeCollectionCellViewModel *)mViewModel
{
    if (!_mViewModel) {
        _mViewModel=[[OrganizeCollectionCellViewModel alloc]init];
    }
    return _mViewModel;
}

@end
