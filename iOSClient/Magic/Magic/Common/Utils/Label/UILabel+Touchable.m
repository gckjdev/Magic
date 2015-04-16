//
//  UILabel+Touchable.m
//  Draw
//
//  Created by Gamy on 13-12-11.
//
//

#import "UILabel+Touchable.h"

@implementation UILabel (Touchable)

- (void)enableTapTouch:(id)target selector:(SEL)selector
{
    self.userInteractionEnabled = YES;
    if (target != nil && selector != NULL) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
}
- (void)disableTapTouch
{
    self.userInteractionEnabled = NO;
    for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
            [self removeGestureRecognizer:gesture];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


@end
