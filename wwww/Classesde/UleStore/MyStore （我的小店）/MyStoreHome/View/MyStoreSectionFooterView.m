//
//  MyStoreSectionFooterView.m
//  UleStoreApp
//
//  Created by xulei on 2019/11/20.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import "MyStoreSectionFooterView.h"

@implementation MyStoreSectionFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor=[UIColor convertHexToRGB:@"f5f5f5"];
    }
    return self;
}



@end
