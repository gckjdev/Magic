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
#import "UIImageView+WebCache.h"
#import "UserAvatarView.h"
#import "StringUtil.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "MKBlockActionSheet.h"
#import "TimeUtils.h"

@interface ChatCell()
@property (nonatomic,strong)UILabel         *timeView;
@property (nonatomic,strong)UIImageView     *iconView;
@property (nonatomic,strong)UIButton        *textView;
@property (nonatomic,strong)UIImageView     *showImageView;
@property (nonatomic,strong) UserAvatarView   *avatarView;
@end

@implementation ChatCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:CHAT_CELL_IDENTIFIER];
    if (cell == nil) {
        cell = [[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CHAT_CELL_IDENTIFIER];
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
        _avatarView =  [[UserAvatarView alloc]initWithUser:nil frame:CGRectZero borderWidth:1.0f];
        [self.contentView addSubview:_avatarView];
        
    
        // 3.正文
        UIButton *textView = [[UIButton alloc] init];
        textView.titleLabel.numberOfLines = 0; // 自动换行
        textView.titleLabel.font = MJTextFont;
        textView.contentEdgeInsets = UIEdgeInsetsMake(MJTextPadding, MJTextPadding, MJTextPadding, MJTextPadding);
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(textViewLongPressAction:)];
        
        [longPressRecognizer setNumberOfTouchesRequired:1];
        
        [textView addGestureRecognizer:longPressRecognizer];
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
- (void)textViewLongPressAction:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long press Ended");
        NSString *makeSure = @"复制";
        MKBlockActionSheet *actionSheet = [[MKBlockActionSheet alloc]
                                           initWithTitle:@"选项"delegate:nil
                                           cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                           otherButtonTitles:makeSure, nil];
        
        __weak typeof (actionSheet) as = actionSheet;
        [actionSheet setActionBlock:^(NSInteger buttonIndex){
            NSString *title = [as buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:makeSure]) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                [pasteboard setString: _messageFrame.message.content];
            }
        }];
        [actionSheet showInView:self];
      
       
    }
  
}
- (void)setMessageFrame:(ChatCellFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    ChatMessage *message = messageFrame.message;
    
    // 1.时间
    self.timeView.text = [self getShowTimeString] ;
    self.timeView.frame = messageFrame.timeF;
    [self.timeView setHidden:message.hideTime];
    
    // 2.头像

    PBUser *avatarUser = _messageFrame.message.pbChat.fromUser;
    _avatarView.frame = messageFrame.iconF;
    [_avatarView updateUser:avatarUser];
  
    
    // 3.正文
     self.textView.frame = messageFrame.contentF;
    
    [self.textView setTitle:message.content forState:UIControlStateNormal];
    if (message.fromType == MESSAGEFROMTYPE_ME) {
        [self.textView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
   
    
    
    // 4.正文的背景
    if (message.fromType == MESSAGEFROMTYPE_ME) { // 自己发的,蓝色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    } else { // 别人发的,白色
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
    //5.显示图片
    if (message.type == MESSAGETYPE_IMAGE) {
        _showImageView.frame =  messageFrame.imageF;
        [_showImageView setContentMode:UIViewContentModeScaleAspectFit];
     
       
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:message.image]
                 placeholderImage:nil
                          options:SDWebImageRetryFailed
                        completed:
          ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
          {
              if (error == nil) {
//                  CGRect imageZoomRect = [self zoomImageFrame:image.size];
                  _showImageView.frame = [self zoomImageFrame:messageFrame.contentF];
//                  _textView.frame =[self zoomContentView:imageZoomRect];
              }
        
              
          }];
        

//        PPDebug(@"neng : url %@",[NSURL URLWithString:message.image]);
        _showImageView.hidden = NO;
    }else{
        _showImageView.hidden = YES;
    }
    
}
-(NSString*)getShowTimeString{
    NSMutableString *result = [NSMutableString string];
    ChatMessage *message = _messageFrame.message;
    
    NSDateComponents *messageCmps = getDateComponents(message.time);
    
    if (isToday(message.time)) {
        [result appendFormat:@"今天 %ld:%ld",messageCmps.hour,messageCmps.minute];
    }
    else if(isYesterday(message.time)){
        [result appendFormat:@"昨天 %ld:%ld",messageCmps.hour,messageCmps.minute];
    }
    else if(isTheDayBeforeYesterday(message.time))
    {
        [result appendFormat:@"前天 %ld:%ld",messageCmps.hour,messageCmps.minute];
    }
    else if(isThisYear(message.time)){
        [result appendFormat:@"%ld月%ld号 %ld:%ld",messageCmps.month,messageCmps.day,messageCmps.hour,messageCmps.minute];
    }else{
        [result appendFormat:@"%ld年%ld月%ld号 %ld:%ld",messageCmps.year,messageCmps.month,messageCmps.day,messageCmps.hour,messageCmps.minute];
    }
    
    return [result copy];
}
-(CGRect)zoomImageFrame:(CGRect)imageSize{
    
//    CGSize oldSize = _messageFrame.imageF.size;
    ChatMessage *message = _messageFrame.message;
    CGRect resultRect = imageSize;
//    if (imageSize.width>oldSize.width&&imageSize.height>oldSize.height) {
//        if (message.fromType == MESSAGEFROMTYPE_ME) {
//            
//            resultRect.origin.x = CGRectGetMaxX(resultRect) - oldSize.width;
//            resultRect.size = CGSizeMake(oldSize.width, oldSize.height);
//        }
//        else{
//            resultRect.size = CGSizeMake(oldSize.width, oldSize.height);
//        }
//    }else if (imageSize.width<oldSize.width&&imageSize.height<oldSize.height){
//        if (message.fromType == MESSAGEFROMTYPE_ME) {
//           
//            resultRect.origin.x = CGRectGetMaxX(resultRect) - imageSize.width;
//             resultRect.size = CGSizeMake(imageSize.width, imageSize.height);
//        }
//        else{
//            resultRect.size = CGSizeMake(imageSize.width, imageSize.height);
//        }
//    }else{
//        if (message.fromType == MESSAGEFROMTYPE_ME) {
//           
//            resultRect.origin.x = CGRectGetMaxX(resultRect) - oldSize.width;
//             resultRect.size = CGSizeMake(oldSize.width, oldSize.height);
//        }
//        else{
//            resultRect.size = CGSizeMake(oldSize.width, oldSize.height);
//        }
//    }
    
 
    resultRect.size.width -= 40;
    resultRect.size.height -= 40;
    if (message.fromType == MESSAGEFROMTYPE_ME) {
       
        resultRect.origin.x += 20;
        resultRect.origin.y += 20;
    }
   
  
    
    
    return resultRect;
}
@end
