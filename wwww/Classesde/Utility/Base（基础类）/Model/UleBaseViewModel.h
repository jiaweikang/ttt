//
//  UleBaseViewModel.h
//  UleApp
//
//  Created by ule-admin on 2018/4/9.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UleSectionBaseModel.h"
#import "UleCellBaseModel.h"

typedef void(^ReturnSucessBlock)(id returnValue);
typedef void(^ErrorCodeBlock)(id errorCode);

@protocol UleBaseViewModelDelegate <NSObject>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end

@interface UleBaseViewModel : NSObject<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) ReturnSucessBlock sucessBlock;
@property (nonatomic, strong) ErrorCodeBlock failedBlock;
@property (nonatomic, strong) NSMutableArray<UleSectionBaseModel *> * mDataArray;
@property (nonatomic, weak) UIViewController * rootVC;
@property (nonatomic, weak) UIScrollView    * rootScrollView;
@property (nonatomic, weak) id <UleBaseViewModelDelegate> delegate;

- (instancetype) initWithDataArray:(NSArray<UleSectionBaseModel *> *) array;

- (void) loadDataWithSucessBlock:(ReturnSucessBlock)success faildBlock:(ErrorCodeBlock) faild;

@end
