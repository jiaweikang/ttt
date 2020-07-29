//
//  OwnGoodsDetailHeadView.h
//  UleStoreApp
//
//  Created by mac_chen on 2019/7/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChooseBtnBlock)(NSString *transFlag);
typedef void(^WithdrawBtnBlock)(void);

@interface OwnGoodsDetailHeadView : UITableViewHeaderFooterView

@property (nonatomic, copy) ChooseBtnBlock chooseBtnBlock;
@property (nonatomic, copy) WithdrawBtnBlock withdrawBtnBlock;
@property (nonatomic, strong) UIButton *explainBtn;
@property (nonatomic, strong) NSString *tipsStr;
- (void)layoutHeadView:(NSString *)totalCount;

@end

NS_ASSUME_NONNULL_END
