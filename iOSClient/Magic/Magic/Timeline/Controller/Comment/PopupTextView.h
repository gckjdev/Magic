//
//  PopupTextView.h
//  BarrageClient
//
//  Created by pipi on 14/12/18.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinishPopupTextViewBackBlock) (NSString* text);

@interface PopupTextView : UIView<UITextViewDelegate>

+ (PopupTextView*)showInView:(UIView*)superView
                        text:(NSString*)text
                    callback:(FinishPopupTextViewBackBlock)callback;

@end
