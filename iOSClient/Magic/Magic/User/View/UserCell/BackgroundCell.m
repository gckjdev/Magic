//
//  BackgroundCell.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/1/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "BackgroundCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "PPDebug.h"
#import "UIViewUtils.h"
#import "ViewInfo.h"

#define kMargin 20
#define kMargin4Height 5

@implementation BackgroundCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = BARRAGE_LABEL_FONT; //  字体
        self.textLabel.textColor = BARRAGE_LABEL_COLOR;   //  颜色
        
        self.bgImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.bgImageView];
        self.bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.bgImageView.clipsToBounds = YES;
        
        [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-kMargin);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.contentView.mas_height).with.offset(-kMargin);
            make.height.equalTo(self.contentView).with.offset(-kMargin);
        }];
        
        [UILabel addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR
                            borderWidth:COMMON_LAYER_BORDER_WIDTH
                              superView:self.contentView];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
      backgroundImg:(NSString *)backgoundImg
        bgLabelText:(NSString *)bgLabelText
{
    self = [self initWithStyle:style
               reuseIdentifier:reuseIdentifier];

    //  user.avatarBg是url来的，得用这个来显示图片
    NSURL* url = [NSURL URLWithString:backgoundImg];
    
    UIImage* placeHolder = nil; // TODO
    [self.bgImageView sd_setImageWithURL:url
                        placeholderImage:placeHolder
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   PPDebug(@"load background image %@, error=%@", backgoundImg, error);
                               }];
    
    self.textLabel.text = bgLabelText;
    return self;
}
@end
