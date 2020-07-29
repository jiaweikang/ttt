//
//  UIImage+USAddition.m
//  AFNetworking
//
//  Created by 陈竹青 on 2020/4/13.
//

#import "UIImage+USAddition.h"
#import "qrencode.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (uleQRCode)


#pragma mark - 二维码
+ (UIImage *)uleQRCodeForString:(NSString *)tString
                           size:(CGFloat)tSize
                      fillColor:(UIColor *)tFillColor
                      iconImage:(UIImage *)tIconImage {

    // 内容不能为空
    if (!tString || tString.length == 0) {
        return [UIImage new];
    }
    // 系统
    if (kSystemVersion>=8.0) {
        NSData *stringData = [tString dataUsingEncoding: NSUTF8StringEncoding];
        //生成
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
        //上色
        UIColor *onColor = [UIColor blackColor];
        if (tFillColor) {
            onColor = tFillColor;
        }
        UIColor *offColor = [UIColor whiteColor];
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues: @"inputImage",qrFilter.outputImage, @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor], @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor], nil];
        // 生成
        CIImage *qrImage = colorFilter.outputImage;
        CGFloat lSize = tSize;// * [UIScreen mainScreen].scale
        CGFloat tScale = MIN(lSize/CGRectGetWidth(qrImage.extent), lSize/CGRectGetHeight(qrImage.extent));
        CIImage *tTransformImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(tScale,tScale)];
        // 保存
        CIContext *tContext = [CIContext contextWithOptions:nil];
        CGImageRef tImageRef = [tContext createCGImage:tTransformImage fromRect:tTransformImage.extent];
        UIImage *tCodeImage = [UIImage imageWithCGImage:tImageRef];
        // 释放
        CGImageRelease(tImageRef);
//        UIImage *tCodeImage = [self changeImageSizeWithCIImage:[self createQRcodeWithUrlString:tString?tString:@""] size:lSize];
        // 添加icon
        if (tIconImage) {
            UIGraphicsBeginImageContext(CGSizeMake(lSize, lSize));
            [tCodeImage drawInRect:CGRectMake(0, 0, lSize, lSize)];
            CGFloat iconSize = 1.0/5.5*lSize;
            [tIconImage drawInRect:CGRectMake((lSize-iconSize)/2.0, (lSize-iconSize)/2.0, iconSize, iconSize)];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return resultImage;
        }
        return tCodeImage;
    }
    // libqrencode
    else {
        QRcode *code = QRcode_encodeString([tString UTF8String], 0, QR_ECLEVEL_H, QR_MODE_8, 1);
        if (!code) {
            return [UIImage new];
        }
        NSInteger iSzie = (NSInteger)tSize;
        // 创建上下文
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef ctx = CGBitmapContextCreate(NULL, iSzie, iSzie, 8, iSzie * 4, colorSpace, kCGImageAlphaPremultipliedLast);
        CGAffineTransform translateTransform = CGAffineTransformMakeTranslation(0, -iSzie);
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1, -1);
        CGContextConcatCTM(ctx, CGAffineTransformConcat(translateTransform, scaleTransform));
        // 颜色填充
        UIColor *tColor = [UIColor blackColor];
        if (tFillColor) {
            tColor = tFillColor;
        }
        // 绘制code
        [UIImage uleDrawQRCode:code context:ctx size:iSzie fillColor:tColor];
        // 生成UIImage
        CGImageRef qrCGImage = CGBitmapContextCreateImage(ctx);
        UIImage * qrImage = [UIImage imageWithCGImage:qrCGImage];
        // 释放
        CGContextRelease(ctx);
        CGImageRelease(qrCGImage);
        CGColorSpaceRelease(colorSpace);
        QRcode_free(code);
        // 添加icon
        if (tIconImage) {
            UIGraphicsBeginImageContext(CGSizeMake(tSize, tSize));
            [qrImage drawInRect:CGRectMake(0, 0, tSize, tSize)];
            CGFloat iconSize = 1.0/5.5*tSize;
            [tIconImage drawInRect:CGRectMake((tSize-iconSize)/2.0, (tSize-iconSize)/2.0, iconSize, iconSize)];
            UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return resultImage;
        }
        
        return qrImage;
    }
    return [UIImage new];
}

