//
//  FooterCollectionReusableView.h
//  BarrageClient
//
//  Created by HuangCharlie on 2/4/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FooterCollectionReusableView : UICollectionReusableView

-(void)customizeFooterViewWithText:(NSString*)text
                        withTarget:(id)target
                            action:(SEL)action;

@end
