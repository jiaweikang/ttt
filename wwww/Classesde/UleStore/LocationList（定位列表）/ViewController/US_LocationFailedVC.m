//
//  US_LocationFailedVC.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/3/3.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_LocationFailedVC.h"
#import <YYLabel.h>
#import <YYText.h>
@interface US_LocationFailedVC ()
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, strong) YYLabel * discribLabel;
@end

@implementation US_LocationFailedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideCustomNavigationBar];
    [self.view sd_addSubviews:@[self.mTitleLabel,self.discribLabel]];
    
    self.mTitleLabel.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .centerYIs(__MainScreen_Height/2.0-50)
    .heightIs(40);
    
    self.discribLabel.sd_layout.leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.mTitleLabel, 5)
    .heightIs(30);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - <setter and getter>
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[[UILabel alloc] init];
        _mTitleLabel.text= @"定位失败";
        _mTitleLabel.font=[UIFont systemFontOfSize:23];
        _mTitleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _mTitleLabel;
}
- (YYLabel *)discribLabel{
    if (!_discribLabel) {
        _discribLabel=[YYLabel new];
        NSMutableAttributedString *text  = [[NSMutableAttributedString alloc] initWithString:@"建议您点击修改地址重试"];
        text.yy_lineSpacing = 5;
        text.yy_font = [UIFont systemFontOfSize:SCALEWIDTH(13)];
        text.yy_color = [UIColor lightGrayColor];
        text.yy_alignment=NSTextAlignmentCenter;
        [text yy_setTextHighlightRange:NSMakeRange(5, 4) color:[UIColor redColor] backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [self pushNewViewController:@"US_LocalAddressListVC" isNibPage:NO withData:nil];
        }];
        _discribLabel.preferredMaxLayoutWidth = __MainScreen_Width - 60; //设置最大的宽度
        _discribLabel.attributedText = text;  //设置富文本
        
    }
    return _discribLabel;
}
@end
