//
//  HYCScrollView.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/24/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

@interface HYCScrollView : UIView

//init view and update view
-(id)initWithFrame:(CGRect)frame;

-(void)updateScrollViewWithViewArray:(NSArray*)views;

-(void)moveToLastPage:(BOOL)flag;

@end
