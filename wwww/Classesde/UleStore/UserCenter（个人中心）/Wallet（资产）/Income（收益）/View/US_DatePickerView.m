//
//  US_DatePickerView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/10/15.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_DatePickerView.h"
#import <UIView+SDAutoLayout.h>
#import <UIView+ShowAnimation.h>
#import "NSDate+USAddtion.h"

@interface US_DatePickerView ()
@property (nonatomic, strong) UIDatePicker *mDatePicker;
@end

@implementation US_DatePickerView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 216)];
    if (self) {
        [self createSubviews];
    }
    return self;
}

- (void)createSubviews{
    
    [self sd_addSubviews:@[self.mDatePicker]];

    self.mDatePicker.sd_layout
    .topSpaceToView(self, 0)
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .heightIs(216);
}

- (void)dateChange:(UIDatePicker *)datePicker {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    NSLog(@"dateStr:%@",dateStr);
    if (self.pickerSelectBlock) {
        self.pickerSelectBlock(dateStr);
    }
}

- (void)datePickerShowWithDateString:(NSString *)dateStr{
    if (dateStr.length>0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSDate *date = [formatter dateFromString:dateStr];
        [self.mDatePicker setDate:date];
    }
    else{
       [self.mDatePicker setDate:[NSDate date]];
    }
    [self showViewWithAnimation:AniamtionPresentBottom];
}

#pragma mark - <setter and getter>
- (UIDatePicker *)mDatePicker{
    if (!_mDatePicker) {
        _mDatePicker=[[UIDatePicker alloc] init];
        _mDatePicker.backgroundColor=[UIColor whiteColor];
        _mDatePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        _mDatePicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [_mDatePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_mDatePicker setMaximumDate:[NSDate date]];
        //获取前一个月的日期
        NSDate *yearagoData = [NSDate getEarlierOrLaterDateFromDate:[NSDate date] withMonth:-12];
        [_mDatePicker setMinimumDate:yearagoData];
        //监听DataPicker的滚动
        [_mDatePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _mDatePicker;
}
@end
