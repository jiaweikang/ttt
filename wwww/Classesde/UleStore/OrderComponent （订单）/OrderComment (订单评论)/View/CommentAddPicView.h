//
//  CommentAddPicView.h
//  UleApp
//
//  Created by denghuan on 2018/10/11.
//  Copyright © 2018年 ule. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDPhotoBrowser.h"
#import "CommentTextCellModel.h"
#import <TZImagePickerController.h>

typedef enum : NSUInteger{
    PicViewStateAddPic,
    PicViewStateShowPic,
} PicViewState;

@protocol PicViewDelegate <NSObject>

@optional
- (void)didCancelSelectedPic:(NSInteger)tag;

@end

@interface PicView : UIView

@property (nonatomic, assign) PicViewState picState;
@property (nonatomic, strong) UIImageView * picImageView;
@property (nonatomic, strong) UIButton * cancelBtn;
@property (nonatomic, strong) UILabel * countLabel;

@property (nonatomic, weak) id<PicViewDelegate>delegate;

@end

@interface CommentAddPicView : UIScrollView<UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PicViewDelegate,SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray * picsArray;
@property (nonatomic, strong) CommentTextCellModel * model;
@property (nonatomic, strong) TZImagePickerController *imagePickerVc;
@property (nonatomic, strong) NSMutableArray * imagePickerVcSelectedAssetsArray;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadPicsWithModel:(CommentTextCellModel *)model;

@end
