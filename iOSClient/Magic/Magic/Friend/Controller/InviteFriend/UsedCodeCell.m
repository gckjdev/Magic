
//
//  UsedCodeCell.m
//  BarrageClient
//
//  Created by gckj on 15/1/27.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UsedCodeCell.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "Masonry.h"
#import "UIViewUtils.h"
#import "ViewInfo.h"

@implementation UsedCodeCell

-(id)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                        text:(NSString*)text
                  detailText:(NSString*)detailText
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.text = text;

        self.textLabel.font = BARRAGE_TEXTFIELD_FONT;
        self.textLabel.backgroundColor = BARRAGE_LABEL_GRAY_COLOR;
        self.detailTextLabel.text = detailText;

        //  添加Cell下方的横线
        [UIView addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR borderWidth:COMMON_LAYER_BORDER_WIDTH superView:self.contentView];
//  暂时不要arrows
//        UIImageView *arrows = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrows.png"]];
//        [self addSubview:arrows];
//        arrows.hidden = YES;    //  暂时隐藏
//        [arrows mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.contentView);
//            make.right.equalTo(self.contentView).with.offset(-16);
//        }];
//        
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-(COMMON_PADDING));
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.6); //  宽度为3/5
        }];
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = BARRAGE_TEXTFIELD_FONT;
        self.textLabel.backgroundColor = BARRAGE_LABEL_GRAY_COLOR;
        
        //  添加Cell下方的横线
        [UIView addSingleLineWithColor:BARRAGE_CELL_LAYER_COLOR borderWidth:COMMON_LAYER_BORDER_WIDTH superView:self.contentView];
        //  暂时不要arrows
        //        UIImageView *arrows = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrows.png"]];
        //        [self addSubview:arrows];
        //        arrows.hidden = YES;    //  暂时隐藏
        //        [arrows mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.centerY.equalTo(self.contentView);
        //            make.right.equalTo(self.contentView).with.offset(-16);
        //        }];
        //
        [self.detailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-(COMMON_PADDING));
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(self.contentView).multipliedBy(0.6); //  宽度为3/5
        }];
    }
    return self;
}
#pragma mark - Default methods
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
