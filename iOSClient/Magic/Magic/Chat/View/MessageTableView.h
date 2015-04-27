//
//  MessageTableView.h
//  talking
//
//  Created by Teemo on 15/4/10.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

typedef void  (^ImageViewSinglePressBlock)(PBChat* pbChat,UIImage *image);
@interface MessageTableView : UITableView

@property (nonatomic, strong) NSArray   *messageFrames;
@property (nonatomic, assign) CGFloat   viewHeight;
@property (nonatomic,copy) ImageViewSinglePressBlock imageViewSinglePressBlock;
-(void)RefreshData;

@end
