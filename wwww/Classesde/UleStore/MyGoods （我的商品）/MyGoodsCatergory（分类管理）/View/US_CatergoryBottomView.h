//
//  US_CatergoryBottomView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/30.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol US_CatergoryBottomViewDelegate <NSObject>

- (void)addNewCatergoryWithName:(NSString *)catergoryName;

@end
@interface US_CatergoryBottomView : UIView
@property (nonatomic, weak) id<US_CatergoryBottomViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
