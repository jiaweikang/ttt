//
//  NSString+Addition.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSString+Utility.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (Addition)

+ (NSString *)isNullToString:(id)string;

+ (NSString *)removeDuplicateHTTP:(NSString *)url;

//去掉最后一个字符串如", ."
+ (NSString *)removeTheLastOneStr:(NSString*)string;

+ (NSInteger) getLastBracesAtIndexOfJsonStr:(NSString *) string;

+ (NSString*)multiShareGetImageUrlString:(NSString *)type withurl:(NSString *)imgurl;

+ (NSString*) getImageUrlString:(NSString*)type withurl:(NSString*)imgurl ;

//椭圆形带填充色
+ (UIImage *) transforOvalImageWithTargetText:(NSString *) targetText  withColor:(UIColor *)color backgroudColor:(UIColor *)backgroudColor andfont:(UIFont *)font;

//方形带填充色
+ (UIImage *) tranforImageWithTargetText:(NSString *) targetText  withColor:(UIColor *)color backgroudColor:(UIColor *)backgroudColor andfont:(UIFont *)font;

//方形不带填充色
+ (UIImage *) transforImageWithTargetText:(NSString *)targetText withColor:(UIColor *)color andBorderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth andFont:(UIFont *)font;

- (NSMutableAttributedString *)setSubStrings:(NSArray *)subStrings showWithFont:(UIFont *)font;

- (NSMutableAttributedString *)setSubStrings:(NSArray *)subStrings showWithFont:(UIFont *)font color:(NSString *)color;

+ (NSString *)appandHtmlStr:(NSString *)string WithParams:(NSDictionary *)params;
@end

@interface NSString (JsonString)

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;

+(NSString *) jsonStringWithArray:(NSArray *)array;

+(NSString *) jsonStringWithString:(NSString *) string;

+(NSString *) jsonStringWithObject:(id) object;

+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
@end

@interface NSString (CGSize)

// 获取size
- (CGSize)sizeForFont:(UIFont *)font
                 size:(CGSize)size
                 mode:(NSLineBreakMode)lineBreakMode;
// 获取宽度
- (CGFloat)widthForFont:(UIFont *)font;
// 指定宽度获取高度
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width;


@end

NS_ASSUME_NONNULL_END
