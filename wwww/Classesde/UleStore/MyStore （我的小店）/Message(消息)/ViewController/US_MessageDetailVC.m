//
//  US_MessageDetailVC.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/5/27.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "US_MessageDetailVC.h"
#import <UleDateFormatter.h>
#import "DeviceInfoHelper.h"
@implementation US_MessageDetailVC

- (void)viewDidLoad{
    [super viewDidLoad];
    NSString *title=[self.m_Params objectForKey:@"title"];
    if (title&&title.length>0) {
        [self.uleCustemNavigationBar customTitleLabel:title];
    }else [self.uleCustemNavigationBar customTitleLabel:@"消息通知"];
    
    UIImage *soundImg = [UIImage bundleImageNamed:@"message_icon_detailTitle"];
    UIImageView *soundImgV = [[UIImageView alloc]initWithImage:soundImg];
    [self.view addSubview:soundImgV];
    soundImgV.sd_layout.leftSpaceToView(self.view, 12)
    .topSpaceToView(self.uleCustemNavigationBar, 11)
    .widthIs(soundImg.size.width)
    .heightIs(soundImg.size.height);
    
    UILabel *appLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(soundImgV.frame) + 10, soundImgV.frame.origin.y, 64, soundImg.size.height)];
    appLb.contentMode = UIViewContentModeCenter;
    appLb.text = [DeviceInfoHelper getAppName];
    appLb.font = [UIFont systemFontOfSize:11];
    appLb.textColor = [UIColor convertHexToRGB:@"0x8c8c8c"];
    appLb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:appLb];
    appLb.sd_layout.leftSpaceToView(soundImgV, 10)
    .topEqualToView(soundImgV)
    .widthIs(70)
    .heightRatioToView(soundImgV, 1);
    
    NSString *timeStr=@"";
    UILabel *timeLb = [UILabel new];
    timeLb.adjustsFontSizeToFitWidth=YES;
    NSString *createTimeInt=self.m_Params[@"sendTime"];
    if (createTimeInt) {
        NSDate *createDate=[NSDate dateWithTimeIntervalSince1970:[createTimeInt longLongValue]/1000];
        timeStr=[UleDateFormatter GetCurrentDate2:createDate];
    }
    timeLb.text = timeStr;
    timeLb.font = [UIFont systemFontOfSize:10];
    timeLb.contentMode = UIViewContentModeCenter;
    timeLb.textAlignment = NSTextAlignmentRight;
    timeLb.textColor = [UIColor convertHexToRGB:@"0x8c8c8c"];
    timeLb.backgroundColor = [UIColor clearColor];
    [self.view addSubview:timeLb];
    timeLb.sd_layout.rightSpaceToView(self.view, 10)
    .centerYEqualToView(soundImgV)
    .heightRatioToView(appLb, 1)
    .autoWidthRatio(0);
    
    [timeLb setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(12.5, 44, __MainScreen_Width - 25, .5)];
    lineV.backgroundColor = [UIColor convertHexToRGB:@"0xe8e8e8"];
    [self.view addSubview:lineV];
    lineV.sd_layout.leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(soundImgV, 10)
    .heightIs(0.5);
    
    UILabel *titleLb = [UILabel new];
    titleLb.text = self.m_Params[@"title"];
    titleLb.textColor = [UIColor convertHexToRGB:@"0x333333"];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = [UIFont systemFontOfSize:17];
    titleLb.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLb];
    titleLb.sd_layout.leftSpaceToView(self.view, 10)
    .rightSpaceToView(self.view, 10)
    .topSpaceToView(lineV, 10)
    .heightIs(40);
    
    UITextView *contentLb = [[UITextView alloc] init];
    contentLb.editable = NO;
    contentLb.text = [NSString stringWithFormat:@"  %@",self.m_Params[@"content"]];
    contentLb.contentMode = UIViewContentModeBottom;
    contentLb.font = [UIFont systemFontOfSize:14];
    contentLb.textColor = titleLb.textColor;
    contentLb.backgroundColor = titleLb.backgroundColor;
    [self.view addSubview:contentLb];
    contentLb.sd_layout.leftSpaceToView(self.view, 10)
    .topSpaceToView(titleLb, 10)
    .rightSpaceToView(self.view, 10)
    .bottomSpaceToView(self.view, 10);
}

@end
