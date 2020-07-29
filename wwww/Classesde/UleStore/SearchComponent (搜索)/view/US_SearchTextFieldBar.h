//
//  US_SearchTextFieldBar.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ClickReturnBlock)(UITextField *textField);

@interface US_SearchTextFieldBar : UIView
@property (nonatomic, strong) UITextField * searchField;
- (instancetype)initWithFrame:(CGRect)frame
                placeholdText:(NSString *)placeholdText
             clickReturnBlock:(ClickReturnBlock)clickReturnBlock;

@end

NS_ASSUME_NONNULL_END
