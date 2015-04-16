//
//  EditImageController.m
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "EditImageController.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import <Masonry.h>
#import "UIViewController+Utils.h"
#import "UIView+Dragging.h"
#import "UIView+Resizing.h"
#import "UIView+Rotating.h"


@interface EditImageController ()
{
    
}

//总的holderView，负载一个image和三个辅助view
@property (nonatomic,strong) UIView* cropHolderView;

//图片，支持拖动，旋转，缩放
@property (nonatomic,strong) UIImageView* imageView;
//负责切割范围和背景颜色黑白切换
@property (nonatomic,strong) UIView* cropView;

//rotation gesture需要的中间变量，记录上一个rotation参数
@property (nonatomic,assign) BOOL isBlackBgColor;

@property (nonatomic,strong)UIView* lowerCoverView;
@property (nonatomic,strong)UIView* upperCoverView;

@end

@implementation EditImageController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    //经过uiimagepicker时候statusbar变了style
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self addRightButtonWithTitle:@"下一步" target:self action:@selector(onNext:)];
    
    
    //cropper image view holder
    self.cropHolderView = [[UIView alloc]init];
    self.cropHolderView.backgroundColor = [UIColor blackColor];
    self.cropHolderView = [self cropperViewWithImage:self.originImage
                                              inView:self.cropHolderView];
    [self.view addSubview:self.cropHolderView];
    [self.cropHolderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (void)onNext:(id)sender
{
    CGFloat scale = self.cropSize.width/self.cropView.frame.size.width;
    self.croppedImage = [self.cropView createSnapShotWithScale:scale];
    
    EXECUTE_BLOCK(self.callBack,self.croppedImage);
}


#pragma mark --- cropper view settings 
// gestures including move, scale, rotate
- (UIView*)cropperViewWithImage:(UIImage*)image
                         inView:(UIView*)superView
{
    superView.clipsToBounds = YES;
    
    //add cropview in the underneath for convinience snapshot
    self.cropView = [[UIView alloc]init];
    self.isBlackBgColor = YES;
    if(self.isBlackBgColor)
        self.cropView.backgroundColor = [UIColor blackColor];
    self.cropView.userInteractionEnabled = YES;
    [superView addSubview:self.cropView];
    [self.cropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView.mas_centerX);
        make.centerY.equalTo(superView.mas_centerY);
        make.width.equalTo(superView.mas_width);
        make.height.equalTo(superView.mas_width).dividedBy(self.cropSize.width/self.cropSize.height);
    }];
    UITapGestureRecognizer *doubleTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onChangeBackgroundColor:)];
    doubleTapGes.numberOfTapsRequired = 1;
    doubleTapGes.numberOfTouchesRequired = 1;
    [self.cropView addGestureRecognizer:doubleTapGes];
    
    //add 2 other covering view for alpha effect
    self.upperCoverView = [[UIView alloc]init];
    self.upperCoverView.backgroundColor = [UIColor blackColor];
    self.upperCoverView.alpha = 0.35;
    [superView addSubview:self.upperCoverView];
    [self.upperCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top);
        make.bottom.equalTo(self.cropView.mas_top);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
    }];
    [UIView addBottomLineWithColor:[UIColor whiteColor]
                       borderWidth:1
                         superView:self.upperCoverView];

    
    self.lowerCoverView = [[UIView alloc]init];
    self.lowerCoverView.backgroundColor = [UIColor blackColor];
    self.lowerCoverView.alpha = 0.35;
    [superView addSubview:self.lowerCoverView];
    [self.lowerCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cropView.mas_bottom);
        make.bottom.equalTo(superView.mas_bottom);
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
    }];
    [UIView addTopLineWithColor:[UIColor whiteColor]
                    borderWidth:1
                      superView:self.lowerCoverView];
    
    //add imageview on cropview, and if next button is press, cropview will be snap shot
    self.imageView = [[UIImageView alloc]initWithImage:image];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    //rotating
//    [self.imageView setViewRotatable];//暂时不用
    //scaling
    [self.imageView setViewResizable];
    //dragging
    [self.imageView setViewDraggable];
    
    UITapGestureRecognizer* tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapImageView:)];
    [self.imageView addGestureRecognizer:tapGes];
    
    [self.cropView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat scale = self.view.frame.size.width/self.originImage.size.width;
        make.centerX.equalTo(self.cropView.mas_centerX);
        make.centerY.equalTo(self.cropView.mas_centerY);
        make.width.equalTo(@(self.originImage.size.width*scale));
        make.height.equalTo(@(self.originImage.size.height*scale));
    }];
    
    return superView;
}

- (void)onTapImageView:(id)sender
{
    //dirty implementation, empty gesture to block imageview for reaction
    
}

- (void)onChangeBackgroundColor:(UITapGestureRecognizer*)sender
{
    if([sender numberOfTouches] == 1)
    {
        self.isBlackBgColor = !self.isBlackBgColor;
    }
    if(self.isBlackBgColor)
    {
        self.cropView.backgroundColor = [UIColor blackColor];
    }else{
        self.cropView.backgroundColor = [UIColor whiteColor];
    }
}

@end
