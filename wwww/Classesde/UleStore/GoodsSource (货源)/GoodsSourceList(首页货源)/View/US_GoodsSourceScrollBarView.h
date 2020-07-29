//
//  US_GoodsSourceScrollBarView.h
//  UleStoreApp
//
//  Created by xulei on 2019/7/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_GoodsSourceScrollBarViewModel : NSObject
@property (nonatomic, strong)NSMutableArray * scrollDataArr;
@property (nonatomic, assign)BOOL    isNewData;
@property (nonatomic, copy)NSString *backgroundUrlStr;

-(instancetype)initWithHomeScrollBar:(NSMutableArray *)barArray;
@end

@interface US_GoodsSourceScrollBarView : UICollectionReusableView

@end

NS_ASSUME_NONNULL_END
