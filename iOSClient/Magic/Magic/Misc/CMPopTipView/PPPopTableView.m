//
//  PPPopTableView.m
//  Draw
//
//  Created by gamy on 13-8-24.
//
//

#import "PPPopTableView.h"
#import "CMPopTipView.h"
#import "StringUtil.h"
#import "PPDebug.h"
#import "DeviceDetection.h"
#import "ColorInfo.h"
#import "UIViewUtils.h"

@interface PPPopTableView()
{
    BOOL _showing;
}
@property(nonatomic, retain) CMPopTipView *popView;
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, assign) CGFloat cellWidth;
@property(nonatomic, copy) SelectedRowHandler handler;
@property(nonatomic, retain) NSArray* icons;
@property(nonatomic, retain) NSArray* titles;
@property(nonatomic, retain) UIControl *maskView;

@end

#define TITLE_FONT (ISIPAD ? [UIFont systemFontOfSize:28] : [UIFont systemFontOfSize:14])
#define MIN_CELL_WIDTH (ISIPAD ? 200 : 100)
#define MAX_CELL_WIDTH (ISIPAD ? 700 : 300)
#define ICON_TITLE_SPACE (ISIPAD ? 20 : 10)
#define EDGE_SPACE (ISIPAD ? 15 : 7)

@implementation PPPopTableView

- (BOOL)isShowing
{
    return _showing;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.cellWidth = MIN_CELL_WIDTH;
        
    }
    return self;
}

+ (PPPopTableView *)popTableViewWithTitles:(NSArray *)titles icons:(NSArray *)icons selectedHandler:(SelectedRowHandler)handler
{
    PPPopTableView *view = [[PPPopTableView alloc] initWithFrame:CGRectZero];
    view.handler = handler;
    view.icons = icons;
    view.titles = titles;
    if ([icons count] != 0 && [icons count] != [titles count]) {
        PPDebug(@"<popTableViewWithTitles> icon count != title counts");
        return nil;
    }
    view.maskView = [[UIControl alloc] init];
    [view.maskView addTarget:view action:@selector(clickAtMaskView:) forControlEvents:UIControlEventTouchUpInside];
    
    return view;
}


- (void)clickAtMaskView:(UIControl*)mask
{
    [self dismiss:YES];
}

- (void)dealloc
{
    PPDebug(@"PPPopTableView dealloc");
    PPRelease(_popView);
    PPRelease(_tableView);
    self.handler = nil;
    PPRelease(_maskView);
}

- (CGFloat)heightForRow:(NSUInteger)row
{
    return (ISIPAD ? 62 : 31);
}

#define VERTICAL_SPACE (ISIPAD ? 10 : 5)

- (void)updateFrame
{
    CGFloat count = [self.titles count];
    CGFloat totalHeight = 0;
    for (int row = 0; row < count; row++) {
        CGFloat height = [self heightForRow:row];
        totalHeight += height;
        CGFloat iconWidth = height;
        NSString *title = [self.titles objectAtIndex:row];
        CGSize titleSize = [title sizeWithMyFont:TITLE_FONT];
        CGFloat width = iconWidth + titleSize.width + ICON_TITLE_SPACE + EDGE_SPACE * 2;
        if ([self.icons count] == 0) {
            width = titleSize.width + EDGE_SPACE * 2;
        }
        self.cellWidth = MAX(self.cellWidth, width);
    }
    self.cellWidth = MIN(self.cellWidth, MAX_CELL_WIDTH);
    self.frame = CGRectMake(0, 0, self.cellWidth, totalHeight);
    self.layer.cornerRadius = VERTICAL_SPACE;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];

}

- (void)updateTableView
{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
//    [self.tableView updateHeight:CGRectGetHeight(self.bounds) + 2* VERTICAL_SPACE];
//    [self.tableView updateOriginY:-VERTICAL_SPACE];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self addSubview:self.tableView];
}

#define POPUP_COLOR OPAQUE_COLOR(238, 94, 82)//OPAQUE_COLOR(255, 187, 85)


