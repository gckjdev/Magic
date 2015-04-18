//
//  ChatCell.m
//  talking
//
//  Created by Teemo on 15/4/9.
//  Copyright (c) 2015年 Teemo. All rights reserved.
//

#import "ChatCell.h"
#import "ChatMessage.h"
#import "ChatCellFrame.h"
#import "UIImage+Extension.h"

@interface ChatCell()
@property (nonatomic,strong)UILabel         *timeView;
@property (nonatomic,strong)UIImageView     *iconView;
@property (nonatomic,strong)UIButton        *textView;
@property (nonatomic,strong)UIImageView     *showImageView;
@end

@implementation ChatCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cellIdentifier";
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 子控件的创建和初始化
        // 1.时间
        UILabel *timeView = [[UILabel alloc] init];
        timeView.textAlignment = NSTextAlignmentCenter;
        timeView.textColor = [UIColor grayColor];
        timeView.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        
        // 2.头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        
        // 3.正文
        UIButton *textView = [[UIButton alloc] init];
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = MJTextFont;
        textView.contentEdgeInsets = UIEdgeInsetsMake(MJTextPadding, MJTextPadding, MJTextPadding, MJTextPadding);
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:textView];
        self.textView = textView;

        //4.图片
        _showImageView = [[UIImageView alloc]init];
//        _showImageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_showImageView];
        
        
        
        // 6.设置cell的背景色
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setMessageFrame:(ChatCellFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    ChatMessage *message = messageFrame.message;
    
    // 1.时间
    self.timeView.text = message.time;
    self.timeView.frame = messageFrame.timeF;
    
    // 2.头像
    NSString *icon = (message.type == MESSAGETYPE_ME) ? @"me" : @"other";
    self.iconView.image = [UIImage imageNamed:icon];
    self.iconView.frame = messageFrame.iconF;
    
    // 3.正文
    [self.textView setTitle:message.content forState:UIControlStateNormal];
    self.textView.frame = messageFrame.textF;
    
    // 4.正文的背景
    if (message.type == MESSAGETYPE_ME) { // 自己发的,蓝色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    } else { // 别人发的,白色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
    //5
    if (message.hasImage) {
        _showImageView.frame =  messageFrame.imageF;
        _showImageView.image = message.myImage;
        _showImageView.hidden = NO;
    }else{
        _showImageView.hidden = YES;
    }
    
}
@end
