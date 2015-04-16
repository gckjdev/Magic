//
//  UILabel+Touchable.h
//  Draw
//
//  Created by Gamy on 13-12-11.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (Touchable) <UIGestureRecognizerDelegate>

//selector is onTap:(UITapGestureRecognizer *)tap;
- (void)enableTapTouch:(id)target selector:(SEL)selector;
- (void)disableTapTouch;

@end
