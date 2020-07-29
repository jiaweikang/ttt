//
//  US_AboutVC.m
//  UleStoreApp
//
//  Created by zemengli on 2018/12/6.
//  Copyright © 2018 chenzhuqing. All rights reserved.
//

#import "US_AboutVC.h"
#import <UIView+SDAutoLayout.h>
#import "UIView+Shade.h"
#import "DeviceInfoHelper.h"

@interface US_AboutVC ()

@end

@implementation US_AboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else {
        [self.uleCustemNavigationBar customTitleLabel:[DeviceInfoHelper getAppName]];
    }
    self.view.backgroundColor = [UIColor convertHexToRGB:@"e6e6e6"];
    
    [self setUI];
}

- (void)setUI
{
    UIImageView *iconView = [[UIImageView alloc]initWithFrame:CGRectMake((__MainScreen_Width - 69) / 2, self.uleCustemNavigationBar.bottom+20, 69, 69)];
    iconView.image = [UIImage imageNamed:@"US_icon"];
    [self.view addSubview:iconView];
    
    UILabel *versionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(iconView.frame) + 8, __MainScreen_Width, 20)];
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = [UIColor convertHexToRGB:@"666666"];
    versionLabel.text = [NSString stringWithFormat:@"版本 %@",NonEmpty([UleStoreGlobal shareInstance].config.appVersion)];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:versionLabel];
    
    UILabel *introLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(versionLabel.frame) + 30, __MainScreen_Width - 40, 60)];
    introLabel.lineBreakMode=NSLineBreakByCharWrapping;
    introLabel.backgroundColor = [UIColor clearColor];
    introLabel.text = [NSString stringWithFormat:@"%@ —— 助力农产品进城，简单！方便！", [DeviceInfoHelper getAppName]];
    introLabel.textColor = [UIColor convertHexToRGB:@"333333"];
    introLabel.font = [UIFont systemFontOfSize:18];
    introLabel.numberOfLines = 2;
    [self.view addSubview:introLabel];
    
    NSArray *array = @[@"3秒快速注册，精选商品一键分享微信；",@"分享商品自己购买，可获优惠；",@"分享商品好友购买，可获收益；",@"各地名优农产品轻松触达；", @"更有拼团、特卖等优惠活动；"];
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(introLabel.frame) + 30 + i *20, 8, 8)];
        imageView.backgroundColor = [UIColor convertHexToRGB:@"666666"];
        imageView.layer.cornerRadius = 4.;
        imageView.layer.masksToBounds = YES;
        [self.view addSubview:imageView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, CGRectGetMinY(imageView.frame) - 6, __MainScreen_Width - 40, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = array[i];
        label.textColor = [UIColor convertHexToRGB:@"666666"];
        label.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:label];
    }
    
    UILabel *endLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(introLabel.frame) + 30 + 90, __MainScreen_Width - 40, 60)];
    endLabel.backgroundColor = [UIColor clearColor];
    endLabel.text = [NSString stringWithFormat:@"马上开启您的%@生意吧！",[DeviceInfoHelper getAppName]];
    endLabel.textColor = [UIColor convertHexToRGB:@"666666"];
    endLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:endLabel];
    
    UILabel *protocolTitle=[[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(endLabel.frame), 36, 22)];
    protocolTitle.text = @"阅读";
    protocolTitle.font = [UIFont systemFontOfSize:15];
    protocolTitle.textColor = [UIColor convertHexToRGB:@"666666"];
    [self.view addSubview:protocolTitle];

    UILabel *protocolLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(protocolTitle.frame), CGRectGetMaxY(endLabel.frame), 170, 22)];
    protocolLabel.text = @"《服务协议与隐私政策》";
    protocolLabel.textColor = [UIColor blueColor];
    protocolLabel.font = [UIFont systemFontOfSize:15];
    protocolLabel.userInteractionEnabled = YES;
    [protocolLabel addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToProtocol)]];
    [UIView setDirectionBorderWithView:protocolLabel top:NO left:NO bottom:YES right:NO borderColor:[UIColor blueColor] withBorderWidth:0.8];
    [self.view addSubview:protocolLabel];
}

- (void)tapToProtocol {
    if ([US_UserUtility sharedLogin].m_protocolUrl && [US_UserUtility sharedLogin].m_protocolUrl.length>0) { //本地有新协议url 则跳转阅读
        NSMutableDictionary *dic = @{KNeedShowNav: @YES,
                                     @"title": @"服务协议与隐私政策",
                                     @"key": [US_UserUtility sharedLogin].m_protocolUrl
                                     }.mutableCopy;
        [self pushNewViewController:@"WebDetailViewController" isNibPage:NO withData:dic];
    }
}

@end
