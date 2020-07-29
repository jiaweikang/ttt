//
//  US_MyGoodsCatergoryCell.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/30.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "US_GoodsCatergory.h"
NS_ASSUME_NONNULL_BEGIN

@protocol US_MyGoodsCatergoryCellDelegate <NSObject>

- (void)cellDidDeletecatergoryId:(NSString *)categoryId;

@end

@interface US_MyGoodsCatergoryCell : UITableViewCell
@property (nonatomic, weak) id<US_MyGoodsCatergoryCellDelegate>delegate;
@property (nonatomic, strong)CategroyItem * model;
@property (nonatomic, assign) BOOL isEditType;
@end

NS_ASSUME_NONNULL_END
