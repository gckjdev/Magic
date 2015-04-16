//
//  HYCTagButton.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/22/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ColorInfo.h"
#import "User.pb.h"

#define TAG_TEXT_FONT              ([UIFont systemFontOfSize:13])


#define TAG_COLOR_GREEN      OPAQUE_COLOR(0x7b, 0xc5, 0x67)
#define TAG_COLOR_YELLOW     OPAQUE_COLOR(0xec, 0xbc, 0x25)
#define TAG_COLOR_PURPLE     OPAQUE_COLOR(0xc7, 0x92, 0xe0)
#define TAG_COLOR_LBLUE      OPAQUE_COLOR(0x6b, 0xb5, 0xe5)
#define TAG_COLOR_RED        OPAQUE_COLOR(0xed, 0x6e, 0x74)
#define TAG_COLOR_DBLUE      OPAQUE_COLOR(0x79, 0x97, 0xf2)
#define TAG_COLOR_ORANGE     OPAQUE_COLOR(0xf6, 0x8a, 0x54)

@interface HYCTagButton : UIButton

@property (nonatomic,strong) NSString *tid;
@property (nonatomic,assign) BOOL isSelected;

-(instancetype)initWithPbUserTag:(PBUserTag*)pbTag
            shouldFillBackground:(BOOL)shouldFill
                          target:(id)target
                       tapAction:(SEL)tapAction
                 longpressAction:(SEL)longpressAction;

-(void)shouldFillBackgroundColor:(BOOL)shouldFill;

+ (BOOL)userByTag:(PBUserTag*)tag areContainedInSelectedUser:(NSArray*)selectedUser;

@end