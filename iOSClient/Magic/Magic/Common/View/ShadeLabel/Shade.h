//
//  Shade.h
//  Shade
//
//  Created by Jun Xiu Chan on 12/3/14.
//  Copyright (c) 2014 Jun Xiu Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Shade : UILabel

@property CGFloat   shadeOpacity;
@property CGSize    shadeOffset;
@property UIColor   *shadeColor;
@property CGFloat   shadeRadius;

- (void)update;
@end
