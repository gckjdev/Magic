//
//  PopupTextView.m
//  BarrageClient
//
//  Created by pipi on 14/12/18.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "PopupTextView.h"
#import "Masonry.h"
#import "PPDebug.h"

@interface PopupTextView()

@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) FinishPopupTextViewBackBlock callback;

@end

@implementation PopupTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        self.closeButton = [UIButton buttonWithType:UIButtonTypeInfoDark];
        [self addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.right.equalTo(self.mas_right);
        }];
        [self.closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
        
        self.textView = [[UITextView alloc] init];
        [self addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.height.equalTo(self.mas_height).with.offset(-10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.closeButton.mas_left).with.offset(-10);
        }];
    }
    return self;
}

+ (PopupTextView*)showInView:(UIView*)superView
                        text:(NSString*)text
                    callback:(FinishPopupTextViewBackBlock)callback
{
    CGRect frame;
    frame.origin.x = 50;
    frame.origin.y = 50;
    frame.size.height = 100;
    frame.size.width = superView.bounds.size.width/1.5f;
    
    PopupTextView* view = [[PopupTextView alloc] initWithFrame:frame];
    view.callback = callback;
    [superView addSubview:view];
    
    // show keyboard
    [view.textView setDelegate:view];
    [view.textView setText:text];
    [view.textView becomeFirstResponder];
    
    return view;
}

- (void)clickCloseButton:(id)sender
{
    EXECUTE_BLOCK(self.callback, self.textView.text);
    self.callback = nil;
    [self removeFromSuperview];
}

#pragma mark - TextView Delegate

- (void)textViewDidChange:(UITextView *)textView{
    
    
}

@end
