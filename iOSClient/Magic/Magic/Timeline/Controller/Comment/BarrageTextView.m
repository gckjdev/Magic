//
//  BarrageTextView.m
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "BarrageTextView.h"
#import "Masonry.h"
#import "UserAvatarView.h"
#import "FeedBarrageView.h"
#import "UserManager.h"
#import "FontInfo.h"
#import "ColorInfo.h"

#import "Barrage.pb.h"
#import "UIImageUtil.h"
#import "StringUtil.h"
#import "UIColor+UIColorExt.h"
#import "MKBlockActionSheet.h"
#import "MessageCenter.h"


#define kShadowColor1		[UIColor blackColor]
#define kShadowColor2		[UIColor colorWithWhite:0.0 alpha:0.75]
#define kShadowOffset		CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)
#define kShadowBlur			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0 : 5.0)
#define kInnerShadowOffset	CGSizeMake(0.0, UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 2.0 : 1.0)
#define kInnerShadowBlur	(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0 : 2.0)

#define kStrokeColor		[UIColor blackColor]
#define kStrokeSize			(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0 : 3.0)

#define kGradientStartColor	[UIColor colorWithRed:255.0 / 255.0 green:193.0 / 255.0 blue:127.0 / 255.0 alpha:1.0]
#define kGradientEndColor	[UIColor colorWithRed:255.0 / 255.0 green:163.0 / 255.0 blue:64.0 / 255.0 alpha:1.0]





@interface BarrageTextView()<UITextViewDelegate>

@property (nonatomic, strong) UserAvatarView* avatarView;

@property (nonatomic, assign) BarrageTextModeType mode;

@property (nonatomic, assign)       BOOL    isReversal;
@end

@implementation BarrageTextView



+(instancetype)initWithFeedAction:(PBFeedAction*)feedAction
                             mode:(BarrageTextModeType) modeType

{
    PBFeedActionBuilder* builder = (feedAction == nil) ? [PBFeedAction builder] : [PBFeedAction builderWithPrototype:feedAction];
    BarrageTextView *bView = [[BarrageTextView alloc]initWithFeedActionBuilder:builder mode:modeType];
    CGRect frame = bView.frame;
    if (builder!=nil) {
        bView.frame = (CGRect){CGPointMake(builder.posX, builder.posY),frame.size};
    }
    else{
        bView.frame = (CGRect){CGPointMake(0, 0),frame.size};
    }
 
    return bView;
}

- (instancetype)initWithFeedActionBuilder:(PBFeedActionBuilder*)feedActionBuilder mode:(BarrageTextModeType) modeType
{
    self = [super init];
    if (self){
        
        _mode = modeType;
        _textBuilder = feedActionBuilder;
        
        [self initialView];
        [self addLongPressHandler];
        [self updateViewWithData:feedActionBuilder];
    }
    return self;
    
}
-(void)initialView
{
    
    
    /* 添加头像的View  */
    [self setupAvatarView];
    
    /* 右边的编辑框和显示栏的View */
    [self setupBarrageTextView];
    
    
    
    if (_textBuilder.angel == 180) {
        _isReversal = YES;
    }
}
-(void)setupAvatarView
{
    PBUser* user = _textBuilder.user;
    CGRect frame = CGRectMake(0, 0, BARRAGE_AVATAR_VIEW_WIDTH, BARRAGE_AVATAR_VIEW_WIDTH);
    self.avatarView = [[UserAvatarView alloc] initWithUser:user frame:frame borderWidth:BARRAGE_AVATAR_BORDER_WIDTH];
   
    [self addSubview:self.avatarView];

}
-(void)setupBarrageTextView
{
    _textFieldView = [BarrageTextFieldView FieldViewWithAction:_textBuilder
                                                              mode:_mode];
    [self addSubview:_textFieldView];
    [self sendSubviewToBack:_textFieldView];
    
    
    
    __weak typeof(self) weakSelf = self;
    _textFieldView.widthChangeBlock=^(CGFloat width){
        [weakSelf changeViewWidth];
    };
    
    _textFieldView.delegate = self;
    
    // set bg
    if (_textBuilder.hasBg) {
        
        [self setBackgroundColorTrans:_textBuilder.hasBg animation:NO];
    }
   

}
- (void)changeViewWidth{
    
    CGFloat viewMaxWidth = self.textFieldView.viewMaxWidth;
    CGRect frame = self.frame;
    frame.size.height = BARRAGETEXTVIEW_HEIGHT;
    
    
    
    
    if (_mode == BARRAGE_SHOWMODE &&[_textBuilder.text isEqualToString:@""]) {
        frame.size.width = BARRAGE_AVATAR_VIEW_WIDTH;

        self.frame = frame;
        
        _avatarView.frame = self.bounds;
        return;
    }
    [UIView beginAnimations:nil context:nil];
    if (_isReversal) {
        frame = _avatarView.frame;
        frame.origin.x = viewMaxWidth - BARRAGE_AVATAR_VIEW_WIDTH ;
        _avatarView.frame = frame;
    }
    else{
        frame = _avatarView.frame;
        frame.origin.x = 0;
        _avatarView.frame = frame;
    }
    frame = self.frame;
    frame.size.width = viewMaxWidth;
    frame.size.height = BARRAGETEXTVIEW_HEIGHT;
    self.frame = frame;
    
    [UIView commitAnimations];
    

}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self changeViewWidth];
  
}
- (void)addLongPressHandler
{
    if (self.mode == BARRAGE_SHOWMODE) {
        // 长按的 Recognizer
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(addLongPressAction:)];
        
        [longPressRecognizer setNumberOfTouchesRequired:1];
        [self addGestureRecognizer:longPressRecognizer];
    }
   
}

