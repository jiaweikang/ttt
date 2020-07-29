//
//  US_CouponListCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/15.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_CouponListCellModel.h"



@implementation US_CouponListCellModel
- (instancetype)initWithCouponData:(MyCouponModel *)couponData{
    self = [super initWithCellName:@"US_CouponListCell"];
    if (self) {
        self.data=couponData;
        self.colorStr=[self couponColor:couponData];
        self.mCouponNameAttribute=[self buildCouponNameAttributeStr:couponData];
        self.mCouponMoneyAttribute=[self valueAttributeStr:couponData.amount];
        self.descriStr=couponData.desc;
        self.startTime=[self getStartTimeStr:couponData];
    }
    return self;
}

- (NSMutableAttributedString *)buildCouponNameAttributeStr:(MyCouponModel *)couponItem{
    NSMutableAttributedString *result=[[NSMutableAttributedString alloc] initWithString:couponItem.remark];
    NSMutableArray * images=[[NSMutableArray alloc] init];
    UIColor * backColor=self.colorStr.length>0?[UIColor convertHexToRGB:self.colorStr]:[UIColor redColor];
    if (couponItem.couponName && couponItem.couponName.length > 0) {
        UIImage * buyNumlimitImage=[NSString tranforImageWithTargetText:couponItem.couponName withColor:[UIColor whiteColor] backgroudColor:backColor andfont:[UIFont boldSystemFontOfSize:KScreenScale(24)]];
        [images addObject:buyNumlimitImage];
    }
    for (int i = 0; i < [images count]; i ++) {
        UIImage * labelImage=images[i];
        NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
        textAttachment.image = labelImage;                                  //设置图片源
        textAttachment.bounds = CGRectMake(0, -3, labelImage.size.width, labelImage.size.height);//设置图片位置和大小
        NSAttributedString *attrStr = [NSAttributedString attributedStringWithAttachment: textAttachment];
        NSMutableAttributedString *spaceString = [[NSMutableAttributedString alloc] initWithString:@" "];
        CGFloat insertposition=0;
        [result insertAttributedString:spaceString atIndex: insertposition];
        [result insertAttributedString: attrStr atIndex: insertposition];
    }
    return result;
}

- (NSMutableAttributedString *)valueAttributeStr:(NSString *)value{
    NSString * sign=@"￥";
    NSMutableAttributedString *markttext = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@",sign,value]];
    [markttext addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:35] range:NSMakeRange(sign.length, value.length)];
    return markttext;
}

- (NSString *)getStartTimeStr:(MyCouponModel *)couponItem{
    NSString * result=[NSString new];
    NSString * startT = [couponItem.activeDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    NSString * endT = [couponItem.expiredDate stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    result=[NSString stringWithFormat:@"%@-%@", startT, endT];
    return result;
}

- (NSString *)couponColor:(MyCouponModel *)couponItem{
    NSString *colorStr = @"";
    if ([couponItem.couponColour hasPrefix:@"#"]) {
        colorStr = [couponItem.couponColour substringFromIndex:1];
    } else {
        colorStr = couponItem.couponColour;
    }
    
    return colorStr;
}

@end
