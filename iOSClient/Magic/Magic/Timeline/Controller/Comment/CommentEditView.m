//
//  CommentEditView.m
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "CommentEditView.h"
#import "Feed.h"
#import "FeedBarrageView.h"
#import "BarrageTextView.h"
#import "Masonry.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "UIImageView+WebCache.h"
#import "UILineGridsView.h"
#import "ColorInfo.h"
#import "BarrageConfigManager.h"
#import "UIView+Dragging.h"
#import "UILabel+Extend.h"

#define COMMENTEDITVIEW_BARRAGEVIEW_TAG        2015030300
#define COMMENTEDITVIEW_BARRAGEVIEW_TAG_END    2015039999
#define COMMENTEDITVIEW_BARRAGEVIEW_IS_BARRAGE_VIEW(tag)        ( (tag >= COMMENTEDITVIEW_BARRAGEVIEW_TAG) && (tag <= COMMENTEDITVIEW_BARRAGEVIEW_TAG_END) )


@interface CommentEditView()<DraggingDelegate>

@property (nonatomic, copy) NSMutableArray *arraybarrageList;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UILineGridsView *lineGridsView;

@end

@implementation CommentEditView

+(instancetype)editViewWithFeed:(Feed*)feed
                     barragePos:(CGPoint)barragePos
{
    CommentEditView *editView = [[CommentEditView alloc]initWithFeed:feed
                                                          barragePos:barragePos];
  
    return editView;
}

- (instancetype)initWithFeed:(Feed*)feed
                  barragePos:(CGPoint)barragePos
{
    self = [super init];
    if (self){
        
        _feed = feed;
        
        _barragePos = barragePos;
        
        [self initImageView];
        
        [self initLineGridsView];
        
        [self initInputView];
      
        [self defaultSetting];
    }
    
    return self;
}
-(void)initImageView{
    self.bounds = CGRectMake(0, 0, BARRAGE_VIEW_WIDTH, BARRAGE_VIEW_HEIGHT);
    self.clipsToBounds = YES;
    
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:_feed.feedBuilder.image]
                      placeholderImage:nil
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             }];
    [self addSubview:self.imageView];
}
-(void)initLineGridsView
{
    _lineGridsView = [[UILineGridsView alloc]initWithFrame:self.bounds];
    [_lineGridsView setBackgroundColor:COLOR_LUCENCY];
    [_lineGridsView setLineColor:COMMENTEDITVIEW_GRIDSVIEW_BG_COLOR];
    [_lineGridsView setHidden:NO];
    [self addSubview:_lineGridsView];
}
-(void)initInputView{
    self.textInputView = [BarrageTextView initWithFeedAction:nil  mode:BARRAGE_EDITMODE];
    [self addSubview:self.textInputView];
    
    CGRect frame = _textInputView.frame;
    
    frame.origin = _barragePos;
    
    _textInputView.frame = frame;
    
     self.textInputView.actionDelegate = self;
    [self.textInputView setDraggableInView:CGSizeMake(800, 800)];
   
    
}
- (void)draggableOutOfView:(int)dir
{
    if (dir == 4) {
        [_textInputView setIsReversal:YES animation:YES];
    }else if(dir ==3){
        [_textInputView setIsReversal:NO animation:YES];
    }
}
-(void)defaultSetting{
    [self setHasGridsView:(BOOL)APP_EDITVIEW_GRID];
    [self setHasBarrageViews:(BOOL)APP_EDITVIEW_PREVIEW_BARRAGE];
}

- (void)setBarrageActions:(NSArray*)barrages
{
    // remove old view
    [self removeAllBarrageViews];
    
     _arraybarrageList = [NSMutableArray arrayWithArray:barrages];
    
    //set subviews and add to super view
    for(int i = 0; i < [_arraybarrageList count]; i++)
    {
        PBFeedAction* feedAction = [_arraybarrageList objectAtIndex:i];
        BarrageTextView* bView;
 
        bView = [BarrageTextView initWithFeedAction:feedAction mode:BARRAGE_SHOWMODE];
    
        bView.tag = COMMENTEDITVIEW_BARRAGEVIEW_TAG+i;
        bView.userInteractionEnabled = NO;
        [self addSubview:bView];
    }
    //输入框总在最前面
    [self  bringSubviewToFront:self.textInputView];
}
- (void)addAllBarrageViews
{
    [self setBarrageActions:_feed.feedBuilder.actions];
}
- (void)removeAllBarrageViews
{
    for (UIView* view in self.subviews){
        BOOL flag = COMMENTEDITVIEW_BARRAGEVIEW_IS_BARRAGE_VIEW(view.tag);
        if (flag){
            [view removeFromSuperview];
        }
    }
}

- (void)updateView:(Feed*)feed feedAction:(PBFeedActionBuilder*)actionBuilder
{

    [self.textInputView updateViewWithData:actionBuilder];
    
//    [self setStartPos:CGPointMake(actionBuilder.posX, actionBuilder.posY)];
    
}
- (void)resignKeyboard
{
    
    [self.textInputView.textFieldView resignFirstResponder];
}
-(void)setStartPos:(CGPoint)pos
{
    CGRect frame = self.textInputView.frame;

    frame.origin = pos;
    self.textInputView.frame= frame;
  
   
}
- (CGFloat)barragePosX
{
    return self.textInputView.frame.origin.x;
}

- (CGFloat)barragePosY
{
    return self.textInputView.frame.origin.y;
}

- (NSString*)barrageText
{
    return self.textInputView.textFieldView.text;
}
-(void)addGridsView
{
    [_lineGridsView setHidden:NO];
}
-(void)removeGridsView{
    [_lineGridsView setHidden:YES];
}
-(void)setHasGridsView:(BOOL)hasGridsView
{
    _hasGridsView = hasGridsView;
    if (_hasGridsView) {
        [self addGridsView];
    }else
    {
        [self removeGridsView];
    }
}
-(void)setHasBarrageViews:(BOOL)hasBarrageViews
{
    _hasBarrageViews = hasBarrageViews;
    if (_hasBarrageViews) {
        [self addAllBarrageViews];
    }
    else{
        [self removeAllBarrageViews];
    }
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
