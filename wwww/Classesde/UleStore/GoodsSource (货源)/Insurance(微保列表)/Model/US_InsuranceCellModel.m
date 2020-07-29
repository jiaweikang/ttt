//
//  US_InsuranceCellModel.m
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/29.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import "US_InsuranceCellModel.h"

@implementation US_InsuranceCellModel

- (instancetype)initWithInsuranceItem:(InsuranceIndexInfo *)indexInfo{
    self = [super initWithCellName:@"US_InsuranceCell"];
    if (self) {
        self.data=indexInfo;
        self.logPageName=@"";
        self.logShareFrom=@"";
        self.shareFrom=@"1";
        self.shareChannel=@"1";
    }
    return self;
}
@end
