//
//  UserDetailCell.m
//  BarrageClient
//
//  Created by 蔡少武 on 15/3/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "UserDetailCell.h"
#import "UIimageView+Webcache.h"
#import "Masonry.h"
#import "ViewInfo.h"
#import "FontInfo.h"
#import "ColorInfo.h"

@implementation UserDetailCell
{
    PBUser *_user;
    BOOL isBackgroundImageLightColor;
    UIImageView *locationImageView;
}

#pragma mark - Default methods
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Public methods
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier user:(PBUser *)user
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _user = user;
        [self loadView];
        [self loadData];
    }
    return  self;
}

#pragma mark - Private methods
//  load data after view did load
- (void)loadData
{
    self.nickNameLabel.text = _user.nick;
    self.sinatureLabel.text = _user.signature;
    self.locationDetailTextLabel.text = _user.location;
    if ([_user.location isEqualToString:@""]) {
        locationImageView.hidden = YES;
    }
}
- (void)loadView
{
    [self loadBackgroundImageView];
    [self loadAvatarView];
    [self loadNickNameLabel];
    [self loadSinatureLabel];
    [self loadTagDetailTextLabel];
    [self loadLocationDetailTextLabel];
    [self loadLocationImageView];
}
- (void)loadBackgroundImageView
{
    self.backgroundImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.backgroundImageView];

    if (![_user.avatarBg isEqualToString:@""] && _user.avatarBg != nil) {
        NSURL *url = [NSURL URLWithString:_user.avatarBg];
        [self.backgroundImageView sd_setImageWithURL:url];
    }else{
        self.backgroundImageView.image = [UIImage imageNamed:@"default_user_background_image"];
    }
    UIColor *backgroundImageMostColor = [self mostColorInImage:self.backgroundImageView.image];
    isBackgroundImageLightColor = [self isLightColor:backgroundImageMostColor];
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.equalTo(self.contentView);
    }];
}
- (void)loadAvatarView
{
    self.avatarView = [[UserAvatarView alloc]initWithUser:_user borderWidth:2];
    [self.contentView addSubview:self.avatarView];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.contentView).with.multipliedBy(0.5);
        make.width.equalTo(self.contentView.mas_height).with.dividedBy(4);
        make.height.equalTo(self.contentView).with.dividedBy(4);
    }];
}
- (void)loadNickNameLabel
{
    self.nickNameLabel = [[THLabel alloc]init];
    [self.contentView addSubview:self.nickNameLabel];
    if (isBackgroundImageLightColor == NO) {
        self.nickNameLabel.textColor = [UIColor whiteColor];
        self.nickNameLabel.strokeColor = [UIColor blackColor];
    }else{
        self.nickNameLabel.textColor = [UIColor blackColor];
        self.nickNameLabel.strokeColor = [UIColor whiteColor];
    }
    self.nickNameLabel.font = [UIFont systemFontOfSize:20];
    self.nickNameLabel.strokeSize = 1.0f;
    
    [self.nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_centerY).with.multipliedBy(0.9);
    }];
}
- (void)loadSinatureLabel
{
    self.sinatureLabel = [[THLabel alloc]init];
    [self.contentView addSubview:self.sinatureLabel];
    self.sinatureLabel.font = [UIFont systemFontOfSize:18];
    self.sinatureLabel.strokeSize = 1.0f;
    self.sinatureLabel.textAlignment = NSTextAlignmentCenter;
    
    if (isBackgroundImageLightColor == NO) {
        self.sinatureLabel.textColor = [UIColor whiteColor];
        self.sinatureLabel.strokeColor = [UIColor blackColor];
    }else{
        self.sinatureLabel.textColor = [UIColor blackColor];
        self.sinatureLabel.strokeColor = [UIColor whiteColor];
    }
    
    [self.sinatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView.mas_centerY).with.multipliedBy(1.2);
        make.width.equalTo(self.contentView).with.multipliedBy(0.7);
    }];
}

