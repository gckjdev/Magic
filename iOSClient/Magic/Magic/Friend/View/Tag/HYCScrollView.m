//
//  HYCScrollView.m
//  BarrageClient
//
//  Created by HuangCharlie on 1/24/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import "HYCScrollView.h"
#import "PPDebug.h"
#import <Masonry.h>
#import "ColorInfo.h"
#import "HYCTagView.h"


#define TAG_BUTTON_HEIGHT 30


@interface HYCScrollView ()<UIScrollViewDelegate>
{

}

@property (nonatomic,strong) UIScrollView* scrollView;
@property (nonatomic,strong) UIPageControl* pageCont;
@property (nonatomic,strong) NSArray* tagViews;

@end

@implementation HYCScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.backgroundColor = BARRAGE_BG_COLOR;

        //scroll view
        self.scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.delegate = self;
        self.scrollView.layer.borderWidth = 0.5f;
        self.scrollView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.layer.cornerRadius = 2;
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.height.equalTo(self.mas_height);
        }];
        
        //page control dot view
        self.pageCont = [[UIPageControl alloc]init];
        self.pageCont.pageIndicatorTintColor = [UIColor colorWithWhite:0.8 alpha:1];
        self.pageCont.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.6 alpha:1];
        self.pageCont.currentPage = 0;
        [self.pageCont sizeToFit];
        [self addSubview:self.pageCont];
        [self.pageCont mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.scrollView.mas_bottom);
            make.height.equalTo(self.mas_height).dividedBy(4);
        }];
        
    }
    return self;
}

- (void)updateScrollViewWithViewArray:(NSArray*)views
{
    //clear all old views
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    self.scrollView.frame = self.frame;
    
    //获取新的views
    self.tagViews = views;
    
    //更新隐藏view的长度
    CGSize scrollViewContentSize = CGSizeMake(self.frame.size.width*[self.tagViews count], self.frame.size.height);
    self.scrollView.contentSize = scrollViewContentSize;
    
    //更新页的总数
    self.pageCont.numberOfPages = [views count];
    
    if([views count] == 1)
        self.pageCont.hidden = YES;
    else
        self.pageCont.hidden = NO;
    
    //add new views
    [self.tagViews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [self.scrollView addSubview:obj];
    }];
}

-(void)moveToLastPage:(BOOL)flag
{
    if(!flag)
        return;

    NSUInteger totalPage = [self.tagViews count];
    self.scrollView.contentOffset = CGPointMake((totalPage-1)*self.scrollView.frame.size.width, 0);
    self.pageCont.currentPage = totalPage;
}


#pragma mark --- scroll view delegate
//page turn
-(void)scrollViewDidScroll:(UIScrollView *)scroll_view{
    NSInteger currentPage = (NSInteger)round(scroll_view.contentOffset.x / scroll_view.frame.size.width);
    self.pageCont.currentPage = currentPage;
}

@end

