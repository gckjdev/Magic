//
//  BarrageTextFieldView.m
//  BarrageClient
//
//  Created by Teemo on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BarrageTextFieldView.h"
#import "StringUtil.h"
#import "FeedBarrageView.h"
#import "PPDebug.h"
#import "UIColor+UIColorExt.h"

@interface BarrageTextFieldView ()

@property(nonatomic,strong)UILabel *hintLabel;
@property(nonatomic,assign)BarrageTextModeType mode; //1: showMode  0:editMode

@end

@implementation BarrageTextFieldView

+(instancetype)FieldViewWithAction:(PBFeedActionBuilder*)action
                              mode:(BarrageTextModeType)mode
{
    CGRect frame;
    if (action.angel == 0) {
        frame = CGRectMake(BARRAGE_AVATAR_VIEW_WIDTH, 0, BARRAGETEXTVIEW_WIDTH_MAX-BARRAGE_AVATAR_VIEW_WIDTH, BARRAGETEXTVIEW_HEIGHT);
    }
    else{
         frame = CGRectMake(BARRAGETEXTVIEW_CONTENT_RIGHT_INSET, 0, BARRAGETEXTVIEW_WIDTH_MAX-BARRAGE_AVATAR_VIEW_WIDTH, BARRAGETEXTVIEW_HEIGHT);
    }
    BarrageTextFieldView* fieldView = [[BarrageTextFieldView alloc]initWithFrame:frame
                                                                          Action:action
                                                                            mode:mode];

    
   
    return fieldView;
}
- (instancetype)initWithFrame:(CGRect)frame
                       Action:(PBFeedActionBuilder*)action
                         mode:(BarrageTextModeType)mode
{
    self = [super initWithFrame:frame];
    if (self) {
        _action = action;
        _mode = mode;
        [self setupView];
    }
    return self;
}

