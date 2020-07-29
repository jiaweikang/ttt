//
//  WKImagePicker.h
//  裁剪照片上传头像
//
//  Created by wangkun on 16/7/20.
//  Copyright © 2016年 ule. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  获取相机权限失败回调
 */
typedef void(^CameraFailedCallBack)(NSInteger code);//1--设备不支持拍照 2--获取相机权限失败

/**
 *  获取相册权限失败回调
 */
typedef void(^PhotoAlbumCallBack)(void);

/**
 *  选取成功回调
 *  对应imagePickerController:didFinishPicking方法
 */
typedef void(^ChooseCallBack)(NSDictionary<NSString *,id> *info);

/**
 *  取消回调
 *  对应imagePickerControllerDidCancel:
 */
typedef void(^CancelCallBack)(void);


@interface USImagePicker : NSObject


/**
 *  提供给外界的接口
 *
 *  @param viewController 用来present的控制器
 *  @param chooseBlock    选取成功回调
 *  @param cancelBlock    取消回调
 */
+ (void)startWKImagePicker:(UIViewController *)viewController
              cameraFailCallBack:(CameraFailedCallBack)cameraBlock
    photoAlbumFailCallBack:(PhotoAlbumCallBack)photoBlock
            chooseCallBack:(ChooseCallBack)chooseBlock
            cancelCallBack:(CancelCallBack)cancelBlock;

@end
