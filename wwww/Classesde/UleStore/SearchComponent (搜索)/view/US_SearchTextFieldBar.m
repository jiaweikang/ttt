//
//  US_SearchTextFieldBar.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_SearchTextFieldBar.h"
#import <UIView+SDAutoLayout.h>

#define kSearchBarHeight 30

@interface US_SearchTextFieldBar ()<UITextFieldDelegate>

@property (nonatomic, strong) ClickReturnBlock textFieldReturnBlock;
@end

@implementation US_SearchTextFieldBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        _searchBar=[[UIView alloc] initWithFrame:CGRectMake(0, 0, __MainScreen_Width-110, kSearchBarHeight)];
        [self setUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
                placeholdText:(NSString *)placeholdText
             clickReturnBlock:(ClickReturnBlock)clickReturnBlock{
    self = [[US_SearchTextFieldBar alloc] initWithFrame:frame];
    if (self) {
        self.searchField.placeholder=placeholdText;
        self.textFieldReturnBlock = [clickReturnBlock copy];
    }
    return self;
}

- (void)setUI{
    UIImageView * icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 11, 15, 15)];
    icon.image=[UIImage bundleImageNamed:@"nav_icon_Search.png"];
    [self addSubview:icon];
    icon.sd_layout.leftSpaceToView(self, 20)
    .centerYEqualToView(self)
    .widthIs(15)
    .heightIs(15);
    UITextField * searchField=[[UITextField alloc] initWithFrame:CGRectZero];
    searchField.placeholder=@"请输入商品ID或关键字";
    _searchField=searchField;
    [self addSubview:searchField];
    _searchField.clearButtonMode=UITextFieldViewModeWhileEditing;
    searchField.font=[UIFont systemFontOfSize:14];
    searchField.delegate=self;
    searchField.returnKeyType=UIReturnKeySearch;
    searchField.sd_layout.leftSpaceToView(icon, 10)
    .topSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .rightSpaceToView(self, 5);
    self.backgroundColor=[UIColor whiteColor];
    self.layer.cornerRadius=kSearchBarHeight/2;
}
#pragma mark - textField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.textFieldReturnBlock){
        self.textFieldReturnBlock(textField);
    }
    return YES;
}

@end
