//
//  US_ActivityRuleView.m
//  UleStoreApp
//
//  Created by xulei on 2019/12/23.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_ActivityRuleView.h"
#import <SDAutoLayout.h>

@interface US_ActivityRuleView ()
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITextView * contentText;
@end

@implementation US_ActivityRuleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(200))];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    self.backgroundColor=kViewCtrBackColor;
    [self sd_addSubviews:@[self.contentView]];
    [self.contentView sd_addSubviews:@[self.contentText]];
    
    self.contentView.sd_layout.leftSpaceToView(self, KScreenScale(20))
    .topSpaceToView(self, KScreenScale(10))
    .rightSpaceToView(self, KScreenScale(20))
    .bottomSpaceToView(self, KScreenScale(10));
    
    self.contentText.sd_layout.leftSpaceToView(self.contentView, KScreenScale(40))
    .topSpaceToView(self.contentView, KScreenScale(10))
    .rightSpaceToView(self.contentView, KScreenScale(40))
    .bottomSpaceToView(self.contentView, KScreenScale(20));
}

- (void)setActivityRuleStr:(NSString *)ruleStr{
    self.contentText.text=ruleStr;
}

#pragma mark - <getters>
- (UIView *)contentView{
    if (!_contentView) {
        _contentView=[UIView new];
        _contentView.backgroundColor=[UIColor whiteColor];
        _contentView.layer.cornerRadius=10;
        _contentView.clipsToBounds=YES;
    }
    return _contentView;
}

- (UITextView *)contentText{
    if (!_contentText) {
        _contentText=[[UITextView alloc] init];
        _contentText.font = [UIFont systemFontOfSize:KScreenScale(26)];
        _contentText.textColor = [UIColor convertHexToRGB:@"333333"];
        _contentText.backgroundColor=[UIColor clearColor];
        _contentText.editable=NO;
    }
    return _contentText;
}
@end
