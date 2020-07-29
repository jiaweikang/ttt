//
//  US_SearchBarView.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/18.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_SearchBarView.h"
#import <UIView+SDAutoLayout.h>

@interface US_SearchTextField ()

@end

@implementation US_SearchTextField


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        NSMutableAttributedString * attribute=[[NSMutableAttributedString alloc] initWithString:@"搜索地址"];
        [attribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 4)];
        self.attributedPlaceholder=attribute;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect  rect=CGRectMake(15, (bounds.size.height-18)/2.0, 18, 18);
    return rect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect rect =CGRectMake(40, 0, bounds.size.width-80, bounds.size.height);
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    CGRect rect =CGRectMake(40, 0, bounds.size.width-80, bounds.size.height);
    return rect;
}

@end

@interface US_SearchBarView ()<UITextFieldDelegate>
@property (nonatomic, strong) US_SearchTextField * mSearchField;


@end

@implementation US_SearchBarView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.mSearchField];
        self.mSearchField.sd_layout.leftSpaceToView(self, 10)
        .rightSpaceToView(self, 10)
        .centerYEqualToView(self)
        .heightIs(30);
        self.mSearchField.sd_cornerRadius=@(15);
        self.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

#pragma mark - <UITextFildDelegate>
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
        [self.delegate searchBarTextDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(self.delegate && [self.delegate respondsToSelector:@selector(searchBarTextDidEndEditing:)]){
        [self.delegate searchBarTextDidEndEditing:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString * changeStr= [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [self.delegate searchBar:self textDidChange:changeStr];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

#pragma mark - <getter and setter>
- (UITextField *)mSearchField{
    if (!_mSearchField) {
        _mSearchField=[[US_SearchTextField alloc] initWithFrame:CGRectZero];
        _mSearchField.delegate=self;
        UIImageView * leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 20, 20)];
        leftImageView.image=[UIImage imageNamed:@"goods_navi_search_new"];
        _mSearchField.leftView = leftImageView;
        _mSearchField.leftViewMode=UITextFieldViewModeAlways;
        _mSearchField.backgroundColor=kViewCtrBackColor;
    }
    return _mSearchField;
}
@end
