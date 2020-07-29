//
//  US_MessageCopyView.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/3.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_MessageCopyView.h"
#import <UIView+SDAutoLayout.h>

@interface US_MessageCopyView ()
@property (nonatomic, strong) UILabel * topLabel;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UITextView * contentText;
@property (nonatomic, strong) UILabel * autoCopyLabel;
@end

@implementation US_MessageCopyView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:CGRectMake(0, 0, __MainScreen_Width, KScreenScale(500))];
    if (self) {
        [self loadUI];
    }
    return self;
}

- (void)loadUI{
    self.backgroundColor=kViewCtrBackColor;
    [self sd_addSubviews:@[self.contentView]];
    [self.contentView sd_addSubviews:@[self.topLabel,self.contentText,self.autoCopyLabel]];
    
    self.contentView.sd_layout.leftSpaceToView(self, KScreenScale(20))
    .topSpaceToView(self, KScreenScale(10))
    .rightSpaceToView(self, KScreenScale(20))
    .bottomSpaceToView(self, KScreenScale(10));
    
    self.topLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(20))
    .topSpaceToView(self.contentView, KScreenScale(30))
    .rightSpaceToView(self.contentView,  KScreenScale(20)).heightIs(KScreenScale(30));
    
    self.autoCopyLabel.sd_layout.leftSpaceToView(self.contentView, KScreenScale(70))
    .bottomSpaceToView(self.contentView, KScreenScale(20))
    .rightSpaceToView(self.contentView, KScreenScale(70))
    .heightIs(KScreenScale(48));
    
    self.contentText.sd_layout.leftSpaceToView(self.contentView, KScreenScale(40))
    .topSpaceToView(self.topLabel, KScreenScale(10))
    .rightSpaceToView(self.contentView, KScreenScale(40))
    .bottomSpaceToView(self.autoCopyLabel, KScreenScale(10));

}

- (void)setMessageCopyStr:(NSString * )message{
    self.contentText.text=message;
    UIPasteboard *board=[UIPasteboard generalPasteboard];
    [board setString:self.contentText.text];
}

- (NSMutableAttributedString *)AttributedString:(NSString *)text{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text];
    
    // 创建图片图片附件
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage bundleImageNamed:@"share_icon_multiok"];
    attach.bounds = CGRectMake(0, -KScreenScale(6), KScreenScale(28), KScreenScale(28));
    NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
    
    //将图片插入到合适的位置
    [string insertAttributedString:attachString atIndex:0];
    
    return string;
    
}
- (void)copBtnAction:(id)sender{
    UIPasteboard *board=[UIPasteboard generalPasteboard];
    [board setString:self.contentText.text];
    [UleMBProgressHUD showHUDWithText:@"文案已复制" afterDelay:1.5];
}
#pragma mark - <setter and getter>
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] init];
        _topLabel.textAlignment=NSTextAlignmentCenter;
        _topLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _topLabel.font = [UIFont boldSystemFontOfSize:KScreenScale(26)];
        _topLabel.text = @"妙文复制，轻松分享";
    }
    return _topLabel;
}

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

- (UILabel *)autoCopyLabel{
    if (!_autoCopyLabel) {
        _autoCopyLabel=[UILabel new];
        _autoCopyLabel.textColor = [UIColor convertHexToRGB:@"e63c40"];
        _autoCopyLabel.font = [UIFont systemFontOfSize:KScreenScale(24)];
        _autoCopyLabel.text = @"  文案已自动复制，可在社交软件中直接粘贴";
        _autoCopyLabel.backgroundColor=[UIColor convertHexToRGB:@"e63c40" withAlpha:0.1];
        _autoCopyLabel.textAlignment = NSTextAlignmentCenter;
        _autoCopyLabel.layer.masksToBounds = YES;
        _autoCopyLabel.layer.cornerRadius = KScreenScale(24);
        _autoCopyLabel.attributedText=[self AttributedString:_autoCopyLabel.text];
    }
    return _autoCopyLabel;
}

@end
