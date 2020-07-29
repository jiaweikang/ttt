//
//  US_MemberDetailVC.m
//  UleStoreApp
//
//  Created by zemengli on 2019/1/10.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_MemberDetailVC.h"
#import "US_MemberListCellModel.h"
#import <UIView+SDAutoLayout.h>
#import "US_MemberEditVC.h"

@interface US_MemberDetailVC ()
@property (nonatomic, strong) UIImageView   * headImgView;           //图片
@property (nonatomic, strong) UILabel       * nameLabel;             //姓名
@property (nonatomic, strong) UILabel       * phoneLabel;            //手机号
@property (nonatomic, strong) UILabel       * addressLabel;          //地址
@property (nonatomic, strong) UIButton      * changeButton;          //修改资料按钮
@property (nonatomic, strong) US_MemberListCellModel * memberInfo;
@end

@implementation US_MemberDetailVC

- (void)dealloc {
    NSLog(@"US_MemberDetailVC -- dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NOTI_RefreshMemberPage
                                                  object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:@"客户详情"];
    }
    self.view.backgroundColor = [UIColor convertHexToRGB:@"ebebeb"];
    self.memberInfo = [self.m_Params objectForKey:@"memberInfo"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateData:)
                                                 name:NOTI_RefreshMemberPage
                                               object:nil];
    [self setUI];
    
    [self setData];
}

- (void)setData{
    [self.headImgView yy_setImageWithURL:[NSURL URLWithString:self.memberInfo.imageUrl] placeholder:[UIImage bundleImageNamed:@"member_img_userHead"]];
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.memberInfo.name];
    self.phoneLabel.text =[NSString stringWithFormat:@"%@",self.memberInfo.mobileNum];
    self.addressLabel.text = [NSString stringWithFormat:@"%@",self.memberInfo.addr];
}

- (void)updateData:(NSNotification *)notification {
    if (notification.userInfo[@"memberInfo"]) {
        self.memberInfo = notification.userInfo[@"memberInfo"];
    }
    [self setData];
}

- (void)setUI{
    UIView * topBackView = [UIView new];
    topBackView.backgroundColor = kNavBarBackColor;
    UILabel * phoneTitleLab=[[UILabel alloc] init];
    phoneTitleLab.textColor = [UIColor convertHexToRGB:@"aaaaaa"];
    phoneTitleLab.text = @"手机号";
    phoneTitleLab.font = [UIFont systemFontOfSize:14];
    UILabel * addressTitleLab=[[UILabel alloc] init];
    addressTitleLab.textColor = [UIColor convertHexToRGB:@"aaaaaa"];
    addressTitleLab.text = @"地    址";
    addressTitleLab.font = [UIFont systemFontOfSize:14];
    UIView * line1 = [UIView new];
    line1.backgroundColor = [UIColor convertHexToRGB:@"cfcfcf"];
    UIView * line2 = [UIView new];
    line2.backgroundColor = [UIColor convertHexToRGB:@"cfcfcf"];
    
    [self.view sd_addSubviews:@[topBackView,self.headImgView,phoneTitleLab,self.phoneLabel,self.nameLabel,line1,addressTitleLab,self.addressLabel,line2,self.changeButton]];
    topBackView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(85);
    self.headImgView.sd_layout
    .topSpaceToView(self.uleCustemNavigationBar, 15)
    .leftSpaceToView(self.view, 15)
    .heightIs(57)
    .widthIs(57);
    self.nameLabel.sd_layout
    .leftSpaceToView(self.headImgView, 15)
    .rightSpaceToView(self.view, 15)
    .centerYEqualToView(self.headImgView)
    .heightIs(20);
    phoneTitleLab.sd_layout
    .topSpaceToView(topBackView, 0)
    .leftSpaceToView(self.view, 15)
    .widthIs(50)
    .heightIs(55);
    self.phoneLabel.sd_layout
    .topEqualToView(phoneTitleLab)
    .leftSpaceToView(phoneTitleLab, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(55);
    line1.sd_layout
    .topSpaceToView(phoneTitleLab, 0)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(1);
    addressTitleLab.sd_layout
    .topSpaceToView(line1, 0)
    .leftEqualToView(phoneTitleLab)
    .rightEqualToView(phoneTitleLab)
    .heightRatioToView(phoneTitleLab, 1);
    self.addressLabel.sd_layout
    .topEqualToView(addressTitleLab)
    .leftSpaceToView(addressTitleLab, 0)
    .rightEqualToView(self.phoneLabel)
    .heightRatioToView(self.phoneLabel, 1);
    line2.sd_layout
    .topSpaceToView(addressTitleLab, 0)
    .leftEqualToView(line1)
    .rightEqualToView(line1)
    .heightRatioToView(line1, 1);
    self.changeButton.sd_layout
    .bottomSpaceToView(self.view, KTabbarSafeBottomMargin+30)
    .leftSpaceToView(self.view, 35)
    .rightSpaceToView(self.view, 35)
    .heightIs(44);
}

#pragma mark - 点击事件
- (void)changeButtonClick{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:self.memberInfo,@"memberInfo",nil];
    [self pushNewViewController:@"US_MemberEditVC" isNibPage:NO withData:dic];
}

#pragma mark - <setter and getter>
- (UIImageView *) headImgView{
    if (!_headImgView) {
        _headImgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 57)];
        _headImgView.layer.cornerRadius = 57/2;
        _headImgView.clipsToBounds = YES;
        _headImgView.layer.borderColor = [UIColor whiteColor].CGColor;
        _headImgView.layer.borderWidth = 1;
    }
    return _headImgView;
}
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[UILabel alloc] init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont systemFontOfSize:17];
    }
    return _nameLabel;
}
- (UILabel *)phoneLabel{
    if (!_phoneLabel) {
        _phoneLabel=[[UILabel alloc] init];
        _phoneLabel.textColor = [UIColor convertHexToRGB:@"000000"];
        _phoneLabel.font = [UIFont systemFontOfSize:15];
    }
    return _phoneLabel;
}
- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel=[[UILabel alloc] init];
        _addressLabel.textColor = [UIColor convertHexToRGB:@"000000"];
        _addressLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addressLabel;
}
- (UIButton *)changeButton{
    if (!_changeButton) {
        _changeButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_changeButton setTitle:@"修改资料" forState:UIControlStateNormal];
        [_changeButton setImage:[UIImage bundleImageNamed:@"memberDetail_button_edit"] forState:UIControlStateNormal];
        [_changeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 25, 0, 0)];
        [_changeButton setTitleColor:[UIColor convertHexToRGB:@"c60a1e"] forState:UIControlStateNormal];
        _changeButton.layer.cornerRadius = 5;
        _changeButton.layer.borderWidth = 1;
        _changeButton.tintColor = [UIColor convertHexToRGB:@"c60a1e"];
        _changeButton.backgroundColor = [UIColor whiteColor];
        [_changeButton addTarget:self action:@selector(changeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}
@end
