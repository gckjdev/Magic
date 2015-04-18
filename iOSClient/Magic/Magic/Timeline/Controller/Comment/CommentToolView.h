//
//  CommentToolView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//


#import <UIKit/UIKit.h>


typedef void (^PreViewButtonChangeBlock) ();
typedef void (^GridsButtonChangeBlock) ();
@interface CommentToolView : UIView
@property (nonatomic,copy) GridsButtonChangeBlock     gridsButtonChangeBlock;
@property (nonatomic,copy) PreViewButtonChangeBlock   preViewButtonChangeBlock;
@end
