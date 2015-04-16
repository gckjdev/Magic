//
//  PlaceholderTextView.h
//  BarrageClient
//
//  Created by gckj on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  added by Shaowu Cai on 15/2/5
#import <UIKit/UIKit.h>

@interface PlaceholderTextView : UITextView
@property (copy,nonatomic) NSString *placeholder;
@property (strong,nonatomic) UIColor *placeholderColor;
@property (strong,nonatomic) UIFont *placeholderFont;
- (id)initWithPlaceholder:(NSString*)placeholder
         placeholderColor:(UIColor*)color
          placeholderFont:(UIFont*)font;
@end
