//
//  HYCTagView.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/22/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "HYCTagView.h"
#import "HYCTagButton.h"
#import <Masonry.h>
#import "PPDebug.h"
#import "StringUtil.h"
#import "User.pb.h"
#import "UIColor+UIColorExt.h"
#import "TagManager.h"

#define TAG_BUTTON_INSET 30
#define TAG_BUTTON_PADDING 15
#define TAG_BUTTON_HEIGHT 30

@interface HYCTagView ()

@property (nonatomic, strong) NSMutableArray *tagButtons1;
@property (nonatomic, strong) NSMutableArray *tagButtons2;
@property (nonatomic, strong) NSMutableArray *tagButtons3;

@end

@implementation HYCTagView

+ (NSUInteger)getArrangedRowCountWithFrame:(CGRect)frame
                                   andTags:(NSArray*)tags
{
    //计算所需要的行数
    __block NSInteger rowCount = 0;
    __block CGFloat sumWidth = 0;
    [tags enumerateObjectsUsingBlock:^(PBUserTag *obj, NSUInteger idx, BOOL *stop)
     {
         NSString *text = [NSString stringWithFormat:@"%@ (%lu)",[obj name],(unsigned long)[[obj userIds]count]];
         
         CGFloat objWidth = TAG_BUTTON_PADDING+[text sizeWithMyFont:TAG_TEXT_FONT].width+TAG_BUTTON_INSET;
         CGFloat maxWidth = frame.size.width - TAG_BUTTON_PADDING;
         
         if(sumWidth + objWidth < maxWidth)
         {
             sumWidth += objWidth;
         }
         else
         {
             rowCount++;
             sumWidth = TAG_BUTTON_PADDING + objWidth;
         }
     }];
    
    return rowCount;
}

+ (NSArray*)createTagViewsWithFrame:(CGRect)frame
                       allPbTagList:(NSArray*)pbTagList
                      selectedUsers:(NSArray*)selectedUsers
                           delegate:(id)delegate
{
    //计算所需要的行数
    __block NSInteger rowCount = 0;
    __block CGFloat sumWidth = 0;
    rowCount = [HYCTagView getArrangedRowCountWithFrame:frame andTags:pbTagList];
    
    //分配tag到每行
    __block NSMutableArray *arrayOfTagList = [[NSMutableArray alloc]init];
    for(NSInteger j = 0; j < rowCount+1; j++)
    {
        NSMutableArray *tList = [[NSMutableArray alloc]init];
        [arrayOfTagList addObject:tList];
    }
    
    sumWidth = 0;
    rowCount = 0;
    [pbTagList enumerateObjectsUsingBlock:^(PBUserTag *obj, NSUInteger idx, BOOL *stop)
     {
         NSString *text = [NSString stringWithFormat:@"%@ (%lu)",[obj name],(unsigned long)[[obj userIds]count]];
         CGFloat objWidth = TAG_BUTTON_PADDING+[text sizeWithMyFont:TAG_TEXT_FONT].width+TAG_BUTTON_INSET;
         CGFloat maxWidth = frame.size.width - TAG_BUTTON_PADDING;
         
         if(sumWidth + objWidth < maxWidth)
         {
             [arrayOfTagList[rowCount] addObject:obj];
             sumWidth += objWidth;
         }
         else
         {
             rowCount++;
             [arrayOfTagList[rowCount] addObject:obj];
             sumWidth = TAG_BUTTON_PADDING + objWidth;
         }
         
     }];
    
    //分配每一个隐藏的scrollview页面的内容，总页数由行数决定,有多少页就建立多少个view，然后添加到scrollview的contentview里面。
    NSInteger pageCount = rowCount/3+1;
    NSMutableArray *tViewArr = [[NSMutableArray alloc]init];
    for(NSInteger i = 0; i < pageCount; i++)
    {
        //这里注意frame和bounds的关系哦。。y坐标不能直接用frame.origin.y，而应该用相对关系的0
        CGRect extendRect = CGRectMake(frame.origin.x+i*frame.size.width, 0, frame.size.width, frame.size.height);
        
        NSArray *tagInRow1 = (i*3+0<=rowCount)? arrayOfTagList[i*3+0]:nil;
        NSArray *tagInRow2 = (i*3+1<=rowCount)? arrayOfTagList[i*3+1]:nil;
        NSArray *tagInRow3 = (i*3+2<=rowCount)? arrayOfTagList[i*3+2]:nil;
        

        HYCTagView* singleTagView = [HYCTagView createTagViewWithFrame:extendRect
                                                         selectedUsers:selectedUsers
                                                           pbtagInRow1:tagInRow1
                                                           pbtagInRow2:tagInRow2
                                                           pbtagInRow3:tagInRow3];
        
        //自动排列tag的核心方法
        [singleTagView arrangeTags];
        [tViewArr addObject:singleTagView];
        singleTagView.delegate = delegate;
    }

    return tViewArr;
}


