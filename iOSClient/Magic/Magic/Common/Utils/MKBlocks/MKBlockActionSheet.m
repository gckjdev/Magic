//
//  MKBlockActionSheet.m
//  Linetime
//
//  Created by Max Kramer on 08/07/2012.
//  Copyright (c) 2012 Max Kramer. All rights reserved.
//

#import "MKBlockActionSheet.h"

@implementation MKBlockActionSheet

- (id) initWithTitle:(NSString *)title delegate:(id<UIActionSheetDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSString *)firstTitle, ... {
    
    if ((self = [super initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:destructiveButtonTitle otherButtonTitles:nil])) {
        
        NSString *title;
        
        va_list args;
        
        if (firstTitle != nil) {
            va_start(args, firstTitle);
            
            [self addButtonWithTitle:firstTitle];
            
            while ((title = va_arg(args, NSString *))) {
                
                [self addButtonWithTitle:title];
                
            }
            
            va_end(args);
        }
        
        if (cancelButtonTitle != nil) {
            NSInteger cancelButtonIndex = [self addButtonWithTitle:cancelButtonTitle];
            
            [self setCancelButtonIndex:cancelButtonIndex];
        }
        
    }
    
    return self;
    
}

//- (void) setActionBlock:(MKActionBlock)_actionBlock {
//    if (actionBlock != _actionBlock) {
//        RELEASE_BLOCK(actionBlock);
//        COPY_BLOCK(actionBlock, _actionBlock);
//    }
//}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
        
    if (self.actionBlock != nil) {
        EXECUTE_BLOCK(self.actionBlock, buttonIndex);
//        RELEASE_BLOCK(actionBlock);
        self.actionBlock = nil;
    }
}

@end
