//
//  US_SelectDateTitleView.m
//  UleStoreApp
//
//  Created by zemengli on 2019/10/14.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_SelectDateTitleView.h"
#import <UIView+SDAutoLayout.h>
#import "US_DatePickerView.h"
#import <UIView+ShowAnimation.h>
#import "NSDate+USAddtion.h"

@interface US_SelectDateTitleView ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *endDateTF;
@property (nonatomic, strong) UIView *middleLine;
@property (nonatomic, strong) UIButton *queryButton;
@property (nonatomic, strong) US_DatePickerView * pickerView;
@end
@implementation US_SelectDateTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, 46)];
    if (self) {
        [self createSubviews];
        NSDate *currentDate = [NSDate date];
        //获取前一个月的日期
        NSDate *monthagoData = [NSDate getEarlierOrLaterDateFromDate:currentDate withMonth:-1];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *agoString = [dateFormatter stringFromDate:monthagoData];
        [self.beginDateTF setText:agoString];
        
        @weakify(self);
        self.pickerView.pickerSelectBlock = ^(NSString * _Nonnull selectDateStr) {
            @strongify(self);
            if (self.beginDateTF.selected) {
                [self.beginDateTF setText:selectDateStr];
            }
            if (self.endDateTF.selected) {
                [self.endDateTF setText:selectDateStr];
            }
        };
        self.pickerView.mCompleteBlock = ^{
            @strongify(self);
            if (self.endDateTF.selected && self.endDateTF.text.length == 0) {
                self.endDateTF.text=[dateFormatter stringFromDate:currentDate];
            }
        };
    }
    return self;
}

- (void)createSubviews{
    self.backgroundColor=[UIColor whiteColor];
    UIView * linView=[[UIView alloc] init];
    linView.backgroundColor=[UIColor convertHexToRGB:@"CACACA"];
    [self sd_addSubviews:@[self.beginDateTF,linView,self.endDateTF,self.queryButton]];
    self.beginDateTF.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(self, 10)
    .widthIs(KScreenScale(245))
    .heightIs(30);
    linView.sd_layout
    .leftSpaceToView(self.beginDateTF, 3)
    .widthIs(5)
    .heightIs(1.5)
    .centerYEqualToView(self);
    self.endDateTF.sd_layout
    .centerYEqualToView(self)
    .leftSpaceToView(linView, 3)
    .widthIs(KScreenScale(245))
    .heightIs(30);
    self.queryButton.sd_layout
    .rightSpaceToView(self, 10)
    .widthIs(KScreenScale(150))
    .heightIs(32)
    .centerYEqualToView(self);
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.beginDateTF){
        [self.pickerView datePickerShowWithDateString:self.beginDateTF.text];
        self.beginDateTF.selected=YES;
        self.endDateTF.selected=NO;
    }
    else if (textField == self.endDateTF){
        [self.pickerView datePickerShowWithDateString:self.endDateTF.text];
        self.beginDateTF.selected=NO;
        self.endDateTF.selected=YES;
    }
    return NO;
}

- (void)queryButtonClick{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
           [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    if (self.beginDateTF.text.length>0 && self.endDateTF.text.length>0) {
        NSDate *beginDate = [dateFormatter dateFromString:self.beginDateTF.text];
        NSDate *endDate = [dateFormatter dateFromString:self.endDateTF.text];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
        NSDateComponents *delta = [calendar components:unit fromDate:beginDate toDate:endDate options:0];
        if (delta.day<0) {
            [UleMBProgressHUD showHUDWithText:@"查询开始日期要早于查询截止日期，请重新选择" afterDelay:2.0];
            return;
        }
    }
    NSString * endDate=self.endDateTF.text;
    if (endDate.length == 0) {
        NSDate *currentDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        endDate = [dateFormatter stringFromDate:currentDate];
    }
    if (self.selectDateBlock) {
        self.selectDateBlock(self.beginDateTF.text, endDate);
    }
}

#pragma mark - <setter and getter>
- (UITextField *)beginDateTF{
    if (!_beginDateTF) {
        _beginDateTF=[[UITextField alloc] init];
        _beginDateTF.layer.cornerRadius = 4;
        _beginDateTF.layer.masksToBounds = YES;
        _beginDateTF.layer.borderWidth = 1;
        _beginDateTF.layer.borderColor = [[UIColor convertHexToRGB:@"AAAAAA"] CGColor];
        _beginDateTF.backgroundColor=[UIColor clearColor];
        _beginDateTF.font=[UIFont systemFontOfSize:14];
        _beginDateTF.textColor=[UIColor convertHexToRGB:@"666666"];
        _beginDateTF.delegate = self;
        _beginDateTF.placeholder=@"请选择时间";
        _beginDateTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_beginDateTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
        UIImageView * rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 12, 12)];
        [rightImageView setImage:[UIImage bundleImageNamed:@"downArrow"]];
        UIView * rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [rightView addSubview:rightImageView];
        _beginDateTF.rightView=rightView;
        _beginDateTF.rightViewMode=UITextFieldViewModeAlways;
        UIView * leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _beginDateTF.leftView=leftView;
        _beginDateTF.leftViewMode=UITextFieldViewModeAlways;
    }
    return _beginDateTF;
}
- (UITextField *)endDateTF{
    if (!_endDateTF) {
        _endDateTF=[[UITextField alloc] init];
        _endDateTF.layer.cornerRadius = 4;
        _endDateTF.layer.masksToBounds = YES;
        _endDateTF.layer.borderWidth = 1;
        _endDateTF.layer.borderColor = [[UIColor convertHexToRGB:@"AAAAAA"] CGColor];
        _endDateTF.backgroundColor=[UIColor clearColor];
        _endDateTF.font=[UIFont systemFontOfSize:14];
        _endDateTF.textColor=[UIColor convertHexToRGB:@"666666"];
        _endDateTF.delegate = self;
        _endDateTF.placeholder=@"今日";
        _endDateTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_endDateTF.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor convertHexToRGB:@"999999"],NSFontAttributeName:[UIFont systemFontOfSize:14]}];
         UIImageView * rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 12, 12)];
        [rightImageView setImage:[UIImage bundleImageNamed:@"downArrow"]];
        UIView * rightView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
        [rightView addSubview:rightImageView];
        _endDateTF.rightView=rightView;
        _endDateTF.rightViewMode=UITextFieldViewModeAlways;
        UIView * leftView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
        _endDateTF.leftView=leftView;
        _endDateTF.leftViewMode=UITextFieldViewModeAlways;
    }
    return _endDateTF;
}
- (UIButton *)queryButton{
    if (!_queryButton) {
        _queryButton=[UIButton buttonWithType:UIButtonTypeCustom];
        _queryButton.layer.cornerRadius = 4;
        _queryButton.layer.masksToBounds = YES;
        _queryButton.layer.borderWidth = 1;
        _queryButton.tintColor = [UIColor convertHexToRGB:@"F03B3B"];
        [_queryButton setTitle:@"查询" forState:UIControlStateNormal];
        [_queryButton setTitleColor:[UIColor convertHexToRGB:@"F03B3B"] forState:UIControlStateNormal];
        _queryButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [_queryButton addTarget:self action:@selector(queryButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queryButton;
}
- (US_DatePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView=[[US_DatePickerView alloc] init];
    }
    return _pickerView;
}

@end
