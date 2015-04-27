//
//  ChatCell.h
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatCellFrame.h"

#define CHAT_CELL_IDENTIFIER        @"ChatCellIdentifier"


@protocol ChatCellDelegate <NSObject>

@optional
-(void)imageViewSinglePress:(PBChat*)pbChat image:(UIImage*)image;
@end


@interface ChatCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (nonatomic,strong)ChatCellFrame *messageFrame;
@property (nonatomic, assign) id<ChatCellDelegate>    delegate;
@end
