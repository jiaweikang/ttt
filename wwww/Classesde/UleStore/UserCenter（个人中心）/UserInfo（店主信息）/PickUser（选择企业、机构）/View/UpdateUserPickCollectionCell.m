//
//  UpdateUserPickCollectionCell.m
//  UleStoreApp
//
//  Created by xulei on 2019/7/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "UpdateUserPickCollectionCell.h"
#import <UIView+SDAutoLayout.h>
#import "UpdateUserPickCollectionViewModel.h"
#import "UpdateUserPickCollectionCellModel.h"
#import "PostOrgModel.h"
#import "AttributionPickCellModel.h"
#import "AttributionPickSideBar.h"

@interface UpdateUserPickCollectionCell ()
@property (nonatomic, strong)UITableView        *mTableView;
@property (nonatomic, strong)AttributionPickSideBar *sideBar;
@property (nonatomic, strong)UpdateUserPickCollectionViewModel  *mViewModel;
@property (nonatomic, strong)UpdateUserPickCollectionCellModel  *mModel;
@end

@implementation UpdateUserPickCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    [self.contentView sd_addSubviews:@[self.mTableView]];
    self.mTableView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
}

- (void)setModel:(UpdateUserPickCollectionCellModel *)model{
    if (model==self.mModel) {
        return;
    }
    self.mModel=model;
    @weakify(self);
    [self.mViewModel loadDataWithSucessBlock:^(id returnValue) {
        @strongify(self);
        [self addSideBarView];
        [self.mTableView reloadData];
    } faildBlock:^(id errorCode) {
    }];
    self.mViewModel.didSelectCellBlock = ^(AttributionPickCellModel * _Nonnull selectCellModel) {
      //点击tableviewCell
        if (model.collectionCellSelectBlock) {
            model.collectionCellSelectBlock(selectCellModel);
        }
    };
    [self.mViewModel fetchTableCellModel:model];
}

- (void)addSideBarView{
    if (self.mModel.mCellType==UpdateUserPickCollectionCellTypeProvince) {
        CGFloat sideBarHeight = CGRectGetHeight(self.frame)-10;
        self.sideBar=[[AttributionPickSideBar alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-KScreenScale(60), 5, KScreenScale(60), sideBarHeight) dataArr:self.mViewModel.sideBarDataArray];
        self.sideBar.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:self.sideBar];
        @weakify(self);
        self.sideBar.didSelectBlock = ^(NSInteger index) {
            @strongify(self);
            [self.mTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        };
        self.mTableView.sd_layout.rightSpaceToView(self.sideBar, 0);
    }
}
#pragma mark - <getters>
- (UITableView *)mTableView{
    if (!_mTableView) {
        _mTableView=[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _mTableView.delegate=self.mViewModel;
        _mTableView.dataSource=self.mViewModel;
        _mTableView.backgroundColor=[UIColor whiteColor];
        _mTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return _mTableView;
}
- (UpdateUserPickCollectionViewModel *)mViewModel{
    if (!_mViewModel) {
        _mViewModel=[[UpdateUserPickCollectionViewModel alloc]init];
    }
    return _mViewModel;
}

@end
