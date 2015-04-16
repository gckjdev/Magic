//
//  UILabel+Extend.h
//  Draw
//
//  Created by 王 小涛 on 13-8-15.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (Extend)

- (void)wrapTextWithConstrainedSize:(CGSize)constrainedSize;

- (CGRect)autoFitFrame;

@end
