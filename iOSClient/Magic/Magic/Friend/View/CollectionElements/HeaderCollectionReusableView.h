//
//  HeaderCollectionReusableView.h
//  BarrageClient
//
//  Created by HuangCharlie on 2/4/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView

-(void)customizeHeaderViewWithTextLabel:(NSString*)text;

-(void)customizeHeaderViewWithText:(NSString*)text
                        withTarget:(id)target
                            action:(SEL)action;

-(void)customizeHeaderViewWithButton:(NSString*)text
                          withTarget:(id)target
                              action:(SEL)action;

@end
