//
//  AlbumCollectionViewCell.m
//  BarrageClient
//
//  Created by Teemo on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "AlbumCollectionViewCell.h"
#import "QNImageToolURL.h"
#import "PPDebug.h"
#import "UIImageView+WebCache.h"


@interface AlbumCollectionViewCell()
@property(nonatomic,strong)UIImageView *imageView;
@end
@implementation AlbumCollectionViewCell


-(void)updateViewWithData:(PBFeed*)feed
{
    _myFeed = feed;
    
    NSString *smallImage = [QNImageToolURL GetSmallSizeImageUrl:feed.image];
//    PPDebug(@"neng smallImage : %@",smallImage);
    NSURL* url = [NSURL URLWithString:smallImage];
    [_imageView sd_setImageWithURL:url
                  placeholderImage:nil
                         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                             PPDebug(@"load background image %@, error=%@", _imageView, error);
                         }];
}

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
    
//    _imageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_imageView];
    
    _imageView.frame  = self.bounds;
  
}


@end
