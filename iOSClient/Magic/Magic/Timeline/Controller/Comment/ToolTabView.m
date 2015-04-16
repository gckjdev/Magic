//
//  ToolTabView.m
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "ToolTabView.h"
#import "ColorInfo.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "FontInfo.h"
#import "ToolTabButton.h"
#import "MessageCenter.h"

#define TOOLCOUNT                               3.0f
#define BUTTON_IMAGE_BOTTOM_PADDING             10.0f
#define TABBARLABEL_COLOR                       OPAQUE_COLOR(158,158,158)
#define SELECT_BUTTON_FONT                      ([UIFont systemFontOfSize:10])
#define TABBAR_LABEL_BOTTOM_OFFSET              -5
#define  TOOLTABVIEW_DEFAULT_HINTMEASSGE         @"本功能正在开发中"

@interface ToolTabView ()
@property (nonatomic,strong) UILabel* editTextLab;
@property (nonatomic,strong) UILabel* graffitLab;
@property (nonatomic,strong) UILabel* tagLab;
@property (nonatomic, weak) ToolTabButton *selectedButton;
@end

@implementation ToolTabView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initView];
        [self setBackgroundColor: BARRAGE_BG_WHITE_COLOR];
    }
    return self;
}


-(void)initView{
    
    CGFloat btnWidth = kScreenWidth/TOOLCOUNT;
    ToolTabButton *editTextBtn = [[ToolTabButton alloc]initWithFrame:CGRectMake(0, 0, btnWidth, TOOLTABVIEW_HEIGHT)];
    UIImage *editTextImageNol = [UIImage imageNamed:@"text_normal"];
    UIImage *editTextImageSel = [UIImage imageNamed:@"text_selected"];
    [editTextBtn setImage:editTextImageNol forState:UIControlStateNormal];
    [editTextBtn setImage:editTextImageSel forState:UIControlStateSelected];
    [editTextBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, BUTTON_IMAGE_BOTTOM_PADDING,0.0)];
    [editTextBtn setTag:EDITTEXTBTN_TAG];
    [editTextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:editTextBtn];
    [editTextBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width).dividedBy(TOOLCOUNT);
        make.height.equalTo(self.mas_height);
        //        make.center.equalTo(self);
        make.centerX.equalTo(self.mas_centerX).dividedBy(3);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    self.editTextLab = [[UILabel alloc]init];
    [self.editTextLab setText:@"文字"];
    [self.editTextLab setTextColor:TABBARLABEL_COLOR];
    [self.editTextLab setFont:SELECT_BUTTON_FONT];
    [self addSubview:self.editTextLab];
    [self.editTextLab  mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(editTextBtn.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).with.offset(TABBAR_LABEL_BOTTOM_OFFSET);
        make.centerX.equalTo(editTextBtn.mas_centerX);
        
    }];
    
    
    
    
    
    ToolTabButton *graffitBtn = [[ToolTabButton alloc]init];
    UIImage *graffitImageNol = [UIImage imageNamed:@"graffiti_normal"];
    UIImage *graffitImageSel = [UIImage imageNamed:@"graffiti_selected"];
    [graffitBtn setImage:graffitImageNol forState:UIControlStateNormal];
    [graffitBtn setImage:graffitImageSel forState:UIControlStateSelected];
    [graffitBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, BUTTON_IMAGE_BOTTOM_PADDING,0.0)];
    [graffitBtn setTag:GRAFFITBTN_TAG];
    [graffitBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:graffitBtn];
    
    
    
    [graffitBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width).dividedBy(TOOLCOUNT);
        make.height.equalTo(self.mas_height);
        make.center.equalTo(self);
        //        make.centerX.equalTo(self.mas_centerX);
        //        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    self.graffitLab = [[UILabel alloc]init];
    [self.graffitLab setText:@"涂鸦"];
    [self.graffitLab setTextColor:TABBARLABEL_COLOR];
    [self.graffitLab setFont:SELECT_BUTTON_FONT];
    [self addSubview:self.graffitLab];
    [self.graffitLab  mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(editTextBtn.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).with.offset(TABBAR_LABEL_BOTTOM_OFFSET);
        make.centerX.equalTo(graffitBtn.mas_centerX);
        
    }];
    
    
    
    
    ToolTabButton *tagBtn = [[ToolTabButton alloc]init];
    UIImage *tagImageNol = [UIImage imageNamed:@"tag_normal"];
    UIImage *tagImageSel = [UIImage imageNamed:@"tag_selected"];
    [tagBtn setImage:tagImageNol forState:UIControlStateNormal];
    [tagBtn setImage:tagImageSel forState:UIControlStateSelected];
    [tagBtn setTag:TAGBTN_TAG];
    [tagBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0, BUTTON_IMAGE_BOTTOM_PADDING,0.0)];
    [tagBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:tagBtn];
    
    
    
    [tagBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.mas_width).dividedBy(TOOLCOUNT);
        make.height.equalTo(self.mas_height);
        //        make.center.equalTo(self);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    
    self.tagLab = [[UILabel alloc]init];
    [self.tagLab setText:@"贴纸"];
    [self.tagLab setTextColor:TABBARLABEL_COLOR];
    [self.tagLab setFont:SELECT_BUTTON_FONT];
    [self addSubview:self.tagLab];
    [self.tagLab  mas_updateConstraints:^(MASConstraintMaker *make) {
        //        make.top.equalTo(editTextBtn.mas_bottom);
        make.bottom.equalTo(self.mas_bottom).with.offset(TABBAR_LABEL_BOTTOM_OFFSET);
        make.centerX.equalTo(tagBtn.mas_centerX);
        
    }];
    
    /**
     *  设置默认首选
     */
    [self buttonClick:editTextBtn];
}
- (void) layoutSubviews
{
    
    
 
    [super layoutSubviews];
   
}

-(void)SetLabSelectColor:(int)tag
{
    if (tag == EDITTEXTBTN_TAG) {
        
        [self.editTextLab  setTextColor:BARRAGE_RED_COLOR];
    }
    else if (tag == GRAFFITBTN_TAG)
    {
        [self.graffitLab  setTextColor:BARRAGE_RED_COLOR];
        POSTMSG(TOOLTABVIEW_DEFAULT_HINTMEASSGE);
    }
    else if (tag == TAGBTN_TAG)
    {
        [self.tagLab  setTextColor:BARRAGE_RED_COLOR];
         POSTMSG(TOOLTABVIEW_DEFAULT_HINTMEASSGE);
    }
}

-(void)SetLabNormalColor:(int)tag
{
    if (tag == EDITTEXTBTN_TAG) {
        
        [self.editTextLab  setTextColor:TABBARLABEL_COLOR];
    }
    else if (tag == GRAFFITBTN_TAG)
    {
        [self.graffitLab  setTextColor:TABBARLABEL_COLOR];
    }
    else if (tag == TAGBTN_TAG)
    {
        [self.tagLab  setTextColor:TABBARLABEL_COLOR];
    }
}
- (void)buttonClick:(ToolTabButton *)button
{
    // 1.让当前选中的按钮取消选中
    self.selectedButton.selected = NO;
    [self SetLabNormalColor:(int)self.selectedButton.tag];
    
    [button setSelected:YES];
    [self SetLabSelectColor:(int)button.tag];
    
    self.selectedButton = button;
}
@end