-(void)setupView{
    
//    self.layer.cornerRadius = BARRAGETEXTVIEW_CORNERRADIUS;
    self.font  =  BARRAGETEXTVIEW_FONT;
    self.scrollEnabled = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.hintLabel = [[UILabel alloc]init];
    self.hintLabel.text = BARRAGETEXTVIEW_HINT_TEXT;
    self.hintLabel.textColor = [UIColor whiteColor];
    self.hintLabel.alpha = BARRAGETEXTVIEW_HINT_ALPHA;
    self.hintLabel.font = BARRAGETEXTVIEW_FONT;
    _hintLabel.frame = self.bounds;
    _hintLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:self.hintLabel];
    
    [self setTextColor:[UIColor whiteColor]];
    [self updateViewWithData:_action];
    
    if (_mode == BARRAGE_EDITMODE){
        [self editMode];
        [self setReturnKeyType:UIReturnKeyDefault];
        [self setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self becomeFirstResponder];
        
        
    }
    else{
        
        [self showMode];
        
    }
    
}
-(void)updateViewWithData:(PBFeedActionBuilder*)action
{
    _action = action;
    if ([_action hasColor]){
        UIColor* color;
        color = [UIColor decompressColorByInt:_action.color];
        self.textColor = color;
    }
    if ([_action hasText]) {
        self.text = _action.text;
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)setIsReversal:(BOOL)isReversal{
    _isReversal = isReversal;
}
#pragma mark - setup


-(void)setupTextInset:(BOOL)isHasBreak{
  
    UIEdgeInsets inset = UIEdgeInsetsZero;
    if (!isHasBreak)
    {
        inset.top =  BARRAGETEXTVIEW_CONTENT_TOP_INSET;
        self.textContainerInset = inset;
    }
    else
    {
        inset.top = BARRAGETEXTVIEW_CONTENT_TOP_NOT_INSET;
        self.textContainerInset = inset;
    }
}

-(void) setTextInset:(NSString*)text
{

     /*  判读是否有换行 */
     
    BOOL isHasBreak = NO;
    NSString *breakLineStr = @"\n";
    NSString *subStr = @"";
    NSRange range = [text rangeOfString:breakLineStr];
   
    if(range.length!=0)
    {
        isHasBreak = YES;
        subStr = [text substringFromIndex:range.location+range.length];
    }

    /* 获取text的宽度 */
    CGSize subStrSize = [subStr sizeWithMyFont:BARRAGETEXTVIEW_FONT
                        constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                            lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize textSize = [text sizeWithMyFont:BARRAGETEXTVIEW_FONT
                             constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)
                                 lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat maxTextWidth = subStrSize.width > textSize.width?subStrSize.width:textSize.width;
    
   
    if (maxTextWidth > BARRAGETEXTVIEW_JUDGE_WIDTH) {
        isHasBreak = YES;
    }

    self.isBreakLine = isHasBreak;
    
     /**  根据Text的宽度调整view的宽度 */
     

    CGFloat minWidth = BARRAGETEXTVIEW_EDIT_WIDTH_MIN;
    
     /*  显示模式下文字为空不显示背景*/
     
    if (!self.mode&&[text  isEqual: @""]) {
        minWidth = BARRAGE_AVATAR_VIEW_WIDTH;
    }
    [self setupFrame:maxTextWidth minWidth:minWidth isHasBreak:isHasBreak];
    [self setupTextInset: isHasBreak];
}

-(void)setupFrame:(CGFloat) maxTextWidth
         minWidth:(CGFloat)minWidth
       isHasBreak:(BOOL)isHasBreak{
    
    CGRect myFrame = self.frame;
    
    if (maxTextWidth + minWidth< BARRAGETEXTVIEW_WIDTH_MAX) {
        if (_mode==BARRAGE_EDITMODE) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:BARRAGETEXTVIEW_ANIMATION_DURATION];
            myFrame.size.width = maxTextWidth+minWidth-BARRAGE_AVATAR_VIEW_WIDTH-BARRAGETEXTVIEW_CONTENT_RIGHT_INSET;

            self.frame = myFrame;
            
            //view最大宽度
            _viewMaxWidth = maxTextWidth+minWidth;
            [UIView commitAnimations];
        }else{
            myFrame.size.width = maxTextWidth+minWidth-BARRAGE_AVATAR_VIEW_WIDTH-BARRAGETEXTVIEW_CONTENT_RIGHT_INSET;
            self.frame = myFrame;
            //view最大宽度
            _viewMaxWidth = maxTextWidth+minWidth;
        }
        
    }
    else
    {
        if (_mode==BARRAGE_EDITMODE) {
            [UIView setAnimationDuration:BARRAGETEXTVIEW_ANIMATION_DURATION];

            myFrame.size.width = BARRAGETEXTVIEW_WIDTH_MAX-BARRAGE_AVATAR_VIEW_WIDTH-BARRAGETEXTVIEW_CONTENT_RIGHT_INSET;
            self.frame = myFrame;
            //view最大宽度
            _viewMaxWidth = BARRAGETEXTVIEW_WIDTH_MAX;
            [UIView commitAnimations];
        }
        else{
            myFrame.size.width = BARRAGETEXTVIEW_WIDTH_MAX-BARRAGE_AVATAR_VIEW_WIDTH-BARRAGETEXTVIEW_CONTENT_RIGHT_INSET;
            self.frame = myFrame;
            //view最大宽度
            _viewMaxWidth = BARRAGETEXTVIEW_WIDTH_MAX;
        }
    }
    self.hintLabel.frame = self.bounds;
    EXECUTE_BLOCK(self.widthChangeBlock,_viewMaxWidth);
}

-(void)setText:(NSString *)text
{
    [super setText:text];
}
-(void) hiddenHintText
{
   [self setTextInset:self.text];
    self.hintLabel.hidden = YES;
}
-(void) showHintText
{
    [self setTextInset:self.hintLabel.text];
    self.hintLabel.hidden = NO;
}

-(void) editMode
{
    
    [self setSelectable:YES];
    [self setEditable:YES];
    [self showHintText];

}
-(void) showMode
{
    
    [self setEditable:NO];
    [self setSelectable:NO];
    [self hiddenHintText];
}
@end
