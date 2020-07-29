//
//  US_HistorySearchView.h
//  u_store
//
//  Created by uleczq on 2017/6/26.
//  Copyright © 2017年 yushengyang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^HistorySearchBlock)(NSString * keywords);
typedef void(^HistoryCanelBlock)(void);
@interface US_HistorySearchView : UIView
@property (nonatomic, strong) HistorySearchBlock searchClick;
@property (nonatomic, strong) HistoryCanelBlock cancelClick;
@property (nonatomic, strong) NSMutableArray * keywordsArray;
@end
