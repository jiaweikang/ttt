//
//  US_TitleAndIconView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/3/4.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface US_TitleAndIconView : UIView

+ (instancetype)titleAndIconViewWithFrame:(CGRect)frame
                                     icon:(NSString *)imageName
                                    title:(NSString *)title
                                  content:(NSString *)content;

- (void)setContent:(NSString *)contentStr;

@end

NS_ASSUME_NONNULL_END
