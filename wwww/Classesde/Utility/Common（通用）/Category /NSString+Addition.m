//
//  NSString+Addition.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2018/12/6.
//  Copyright © 2018年 chenzhuqing. All rights reserved.
//

#import "NSString+Addition.h"
#import <UleNetworkKit/UleReachability.h>
#import <UIImage+Extension.h>
@implementation NSString (Addition)

//对无效字符串进行处理(字符串所有无效格式)
+ (NSString *)isNullToString:(id)string{
    if ([string isEqual:@"NULL"]
        || [string isKindOfClass:[NSNull class]]
        || [string isEqual:[NSNull null]]
        || [string isEqual:NULL]
        || [[string class] isSubclassOfClass:[NSNull class]]
        || string == nil
        || string == NULL
        || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0
        || [string isEqualToString:@"<null>"]
        || [string isEqualToString:@"(null)"])
    {
        return @"";
    }else
    {
        return (NSString *)string;
    }
}

+ (NSString *)removeDuplicateHTTP:(NSString *)url
{
    if ([self isNullToString:url].length > 0) {
        NSArray *urlArr = [url componentsSeparatedByString:@":"];
        if (urlArr.count > 1) {
            return [NSString stringWithFormat:@"%@:%@", urlArr[urlArr.count - 2], urlArr[urlArr.count - 1]];
        } else {
            return [NSString stringWithFormat:@"https:%@", url];
        }
    }
    return @"";
}

+ (NSString *)removeTheLastOneStr:(NSString*)string{
    if([string length] > 0){
        return  [string substringToIndex:([string length]-1)];//去掉最后一个字符串如", ."
    }else{
        return string;
    }
}

+ (NSInteger) getLastBracesAtIndexOfJsonStr:(NSString *) string{
    NSInteger lenth=string.length-1;
    while (lenth>0) {
        char a=[string characterAtIndex:lenth];
        if ( a== '}') {
            break;
        }else{
            lenth--;
        }
    }
    return lenth+1;
}

