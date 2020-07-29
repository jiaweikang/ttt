//
//  US_MyGoodsBatchDeleteAlert.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/24.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MyGoodsBatchDeleteAlert.h"

@interface US_MyGoodsBatchDeleteAlert ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UICollectionView * mCollectionView;

@end

@implementation US_MyGoodsBatchDeleteAlert

#pragma mark - <setter and getter>
- (UICollectionView *)mCollectionView{
    if (!_mCollectionView) {
        _mCollectionView=[[UICollectionView alloc] init];
    }
    return _mCollectionView;
}
@end