//- (void)loadTagTextLabel
//{
//    self.tagTextLabel = [[UILabel alloc]init];
//    [self.contentView addSubview:self.tagTextLabel];
//    self.tagTextLabel.textColor = isBackgroundImageDeepColor ? BARRAGE_LABEL_COLOR : [UIColor whiteColor];
//    self.tagTextLabel.font = BARRAGE_LABEL_FONT;
//    
//    [self.tagTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).with.offset(+COMMON_MARGIN_OFFSET_X);
//        make.bottom.equalTo(self.contentView).with.offset(-COMMON_MARGIN_OFFSET_Y);
//    }];
//}
- (void)loadTagDetailTextLabel
{
    self.tagDetailTextLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.tagDetailTextLabel];
    self.tagDetailTextLabel.textColor = isBackgroundImageLightColor ? BARRAGE_LABEL_GRAY_COLOR : [UIColor whiteColor];
    self.tagDetailTextLabel.font = [UIFont systemFontOfSize:11];
    
    [self.tagDetailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(+COMMON_MARGIN_OFFSET_X);
        make.bottom.equalTo(self.contentView).with.offset(-COMMON_MARGIN_OFFSET_Y);
    }];
}
//- (void)loadLocationTextLabel
//{
//    self.locationTextLabel = [[UILabel alloc]init];
//    [self.contentView addSubview:self.locationTextLabel];
//    self.locationTextLabel.textColor = isBackgroundImageDeepColor ? BARRAGE_LABEL_COLOR : [UIColor whiteColor];
//    self.locationTextLabel.font = BARRAGE_LABEL_FONT;
//    
//    [self.locationTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_centerX).with.offset(+COMMON_MARGIN_OFFSET_X);
//        make.bottom.equalTo(self.contentView).with.offset(-COMMON_MARGIN_OFFSET_Y);
//    }];
//}
- (void)loadLocationDetailTextLabel
{
    self.locationDetailTextLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.locationDetailTextLabel];
    self.locationDetailTextLabel.textColor = isBackgroundImageLightColor ? BARRAGE_LABEL_GRAY_COLOR : [UIColor whiteColor];
    self.locationDetailTextLabel.font = [UIFont systemFontOfSize:11];
    
    [self.locationDetailTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-COMMON_MARGIN_OFFSET_X);
        make.bottom.equalTo(self.contentView).with.offset(-COMMON_MARGIN_OFFSET_Y);
    }];
}

- (void)loadLocationImageView
{
    locationImageView = [[UIImageView alloc]init];
    [self.contentView addSubview:locationImageView];
    NSString *imageName = isBackgroundImageLightColor ? @"location_black.png" : @"location_white.png";
    locationImageView.image = [UIImage imageNamed:imageName];
    
    [locationImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.locationDetailTextLabel);
        make.right.equalTo(self.locationDetailTextLabel.mas_left);
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
}

#pragma mark - Utils
-(UIColor*)mostColorInImage:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(50, 50);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL)
    {
        CGContextRelease(context);
        return nil;
    }
    
    NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            
            int offset = 4*(x*y);
            
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha =  data[offset+3];
            
            NSArray *clr=@[@(red),@(green),@(blue),@(alpha)];
            [cls addObject:clr];
            
        }
    }
    CGContextRelease(context);
    
    //第三步 找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    
    NSArray *MaxColor=nil;
    NSUInteger MaxCount=0;
    
    while ( (curColor = [enumerator nextObject]) != nil )
    {
        NSUInteger tmpCount = [cls countForObject:curColor];
        
        if ( tmpCount < MaxCount ) continue;
        
        MaxCount=tmpCount;
        MaxColor=curColor;
        
    }
    
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

//判断颜色是不是亮色
-(BOOL) isLightColor:(UIColor*)clr {
    CGFloat components[3];
    [self getRGBComponents:components forColor:clr];
    
    CGFloat num = components[0] + components[1] + components[2];
    if(num < 382)
        return NO;
    else
        return YES;
}

//获取RGB值
- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 bitmapInfo);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        components[component] = resultingPixel[component];
    }
}
@end