- (void)updatePopView
{
    [self.popView removeFromSuperview];
    self.popView = [[CMPopTipView alloc] initWithCustomView:self];
    [self.popView setBackgroundColor:POPUP_COLOR];
    [self.popView setCornerRadius:VERTICAL_SPACE];
    [self.popView setDelegate:self];
}

- (void)showInView:(UIView *)inView atView:(UIView *)atView animated:(BOOL)animated allowClickMaskDismiss:(BOOL)allowClickMaskDismiss
{
    if (self.tableView) {
        [self.tableView reloadData];
    }else{
        [self updateFrame];
        [self updateTableView];
    }
    [self updatePopView];
    
    if (allowClickMaskDismiss){
        self.maskView.frame = inView.bounds;
        [inView addSubview:self.maskView];
    }
    
    [self.popView presentPointingAtView:atView inView:inView animated:animated];
    _showing = YES;
    
    
}


- (void)showInView:(UIView *)inView atView:(UIView *)atView animated:(BOOL)animated
{
    
    [self showInView:inView atView:atView animated:animated allowClickMaskDismiss:YES];
    
//    if (self.tableView) {
//        [self.tableView reloadData];
//    }else{
//        [self updateFrame];
//        [self updateTableView];
//    }
//    [self updatePopView];
//    
//    self.maskView.frame = inView.bounds;
//    [inView addSubview:self.maskView];
//    
//    [self.popView presentPointingAtView:atView inView:inView animated:animated];
//    _showing = YES;

    
}
- (void)dismiss:(BOOL)animated
{
    [self.popView dismissAnimated:animated];
    _showing = NO;
    [self.maskView removeFromSuperview];
}


#pragma mark tableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EXECUTE_BLOCK(_handler, indexPath.row);
    [self dismiss:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForRow:indexPath.row];
}



#define TEXT_COLOR  COLOR_COFFEE
#define TEXT_COLOR_SELECTED  COLOR_WHITE

#define ICON_TAG 1308241
#define TITLE_TAG 1308242
#define SPLITE_TAG 1308243
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"PopCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    CGFloat height = [self heightForRow:indexPath.row];
    UIImageView *icon = (id)[cell.contentView reuseViewWithTag:ICON_TAG viewClass:[UIImageView class] frame:CGRectMake(EDGE_SPACE, 0, height, height)];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat labelX = CGRectGetMaxX(icon.frame) + ICON_TITLE_SPACE;
    if ([self.icons count] > indexPath.row) {
        [icon setImage:[self.icons objectAtIndex:indexPath.row]];
    }else{
        labelX = EDGE_SPACE;
        [icon setImage:nil];
    }
    NSString *title = [self.titles objectAtIndex:indexPath.row];
    UILabel *label = [cell.contentView reuseLabelWithTag:TITLE_TAG frame:CGRectMake(labelX, 0, height, height) font:TITLE_FONT text:title];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:TEXT_COLOR];
    [label updateHeight:height];
    [label updateWidth:self.cellWidth - labelX - EDGE_SPACE];
    [label setTextColor:COLOR_COFFEE];
    [label setBackgroundColor:[UIColor clearColor]];
        
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row & 1) == 0) {
        cell.contentView.backgroundColor = OPAQUE_COLOR(254, 217, 35);
    }else{
        cell.contentView.backgroundColor = OPAQUE_COLOR(254, 203, 47);
    }
    UILabel *label = (id)[cell.contentView viewWithTag:TITLE_TAG];
    if ([cell isSelected]) {
        [label setTextColor:TEXT_COLOR_SELECTED];
    }else{
        [label setTextColor:TEXT_COLOR];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titles count];
}


#pragma mark CMPopTip View delegate

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    self.popView = nil;
    _showing = NO;
    [self.maskView removeFromSuperview];
}
- (void)popTipViewWasDismissedByCallingDismissAnimatedMethod:(CMPopTipView *)popTipView
{
    self.popView = nil;
    _showing = NO;
   [self.maskView removeFromSuperview];
}


@end
