//
//  Ule_LockConst.h
//  u_store
//
//  Created by yushengyang on 15/6/8.
//  Copyright (c) 2015年 yushengyang. All rights reserved.
//

#import <Foundation/Foundation.h>

//*************顶部提示信息*************//
extern const NSInteger kIndicator_tag;  // tag基数
extern const CGFloat kIndicatorDiameter;// 圆点直径
extern const CGFloat kIndicatorMargin;  // 圆点间距

//*************手势锁view*************//
extern const NSInteger kLockView_tag;   // tag基数（请勿修改）
extern const CGFloat kLVMargin;         // 圆点离屏幕左边距
extern const CGFloat kLVDiameter;       // 圆点直径
extern const CGFloat kLVAlpha;          // 圆点透明度
extern const CGFloat kLVLineWidth;      // 线条宽
// 线条色默认
#define kLVLineColor [UIColor convertHexToRGB:@"ed7e41"]
// 线条色错误
#define kLVLineColorError [UIColor convertHexToRGB:@"ff0000"]

extern NSString *const kLVImageNone;    //圆圈图片
extern NSString *const kLVImageSelect;  //蓝色圆圈图片
extern NSString *const kLVImageError;   //红色圆圈图片

//*************手势锁VC*************//
extern const CGFloat kLVCMaxNumber;
extern NSString *const kLVTypeKey;   //类型key
// 手势管理VC 枚举类型
typedef enum {
    UleLockVCTypeCheck,  // 验证手势密码
    UleLockVCTypeCreate, // 创建手势密码
    UleLockVCTypeModify, // 修改（重设置）
}UleLockVCType;


@interface Ule_LockConst : NSObject

@end
