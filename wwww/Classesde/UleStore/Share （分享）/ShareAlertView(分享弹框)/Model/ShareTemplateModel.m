//
//  ShareTemplateModel.m
//  u_store
//
//  Created by xstones on 2017/7/24.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import "ShareTemplateModel.h"


@implementation ShareTemplateList
@synthesize _id,imgUrl,modelNo,sectionId,title,C_CONF_shareImageIFirst,priority,link,shareImagelFirst,key,cellSelected;

-(instancetype)init
{
    if (self=[super init]) {
        cellSelected=NO;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_id forKey:@"_id"];
    [aCoder encodeObject:imgUrl forKey:@"imgUrl"];
    [aCoder encodeObject:modelNo forKey:@"modelNo"];
    [aCoder encodeObject:sectionId forKey:@"sectionId"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:C_CONF_shareImageIFirst forKey:@"C_CONF_shareImageIFirst"];
    [aCoder encodeObject:priority forKey:@"priority"];
    [aCoder encodeObject:link forKey:@"link"];
    [aCoder encodeObject:shareImagelFirst forKey:@"shareImagelFirst"];
    [aCoder encodeObject:key forKey:@"key"];
    [aCoder encodeBool:cellSelected forKey:@"cellSelected"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _id=[aDecoder decodeObjectForKey:@"_id"];
        imgUrl=[aDecoder decodeObjectForKey:@"imgUrl"];
        modelNo=[aDecoder decodeObjectForKey:@"modelNo"];
        sectionId=[aDecoder decodeObjectForKey:@"sectionId"];
        title=[aDecoder decodeObjectForKey:@"title"];
        C_CONF_shareImageIFirst=[aDecoder decodeObjectForKey:@"C_CONF_shareImageIFirst"];
        priority=[aDecoder decodeObjectForKey:@"priority"];
        link=[aDecoder decodeObjectForKey:@"link"];
        shareImagelFirst=[aDecoder decodeObjectForKey:@"shareImagelFirst"];
        key=[aDecoder decodeObjectForKey:@"key"];
        cellSelected=[aDecoder decodeBoolForKey:@"cellSelected"];
    }
    return self;
}


@end



@implementation ShareTemplateModel
@synthesize total,returnCode,indexInfo;

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"indexInfo" : [ShareTemplateList class]
             };
}

@end
