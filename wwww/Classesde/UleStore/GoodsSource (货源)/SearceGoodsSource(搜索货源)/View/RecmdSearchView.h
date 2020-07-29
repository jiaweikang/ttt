//
//  RecmdSearchView.h
//  UleApp
//
//  Created by chenzhuqing on 2017/10/25.
//  Copyright © 2017年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleSearchKeyObject.h"
@interface RecmdSearchView : UIView

- (void)reloadHotSearchViewWithData:(NSArray<SearchKeyWordItem*> *)searchKeyWords;
- (void)reloadHistorySearchView;
@end