//图片处理
+ (NSString*)multiShareGetImageUrlString:(NSString *)type withurl:(NSString *)imgurl{
    @try {
        NSString* retstr = nil;
        NSString *footString = [[NSString alloc] initWithFormat:@"%@",[[imgurl componentsSeparatedByString:@"."] lastObject]];
        retstr = [imgurl substringFromIndex:([imgurl length]-footString.length-1)];
        retstr = [NSString stringWithFormat:@"%@_%@%@",[imgurl substringToIndex:([imgurl length]-footString.length-1)] ,type,retstr];
        return  retstr;
    }
    @catch (NSException *exception) {
        return imgurl;
    }
}
+ (UIImage *)transforOvalImageWithTargetText:(NSString *)targetText withColor:(UIColor *)color backgroudColor:(UIColor *)backgroudColor andfont:(UIFont *)font{
    UILabel * label = [UILabel new];
    label.backgroundColor =backgroudColor;
    label.text      = targetText;
    label.textColor = color;
    label.font      = font;
    label.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize labelsize ;
    labelsize= [targetText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    [label setFrame:CGRectMake(0, 0, ceil(labelsize.width+20), ceil(labelsize.height+6))];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = label.frame.size.height*0.5;
    return [UIImage makeImageWithView:label];
}
+ (UIImage *) tranforImageWithTargetText:(NSString *) targetText  withColor:(UIColor *)color backgroudColor:(UIColor *)backgroudColor andfont:(UIFont *)font{
    UILabel * label = [UILabel new];
    label.text      = targetText;
    label.textColor = color;
    label.font      = font;
    label.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize labelsize ;
    labelsize= [targetText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    label.backgroundColor =backgroudColor;
    [label setFrame:CGRectMake(0, 0, ceil(labelsize.width+KScreenScale(12)), ceil(labelsize.height+KScreenScale(5)))];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = KScreenScale(5);
     return [UIImage makeImageWithView:label];
}
+ (UIImage *)transforImageWithTargetText:(NSString *)targetText withColor:(UIColor *)color andBorderColor:(UIColor *)borderColor andBorderWidth:(CGFloat)borderWidth andFont:(UIFont *)font{
    UILabel * label = [UILabel new];
    label.text      = targetText;
    label.textColor = color;
    label.font      = font;
    label.textAlignment = NSTextAlignmentCenter;
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGSize labelsize ;
    labelsize= [targetText boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    [label setFrame:CGRectMake(0, 0, ceil(labelsize.width+KScreenScale(12)), ceil(labelsize.height+KScreenScale(5)))];
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = KScreenScale(5);
    label.layer.borderColor = borderColor.CGColor;
    label.layer.borderWidth = borderWidth;
    return [UIImage makeImageWithView:label];
}

//图片处理
+(NSString*) getImageUrlString:(NSString*)type withurl:(NSString*)imgurl {
    @try {
        
        NSString* retstr = nil;
        if ( [UleReachability sharedManager].mReachabilityStatus == UleReachabilityStatusViaWiFi) {
            if ([type  isEqualToString: kImageUrlType_M ]) {
                type = kImageUrlType_SL;
            }
            else if([type  isEqualToString: kImageUrlType_SL ] ) {
                type = kImageUrlType_L;
            }
            else if([type  isEqualToString: kImageUrlType_L ] ) {
                type = kImageUrlType_XL;
            }
        }
        
        NSString *footString = [[NSString alloc] initWithFormat:@"%@",[[imgurl componentsSeparatedByString:@"."] lastObject]];
        retstr = [imgurl substringFromIndex:([imgurl length]-footString.length-1)];
        retstr = [NSString stringWithFormat:@"%@_%@%@",[imgurl substringToIndex:([imgurl length]-footString.length-1)] ,type,retstr];
        return  retstr;
    }
    @catch (NSException *exception) {
        return imgurl;
    }
}

- (NSMutableAttributedString *)setSubStrings:(NSArray *)subStrings showWithFont:(UIFont *)font{
    
    NSMutableAttributedString * result=[[NSMutableAttributedString alloc] initWithString:self];
    for (NSString * subStr in subStrings) {
        NSRange redRange = NSMakeRange([self rangeOfString:subStr].location, [self rangeOfString:subStr].length);
        [result addAttribute:NSFontAttributeName value:font range:redRange];
    }
    return result;
}

- (NSMutableAttributedString *)setSubStrings:(NSArray *)subStrings showWithFont:(UIFont *)font color:(NSString *)color {
    
    NSMutableAttributedString * result=[[NSMutableAttributedString alloc] initWithString:self];
    for (NSString * subStr in subStrings) {
        NSRange redRange = NSMakeRange([self rangeOfString:subStr].location, [self rangeOfString:subStr].length);
        [result addAttribute:NSFontAttributeName value:font range:redRange];
        [result addAttribute:NSForegroundColorAttributeName value:[UIColor convertHexToRGB:color] range:redRange];
    }
    return result;
}

+ (NSString *)appandHtmlStr:(NSString *)string WithParams:(NSDictionary *)params{
    NSString * result= string;
    for (NSString * key in params) {
        NSString * value= params[key];
        if ([value isKindOfClass:[NSString class]]&&value.length>0) {
            if ([result containsString:@"?"]) {
                result = [NSString stringWithFormat:@"%@&%@=%@",result,key,params[key]];
            }else{
                result=[NSString stringWithFormat:@"%@?%@=%@",result,key,params[key]];
            }
        }
    }
    return [result copy];
}
@end

@implementation NSString (JsonString)

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}

+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@","]];
    [reString appendString:@"]"];
    return reString;
}

+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [NSString jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}

+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [NSString jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [NSString jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [NSString jsonStringWithArray:object];
    }
    return value;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end

@implementation NSString (CGSize)

#pragma mark - NSString Size
- (CGSize)sizeForFont:(UIFont *)font
                 size:(CGSize)size
                 mode:(NSLineBreakMode)lineBreakMode {
    
    CGSize result;
    if (!font) font = [UIFont systemFontOfSize:12];
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableDictionary *attr = [NSMutableDictionary new];
        attr[NSFontAttributeName] = font;
        if (lineBreakMode != NSLineBreakByWordWrapping) {
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineBreakMode = lineBreakMode;
            attr[NSParagraphStyleAttributeName] = paragraphStyle;
        }
        CGRect rect = [self boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:attr context:nil];
        result = rect.size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        result = [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
    return result;
}
- (CGFloat)widthForFont:(UIFont *)font {
    
    CGSize size = [self sizeForFont:font size:CGSizeMake(HUGE, HUGE) mode:NSLineBreakByWordWrapping];
    return size.width;
}
- (CGFloat)heightForFont:(UIFont *)font width:(CGFloat)width {
    
    CGSize size = [self sizeForFont:font size:CGSizeMake(width, HUGE) mode:NSLineBreakByWordWrapping];
    return size.height;
}


@end
