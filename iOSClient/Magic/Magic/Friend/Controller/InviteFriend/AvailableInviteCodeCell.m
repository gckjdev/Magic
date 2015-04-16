//
//  AvailableInviteCodeCell.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/11.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "AvailableInviteCodeCell.h"
#import "Masonry.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "PPDebug.h"

#define kPadding 16
#define notificationName @"inviteFriends"

@implementation AvailableInviteCodeCell

#pragma mark - Public methods

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = BARRAGE_BG_COLOR;
        
        self.backgroundView = [[UIView alloc]init];
        [self.contentView addSubview:self.backgroundView];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.width.equalTo(self.contentView).with.offset(-36);
            make.height.equalTo(self.contentView).with.offset(-6);
        }];
        
        [self.backgroundView.layer setBorderWidth:1.0f];
        [self.backgroundView.layer setBorderColor:[BARRAGE_CELL_LAYER_COLOR CGColor]];
        [self loadView];
    }
    return self;
}

#pragma mark - Private methods

- (void)loadView
{
    self.textLabel.font = BARRAGE_LABEL_FONT;
    self.textLabel.textColor = BARRAGE_LABEL_COLOR;
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView).with.offset(+kPadding);
        make.centerY.equalTo(self.backgroundView);
    }];
    self.button = [[UIButton alloc]init];
    [self.button setImage:[UIImage imageNamed:@"invite_with_code.png"]
                            forState:UIControlStateNormal];
    [self.button setImage:[UIImage imageNamed:@"invite_with_code_selected.png"]
                            forState:UIControlStateHighlighted];
    [self.backgroundView addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backgroundView);
        make.right.equalTo(self.backgroundView).with.offset(-kPadding);
    }];
    [self.button addTarget:self
                    action:@selector(clickSendInviteCodeBtn:)
          forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Utils

//  点击发送按钮
- (void)clickSendInviteCodeBtn:(id)sender
{
    //  对象注册，并关连消息
//   [[NSNotificationCenter defaultCenter] postNotificationName:notificationName
//                                                       object:nil];

    EXECUTE_BLOCK(self.clickAddActionBlock, self.indexPath);    
}
@end
