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
#import "Masonry.h"
#import "FontInfo.h"



#define IMAGEVIEW_PADDING 15.0f

@interface ChatCell()
@property (nonatomic,strong) UILabel         *timeView;
@property (nonatomic,strong) UIImageView     *iconView;
@property (nonatomic,strong) UIButton        *textView;
@property (nonatomic,strong) UIImageView     *showImageView;
@property (nonatomic,strong) UIImageView     *voiceAnimationView;
@property (nonatomic,strong) UILabel         *voiceDurationView;

@property (nonatomic,strong) UserAvatarView  *avatarView;
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
        [self setupView];
    }
    return self;
}

#pragma mark -setup
-(void)setupView{
    // 子控件的创建和初始化

    [self setupTimeView];
    [self setupAvatar];
    [self setupTextView];
    [self setupImageView];
    [self setupVoiceAnimationView];
    [self setupVoiceDurationView];
    
    self.backgroundColor = [UIColor clearColor];
}


-(void)setupTimeView{
    // 1.时间
    UILabel *timeView = [[UILabel alloc] init];
    timeView.textAlignment = NSTextAlignmentCenter;
    timeView.textColor = [UIColor grayColor];
    timeView.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:timeView];
    self.timeView = timeView;
}

-(void)setupAvatar{
    // 2.头像
    _avatarView =  [[UserAvatarView alloc]initWithUser:nil frame:CGRectZero borderWidth:1.0f];
    [self.contentView addSubview:_avatarView];
}

-(void)setupTextView{
    // 3.正文
    UIButton *textView = [[UIButton alloc] init];
    textView.titleLabel.numberOfLines = 0; // 自动换行
    textView.titleLabel.font = MJTextFont;
    textView.contentEdgeInsets = UIEdgeInsetsMake(MJTextPadding, MJTextPadding, MJTextPadding, MJTextPadding);
    [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.textView = textView;
    [self.contentView addSubview:textView];
    
    [self textViewAddGesture];
}

-(void)setupImageView{

    //4.图片
    _showImageView = [[UIImageView alloc]init];
    [_showImageView.layer setCornerRadius:6];
    [_showImageView setClipsToBounds:YES];
    [self.contentView addSubview:_showImageView];
//    [_showImageView setBackgroundColor:[UIColor redColor]];
    
}

-(void)setupVoiceAnimationView{
    _voiceAnimationView = [[UIImageView alloc]init];
    [self.contentView addSubview:_voiceAnimationView];
    [_voiceAnimationView setContentMode:UIViewContentModeScaleAspectFit];

}

-(void)setupVoiceDurationView{
    _voiceDurationView = [[UILabel alloc]init];
    [self addSubview:_voiceDurationView];
    [_voiceDurationView setTextColor:[UIColor grayColor]];
    [_voiceDurationView setTextAlignment:NSTextAlignmentRight];
    [_voiceDurationView setFont:CELL_TIME_FONT];
}

#pragma mark - Action
- (void)textViewAddGesture{
    
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewSinglePressAction:)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给view添加一个手势监测；
    [_textView addGestureRecognizer:singleRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(textViewLongPressAction:)];
    
    [longPressRecognizer setNumberOfTouchesRequired:1];
    
    [_textView addGestureRecognizer:longPressRecognizer];
    
   
    
}
-(void)textViewSinglePressAction:(UITapGestureRecognizer*)sender{
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_messageFrame.message.type == MESSAGETYPE_IMAGE) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(imageViewSinglePress:image:)])
            {
                [self.delegate imageViewSinglePress:_messageFrame.message.pbChat image:_showImageView.image];
            }
        }
        else if (_messageFrame.message.type == MESSAGETYPE_VOICE){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(voiceViewSinglePress:cell:)])
            {
               
                [self.delegate voiceViewSinglePress:_messageFrame.message.pbChat cell:self];
            }
        }

    }
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

#pragma mark - Animation

-(void)voiceAnimationStart
{
    [_voiceAnimationView startAnimating];
}

-(void)voiceAnimationStop
{
    [_voiceAnimationView stopAnimating];
}

#pragma mark - setupFrame 

- (void)setMessageFrame:(ChatCellFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    ChatMessage *message = messageFrame.message;
    
   
    
    [self setupCommonMode];
    
    
    if (message.type == MESSAGETYPE_TEXT) {
        [self setupTextMode];
    }
    else if(message.type == MESSAGETYPE_IMAGE)
    {
        [self setupImageMode];
    }
    else if (message.type == MESSAGETYPE_VOICE)
    {
        [self setupVoiceMode];
    }
    
}

