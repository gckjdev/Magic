//
//  ColorInfo.h
//  BarrageClient
//
//  Created by pipi on 14/12/16.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import "UIColor+UIColorExt.h"

#ifndef BarrageClient_ColorInfo_h
#define BarrageClient_ColorInfo_h

#define TABLE_CELL_LINE_COLOR           OPAQUE_COLOR(0xe7, 0xe7, 0xe7)

// 通用红色
#define BARRAGE_RED_COLOR               OPAQUE_COLOR(0xec, 0x51, 0x52)      // TO BE CHANGED

// 通用灰色背景
#define BARRAGE_BG_GRAY_COLOR           OPAQUE_COLOR(254, 198, 48)      // TO BE CHANGED

// 通用白色背景
#define BARRAGE_BG_WHITE_COLOR           [UIColor whiteColor]      // TO BE CHANGED

//按钮标题的颜色
#define BUTTON_TITLE_COLOR               OPAQUE_COLOR(0xFF,0xFF,0xFF)

//  label字体黑色
#define BARRAGE_LABEL_COLOR         OPAQUE_COLOR(33,33,33)

//  label字体灰色
#define BARRAGE_LABEL_GRAY_COLOR           OPAQUE_COLOR(84, 84, 84)

//  label字体红色
#define BARRAGE_LABEL_RED_COLOR             OPAQUE_COLOR(0XED, 50, 50)

//  通用背景颜色
#define BARRAGE_BG_COLOR                    OPAQUE_COLOR(0Xf5,0Xf5,0Xf5)

//   消息流背景颜色
#define BARRAGE_NEWS_BG_COLOR                    COLOR1(0X00,0X00,0X00,0.7)

//  cell边框颜色
#define BARRAGE_CELL_LAYER_COLOR                    OPAQUE_COLOR(0Xdf,0Xdf,0Xdf)

//  边框颜色
#define BARRAGE_LAYER_COLOR                    BARRAGE_CELL_LAYER_COLOR

//  textField字体 邀请好友页面 label颜色
#define BARRAGE_TEXTFIELD_COLOR         OPAQUE_COLOR(33,33,33)

//  textField边框颜色
#define BARRAGE_TEXTFIELD_LAYER_COLOR         OPAQUE_COLOR(0XD6,0XDD,0XE0)

//  QQ登录/注册按钮背景颜色
#define BARRAGE_QQ_BTN_BG_COLOR         OPAQUE_COLOR(0X6B,0XB5,0XE5)

//  新浪微博登录/注册按钮背景颜色
#define BARRAGE_SINA_BTN_BG_COLOR         OPAQUE_COLOR(0XF2,0X7F,0X71)

//  微信登录/注册按钮背景颜色
#define BARRAGE_WEIXIN_BTN_BG_COLOR         OPAQUE_COLOR(0X7B,0XC5,0X67)

//  Email登录/注册按钮背景颜色
#define BARRAGE_EMAIL_BTN_BG_COLOR         OPAQUE_COLOR(0XEC,0XBC,0X25)
//#define BARRAGE_EMAIL_BTN_BG_COLOR         OPAQUE_COLOR(0X7B,0XC5,0X67)

//  手机登录/注册按钮背景颜色
#define BARRAGE_PHONE_BTN_BG_COLOR         OPAQUE_COLOR(0XC7,0X92,0XE0)
//#define BARRAGE_PHONE_BTN_BG_COLOR         OPAQUE_COLOR(0XEC,0XBC,0X25)

//  主页下拉播放框横线颜色
#define BARRAGE_HOME_PULL_DOWN_LAYER_COLOR      OPAQUE_COLOR(0X26,0X26,0X26)

//  弹幕背景颜色
#define BARRAGETEXTVIEW_BG_COLOR                [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.4]

//  弹幕透明背景
#define BARRAGETEXTVIEW_BG_COLOR_OPACITY               [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.0]

//  TimeLine中interView背景颜色
#define BARRAGE_TIMELINE_INTERVIEW_BG_COLOR                    OPAQUE_COLOR(0Xdd,0Xdd,0Xdd)

#define COMMENTEDITVIEW_GRIDSVIEW_BG_COLOR      OPAQUE_COLOR(0x2f, 0xff, 0xf3)

