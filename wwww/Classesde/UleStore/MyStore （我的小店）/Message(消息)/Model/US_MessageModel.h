//
//  US_MessageModel.h
//  UleStoreApp
//
//  Created by chenzhuqing on 2019/1/17.
//  Copyright © 2019年 chenzhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface US_MessageDetail : NSObject
@property (nonatomic, copy) NSString *batchId;
@property (nonatomic, copy) NSString *content;
//@property (nonatomic, copy) NSString *createTime;
//@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *deviceType;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *msgparam;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *pushMsgType;
@property (nonatomic, copy) NSString *sendTime;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *push_msg_type;
@property (nonatomic, strong) NSNumber *channel_type;
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *to;
@end


@interface US_MessageData : NSObject
@property (nonatomic, copy)   NSString *total;
@property (nonatomic, copy)   NSString *pageIndex;
@property (nonatomic, copy)   NSString *pageSize;
@property (nonatomic, strong) NSMutableArray *data;
@end

@interface US_MessageModel : NSObject
@property(nonatomic, copy)NSString  *returnCode;
@property(nonatomic, copy)NSString  *returnMessage;
@property(nonatomic, copy)NSString  *timestamp;
@property (nonatomic, strong) US_MessageData *data;
@end

@interface MessageData2 : NSObject
@property(nonatomic, copy) NSString  *returnCode;
@property(nonatomic, copy) NSString  *returnMessage;
@property(nonatomic, copy) NSString  *total;
@property (nonatomic, strong) NSMutableArray *data;
@end

NS_ASSUME_NONNULL_END