-(void)setupCommonMode{
     ChatMessage *message = _messageFrame.message;
    
    // 1.时间
    self.timeView.text = [self getShowTimeString] ;
    self.timeView.frame = _messageFrame.timeF;
    [self.timeView setHidden:message.hideTime];
    
    // 2.头像
    
    PBUser *avatarUser = _messageFrame.message.pbChat.fromUser;
    _avatarView.frame = _messageFrame.iconF;
    [_avatarView updateUser:avatarUser];
    
    
    // 3.正文
    self.textView.frame = _messageFrame.contentF;
    
    [self.textView setTitle:message.content forState:UIControlStateNormal];
    if (message.fromType == MESSAGEFROMTYPE_ME) {
        [self.textView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    
    
    // 4.正文的背景
    if (message.fromType == MESSAGEFROMTYPE_ME) {
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_send_nor"] forState:UIControlStateNormal];
    } else {
        [self.textView setBackgroundImage:[UIImage resizableImage:@"chat_recive_nor"] forState:UIControlStateNormal];
    }
    
    
    [_voiceAnimationView setHidden:YES];
    [_voiceDurationView setHidden:YES];
    [_showImageView setHidden:YES];
}
-(void)setupTextMode{
    
}

-(void)setupImageMode{
    ChatMessage *message = _messageFrame.message;
    _showImageView.frame =  _messageFrame.imageF;
    [_showImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    [_showImageView sd_setImageWithURL:[NSURL URLWithString:message.image]
                      placeholderImage:nil
                               options:SDWebImageRetryFailed
                             completed:
     ^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
     {
         if (error == nil) {
             //                  CGRect imageZoomRect = [self zoomImageFrame:image.size];
             _showImageView.frame = [self zoomImageFrame:_messageFrame.contentF];
             //                  _textView.frame =[self zoomContentView:imageZoomRect];
         }
         
     }];
    
    _showImageView.hidden = NO;
}

-(void)setupVoiceMode{
    ChatMessage *message = _messageFrame.message;
   

    [_voiceAnimationView setHidden:NO];
    [_voiceDurationView setHidden:NO];
    _voiceAnimationView.frame = _messageFrame.voiceAnimationF;
    _voiceDurationView.frame = _messageFrame.voiceDurationF;
    NSString *duration = [NSString stringWithFormat:@"%ld\"",message.voiceDuration];
    [_voiceDurationView setText:duration];
    
    
    
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i< 3; i++) {
        UIImage *image;
        if (_messageFrame.message.fromType == MESSAGEFROMTYPE_ME) {
            NSString *tmpName = [NSString stringWithFormat:@"SenderVoiceNodePlaying00%d",i+1];
            image = [UIImage imageNamed:tmpName];
        }
        else{
            NSString *tmpName = [NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d",i+1];
            image = [UIImage imageNamed:tmpName];
        }
        
        [imageArray addObject:image];
    }
    [_voiceAnimationView setAnimationImages:[imageArray copy]];
    [_voiceAnimationView setAnimationRepeatCount:0];
    [_voiceAnimationView setAnimationDuration:0.8];
    [_voiceAnimationView setUserInteractionEnabled:NO];
    if (_messageFrame.message.fromType == MESSAGEFROMTYPE_ME) {
        [_voiceAnimationView setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying"]];
        [_voiceDurationView setTextAlignment:NSTextAlignmentRight];
    }
    else{
        [_voiceAnimationView setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying"]];
        [_voiceDurationView setTextAlignment:NSTextAlignmentLeft];
    }
    
    
   
}
-(NSString*)getShowTimeString{
    NSMutableString *result = [NSMutableString string];
    ChatMessage *message = _messageFrame.message;
    
    NSDateComponents *messageCmps = getDateComponents(message.time);
    
    if (isToday(message.time)) {
        [result appendFormat:@"今天 %ld:%02ld",messageCmps.hour,messageCmps.minute];
    }
    else if(isYesterday(message.time)){
        [result appendFormat:@"昨天 %ld:%02ld",messageCmps.hour,messageCmps.minute];
    }
    else if(isTheDayBeforeYesterday(message.time))
    {
        [result appendFormat:@"前天 %ld:%02ld",messageCmps.hour,messageCmps.minute];
    }
    else if(isThisYear(message.time)){
        [result appendFormat:@"%ld月%ld号 %ld:%02ld",messageCmps.month,messageCmps.day,messageCmps.hour,messageCmps.minute];
    }
    else{
        [result appendFormat:@"%ld年%ld月%ld号 %ld:%02ld",messageCmps.year,messageCmps.month,messageCmps.day,messageCmps.hour,messageCmps.minute];
    }
    
    return [result copy];
}
-(CGRect)zoomImageFrame:(CGRect)imageSize{
    
    ChatMessage *message = _messageFrame.message;
    CGRect resultRect = imageSize;

    resultRect.size.width -= IMAGEVIEW_PADDING*2;
    resultRect.size.height -= IMAGEVIEW_PADDING*2;
    if (message.fromType == MESSAGEFROMTYPE_ME) {
       
        resultRect.origin.x += IMAGEVIEW_PADDING;
        resultRect.origin.y += IMAGEVIEW_PADDING;
    }
    else{
        resultRect.origin.x += IMAGEVIEW_PADDING;
        resultRect.origin.y += IMAGEVIEW_PADDING;
    }

    return resultRect;
}
@end