//导航栏黑色
#define NAVIGATIONBAR_BLACK              OPAQUE_COLOR(0x12, 0x12, 0x12)

#define BARRAGE_TIME_COLOR              OPAQUE_COLOR(0x84, 0x84, 0x84)

#define COLOR_LUCENCY                          COLOR255(0.0,0.0,0.0,0.0)
#define BARRAGE_DEFAULT_TEXT_COLOR      [UIColor whiteColor]

#define COLOR_WHITE             [UIColor whiteColor]

#define PPSIZE(x,y) (ISIPAD ? x : y)

#define CONTENT_VIEW_INSERT (ISIPAD ? 10 : 5)

#define TEXT_VIEW_BORDER_WIDTH   (ISIPAD ? 6  : 3)
#define TEXT_VIEW_CORNER_RADIUS  (ISIPAD ? 8 : 4)
#define DEFAULT_CORNER_RADIUS  (ISIPAD ? 10 : 6)
#define BUTTON_CORNER_RADIUS    TEXT_VIEW_CORNER_RADIUS
#define FONT_BUTTON [UIFont boldSystemFontOfSize:(ISIPAD ? 30 : 15)]
#define LOGIN_FONT_BUTTON [UIFont systemFontOfSize:(ISIPAD ? 36 : 19)]

//#define COLOR_LIGHT_YELLOW OPAQUE_COLOR(75, 63, 50) // common dialog
//#define COLOR_YELLOW OPAQUE_COLOR(255, 187, 85) // common dialog
//#define COLOR_YELLOW1 OPAQUE_COLOR(254, 198, 48) // common tab selected bg
//#define COLOR_YELLOW2 OPAQUE_COLOR(204, 131, 24) // common tab selected bg

// (浅)橙黄色按钮，用于normal状态。
#define COLOR_ORANGE OPAQUE_COLOR(238, 94, 82)
// (深)橙黄色按钮，用于select/hightlight状态。
#define COLOR_ORANGE1 OPAQUE_COLOR(209, 66, 53)

// (浅)黄色，用在按钮上(normal)，也用在一些背景设置上。
#define COLOR_YELLOW OPAQUE_COLOR(254, 198, 48)

// (浅)黄色，用在按钮上(normal)和背景，如作品详情的按钮，以及背景，这个颜色是特别配合作品详情图标的颜色，请勿更改
#define COLOR_YELLOW_ICON OPAQUE_COLOR(253, 188, 60)

// (深)黄色，用在按钮上(hightlight/select)
#define COLOR_YELLOW1 OPAQUE_COLOR(204, 131, 24)

// CommonDialog 边框的颜色。
#define COLOR_RED OPAQUE_COLOR(235, 83, 48)

// 通用绿色。
#define COLOR_GREEN OPAQUE_COLOR(0, 190, 177)

//新消息提示背景颜色
#define COLOR_GREEN_TAG OPAQUE_COLOR(112,199,60)

// 深蓝色
#define COLOR_BLUE OPAQUE_COLOR(2, 76, 136)

// 黄色按钮上的字体颜色。其他颜色的按钮上的字体为白色。
//#define COLOR_COFFEE OPAQUE_COLOR(126, 49, 46)
#define COLOR_COFFEE OPAQUE_COLOR(115, 86, 68)

// 普通label上的字体颜色。
//#define COLOR_BROWN OPAQUE_COLOR(75, 63, 50)
#define COLOR_BROWN COLOR_COFFEE


// cell的背景颜色
#define COLOR_WHITE [UIColor whiteColor] //Cell
#define COLOR_GRAY OPAQUE_COLOR(245, 245, 245) //Cell

// cell上的灰色文字（如时间）
#define COLOR_GRAY_TEXT     OPAQUE_COLOR(154, 154, 154)

// 用户头像的灰色
#define COLOR_GRAY_AVATAR   OPAQUE_COLOR(214, 214, 214)

// cell上的灰色背景上的灰色背景（如评论）
#define COLOR_GRAY_BG   OPAQUE_COLOR(222, 222, 222)

#define IMAGE_FROM_COLOR(color) ([ShareImageManager imageWithColor:color])

#define SET_VIEW_BG(view) (view.backgroundColor = COLOR_GRAY)

#endif
