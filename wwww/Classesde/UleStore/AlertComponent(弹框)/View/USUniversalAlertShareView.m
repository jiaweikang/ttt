//
//  USUniversalAlertShareView.m
//  u_store
//
//  Created by mac_chen on 2019/2/23.
//  Copyright © 2019年 yushengyang. All rights reserved.
//

#import "USUniversalAlertShareView.h"
#import "UIImage+USAddition.h"
#import "UIImageView+WebCache.h"
#import <UIView+SDAutoLayout.h>

@interface USUniversalAlertShareView ()

@property (nonatomic, strong) NSMutableDictionary *dataDic;

@end

@implementation USUniversalAlertShareView

-(instancetype)initWithData:(NSMutableDictionary *)shareData
{
    if (self = [super init]) {
        self.clipsToBounds = YES;
        self.dataDic = shareData;
        [self setUI];
    }
    return self;
}

- (void)setUI {
//    self.center = [[UIApplication sharedApplication].keyWindow center];
    self.backgroundColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, KScreenScale(750), KScreenScale(1170));

    //活动图片
    UIImageView *topImageView = [[UIImageView alloc] init];
    [self addSubview:topImageView];
    topImageView.sd_layout.topSpaceToView(self, KScreenScale(40))
    .leftSpaceToView(self, KScreenScale(40))
    .rightSpaceToView(self, KScreenScale(40))
    .heightIs(KScreenScale(940));
    
    //头像
    UIImageView *userImgView = [[UIImageView alloc]init];
    userImgView.clipsToBounds = YES;
    userImgView.layer.cornerRadius = KScreenScale(100)/2.0;
    [self addSubview:userImgView];
    userImgView.sd_layout.topSpaceToView(topImageView, KScreenScale(50))
    .leftSpaceToView(self, KScreenScale(54))
    .widthIs(KScreenScale(100))
    .heightIs(KScreenScale(100));
    
    //二维码背景
    UIView *mQRimageBg = [[UIView alloc] init];
    mQRimageBg.backgroundColor = [UIColor whiteColor];
    [self addSubview:mQRimageBg];
    mQRimageBg.sd_layout.topSpaceToView(topImageView, -KScreenScale(98))
    .rightSpaceToView(self, KScreenScale(54))
    .widthIs(KScreenScale(196))
    .heightIs(KScreenScale(196));
    
    //二维码
    UIImageView *mQRImageView = [[UIImageView alloc] init];
    mQRImageView.image = [UIImage uleQRCodeForString:self.dataDic[@"shareUrl"] size:200 fillColor:[UIColor blackColor] iconImage:nil];
    [mQRimageBg addSubview:mQRImageView];
    mQRImageView.sd_layout.topSpaceToView(mQRimageBg, KScreenScale(12))
    .leftSpaceToView(mQRimageBg, KScreenScale(12))
    .widthIs(KScreenScale(172))
    .heightIs(KScreenScale(172));
    
    //店铺名
    UILabel *storeNameLab = [[UILabel alloc]init];
    storeNameLab.textColor = SETCOLOR(51, 51, 51, 1);
    storeNameLab.font = [UIFont systemFontOfSize:KScreenScale(32)];
    [self addSubview:storeNameLab];
    storeNameLab.sd_layout.centerYEqualToView(userImgView)
    .leftSpaceToView(userImgView, KScreenScale(30))
    .rightSpaceToView(mQRImageView, KScreenScale(20))
    .heightIs(KScreenScale(36));
    
    //长按识别图中二维码
    UILabel *desLab = [[UILabel alloc]init];
    desLab.text=@"长按识别\n图中二维码";
    desLab.textColor = SETCOLOR(102, 102, 102, 1);
    desLab.font=[UIFont systemFontOfSize:KScreenScale(24)];
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.numberOfLines = 0;
    [self addSubview:desLab];
    desLab.sd_layout.topSpaceToView(mQRimageBg, KScreenScale(14))
    .leftSpaceToView(mQRimageBg, 0)
    .rightSpaceToView(mQRimageBg, 0)
    .heightIs(KScreenScale(60));
    
    //赋值
    [topImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDic[@"imageUrl"]] placeholderImage:[UIImage bundleImageNamed:@"placeholder_img_shareQR"]];
    
    //用户头像
    UIImage *iconImg=[UIImage bundleImageNamed:@"my_img_head_default"];
    
    if ([US_UserUtility sharedLogin].m_userHeadImage) {
        iconImg=[US_UserUtility sharedLogin].m_userHeadImage;
    }
    [userImgView setImage:iconImg];
    //店铺名称
    NSString *storeNameStr=@"";
    
    if ([NSString isNullToString:[US_UserUtility sharedLogin].m_stationName].length>0) {
        storeNameStr = [US_UserUtility sharedLogin].m_stationName;
    } else {
        storeNameStr = [NSString stringWithFormat:@"%@的小店",[US_UserUtility sharedLogin].m_userName];
    }
    storeNameLab.text=storeNameStr;
}

@end
