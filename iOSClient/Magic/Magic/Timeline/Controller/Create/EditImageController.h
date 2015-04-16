//
//  EditImageController.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//


//add image cropper here with wechat-like style
//all codes added by Charlie 2015 1 14

#import <UIKit/UIKit.h>

typedef void(^EditImageCallBack)(UIImage* croppedImage);

@interface EditImageController : UIViewController<UITextFieldDelegate>
{
    
}

@property (nonatomic,strong) UIImage* originImage;
@property (nonatomic,strong) UIImage* croppedImage;

@property (nonatomic,assign) CGSize cropSize;

@property (nonatomic,strong) EditImageCallBack callBack;

@end
