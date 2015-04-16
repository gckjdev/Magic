//
//  TextToolView.m
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "TextToolView.h"
#import "Masonry.h"
#import "PPDebug.h"
#import "ColorInfo.h"
#import "UIImageUtil.h"
#import "ToolTabButton.h"
#import "UIViewUtils.h"
#import "UIImageUtil.h"
#import "BarrageConfigManager.h"






@interface TextToolView()

@property (nonatomic,strong) UIScrollView *scrollView;//选择颜色的scrollview
@property (nonatomic,strong) UIView *leftView;//选择背景开关的view
@property (nonatomic,strong) ToolTabButton *switchBtn;//选择背景开关的button

@property (nonatomic, weak) ToolTabButton *selectedButton;
@property (nonatomic,strong) NSMutableDictionary *myColor;
@property (nonatomic,strong) NSMutableArray *myTag;

@end
@implementation TextToolView



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
-(void)initialize{
    /**
     *  init data
     */
    self.myColor = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    COLORBUTTON_COLOR_WHITE,            @"0",
                    COLORBUTTON_COLOR_RED,              @"1",
                    COLORBUTTON_COLOR_YELLOW,           @"2",
                    COLORBUTTON_COLOR_GREEN,            @"3",
                    COLORBUTTON_COLOR_SKY_BLUE,         @"4",
                    COLORBUTTON_COLOR_PINK,             @"5",
                    COLORBUTTON_COLOR_LIGHT_GREEN,      @"6",
                    COLORBUTTON_COLOR_NAVY,             @"7",
                    COLORBUTTON_COLOR_ORANGE,           @"8",
                    COLORBUTTON_COLOR_VIOLET,           @"9",
                    COLORBUTTON_COLOR_LIGHT_BLUE,       @"10",
                    COLORBUTTON_COLOR_OLIVE_BROWN,      @"11",
                    nil];
    self.myTag=  [[NSMutableArray alloc]init];
    
    
    
    /**
     *  ScrollView init
     */
    self.scrollView = [[UIScrollView alloc]init];
