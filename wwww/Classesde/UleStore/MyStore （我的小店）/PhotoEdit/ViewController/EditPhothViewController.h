//
//  EditPhothViewController.h
//  自定义相机测试
//
//  Created by chenxiaoqiang on 2/14/14.
//  Copyright (c) 2014 ule. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol EditPhotoDelegate <NSObject>

- (void)EditPhotoMethod:(UIImage *)image;

@end

@interface EditPhothViewController : UIViewController

@property (nonatomic, weak)id<EditPhotoDelegate> delegate;

@property (nonatomic) BOOL isCamera;

@property (nonatomic)CGSize              cutSize;

@property (nonatomic)CGRect              cutRect;

@property (nonatomic, strong)UIImage     *image;

@property (nonatomic, strong)UIImageView *imageView;

@property (nonatomic, strong)UIButton    *bkButton;

@property (nonatomic, strong)UIButton    *useButton;

@property (nonatomic, strong)UIImageView *saveUIImageView;

@property (nonatomic, strong)UILabel     *centerText;

@property float lastScale;
// 权限请求
+ (void)requestCameraPermissionWithSuccess:(void (^)(BOOL success))successBlock;
@end
