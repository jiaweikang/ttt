//
//  US_OrderDetailAddressCell.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/2/22.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_OrderDetailAddressCell.h"
#import <UIView+SDAutoLayout.h>
#import <MessageUI/MessageUI.h>
#import "US_CustemSheetView.h"
#define kOrderDetailMargin 15

@interface US_OrderDetailAddressCell ()<MFMessageComposeViewControllerDelegate>
@property (nonatomic, strong) UILabel * nameAndPhoneLabel;
@property (nonatomic, strong) UILabel * addressLabel;
@property (nonatomic, strong) UIImageView * iconImageView;
@property (nonatomic, strong) UIButton * contactBuyer;
@property (nonatomic, strong) MFMessageComposeViewController *messageVC;
@end

@implementation US_OrderDetailAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.selectionStyle=UITableViewCellSelectionStyleNone;
    [self.contentView sd_addSubviews:@[self.iconImageView,self.nameAndPhoneLabel,self.addressLabel,self.contactBuyer]];
    
    self.iconImageView.sd_layout.leftSpaceToView(self.contentView, kOrderDetailMargin)
    .centerYEqualToView(self.contentView)
    .widthIs(18).heightEqualToWidth();
    
    self.nameAndPhoneLabel.sd_layout.leftSpaceToView(self.iconImageView, kOrderDetailMargin)
    .topSpaceToView(self.contentView, kOrderDetailMargin)
    .heightIs(20).autoWidthRatio(0);
    
    self.contactBuyer.sd_layout.centerYEqualToView(self.nameAndPhoneLabel)
    .rightSpaceToView(self.contentView, 5)
    .widthIs(90).heightIs(40);
    
    self.addressLabel.sd_layout.leftEqualToView(self.nameAndPhoneLabel)
    .topSpaceToView(self.nameAndPhoneLabel, kOrderDetailMargin)
    .rightSpaceToView(self.contentView, kOrderDetailMargin)
    .autoHeightRatio(0);
    
    [self setupAutoHeightWithBottomViewsArray:@[self.nameAndPhoneLabel,self.addressLabel] bottomMargin:kOrderDetailMargin];
}

- (void)setModel:(US_OrderDetailAddressCellModel *)model{
    _model=model;
    self.nameAndPhoneLabel.text=[NSString stringWithFormat:@"%@      %@",model.userName,model.phoneNumber];
    self.addressLabel.text=model.addressInfo;
    
    [self.nameAndPhoneLabel setSingleLineAutoResizeWithMaxWidth:300];
    
    self.contactBuyer.hidden=model.isMyOrder?YES:NO;
    self.addressLabel.hidden=model.isMyOrder?NO:YES;
    //汽车订单不显示地址详情
    if (model.isMyOrder&&!model.carOrderHiddenAddressInfo) {
        self.addressLabel.hidden = NO;
        [self setupAutoHeightWithBottomView:self.addressLabel bottomMargin:kOrderDetailMargin];
    }else{
        self.addressLabel.hidden = YES;
        [self setupAutoHeightWithBottomView:self.nameAndPhoneLabel bottomMargin:kOrderDetailMargin];
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - <button action>
- (void)contactAction:(id)sender{
    //TODO:
    US_CustemSheetView * sheet=[[US_CustemSheetView alloc] initWithTitle:@"" buttons:@[@"短信联系",@"电话联系"]];
    @weakify(self);
    sheet.sureBlock = ^(NSInteger index) {
        @strongify(self);
        if (index==0) {
            [self sendMessage:self.model.phoneNumber message:@""];
        }else{
            [self showAlertView:self.model.phoneNumber];
        }
    };
    [sheet showViewWithAnimation:AniamtionPresentBottom];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailContactWithPhoneNum:)]) {
//        [self.delegate orderDetailContactWithPhoneNum:self.model.phoneNumber];
//    }
}

-(void)showAlertView:(NSString *)message{
    if (kSystemVersion>=10.2) {
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",message]] options:@{} completionHandler:nil];
        }
    }else {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"拨打电话" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",message]]];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertControl addAction:sureAction];
        [alertControl addAction:cancelAction];
        [[UIViewController currentViewController] presentViewController:alertControl animated:YES completion:^{
        }];
    }
}
//发送短信
- (void)sendMessage:(NSString *)recipients message:(NSString *)body{
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController * messageVC = [[MFMessageComposeViewController alloc] init];
        //短信接收人
        messageVC.recipients = @[recipients];
        //短信内容
        messageVC.body = body;
        messageVC.messageComposeDelegate = self;
        [[UIViewController currentViewController] presentViewController:messageVC animated:YES completion:nil];
    }
}
#pragma mark - MFMessageComposeViewControllerDelegate
- (void)msgBackFun{
    [self.messageVC dismissViewControllerAnimated:YES completion:nil];
    self.messageVC=nil;
}
//处理完信息结果后调用
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    //信息结果处理完成后回到程序
    [controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            NSLog(@"发送成功");
            break;
        case MessageComposeResultFailed:
            NSLog(@"发送失败");
            break;
        case MessageComposeResultCancelled:
            NSLog(@"发送取消");
            break;
        default:
            break;
    }
}
#pragma mark - <setter and getter>
- (UILabel *)nameAndPhoneLabel{
    if (!_nameAndPhoneLabel) {
        _nameAndPhoneLabel=[UILabel new];
        _nameAndPhoneLabel.font = [UIFont boldSystemFontOfSize:14];
        _nameAndPhoneLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    }
    return _nameAndPhoneLabel;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel=[UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:14];
        _addressLabel.textColor = [UIColor convertHexToRGB:@"666666"];
        _addressLabel.numberOfLines = 0;
    }
    return _addressLabel;
}
- (UIButton *)contactBuyer{
    if (!_contactBuyer) {
        _contactBuyer=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
        [_contactBuyer setImage:[UIImage bundleImageNamed:@"myOrder_icon_buyer"] forState:UIControlStateNormal];
        [_contactBuyer setTitle:@" 联系买家" forState:UIControlStateNormal];
        [_contactBuyer setTitleColor:[UIColor convertHexToRGB:@"333333"] forState:UIControlStateNormal];
        _contactBuyer.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [_contactBuyer addTarget:self action:@selector(contactAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactBuyer;
}
- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView=[[UIImageView alloc] init];
        _iconImageView.image=[UIImage bundleImageNamed:@"myOrder_icon_user"];
    }
    return _iconImageView;
}
@end
