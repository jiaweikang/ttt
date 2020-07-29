//
//  US_HomeEmptyVC.m
//  UleMarket
//
//  Created by chenzhuqing on 2020/3/3.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import "US_HomeEmptyVC.h"
#import "DeviceInfoHelper.h"

@interface US_HomeEmptyVC ()
@property (nonatomic, strong) UILabel * mTitleLabel;
@property (nonatomic, strong) UILabel * mSubTitleLabel;
@property (nonatomic, strong) UIButton * mChangeAddress;
@end

@implementation US_HomeEmptyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self hideCustomNavigationBar];
    [self.view sd_addSubviews:@[self.mTitleLabel,self.mSubTitleLabel,self.mChangeAddress]];
    
    self.mTitleLabel.sd_layout.leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .centerYIs(__MainScreen_Height/2.0-50)
    .heightIs(40);
    
    self.mSubTitleLabel.sd_layout.leftSpaceToView(self.view, 20)
    .rightSpaceToView(self.view, 20)
    .topSpaceToView(self.mTitleLabel, 5)
    .heightIs(30);
    
    self.mChangeAddress.sd_layout.centerXEqualToView(self.view)
    .bottomSpaceToView(self.view, kIphoneX1?50:10)
    .widthIs(120)
    .heightIs(40);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma makr
- (void)btnClick:(id)sender{
    [self pushNewViewController:@"US_LocalAddressListVC" isNibPage:NO withData:nil];
}
#pragma mark - <getter>
- (UILabel *)mTitleLabel{
    if (!_mTitleLabel) {
        _mTitleLabel=[[UILabel alloc] init];
        _mTitleLabel.text= @"";//[NSString stringWithFormat:@"现已开通%@",USCITYNAME];
        _mTitleLabel.font=[UIFont systemFontOfSize:23];
        _mTitleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _mTitleLabel;
}

- (UILabel *)mSubTitleLabel{
    if (!_mSubTitleLabel) {
        _mSubTitleLabel=[[UILabel alloc] init];
        _mSubTitleLabel.text= [@"您选择的城市暂未开通" stringByAppendingString:[DeviceInfoHelper getAppName]];
        _mSubTitleLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _mSubTitleLabel;
}

- (UIButton *)mChangeAddress{
    if (!_mChangeAddress) {
        _mChangeAddress=[UIButton new];
        [_mChangeAddress setTitle:@"修改地址" forState:UIControlStateNormal];
        [_mChangeAddress setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _mChangeAddress.titleLabel.font=[UIFont systemFontOfSize:15];
        _mChangeAddress.layer.cornerRadius=5;
        _mChangeAddress.layer.borderWidth=0.6;
        _mChangeAddress.tintColor=[UIColor grayColor];
        _mChangeAddress.layer.borderColor=[UIColor grayColor].CGColor;
        [_mChangeAddress addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mChangeAddress;
}
@end
