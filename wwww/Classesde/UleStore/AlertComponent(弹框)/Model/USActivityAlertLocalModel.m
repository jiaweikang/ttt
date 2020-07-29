//
//  USActivityAlertModel.m
//  UleStoreApp
//
//  Created by zemengli on 2019/7/24.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "USActivityAlertLocalModel.h"

@implementation USActivityLocalAlertInfo
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_activityCode forKey:@"activityCode"];
    [aCoder encodeObject:_alertShowDate forKey:@"alertShowDate"];
    [aCoder encodeObject:_alertShowCount forKey:@"alertShowCount"];
}

-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self=[super init]) {
        self.activityCode =[aDecoder decodeObjectForKey:@"activityCode"];
        self.alertShowDate =[aDecoder decodeObjectForKey:@"alertShowDate"];
        self.alertShowCount =[aDecoder decodeObjectForKey:@"alertShowCount"];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    USActivityLocalAlertInfo *copy = [[[self class] allocWithZone:zone] init];
    copy.activityCode =[self.activityCode copyWithZone:zone];
    copy.alertShowDate =[self.alertShowDate copyWithZone:zone];
    copy.alertShowCount =[self.alertShowCount copyWithZone:zone];
    return copy;
}
@end


@implementation USActivityAlertLocalModel
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_remainder forKey:@"remainder"];
    [aCoder encodeObject:_alertDataArr forKey:@"alertDataArr"];
    [aCoder encodeObject:_lastShowDate forKey:@"lastShowDate"];
}

-(id)initWithCoder:(NSCoder *)aDecoder//和上面对应
{
    if (self=[super init]) {
        self.remainder =[aDecoder decodeObjectForKey:@"remainder"];
        self.alertDataArr =[aDecoder decodeObjectForKey:@"alertDataArr"];
        self.lastShowDate =[aDecoder decodeObjectForKey:@"lastShowDate"];
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone {
    USActivityAlertLocalModel *copy = [[[self class] allocWithZone:zone] init];
    copy.alertDataArr =[self.alertDataArr copyWithZone:zone];
    copy.remainder =[self.remainder copyWithZone:zone];
    copy.lastShowDate =[self.lastShowDate copyWithZone:zone];
    return copy;
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"alertDataArr" : [USActivityLocalAlertInfo class],
             };
}
@end
