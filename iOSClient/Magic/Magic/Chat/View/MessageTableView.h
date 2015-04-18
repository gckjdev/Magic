//
//  MessageTableView.h
//  talking
//
//  Created by Teemo on 15/4/10.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableView : UITableView
@property (nonatomic,strong) NSArray   *messageFrames;
@property (nonatomic, assign) CGFloat      viewHeight;
@end
