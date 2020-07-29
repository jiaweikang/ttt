//
//  UIImage+USAddition.h
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (uleQRCode)

/**
 生成二维码图
 tString:   内容
 tSize:     大小
 fillColor: 填充色
 iconImage: 中间小图标
 */
+ (UIImage *)uleQRCodeForString:(NSString *)tString
                           size:(CGFloat)tSize
                      fillColor:(UIColor *)tFillColor
                      iconImage:(UIImage *)tIconImage;
/**
 生成条形码
 tString:   内容
 tSizeW:     W大小
 tSizeH:     H大小
 */
+ (UIImage *)uleBarCodeForString:(NSString *)tString
                       sizeWidth:(CGFloat)tSizeW
                      sizeHeight:(CGFloat)tSizeH
                       fillColor:(UIColor *)tFillColor;
@end


@interface UIImage (USAddition)
+ (NSMutableArray *)praseGIFDataToImageArray:(NSData *)data;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

-(UIImage *) imageWithSize:(CGSize) size UIRectCorner:(UIRectCorner)corener andCornerRadius:(CGFloat) radius;

+ (UIImage *)bundleImageNamed:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
