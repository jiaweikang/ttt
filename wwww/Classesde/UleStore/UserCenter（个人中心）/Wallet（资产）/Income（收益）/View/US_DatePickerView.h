//
//  US_DatePickerView.h
//  UleStoreApp
//
//  Created by zemengli on 2019/10/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^DatePickerSelectBlock)(NSString *selectDateStr);

@interface US_DatePickerView : UIView
- (void)datePickerShowWithDateString:(NSString *)dateStr;
@property (nonatomic, copy) DatePickerSelectBlock pickerSelectBlock;
@end

NS_ASSUME_NONNULL_END
