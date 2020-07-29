//
//  US_SharePageControl.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/4/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol US_SharePageControlDelegate <NSObject>

-(void)picSharePageLeftBtnClick:(NSUInteger)currentP;
-(void)picSharePageRightBtnClick:(NSUInteger)currentP;

@end
@interface US_SharePageControl : UIView
@property (nonatomic, assign) NSInteger totoalPage;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, weak) id<US_SharePageControlDelegate>delegate;

- (instancetype)initWithTotalPages:(NSInteger )totoal;
@end

NS_ASSUME_NONNULL_END
