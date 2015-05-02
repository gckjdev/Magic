//
//  ChatRecordHintView.h
//  Magic
//
//  Created by Teemo on 15/4/29.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>


#define CHATRECORDHINTVIEW_WIDTH    180.0f
#define CHATRECORDHINTVIEW_HEIGHT   180.0f

@interface ChatRecordHintView : UIView
@property (nonatomic,strong) UIButton   *volumeImageView;

-(void)updateVolumeImage:(NSInteger)volumeNum;

@end
