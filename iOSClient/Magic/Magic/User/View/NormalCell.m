//
//  NormalCell.m
//  BarrageClient
//
//  Created by gckj on 15/1/30.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "NormalCell.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "UIViewUtils.h"

@implementation NormalCell

#pragma mark - Default methods
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Public methods
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = BARRAGE_LABEL_FONT; //  字体
        self.textLabel.textColor = BARRAGE_TEXTFIELD_COLOR;   //  颜色
        
        self.detailTextLabel.font = BARRAGE_LITTLE_LABEL_FONT; //  字体
        //  添加横线
        [UIView addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR
                           borderWidth:COMMON_LAYER_BORDER_WIDTH
                             superView:self.contentView];
    }
    return self;
}
//  暂时用不到
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                        text:(NSString*)text
                  detailText:(NSString*)detailText
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text = text;
        self.detailTextLabel.text = detailText;
    }
    return self;
}
@end
