//
//  US_MemberListCell.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_MemberListCell.h"
#import "US_MemberListCellModel.h"
#import <UIView+SDAutoLayout.h>

@interface US_MemberListCell ()
@property (nonatomic, strong) UIImageView   * headImgView;           //图片
@property (nonatomic, strong) UILabel       * nameLabel;             //姓名
@property (nonatomic, strong) UILabel       * mobileNumLabel;        //手机号
@property (nonatomic, strong) UILabel       * noteLabel;             //求靓照
@property (nonatomic, strong) UIButton      * sendMessageButton;     //短信按钮
@property (nonatomic, strong) UIButton      * callButton;            //打电话按钮
@property (nonatomic, strong) US_MemberListCellModel * model;
@end
@implementation US_MemberListCell
- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        UIView * line = [UIView new];
        line.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
        [self.contentView sd_addSubviews:@[self.headImgView,self.nameLabel,self.mobileNumLabel,self.sendMessageButton,self.callButton,line]];
        self.headImgView.sd_layout.leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .widthIs(55)
        .heightIs(55);
        self.callButton.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .centerYEqualToView(self.contentView)
        .heightIs(30)
        .widthIs(30);
        self.sendMessageButton.sd_layout
        .rightSpaceToView(self.callButton, 10)
        .centerYEqualToView(self.contentView)
        .heightIs(30)
        .widthIs(30);
        self.nameLabel.sd_layout
        .leftSpaceToView(self.headImgView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 15)
        .heightIs(20);
        self.mobileNumLabel.sd_layout
        .leftSpaceToView(self.headImgView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.nameLabel, 4)
        .heightIs(20);
        line.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.headImgView, 10)
        .heightIs(1);

        [self setupAutoHeightWithBottomView:self.headImgView bottomMargin:11];
        [self.headImgView sd_addSubviews:@[self.noteLabel]];
        self.noteLabel.sd_layout
        .leftSpaceToView(self.headImgView, 0)
        .rightSpaceToView(self.headImgView, 0)
        .bottomSpaceToView(self.headImgView, 2)
        .heightIs(20);
    }
    return self;
}
- (void)setModel:(US_MemberListCellModel *)model {
    _model = model;
    if (model.imageUrl.length > 0) {
        self.noteLabel.hidden=YES;
    }
    else{
        self.noteLabel.hidden=NO;
    }
    if (model.imageUrl.length > 0) {
        [self.headImgView yy_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholder:[UIImage bundleImageNamed:@"member_img_userHead"]];
    }
    else{
        [self.headImgView yy_setImageWithURL:nil placeholder:[UIImage bundleImageNamed:@"member_img_userHead"]];
    }
    
    self.nameLabel.text=model.name;
    self.mobileNumLabel.text=[NSString stringWithFormat:@"手机号 %@",model.mobileNum];
}

#pragma mark - 点击事件
- (void) sendMessageButtonClick{
    if (_model.mobileNum.length <= 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(memberListCellSendMessage:)]) {
        [self.delegate memberListCellSendMessage:_model.mobileNum];
    }
}

- (void) callButtonClick{
    if (_model.mobileNum.length <= 0) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(memberListCellCall:)]) {
        [self.delegate memberListCellCall:_model.mobileNum];
    }
}

#pragma mark - <setter and getter>
- (UIImageView *) headImgView{
    if (!_headImgView) {
        _headImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        _headImgView.clipsToBounds = YES;
        _headImgView.layer.cornerRadius = 55/2;
    }
    return _headImgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.textColor = [UIColor convertHexToRGB:@"333333"];
        _nameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _nameLabel;
}

- (UILabel *)mobileNumLabel{
    if (!_mobileNumLabel) {
        _mobileNumLabel=[[UILabel alloc] init];
        _mobileNumLabel.textColor = [UIColor convertHexToRGB:@"999999"];
        _mobileNumLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mobileNumLabel;
}

- (UILabel *)noteLabel{
    if (!_noteLabel) {
        _noteLabel=[[UILabel alloc] init];
        _noteLabel.textColor = [UIColor whiteColor];
        _noteLabel.font = [UIFont systemFontOfSize:10];
        _noteLabel.text = @"求靓照";
        _noteLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _noteLabel;
}

- (UIButton *)sendMessageButton{
    if (!_sendMessageButton) {
        _sendMessageButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendMessageButton setImage:[UIImage bundleImageNamed:@"member_button_sendMessage"] forState:UIControlStateNormal];
        [_sendMessageButton addTarget:self action:@selector(sendMessageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendMessageButton;
}

- (UIButton *)callButton{
    if (!_callButton) {
        _callButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_callButton setImage:[UIImage bundleImageNamed:@"member_button_call"] forState:UIControlStateNormal];
        [_callButton addTarget:self action:@selector(callButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

@end
