//
//  US_MemberListCell.h
//  UleStoreApp
//
//  Created by zemengli on 2019/1/4.
//  Copyright © 2019 chenzhuqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UleTableViewCellProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@protocol US_MemberListCellDelegate <NSObject>

- (void)memberListCellSendMessage:(NSString *)phoneNum;
- (void)memberListCellCall:(NSString *)phoneNum;
@end
@interface US_MemberListCell : UITableViewCell<UleTableViewCellProtocol>
@property (nonatomic, weak) id<US_MemberListCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
