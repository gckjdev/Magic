//
//  ChatRecordHintView.m
//  Magic
//
//  Created by Teemo on 15/4/29.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "ChatRecordHintView.h"
#import "Masonry.h"
#import "FontInfo.h"
#import "UIImageUtil.h"
#import "ColorInfo.h"
@interface ChatRecordHintView()
@property (nonatomic,strong) UIImageView    *imageHintView;
@property (nonatomic,strong) UILabel        *hintLabel;
@end
@implementation ChatRecordHintView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}


#pragma mark - setup
-(void)setupView{
    
    self.backgroundColor = OPAQUE_COLOR(104, 104, 104);
    self.layer.cornerRadius = 8;
    
    _imageHintView = [[UIImageView alloc]init];
//    [_imageHintView setBackgroundColor:[UIColor redColor]];
    [_imageHintView setImage:[UIImage imageNamed:@"RecordingBkg"]];
    [_imageHintView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_imageHintView];
    CGFloat tmpWidth = CHATRECORDHINTVIEW_WIDTH/2.0;
    CGFloat tmpHeight = CHATRECORDHINTVIEW_HEIGHT*(3/4.0f);
    [_imageHintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(tmpWidth, tmpHeight));
    }];
    
    
    
    
    _hintLabel = [[UILabel alloc]init];
//    [_hintLabel setBackgroundColor:[UIColor blueColor]];
    [_hintLabel setText:@"手指上滑, 取消发送"];
    [_hintLabel setTextColor:[UIColor whiteColor]];
    [_hintLabel setTextAlignment:NSTextAlignmentCenter];
    [_hintLabel setFont:BARRAGE_TEXTFIELD_FONT];
    [self addSubview:_hintLabel];
    tmpWidth = CHATRECORDHINTVIEW_WIDTH;
    tmpHeight = CHATRECORDHINTVIEW_HEIGHT*(1/4.0f);
    
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(tmpWidth, tmpHeight));
        make.bottom.equalTo(self);
        make.centerX.equalTo(self);
    }];
    
    
    
    
    UIImage *rotatedImage = [[UIImage alloc] initWithCGImage: [UIImage imageNamed:@"bottleRecordingSignal000"].CGImage
                                              scale: 1
                                        orientation: UIImageOrientationRightMirrored];

    
    _volumeImageView = [[UIButton alloc]init];
//    [_volumeImageView setBackgroundColor:[UIColor brownColor]];
   
    [_volumeImageView setUserInteractionEnabled:NO];
    [_volumeImageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_volumeImageView setImageEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
    [_volumeImageView setImage:rotatedImage forState:UIControlStateNormal];
    [self addSubview:_volumeImageView];
    tmpWidth = CHATRECORDHINTVIEW_WIDTH/2.0;
    tmpHeight = CHATRECORDHINTVIEW_HEIGHT*(3/4.0f);
    [_volumeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(tmpWidth, tmpHeight));
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
    }];
}

-(void)updateVolumeImage:(NSInteger)volumeNum
{
    NSString *tmpName = [NSString stringWithFormat:@"bottleRecordingSignal%03ld",volumeNum];
    [_volumeImageView setImage:[self rotateImage:tmpName] forState:UIControlStateNormal];
}
-(UIImage*)rotateImage:(NSString*)name{
    UIImage *rotatedImage = [[UIImage alloc] initWithCGImage: [UIImage imageNamed:name].CGImage
                                                       scale: 1
                                                 orientation: UIImageOrientationRightMirrored];
    return rotatedImage;
}
@end