/* 长按触发事件 */
-(void)addLongPressAction:(UILongPressGestureRecognizer*)recognizer
{
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSString *makeSure = @"删除弹幕";
        MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                           initWithTitle:@"选项"delegate:nil
                                           cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:makeSure, nil];
        
        __weak typeof (actionSheet) as = actionSheet;
        [actionSheet setActionBlock:^(NSInteger buttonIndex){
            NSString *title = [as buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:makeSure]) {
                EXECUTE_BLOCK(self.longPressBlock, self);
            }
        }];
        [actionSheet showInView:self];
    }
}

/**
 *  根据输入文字自动换行
 */
- (void)textViewDidChange:(UITextView *)textView
{

    if([textView.text  isEqual: @""])
    {
        [self.textFieldView showHintText];
    }
    else
    {
        [self.textFieldView hiddenHintText];
    }
    
    //set view frame
    [self changeViewWidth];
    
    if (self.textFieldView.isBreakLine) {
        if (self.textFieldView.returnKeyType != UIReturnKeyDone){
            [self.textFieldView setReturnKeyType:UIReturnKeyDone];
            [self.textFieldView resignFirstResponder];
            [self.textFieldView becomeFirstResponder];
            
        }
    }
    else
    {
        if (self.textFieldView.returnKeyType != UIReturnKeyDefault){
            [self.textFieldView setReturnKeyType:UIReturnKeyDefault];
            [self.textFieldView resignFirstResponder];
            [self.textFieldView becomeFirstResponder];
        }
    }
 
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
//    [self.textFieldView reloadInputViews];
    return YES;
}
/**
 *  限制输入长度
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
   
    if ([text isEqualToString:@""] && range.length > 0) {
        //删除字符肯定是安全的
     
        return YES;
    }
    else if ([text isEqualToString:@"\n"]) {
        if (self.textFieldView.isBreakLine) {
            [textView resignFirstResponder];
            //点键盘完成调用block
            EXECUTE_BLOCK(self.keyboardFinishBlock);
            
            return NO;
        }
    }
    else {
        int padding = 10;
        CGSize subStrSize = [text sizeWithMyFont:BARRAGETEXTVIEW_FONT
                                 constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                                     lineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize textSize = [textView.text sizeWithMyFont:BARRAGETEXTVIEW_FONT
                             constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat limitWidth =   BARRAGETEXTVIEW_JUDGE_WIDTH;
//        PPDebug(@"neng : %f %f",subStrSize.width +  textSize.width,limitWidth);
//        PPDebug(@"neng : width %f",self.frame.size.width);
        if (subStrSize.width +  textSize.width> limitWidth*2-padding) {
            return NO;
        }
       
    }
    return YES;
}
-(void)setBackgroundColorTrans:(BOOL)hasBg
                    animation :(BOOL)animation
{
    if (hasBg) {
        if (animation) {
            [UIView beginAnimations:nil context:nil];
            [UIView    setAnimationCurve: UIViewAnimationCurveLinear];
            [UIView    setAnimationDelegate:self];
            [UIView    setAnimationDuration:0.5];
            [self setBackgroundColor:BARRAGETEXTVIEW_BG_COLOR];
            [UIView commitAnimations];
        }
        else{
            [self setBackgroundColor:BARRAGETEXTVIEW_BG_COLOR];
        }
        
        _textBuilder.hasBg = YES;
    }
    else{
        if (animation) {
            [UIView beginAnimations:nil context:nil];
            [UIView    setAnimationCurve: UIViewAnimationCurveLinear];
            [UIView    setAnimationDelegate:self];
            [UIView    setAnimationDuration:0.5];
            [self setBackgroundColor:BARRAGETEXTVIEW_BG_COLOR_OPACITY];
            [UIView commitAnimations];
        }
        else
        {
            [self setBackgroundColor:BARRAGETEXTVIEW_BG_COLOR_OPACITY];
        }
        _textBuilder.hasBg = NO;
    }
    self.layer.cornerRadius = BARRAGETEXTVIEW_CORNERRADIUS;
}

-(void)setTextColor:(UIColor*)color
{
    _textBuilder.color = (UInt32)[UIColor compressColor:color];
    [_textFieldView setTextColor:color];
}
-(void)setDataPostion{
    _textBuilder.posX = self.frame.origin.x;
    _textBuilder.posY = self.frame.origin.y;
}
-(void)setDataText{
    _textBuilder.text = _textFieldView.text;
}
-(PBFeedAction*)getBarrageData
{
    PBFeedAction *action = nil;
    if(_textBuilder!=nil){
        [self setDataPostion];
        [self setDataText];
        action = [_textBuilder build];
    }
    return action;
}
- (void)updateViewWithData:(PBFeedActionBuilder*)data;
{
    _textBuilder = data;
  
    [_textFieldView updateViewWithData:_textBuilder];
    
    // set bg
    [self setBackgroundColorTrans:_textBuilder.hasBg animation:YES];
    
    // update avatar
    [self.avatarView updateUser:self.textBuilder.user];
    
    if (_textBuilder.angel == 180) {
        [self setIsReversal:YES animation:NO];
    }else{
        [self setIsReversal:NO animation:NO];
    }
}
-(void)setIsReversal:(BOOL)isReversal
           animation:(BOOL)animation{
    _isReversal = isReversal;
    if (_isReversal) {
        [self reversal:animation];
    }else{
        [self unReversal:animation];
    }
}
-(void)reversal:(BOOL)animation
{
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView    setAnimationDuration:BARRAGETEXTVIEW_ANIMATION_DURATION];
        CGRect avaFrame = _avatarView.frame;
        CGRect textFrame = _textFieldView.frame;
        avaFrame.origin.x = self.frame.size.width - BARRAGE_AVATAR_VIEW_WIDTH;
        textFrame.origin.x  = BARRAGETEXTVIEW_CONTENT_RIGHT_INSET;
        
        _avatarView.frame = avaFrame;
        _textFieldView.frame = textFrame;
        [UIView commitAnimations];
    }
    else{
        CGRect avaFrame = _avatarView.frame;
        CGRect textFrame = _textFieldView.frame;
        avaFrame.origin.x = CGRectGetMaxX(textFrame) - BARRAGE_AVATAR_VIEW_WIDTH;
        
        _avatarView.frame = avaFrame;
    }
    
    _isReversal = YES;
    _textFieldView.isReversal = _isReversal;
    
    
    _textBuilder.angel = 180;
}
-(void)unReversal:(BOOL)animation
{
    if (animation) {
        [UIView beginAnimations:nil context:nil];
        [UIView    setAnimationDuration:BARRAGETEXTVIEW_ANIMATION_DURATION];
        CGRect avaFrame = _avatarView.frame;
        CGRect textFrame = _textFieldView.frame;
        avaFrame.origin.x = 0;
        
        textFrame.origin.x = BARRAGE_AVATAR_VIEW_WIDTH;
        _avatarView.frame = avaFrame;
        _textFieldView.frame = textFrame;
        [UIView commitAnimations];
    }else{
        CGRect avaFrame = _avatarView.frame;
        CGRect textFrame = _textFieldView.frame;
        avaFrame.origin.x = 0;
        
        textFrame.origin.x = BARRAGE_AVATAR_VIEW_WIDTH;
        _avatarView.frame = avaFrame;
        _textFieldView.frame = textFrame;
    }
  
    _isReversal = NO;
    _textFieldView.isReversal = _isReversal;
    
    _textBuilder.angel = 0;
}
@end
