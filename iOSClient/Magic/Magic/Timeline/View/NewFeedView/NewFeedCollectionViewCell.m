//
//  NewFeedCollectionViewCell.m
//  BarrageClient
//
//  Created by Teemo on 15/3/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#define RIGHTTOP_VIEW_SIZE 30.0f


#import "NewFeedCollectionViewCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "PPDebug.h"
#import "NewFeedNumView.h"
#import "QNImageToolURL.h"

@interface NewFeedCollectionViewCell ()
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)NewFeedNumView *numView;
@end
@implementation NewFeedCollectionViewCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
-(void)initView{
    for (UIView* subview in self.contentView.subviews){
        [subview removeFromSuperview];
    }
    
    UIImageView *imageView = [[UIImageView alloc]init];
    _imageView = imageView;
    
    _imageView.backgroundColor = [UIColor blackColor];
    [self addSubview:_imageView];
    
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self);
        make.center.equalTo(self);
    }];
    
    
 
    _numView = [[NewFeedNumView alloc]init];
    
//    _numView.backgroundColor = [UIColor blueColor];
    [self addSubview:_numView];
    
    [_numView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(RIGHTTOP_VIEW_SIZE, RIGHTTOP_VIEW_SIZE) );
        make.top.mas_equalTo(self.mas_top);
        make.right.mas_equalTo(self.mas_right);
    }];
    
}
-(void)updateView:(PBMyNewFeed*)myNewFeed
{
    _myNewFeed = myNewFeed;
    //TODO
    NSString *smallImage = [QNImageToolURL GetSmallSizeImageUrl:_myNewFeed.image];
    PPDebug(@"neng smallImage : %@",smallImage);
    NSURL* url = [NSURL URLWithString:smallImage];
    [_imageView sd_setImageWithURL:url
                        placeholderImage:nil
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                   PPDebug(@"load background image %@, error=%@", _imageView, error);
                               }];
    
    [_numView updateView:_myNewFeed];
}
@end
