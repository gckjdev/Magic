//
//  PlaceholderTextView.m
//  BarrageClient
//
//  Created by gckj on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  the default number of placeholderLabel's line is 1,suggest to be 1
//  otherwise, it's location will be uncertain.

#import "PlaceholderTextView.h"
#import "Masonry.h"

//  以下3个数只是为了placeholderLabel能跟输入光标在同个水平线上
const float kPlaceHolderHeight = 30;
const float kPlaceHolderLeftPadding = 5.0f;
const float kPlaceHolderTopPadding = 5.0f;

@implementation PlaceholderTextView
{
    UILabel *placeholderLabel;
}

#pragma mark - Public methods
- (id)initWithPlaceholder:(NSString*)placeholder
         placeholderColor:(UIColor*)color
          placeholderFont:(UIFont*)font
{
    self = [super init];
    if (self) {
        placeholderLabel=[[UILabel alloc]init];
        [self addSubview:placeholderLabel];

        if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
            placeholderLabel.hidden=YES;
        }else{
            self.placeholderColor = color ? color : [UIColor lightGrayColor];;
            self.placeholderFont = font ? font : self.font;
            self.placeholder = placeholder;
            [self loadPlaceholderLabel];
        }
    }
    return self;
}
#pragma mark - Default methods

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = self.frame;
    frame.origin.x += kPlaceHolderLeftPadding;
//    frame.origin.y += kPlaceHolderTopPadding;
    frame.size.height = kPlaceHolderHeight;
    frame.size.width -= kPlaceHolderLeftPadding*2;
    placeholderLabel.frame = frame;
}

#pragma mark - Private methods
//  加载placeholderLabel
- (void)loadPlaceholderLabel
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(DidChange:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
    
    placeholderLabel.textColor = self.placeholderColor;
    placeholderLabel.font = self.placeholderFont;
    placeholderLabel.text=self.placeholder;
    [placeholderLabel layoutIfNeeded];
}

#pragma mark - Utils
//  当用户开始输入的时候执行
-(void)DidChange:(NSNotification*)notification{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        placeholderLabel.hidden=YES;
    }
    if (self.text.length > 0) {
        placeholderLabel.hidden=YES;
    }
    else{
        placeholderLabel.hidden=NO;
    }
}
@end