//    self.scrollView.contentSize = CGSizeMake(0, TEXTTOOLVIEW_HEIGHT);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.scrollView setBackgroundColor: TEXTTOOLVIEW_BG_COLOR];
    [self addSubview:self.scrollView];
    
    
    /**
     *  ColorButton init
     */
    
    [self initColorBtn];
    

    /**
     *  LeftView init
     */
    
    self.leftView = [[UIView alloc]init];
    [self.leftView setBackgroundColor: TEXTTOOLVIEW_BG_COLOR];
    [self.leftView addSubview:self.switchBtn];
    [self addSubview:self.leftView];
    
    /**
     *  SwitchButton init
     */
    self.switchBtn = [[ToolTabButton alloc]init];
    [self.switchBtn setImage:[UIImage imageNamed:@"hasbgbtn_normal"] forState:UIControlStateNormal];
    [self.switchBtn setImage:[UIImage imageNamed:@"hasbgbtn_selected"] forState:UIControlStateSelected];
    [self.switchBtn setBackgroundImage:[UIImage imageFromColor:TEXTTOOLVIEW_SWITCHBUTTON_COLOR_NORMAL corner:CornerAll radius:TEXTTOOLVIEW_SWITCHBUTTON_RADIUS] forState:UIControlStateNormal];
     [self.switchBtn setBackgroundImage:[UIImage imageFromColor:TEXTTOOLVIEW_SWITCHBUTTON_COLOR_SELECTED corner:CornerAll radius:TEXTTOOLVIEW_SWITCHBUTTON_RADIUS] forState:UIControlStateSelected];
    [self.switchBtn addTarget:self action:@selector(onSwitchBtnClick) forControlEvents:UIControlEventTouchDown];
 

    [self.leftView addSubview:self.switchBtn];
    

}
- (void) onSwitchBtnClick
{
    self.switchBtn.selected =  !self.switchBtn.selected;

    EXECUTE_BLOCK(self.switchChangeBlock);
}
- (void) initColorBtn{
    NSArray *keys = [self.myColor allKeys];
    NSInteger  length = [keys count];
    self.scrollView.contentSize = CGSizeMake(TEXTTOOLVIEW_CONTENT_WIDTH(length), TEXTTOOLVIEW_HEIGHT);
    for (int i = 0; i<length; i++ )
    {
        
        int tmpX = i*(COLORBUTTON_WIDTH-COLORBUTTON_PADDING)+TEXTTOOLVIEW_BTN_LEFT_OFFSET;
        int tmpY =  COLORBUTTON_PADDING/2;
        int tmpWidth =  COLORBUTTON_WIDTH-COLORBUTTON_PADDING;
        int tmpHeight = COLORBUTTON_WIDTH-COLORBUTTON_PADDING;
        CGRect btnFrame = CGRectMake(tmpX,tmpY,tmpWidth ,tmpHeight);
        
        NSString *keyStr = [[NSString alloc] initWithFormat:@"%d",i];
        UIColor *currBtnColor = (UIColor*)[self.myColor objectForKey:keyStr];
        UIImage *colorBtnSelImg = [UIImage imageNamed:@"color_selected"];
        UIImage *colorBtnNol = [UIImage imageFromCircleColor: currBtnColor
                                                      radius:COLORBUTTON_WIDTH/4.0f];
        ToolTabButton * colorBtn = [[ToolTabButton alloc]initWithFrame:btnFrame];
        
        NSNumber *tag = @(i + COLORBUTTON_TAG_INDEX);
        
        colorBtn.tag = [tag integerValue];
        [colorBtn setBackgroundImage:colorBtnSelImg forState:UIControlStateSelected];
        [colorBtn setImage:colorBtnNol forState:UIControlStateNormal];
        
        
        [self.myTag insertObject:tag atIndex:i];
        
        [colorBtn addTarget:self action:@selector(onColorBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self.scrollView addSubview:colorBtn];
        
        //默认选中第一个按钮
        if(i==0)
        {
            [self onColorBtnClick:colorBtn];
        }
    }
    
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    [self layoutSetFrame];

}

-(void)layoutSetFrame
{
    //隐藏选择背景按钮
#ifdef showBGBTN
    self.scrollView.frame = self.bounds;
    CGRect tmpFrame = self.scrollView.frame;
    tmpFrame.origin.x = TEXTTOOLVIEW_SWITCHBUTTON_WIDTH + TEXTTOOLVIEW_SWITCHBUTTON_LEFT_PADDING*2;
    tmpFrame.size.width -= TEXTTOOLVIEW_SWITCHBUTTON_WIDTH + TEXTTOOLVIEW_SWITCHBUTTON_LEFT_PADDING*2;
    self.scrollView.frame = tmpFrame;
    
    self.leftView.frame = self.bounds;
    tmpFrame = self.leftView.frame;
    tmpFrame.size.width = TEXTTOOLVIEW_SWITCHBUTTON_WIDTH + TEXTTOOLVIEW_SWITCHBUTTON_LEFT_PADDING*2;
    self.leftView.frame = tmpFrame;
    
    [_switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.leftView);
        make.size.mas_equalTo(CGSizeMake(TEXTTOOLVIEW_SWITCHBUTTON_WIDTH, TEXTTOOLVIEW_SWITCHBUTTON_HEIGHT));
    }];
#else
    self.scrollView.frame = self.bounds;

#endif
  
    
}

-(UIColor*)getCurSelColor:(int)tag
{

    NSArray *keys = [self.myColor allKeys];
    NSInteger  length = [keys count];
    for(int i = 0;i<length;i++)
    {
        
        NSNumber *tmp = [self.myTag objectAtIndex:i];

        if ([tmp intValue]==tag) {
            NSString *keyStr = [[NSString alloc] initWithFormat:@"%d",i];
            return (UIColor*)[self.myColor objectForKey:keyStr];
        }
    }
    return nil;
}
- (void)onColorBtnClick:(ToolTabButton *)button
{
    // 让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    [button setSelected:YES];
    
    self.selectedButton = button;
    
    //get selected color
    UIColor* currColor = [self getCurSelColor:(int)button.tag] ;
    // set selected color
    self.currentColor = currColor;
    
    // invoke selected callback
    EXECUTE_BLOCK(self.colorChangeBlock, self.currentColor);
}
@end
