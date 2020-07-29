//
//  US_MyGoodsDeleteAlertView.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/25.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class US_MyGoodsDeleteAlertView;
@protocol US_MyGoodsDeleteAlertViewDelegate <NSObject>

@optional

-(void)alertView:(US_MyGoodsDeleteAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface US_MyGoodsDeleteAlertView : UIView
@property (nonatomic, weak) id<US_MyGoodsDeleteAlertViewDelegate>delegate;

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles;
@end

NS_ASSUME_NONNULL_END
