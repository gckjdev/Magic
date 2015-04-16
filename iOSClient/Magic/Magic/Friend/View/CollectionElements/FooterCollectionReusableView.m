//
//  FooterCollectionReusableView.m
//  BarrageClient
//
//  Created by HuangCharlie on 2/4/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "FooterCollectionReusableView.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import <Masonry.h>

#define PADDING 30

@implementation FooterCollectionReusableView

-(void)customizeFooterViewWithText:(NSString*)text
                        withTarget:(id)target
                            action:(SEL)action
{    
    UIButton *delButt = [[UIButton alloc]init];
    [delButt setTitle:@"删除标签" forState:UIControlStateNormal];
    [delButt setBackgroundColor:[UIColor redColor]];
    [delButt.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [delButt.titleLabel setTextColor:BARRAGE_LABEL_COLOR];
    [delButt.layer setCornerRadius:self.frame.size.height/4];
    [self addSubview:delButt];
    [delButt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(PADDING);
        make.right.equalTo(self.mas_right).with.offset(-PADDING);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(self.mas_height).dividedBy(2);
    }];
    [delButt addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
