//
//  US_SelectDateTitleView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/10/14.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectDateTitleViewSelectDateBlock)(NSString *beginDateStr,NSString *endDateStr);

@interface US_SelectDateTitleView : UIView
@property (nonatomic, strong) UITextField *beginDateTF;
@property (nonatomic, copy) SelectDateTitleViewSelectDateBlock selectDateBlock;
@end

NS_ASSUME_NONNULL_END
