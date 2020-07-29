//
//  US_SearchAddressModel.h
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/15.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentLBS/TencentLBS.h>
NS_ASSUME_NONNULL_BEGIN

@interface US_Location : NSObject
@property (nonatomic, strong) NSNumber * lat;
@property (nonatomic, strong) NSNumber * lng;
@end

@interface US_AddressModel : NSObject
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * province;
@property (nonatomic, copy) NSString * city;
@property (nonatomic, copy) NSString * adcode;
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * district;
@property (nonatomic, copy) NSString * category;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) NSNumber * _distance;
@property (nonatomic, strong) US_Location * location;

- (instancetype)initWithTencentLocation:(TencentLBSLocation *)location;
@end

@interface US_SearchAddressModel : NSObject
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * message;
@property (nonatomic, assign) NSNumber * number;
@property (nonatomic, strong) NSMutableArray * data;
@end

NS_ASSUME_NONNULL_END