//如果想要更改行数，则需要修改这个函数，因为这里我把每一个view的行数固定为三个。
+ (HYCTagView*)createTagViewWithFrame:(CGRect)frame
                        selectedUsers:(NSArray*)selectedUsers
                          pbtagInRow1:(NSArray*)tagList1
                          pbtagInRow2:(NSArray*)tagList2
                          pbtagInRow3:(NSArray*)tagList3
{
    HYCTagView *singleTagView = [[HYCTagView alloc]initWithFrame:frame];
    
    [tagList1 enumerateObjectsUsingBlock:^(PBUserTag *pbtag, NSUInteger idx, BOOL *stop)
    {
        HYCTagButton *tagButt =
        [[HYCTagButton alloc]initWithPbUserTag:pbtag
                          shouldFillBackground:NO
                                        target:singleTagView
                                     tapAction:@selector(onTapped:)
                               longpressAction:@selector(onLongPressed:)];
        
        BOOL flag;
        if(selectedUsers == nil) flag = YES;
        else flag = [HYCTagButton userByTag:pbtag
                 areContainedInSelectedUser:selectedUsers];
        [tagButt shouldFillBackgroundColor:flag];
        
        [singleTagView.tagButtons1 addObject:tagButt];
    }];
    
    [tagList2 enumerateObjectsUsingBlock:^(PBUserTag *pbtag, NSUInteger idx, BOOL *stop)
    {
        HYCTagButton *tagButt =
        [[HYCTagButton alloc]initWithPbUserTag:pbtag
                          shouldFillBackground:NO
                                        target:singleTagView
                                     tapAction:@selector(onTapped:)
                               longpressAction:@selector(onLongPressed:)];
        
        BOOL flag;
        if(selectedUsers == nil) flag = YES;
        else flag = [HYCTagButton userByTag:pbtag
                 areContainedInSelectedUser:selectedUsers];
        [tagButt shouldFillBackgroundColor:flag];
        
        [singleTagView.tagButtons2 addObject:tagButt];
    }];
    
    [tagList3 enumerateObjectsUsingBlock:^(PBUserTag *pbtag, NSUInteger idx, BOOL *stop)
    {
        HYCTagButton *tagButt =
        [[HYCTagButton alloc]initWithPbUserTag:pbtag
                          shouldFillBackground:NO
                                        target:singleTagView
                                     tapAction:@selector(onTapped:)
                               longpressAction:@selector(onLongPressed:)];
        
        BOOL flag;
        if(selectedUsers == nil) flag = YES;
        else flag = [HYCTagButton userByTag:pbtag
                 areContainedInSelectedUser:selectedUsers];
        [tagButt shouldFillBackgroundColor:flag];
        
        [singleTagView.tagButtons3 addObject:tagButt];
    }];
    
    return singleTagView;
}


- (void)onTapped:(UITapGestureRecognizer*)sender
{
    PPDebug(@"tap ges %@",sender);
    HYCTagButton *butt = (HYCTagButton*)[sender view];
    PBUserTag *targetTag = [[TagManager sharedInstance]getTagWithTID:butt.tid];
    [self.delegate didTapTag:targetTag inStatus:butt.isSelected];
}

- (void)onLongPressed:(UILongPressGestureRecognizer*)sender
{
    PPDebug(@"long press ges %@",sender);
    HYCTagButton *butt = (HYCTagButton*)[sender view];
    PBUserTag *targetTag = [[TagManager sharedInstance]getTagWithTID:butt.tid];
    [self.delegate didLongPressTag:targetTag];
}


- (void)arrangeTags
{
    //clear all subviews added in before
    [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop){
        [obj removeFromSuperview];
    }];
    
    //for relative position making
    NSArray *array;
    CGFloat buttHeight = 0.0;
    CGFloat centerYoffset = 0.0;

    for(int i = 0; i < 3; i++)
    {
        if(i == 0){
            array = self.tagButtons1;
            buttHeight = TAG_BUTTON_HEIGHT;
            centerYoffset = TAG_BUTTON_PADDING+buttHeight/2;//第一行的centery
        }
        if(i == 1){
            array = self.tagButtons2;
            buttHeight = TAG_BUTTON_HEIGHT;
            centerYoffset = 2*TAG_BUTTON_PADDING+3*buttHeight/2;//第二行的centery
        }
        if(i == 2){
            array = self.tagButtons3;
            buttHeight = TAG_BUTTON_HEIGHT;
            centerYoffset = 3*TAG_BUTTON_PADDING+5*buttHeight/2;//第三行的centery
        }
        [self lineUpTags:array
              withHeight:buttHeight
           centerYoffset:centerYoffset];
    }
}

- (void)lineUpTags:(NSArray*)tags
        withHeight:(CGFloat)height
     centerYoffset:(CGFloat)centerYoffset
{
    __block HYCTagButton *lastButt;
    [tags enumerateObjectsUsingBlock:^(HYCTagButton *obj, NSUInteger idx, BOOL *stop){
        [self addSubview:obj];
        if(idx == 0){
            //放置第一个tag button
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).with.offset(TAG_BUTTON_PADDING);
                make.centerY.equalTo(self.mas_top).with.offset(centerYoffset);
                make.width.equalTo(@(obj.frame.size.width+TAG_BUTTON_INSET));
                make.height.equalTo(@(height));
            }];
            lastButt = obj;
        }
        else{
            //往右排列下去
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastButt.mas_right).with.offset(TAG_BUTTON_PADDING);
                make.centerY.equalTo(self.mas_top).with.offset(centerYoffset);
                make.width.equalTo(@(obj.frame.size.width+TAG_BUTTON_INSET));
                make.height.equalTo(@(height));
            }];
            lastButt = obj;
        }
    }];
}


- (NSMutableArray *)tagButtons1
{
    if(!_tagButtons1)
    {
        _tagButtons1 = [NSMutableArray array];
    }
    return _tagButtons1;
}
- (NSMutableArray *)tagButtons2
{
    if(!_tagButtons2)
    {
        _tagButtons2 = [NSMutableArray array];
    }
    return _tagButtons2;
}
- (NSMutableArray *)tagButtons3
{
    if(!_tagButtons3)
    {
        _tagButtons3 = [NSMutableArray array];
    }
    return _tagButtons3;
}


@end
