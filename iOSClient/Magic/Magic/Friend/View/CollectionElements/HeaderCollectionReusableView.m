//
//  HeaderCollectionReusableView.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/4/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "HeaderCollectionReusableView.h"
#import <Masonry.h>
#import "UIViewUtils.h"


@implementation HeaderCollectionReusableView

-(void)customizeHeaderViewWithTextLabel:(NSString*)text
{
    for(UIView* v in self.subviews){
        [v removeFromSuperview];
    }
    
    UIView *holderView = [[UIView alloc]init];
    holderView.backgroundColor = [UIColor whiteColor];
    [self addSubview:holderView];
    [holderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIView *cleverSegmentationView = [[UIView alloc]init];
    cleverSegmentationView.backgroundColor = BARRAGE_BG_COLOR;
    [holderView addSubview:cleverSegmentationView];
    [cleverSegmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left);
        make.right.equalTo(holderView.mas_right);
        make.width.equalTo(holderView.mas_width);
        make.height.equalTo(@(COMMON_MARGIN_OFFSET_Y));
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = text;
    label.textColor = BARRAGE_LABEL_GRAY_COLOR;
    label.font = BARRAGE_LABEL_FONT;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    [holderView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(holderView.mas_left).with.offset(COMMON_MARGIN_OFFSET_X);
        make.height.equalTo(holderView.mas_height).with.offset(-COMMON_MARGIN_OFFSET_Y);
        make.bottom.equalTo(holderView.mas_bottom);
    }];
    
    [self addSubview:holderView];
}

-(void)customizeHeaderViewWithText:(NSString*)text
                        withTarget:(id)target
                            action:(SEL)action
{
    for(UIView* v in self.subviews){
        [v removeFromSuperview];
    }
    UIView *cleverSegmentationView = [[UIView alloc]init];
    cleverSegmentationView.backgroundColor = BARRAGE_BG_COLOR;
    [self addSubview:cleverSegmentationView];
    [cleverSegmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(COMMON_MARGIN_OFFSET_Y));
    }];
    
    UITextField *textField = [UIView defaultTextField:text superView:self];
    [textField resignFirstResponder];
    textField.delegate = target;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
    }];
}

-(void)customizeHeaderViewWithButton:(NSString*)text
                          withTarget:(id)target
                              action:(SEL)action
{
    for(UIView* v in self.subviews){
        [v removeFromSuperview];
    }
    UIView *cleverSegmentationView = [[UIView alloc]init];
    cleverSegmentationView.backgroundColor = BARRAGE_BG_COLOR;
    [self addSubview:cleverSegmentationView];
    [cleverSegmentationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@(COMMON_MARGIN_OFFSET_Y));
    }];
   
    UIButton *delButt = [UIView defaultTextButton:@"删除标签" superView:self];
    [delButt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
    }];
    [delButt addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
