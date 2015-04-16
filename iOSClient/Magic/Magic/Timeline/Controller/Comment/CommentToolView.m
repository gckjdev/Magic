//
//  CommentToolView.m
//  BarrageClient
//
//  Created by Teemo on 15/3/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommentToolView.h"
#import "PPDebug.h"

@interface CommentToolView()
@property (nonatomic,strong) UIButton *preViewButton;
@property (nonatomic,strong) UIButton *gridsButton;
@end


@implementation CommentToolView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize
{
    _preViewButton = [[UIButton alloc]init];
    [_preViewButton setImage:[UIImage imageNamed:@"preview"] forState:UIControlStateNormal];
    [_preViewButton addTarget:self action:@selector(preViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_preViewButton];
    
    _gridsButton = [[UIButton alloc]init];
    [_gridsButton setImage:[UIImage imageNamed:@"grids"] forState:UIControlStateNormal];
    [_gridsButton addTarget:self action:@selector(gridsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_gridsButton];
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width /=2.0f;
    
    _preViewButton.frame = frame;
    
    frame.origin.x = frame.size.width;
    
    _gridsButton.frame = frame;
}
-(void)preViewButtonAction{
    EXECUTE_BLOCK(self.preViewButtonChangeBlock);
}
-(void)gridsButtonAction{
    EXECUTE_BLOCK(self.gridsButtonChangeBlock);
}
@end
