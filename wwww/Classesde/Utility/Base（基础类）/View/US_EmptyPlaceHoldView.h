//
//  US_EmptyPlaceHoldView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^US_EmptyPlaceHoldClickBlock)(void);
typedef void(^US_EmptyPlaceHoldBtnClickBlock)(void);

@interface US_EmptyPlaceHoldView : UIView
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UILabel * subTitleLabel;
@property (nonatomic, strong) NSString * describe;
@property (nonatomic, strong) UIButton * clickBtn;
@property (nonatomic, strong) NSString * clickBtnText;
@property (nonatomic, copy) US_EmptyPlaceHoldClickBlock clickEvent;
@property (nonatomic, copy) US_EmptyPlaceHoldBtnClickBlock btnClickBlock;

@end

NS_ASSUME_NONNULL_END
