//
//  PPPopTableView.h
//  Draw
//
//  Created by gamy on 13-8-24.
//
//

#import <UIKit/UIKit.h>
#import "CMPopTipView.h"
@class PPPopTableView;


typedef void (^SelectedRowHandler)(NSInteger row);

@interface PPPopTableView : UIView<UITableViewDataSource, UITableViewDelegate, CMPopTipViewDelegate>

+ (PPPopTableView *)popTableViewWithTitles:(NSArray *)titles icons:(NSArray *)icons selectedHandler:(SelectedRowHandler)handler;

- (BOOL)isShowing;

- (void)showInView:(UIView *)inView
            atView:(UIView *)atView
          animated:(BOOL)animated;

- (void)dismiss:(BOOL)animated;

- (void)showInView:(UIView *)inView
            atView:(UIView *)atView
          animated:(BOOL)animated
allowClickMaskDismiss:(BOOL)allowClickMaskDismiss;

@end
