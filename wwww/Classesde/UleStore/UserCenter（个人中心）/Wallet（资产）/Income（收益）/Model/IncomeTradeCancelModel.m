//
//  IncomeTradeCancelModel.m
//  AFNetworking
//
//  Created by lei xu on 2020/5/27.
//

#import "IncomeTradeCancelModel.h"

@implementation IncomeTradeCancelList

@end

@implementation IncomeTradeCancelResult
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"list" : [IncomeTradeCancelList class]};
}
@end

@implementation IncomeTradeCancelData

@end

@implementation IncomeTradeCancelModel

@end