// 内部处理方法
// 填充颜色
+ (void)uleDrawQRCode:(QRcode *)code
             context:(CGContextRef)ctx
                size:(CGFloat)size
           fillColor:(UIColor *)fillColor {
    
    int margin = 0;
    unsigned char *data = code->data;
    int width = code->width;
    int totalWidth = width + margin * 2;
    int imageSize = (int)floorf(size);
    
    // @todo - review float->int stuff
    int pixelSize = imageSize / totalWidth;
    if (imageSize % totalWidth) {
        pixelSize = imageSize / width;
        margin = (imageSize - width * pixelSize) / 2;
    }
    
    CGRect rectDraw = CGRectMake(0.0f, 0.0f, pixelSize, pixelSize);
    // draw
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    for(int i = 0; i < width; ++i) {
        for(int j = 0; j < width; ++j) {
            if(*data & 1) {
                rectDraw.origin = CGPointMake(margin + j * pixelSize, margin + i * pixelSize);
                CGContextAddRect(ctx, rectDraw);
            }
            ++data;
        }
    }
    CGContextFillPath(ctx);
}

#pragma mark - 条形码
+ (UIImage *)uleBarCodeForString:(NSString *)tString
                       sizeWidth:(CGFloat)tSizeW
                      sizeHeight:(CGFloat)tSizeH
                       fillColor:(UIColor *)tFillColor {

    // 内容不能为空
    if (!tString || tString.length == 0) {
        return [UIImage new];
    }
    // 系统
    if (kSystemVersion>=8.0) {
        NSData *stringData = [tString dataUsingEncoding: NSUTF8StringEncoding];
        //生成
        CIFilter *qrFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        //上色
        UIColor *onColor = [UIColor blackColor];
        if (tFillColor) {
            onColor = tFillColor;
        }
        UIColor *offColor = [UIColor whiteColor];
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues: @"inputImage",qrFilter.outputImage, @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor], @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor], nil];
        // 生成
        CIImage *qrImage = colorFilter.outputImage;
        CGFloat lSizeW = tSizeW;// * [UIScreen mainScreen].scale
        CGFloat lSizeH = tSizeH;// * [UIScreen mainScreen].scale
        CIImage *tTransformImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(lSizeW/CGRectGetWidth(qrImage.extent),lSizeH/CGRectGetHeight(qrImage.extent))];
        // 保存
        CIContext *tContext = [CIContext contextWithOptions:nil];
        CGImageRef tImageRef = [tContext createCGImage:tTransformImage fromRect:tTransformImage.extent];
        UIImage *tCodeImage = [UIImage imageWithCGImage:tImageRef];
        // 释放
        CGImageRelease(tImageRef);
        
        return tCodeImage;
    }
    return [UIImage new];
}

/**
 *  根据字符串生成二维码CIImage对象
 *
 *  @param urlString 需要生成字符串的二维码对象
 *
 *  @return 生成的二维码
 */
+ (CIImage *)createQRcodeWithUrlString:(NSString *)urlString {
    //实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //恢复滤镜的默认属性
    [filter setDefaults];
    //将字符串转化为NSData
    NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    //通过KVO设置滤镜，传入data，将来滤镜就知道要用过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    //生成二维码
    CIImage *outPutImage = [filter outputImage];
    return outPutImage;
}

/**
 *  改变二维码图片大小（正方形图片）
 *
 *  @param ciImage 需要改变大小的CIImage对象
 *  @param size    图片的大小（正方形图片 只需要一个数）
 *
 *  @return 生成的目标图片
 */
+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage size:(CGFloat)size {
    
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    //创建bitmap
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

@end
@implementation UIImage (USAddition)
+ (NSMutableArray *)praseGIFDataToImageArray:(NSData *)data{
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    CGFloat animationTime = 0.f;
    if (src) {
        size_t l = CGImageSourceGetCount(src);
        frames = [NSMutableArray arrayWithCapacity:l];
        for (size_t i = 0; i < l; i++) {
            CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
            NSDictionary *properties = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(src, i, NULL));
            NSDictionary *frameProperties = [properties objectForKey:(NSString *)kCGImagePropertyGIFDictionary];
            NSNumber *delayTime = [frameProperties objectForKey:(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
            animationTime += [delayTime floatValue];
            if (img) {
                [frames addObject:[UIImage imageWithCGImage:img]];
                CGImageRelease(img);
            }
        }
        CFRelease(src);
    }
    return frames;
}

- (UIImage *)imageByScalingToSize:(CGSize)size {

    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(UIImage *) imageWithSize:(CGSize) size UIRectCorner:(UIRectCorner)corener andCornerRadius:(CGFloat) radius{
    CGRect rect= CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);//创建一个透明的图层
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corener cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(context); //剪切
    [self drawInRect:rect]; //绘制
    UIImage * corenerimage=UIGraphicsGetImageFromCurrentImageContext();
    return corenerimage;
}

+ (UIImage *)bundleImageNamed:(NSString *)name{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"UleStoreApp" ofType:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

@end
