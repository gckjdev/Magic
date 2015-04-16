//
//  TextToolView.h
//  BarrageClient
//
//  Created by pipi on 14/12/17.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TEXTTOOLVIEW_HEIGHT         55.0f

#define COLORBUTTON_WIDTH           56.0f
#define COLORBUTTON_PADDING         11.0F

#define COLORBUTTON_COLOR_BLACK         OPAQUE_COLOR(56,56,56)
#define COLORBUTTON_COLOR_WHITE         OPAQUE_COLOR(255,255,255)
#define COLORBUTTON_COLOR_VIOLET        OPAQUE_COLOR(0x66,0x33,0x99)
#define COLORBUTTON_COLOR_GREEN         OPAQUE_COLOR(0x33,0x99,0)
#define COLORBUTTON_COLOR_LIGHT_GREEN   OPAQUE_COLOR(0x66,0xcc,0x33)
#define COLORBUTTON_COLOR_BLUE          OPAQUE_COLOR(109,160,240)
#define COLORBUTTON_COLOR_SKY_BLUE      OPAQUE_COLOR(0,0,0x66)
#define COLORBUTTON_COLOR_NAVY          OPAQUE_COLOR(0,0x99,0xff)
#define COLORBUTTON_COLOR_LIGHT_BLUE    OPAQUE_COLOR(0x33,0xcc,0xcc)
#define COLORBUTTON_COLOR_ORANGE        OPAQUE_COLOR(0xff,0x99,0)
#define COLORBUTTON_COLOR_RED           OPAQUE_COLOR(0xff,0,0)
#define COLORBUTTON_COLOR_PINK          OPAQUE_COLOR(0xff,0x33,0x66)
#define COLORBUTTON_COLOR_YELLOW        OPAQUE_COLOR(0xff,0xff,0)
#define COLORBUTTON_COLOR_OLIVE_BROWN   OPAQUE_COLOR(0x66,0x66,0)

#define COLORBUTTON_TAG_INDEX       2015020500

#define COLORBUTTON_BG_INSETS                   10.0f
#define TEXTTOOLVIEW_BG_COLOR                   OPAQUE_COLOR(230,230,230)
#define TEXTTOOLVIEW_BTN_LEFT_OFFSET            10.0f
#define TEXTTOOLVIEW_CONTENT_WIDTH(COLOR_COUNT)              (COLOR_COUNT*(COLORBUTTON_WIDTH-COLORBUTTON_PADDING)           + TEXTTOOLVIEW_BTN_LEFT_OFFSET*2)


#define TEXTTOOLVIEW_SWITCHBUTTON_LEFT_PADDING          10.0f
#define TEXTTOOLVIEW_SWITCHBUTTON_WIDTH                 50.0f
#define TEXTTOOLVIEW_SWITCHBUTTON_HEIGHT                29.0f
#define TEXTTOOLVIEW_SWITCHBUTTON_RADIUS                16.0f
#define TEXTTOOLVIEW_SWITCHBUTTON_COLOR_NORMAL  OPAQUE_COLOR(0x84,0x84,0x84)
#define TEXTTOOLVIEW_SWITCHBUTTON_COLOR_SELECTED  OPAQUE_COLOR(0x78,0xc5,0x67)


typedef void (^ColorChangeBlock) (UIColor* color);
typedef void (^SwitchChangeBlock) ();
@interface TextToolView : UIView


@property (nonatomic, strong) UIColor *currentColor;
@property (nonatomic, strong) ColorChangeBlock colorChangeBlock;
@property (nonatomic,strong)  SwitchChangeBlock switchChangeBlock;
@end
