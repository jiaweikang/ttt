//
//  UleRedRainNotificationModel.m
//  UleApp
//
//  Created by zemengli on 2019/8/14.
//  Copyright © 2019 ule. All rights reserved.
//

#import "UleRedRainNotificationModel.h"

@implementation UleRedRainNotificationModel
@synthesize themeCode;
@synthesize title;
@synthesize content;
@synthesize ios_action;


- (id)copyWithZone:(NSZone *)zone {
    UleRedRainNotificationModel *copy = [[[self class] allocWithZone:zone] init];
    copy.themeCode = [self.themeCode copyWithZone:zone];
    copy.title = [self.title copyWithZone:zone];
    copy.content = [self.content copyWithZone:zone];
    copy.ios_action = [self.ios_action copyWithZone:zone];

    return copy;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:themeCode forKey:@"themeCode"];
    [aCoder encodeObject:title forKey:@"title"];
    [aCoder encodeObject:content forKey:@"content"];
    [aCoder encodeObject:ios_action forKey:@"ios_action"];

}

-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self=[super init]) {
        self.themeCode =[aDecoder decodeObjectForKey:@"themeCode"];
        self.title =[aDecoder decodeObjectForKey:@"title"];
        self.content =[aDecoder decodeObjectForKey:@"content"];
        self.ios_action =[aDecoder decodeObjectForKey:@"ios_action"];

    }
    return self;
}
@end
