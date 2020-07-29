//
//  US_SearchBarView.h
//  UleMarket
//
//  Created by chenzhuqing on 2020/2/18.
//  Copyright © 2020 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class US_SearchBarView;
@protocol US_SearchBarViewDelegate <NSObject>
- (void)searchBarTextDidBeginEditing:(US_SearchBarView *)searchBar;
- (void)searchBarTextDidEndEditing:(US_SearchBarView *)searchBar;
- (void)searchBar:(US_SearchBarView *)searchBar textDidChange:(NSString *)searchText;
@end

@interface US_SearchTextField : UITextField

@end


@interface US_SearchBarView : UIView
@property (nonatomic, weak) id <US_SearchBarViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
