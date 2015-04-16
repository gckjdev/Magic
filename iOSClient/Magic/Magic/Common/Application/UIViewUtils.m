//
//  UIViewUtils.m
//  three20test
//
//  Created by qqn_pipi on 10-3-19.
//  Copyright 2010 QQN-PIPI.com. All rights reserved.
//

#import "UIViewUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "LogUtil.h"
#import "StringUtil.h"
#import "PPDebug.h"
#import "Masonry.h"
#import "ViewInfo.h"
#import "NSLayoutConstraint+MASDebugAdditions.h"

#import "POP.h"

@implementation UIView (UIViewUtils)

- (void)setBackgroundImageView:(NSString *)imageName
{
	int kBackgroundViewTag = 1024768;
	
	self.backgroundColor = [UIColor clearColor];
	
	CGRect frame = self.bounds;
	
	// create view
	UIImageView* bgview = [[UIImageView alloc] initWithFrame:frame];
	
	// set view tag
	bgview.tag = kBackgroundViewTag;
	
	// set image
	UIImage* image = [UIImage imageNamed:imageName];
//	image = [image stretchableImageWithLeftCapWidth:self.frame.size.width topCapHeight:self.frame.size.height];
	
	[bgview setImage:image];	
	
	// remove old bgview if it exists
	UIView* oldView = [self viewWithTag:kBackgroundViewTag];
	[oldView removeFromSuperview];
	
	// add to super view
	[self insertSubview:bgview atIndex:0];
}



- (UIView *)findFirstResonder
{
    if (self.isFirstResponder) {        
        return self;     
    }
	
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView findFirstResonder];
		
        if (firstResponder != nil) {
			return firstResponder;
        }
    }
	
    return nil;
}


- (UIActivityIndicatorView*)createActivityViewAtCenter:(UIActivityIndicatorViewStyle)style
{
	static int size = 30;
	
	UIActivityIndicatorView* activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
	activityView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - size/2, [UIScreen mainScreen].bounds.size.height/2 - size*2, size, size);
	activityView.tag = activityViewTag;
	[self addSubview:activityView];
	return activityView;
}

- (UIActivityIndicatorView*)getActivityViewAtCenter
{
	UIView* view = [self viewWithTag:activityViewTag];
	if (view != nil && [view isKindOfClass:[UIActivityIndicatorView class]]){
		return (UIActivityIndicatorView*)view;
	}
	else {
		return nil;
	}
}

- (void)showActivityViewAtCenter
{
	UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
	if (activityView == nil){
		activityView = [self createActivityViewAtCenter:UIActivityIndicatorViewStyleWhite];
	}

	[activityView startAnimating];
}

- (void)hideActivityViewAtCenter
{
	UIActivityIndicatorView* activityView = [self getActivityViewAtCenter];
	if (activityView != nil){
		[activityView stopAnimating];
	}		
}

- (void)createButtonsInView:(NSArray*)buttonTextArray templateButton:(UIButton*)templateButton
                     target:(id)target action:(SEL)action
{
    const int RIGHT_SPACING = 10;
    
    const int BUTTON_HEIGHT_INDENT = 5;
    const int BUTTON_WIDTH_INDENT = 5;  
    const int BUTTON_WIDTH_EXTEND = 20;
    const int DEFAULT_BUTTON_HEIGHT = 30;
    
    UIFont* font = [templateButton.titleLabel font];
    
    int buttonHeight = DEFAULT_BUTTON_HEIGHT;    
    int right = self.frame.origin.x + self.frame.size.width;
    
    NSUInteger count = [buttonTextArray count];
    
    CGSize scrollSize = self.bounds.size;
    
    const int START_X = 0;
    const int START_Y = 0;
    
    int buttonLeft = START_X;
    int buttonTop = START_Y;
    for (int i=0; i<count; i++){
        
        NSString* word = [buttonTextArray objectAtIndex:i];
        CGSize size = [word sizeWithMyFont:font];
        int buttonWidth = size.width + BUTTON_WIDTH_EXTEND;            
        
        UIButton* button = [UIButton buttonWithType:templateButton.buttonType];
        UIColor* color = [templateButton titleColorForState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal]; 
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(buttonLeft, buttonTop, buttonWidth, buttonHeight);        
        [button setTitle:word forState:UIControlStateNormal];
        [button.titleLabel setFont:templateButton.titleLabel.font];
        [self addSubview:button];
        
        if ( (i+1) < count ){
            NSString* nextWord = [buttonTextArray objectAtIndex:i+1];
            CGSize size = [nextWord sizeWithMyFont:font];
            int nextButtonWidth = size.width + BUTTON_WIDTH_EXTEND;
            buttonLeft += buttonWidth + BUTTON_WIDTH_INDENT;
            if (buttonLeft + nextButtonWidth + RIGHT_SPACING > right){
                // new line
                buttonTop += buttonHeight + BUTTON_HEIGHT_INDENT;
                buttonLeft = START_X;
                
                scrollSize.height += buttonHeight + BUTTON_HEIGHT_INDENT;
                if ([self isKindOfClass:[UIScrollView class]]){
                    [((UIScrollView*)self) setContentSize:scrollSize];
                }
            }
        }
    }
    
}

- (void)removeAllSubviews
{
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}


- (void)moveTtoCenter:(CGPoint)center needAnimation:(BOOL)need animationDuration:(NSTimeInterval)interval
{
    if (need) {
        [UIView beginAnimations:nil context:nil];
        [UIImageView setAnimationDuration:interval];
        [self setCenter:center];
        [UIImageView commitAnimations];        
    }else{
        [self setCenter:center];        
    }
}

+ (id)createViewWithXibIdentifier:(NSString *)identifier ofViewIndex:(NSUInteger) index
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:identifier owner:self options:nil];
    
    if (topLevelObjects == nil || [topLevelObjects count] <= index){
        NSLog(@"create %@ but cannot find view object from Nib", identifier);
        return nil;
    }
    return [topLevelObjects objectAtIndex:index];
}

+ (id)createViewWithXibIdentifier:(NSString *)identifier
{
    return [UIView createViewWithXibIdentifier:identifier ofViewIndex:0];
}

- (void)updateOriginX:(CGFloat)originX
{
    self.frame = CGRectMake(originX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)updateOriginY:(CGFloat)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height);
}

- (void)updateOriginDataViewTableY:(CGFloat)originY
{
    self.frame = CGRectMake(self.frame.origin.x, originY, self.frame.size.width, self.frame.size.height-STATUSBAR_DELTA);
}

- (void)updateBottom:(CGFloat)bottom{
    self.frame = CGRectMake(self.frame.origin.x, bottom-self.frame.size.height, self.frame.size.width, self.frame.size.height);
}

- (void)updateCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)updateCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)updateWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

- (void)updateHeight:(CGFloat)height
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

- (UIView *)PPRootView
{
    UIView *view = self;
    while (view.superview != nil) {
        view = view.superview;
    }
    return view;
}

- (void)setShadowOffset:(CGSize)offset
                   blur:(float)blur
            shadowColor:(UIColor*)color
{
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = blur;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
}

- (void)scaleWithSize:(CGSize)size
           anchorType:(AnchorType)anchorType
            constType:(ConstType)constType
{
    CGRect frame = self.frame;

    //cal the new size
    CGSize newSize = size;
    if (constType == ConstTypeHeight) {
        newSize.height = CGRectGetHeight(self.bounds);
        newSize.width = size.width * newSize.height / size.height;
    }else if (constType == ConstTypeWidth){
        newSize.width = CGRectGetWidth(self.bounds);
        newSize.height = size.height * newSize.width / size.width;
    }
//    frame.size = newSize;
    
    //cal the origin
    CGPoint newOrigin = frame.origin;
    
    switch (anchorType) {

        case AnchorTypeRightTop:
        {
            newOrigin.x = CGRectGetMaxX(frame) - newSize.width;
            break;
        }
        case AnchorTypeLeftBottom:
        {
            newOrigin.y = CGRectGetMaxY(frame) - newSize.height;
            break;
        }
        case AnchorTypeRightBottom:
        {
            newOrigin.x = CGRectGetMaxX(frame) - newSize.width;
            newOrigin.y = CGRectGetMaxY(frame) - newSize.height;
            break;
        }
        case AnchorTypeCenter:
        {
            CGPoint center = self.center;
            newOrigin.x = center.x - newSize.width / 2;
            newOrigin.y = center.y - newSize.height / 2;
            break;
        }
        case AnchorTypeLeftTop:
        {
            break;
        }
        default:
            break;
    }
    frame.origin = newOrigin;
    frame.size = newSize;
    PPDebug(@"<scaleWithSize> from frame: %@ to frame: %@ ",NSStringFromCGRect(self.frame),NSStringFromCGRect(frame));
    self.frame = frame;
}

- (UIView *)theTopView
{
    UIResponder *responder = self;
    
    while (responder && [responder.nextResponder isKindOfClass:[UIView class]]) {
        responder = responder.nextResponder;
//        PPDebug(@"Next Responder = %@", [responder description]);
    }
    return (UIView *)responder;
}
- (UIViewController *)theViewController
{
    UIResponder *responder = [self theTopView];
    while (responder && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
//        PPDebug(@"Next Responder = %@", [responder description]);
    }
    if ([responder isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)responder;
    }
    return nil;
}

- (UIView *)reuseViewWithTag:(NSInteger)tag
                   viewClass:(Class)viewClass
                       frame:(CGRect)frame
{
    UIView *view = [self viewWithTag:tag];
    if (![view isKindOfClass:[viewClass class]]) {
        view = [[viewClass alloc] initWithFrame:frame];
        view.tag = tag;
        [self addSubview:view];
    }
    view.frame = frame;
    return view;
}

- (UILabel *)reuseLabelWithTag:(NSInteger)tag
                         frame:(CGRect)frame
                          font:(UIFont *)font
                          text:(NSString *)text
{
    UILabel *label = (id)[self reuseViewWithTag:tag viewClass:[UILabel class] frame:frame];
    [label setFont:font];
    [label setText:text];
    [label sizeToFit];
    return label;
}

- (UIButton *)reuseButtonWithTag:(NSInteger)tag
                           frame:(CGRect)frame
                            font:(UIFont *)font
                            text:(NSString *)text
{
    UIButton *button = (id)[self reuseViewWithTag:tag viewClass:[UIButton class] frame:frame];
    [button.titleLabel setFont:font];
    [button setTitle:text forState:UIControlStateNormal];
    if (text) {
        [button sizeToFit];
    }
    return button;
    
}


- (BOOL)containsSubView:(UIView *)view
{
    for (UIView *sv in self.subviews) {
        if (sv == view || [sv containsSubView:view]) {
            return YES;
        }
    }
    return NO;
}
- (BOOL)containsSubViewWithClass:(Class)viewClass
{
    for (UIView *sv in self.subviews) {
        if ([sv isKindOfClass:viewClass] || [sv containsSubViewWithClass:viewClass]) {
            return YES;
        }
    }
    return NO;    
}

- (void)reverseViewHorizontalContent
{
    for (UIView *view in self.subviews) {
        CGPoint center = view.center;
        center.x = CGRectGetWidth(self.bounds) - center.x;
        view.center = center;
    }
}
- (void)reverseViewVerticalContent
{
    for (UIView *view in self.subviews) {
        CGPoint center = view.center;
        center.y = CGRectGetHeight(self.bounds) - center.y;
        center = center;
    }
}

- (void)enumSubviewsWithClass:(Class)viewClass handler:(void (^)(id view))handler
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewClass]) {
            EXECUTE_BLOCK(handler,view);
        }
    }
}

- (void)removeSubviewsWithClass:(Class)viewClass
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:viewClass]) {
            [view removeFromSuperview];
        }
    }
}

- (UITapGestureRecognizer*)addTapGestureWithTarget:(id)target selector:(SEL)selector
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    [self addGestureRecognizer:tapGestureRecognizer];
    return tapGestureRecognizer;
}

- (UIImage *)createSnapShotWithScale:(CGFloat)scale
{
    CGSize size = self.bounds.size;
    return [self createSnapShotWithScale:scale size:size];
}

- (UIImage *)createSnapShotWithScale:(CGFloat)scale size:(CGSize)size
{    
    size.width *= scale;
    size.height *= scale;
    UIImage *retImage = nil;
    
    //for retina display, change the first line into this
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scale, scale);
    [self.layer renderInContext:context];
    retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retImage;
}

- (void)scaleView:(CGFloat)scale
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:DRAW_INFO_NEED_UPDATE object:nil];
    
    CGAffineTransform transform = self.transform; //CGAffineTransformScale(self.transform, scale, scale);
    transform.a = transform.d = scale;
    self.transform = transform;
    
    PPDebug(@"<scaleView> scale = %f, transform = %@, frame = %@", scale,
            NSStringFromCGAffineTransform(transform),
            NSStringFromCGRect(self.frame));
}

- (CGFloat)scaleInView:(UIView*)superView
{
    CGFloat xScale = CGRectGetWidth(superView.bounds) / CGRectGetWidth(self.bounds);
    CGFloat yScale = CGRectGetHeight(superView.bounds) / CGRectGetHeight(self.bounds);
    CGFloat scale = MIN(xScale, yScale);

    CGAffineTransform transform = self.transform; //CGAffineTransformScale(self.transform, scale, scale);
    transform.a = transform.d = scale;
    self.transform = transform;
    
    PPDebug(@"<scaleInView>scale = %f, transform = %@, frame = %@", scale,
            NSStringFromCGAffineTransform(transform),
            NSStringFromCGRect(self.frame));
    
    CGPoint center = CGRectGetCenter(superView.bounds);;
    self.center = center;
    
    return scale;
}

+ (UIButton*)createButton:(NSString*)imageName
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    return button;
}

+ (UIButton*)defaultTextButton:(NSString*)title
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = BARRAGE_BUTTON_FONT;
    [button setBackgroundColor:BARRAGE_RED_COLOR];
    [button setTitleColor:BUTTON_TITLE_COLOR forState:UIControlStateNormal];
    SET_VIEW_ROUND_CORNER(button);    //  设置圆角
    
    [button setTitle:title
            forState:UIControlStateNormal];

    return button;
}

+ (UIButton*)defaultTextButton:(NSString*)title superView:(UIView*)superView
{
    UIButton *button = [self defaultTextButton:title];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.height.equalTo(@(COMMON_BUTTON_HEIGHT));
        make.width.equalTo(@(GOLDNUM*kScreenWidth));
    }];
    return button;
}
//  需要修改宽度
+ (UIButton*)createButton:(NSString *)title superView:(UIView *)superView
{
    UIButton *button = [self defaultTextButton:title];
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.height.equalTo(@(COMMON_BUTTON_HEIGHT));
    }];
    return button;
}
//  生成默认textField 调用的时候记得得设置垂直方向的坐标
+(UITextField*)defaultTextField:(NSString*)placeholder
                      superView:(UIView*)superView
{
    UITextField *textField = [[UITextField alloc]init];
    textField.font = BARRAGE_TEXTFIELD_FONT;
    textField.textColor = BARRAGE_TEXTFIELD_COLOR;
    textField.backgroundColor = [UIColor whiteColor];   //  背景颜色：白色
    textField.placeholder =placeholder;
    textField.textAlignment = NSTextAlignmentCenter;
    //  边框颜色及大小
    textField.layer.borderWidth = COMMON_LAYER_BORDER_WIDTH;
    textField.layer.borderColor = [BARRAGE_TEXTFIELD_LAYER_COLOR CGColor];
    
    textField.clearButtonMode = UITextFieldViewModeAlways;     //  清除按钮
    
    [textField becomeFirstResponder];   //  第一响应者
    [superView addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.width.equalTo(superView);
        make.height.equalTo(@(COMMON_TEXTFIELD_HEIGHT));
    }];
    return textField;
}
//  生成默认Label
+(UILabel*)defaultLabel:(NSString*)text
              superView:(UIView*)superView
{
    UILabel *label = [[UILabel alloc]init];
    [superView addSubview:label];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = text;
    label.textColor = BARRAGE_LABEL_GRAY_COLOR;
    label.font = BARRAGE_LABEL_FONT;
    label.numberOfLines = 0;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.width.equalTo(superView).offset(-50);
    }];
    return label;
}
//  生成其他注册方式按钮 其他登录方式的也暂时用这个 暂时弃用
+ (UIButton*)registerStyleWithsuperView:(UIView*)superView
                         normalBgImg:(NSString*)normalBgImg
                      highlightedBgImg:(NSString*)highlightedBgImg
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:normalBgImg]
                      forState:UIControlStateNormal];   //  默认状态图片
    [button setBackgroundImage:[UIImage imageNamed:highlightedBgImg]
                      forState:UIControlStateHighlighted];  //  高亮状态图片
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
    }];
    return button;
}
//  生成其他注册方式按钮 其他登录方式的也暂时用这个
+ (UIButton*)registerStyleWithsuperView:(UIView*)superView
                                  title:(NSString*)title
                                   icon:(NSString*)icon
                                bgColor:(UIColor*)bgColor
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:bgColor];
    SET_VIEW_ROUND_CORNER_RADIUS(button, 18);   //  设置圆角
    [superView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.width.equalTo(superView).with.multipliedBy(0.59);
    }];
    
    //  辅助的view
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor greenColor];
    [button addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(button);
    }];
    //  图标
    UIImageView *iconView = [[UIImageView alloc]initWithImage:[UIImage  imageNamed:icon]];
    [view addSubview:iconView];
    [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(view);
    }];
    //  标题
    UILabel *titleLabel = [[UILabel alloc]init];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.equalTo(view);
        make.left.equalTo(iconView.mas_right).with.offset(+5);  //  因为view根据titleLabel和iconView来确定width，所以可以既有right又有left
    }];
    
    titleLabel.text = title;
    titleLabel.font = BARRAGE_LABEL_FONT;
    titleLabel.textColor = [UIColor whiteColor];
    return button;
}

//  用于UITableViewCell下方的横线
+(void)addSingleLineWithColor:(UIColor *)color
                  borderWidth:(CGFloat)borderWidth
                    superView:(id)superView
{
    [self addBottomLineWithColor:color
                     borderWidth:borderWidth
                       superView:superView];
}
//  普通横线
+(UIView*)creatSingleLineWithColor:(UIColor *)color
                      borderWidth:(CGFloat)borderWidth
                        superView:(id)superView
{
    UIView *view = [[UIView alloc]init];
    [superView addSubview:view];
    view.backgroundColor = color;
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(borderWidth));
        make.width.equalTo(superView);
        make.centerX.equalTo(superView);
    }];
    return view;
}

//  上方横线
+(void)addTopLineWithColor:(UIColor *)color
               borderWidth:(CGFloat)borderWidth
                 superView:(id)superView
{
    UIView *view = [UIView creatSingleLineWithColor:color
                                        borderWidth:borderWidth
                                          superView:superView];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView);
    }];
}

//  下方横线
+(void)addBottomLineWithColor:(UIColor *)color
               borderWidth:(CGFloat)borderWidth
                 superView:(id)superView
{
    UIView *view = [UIView creatSingleLineWithColor:color
                                        borderWidth:borderWidth
                                          superView:superView];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(superView);
    }];
}

//默认的分割view，高度只有窄窄的COMMON_OFFSETY(14)，用于在superview中分割subview，形成全局统一风格
//该方法需要使用后自定义Y坐标位置，使用centerY等等属性
+(UIView*)defaultSpacingInSuperView:(UIView*)superView
{
    UIView* view = [[UIView alloc]init];
    view.backgroundColor = BARRAGE_BG_COLOR;
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView.mas_left);
        make.right.equalTo(superView.mas_right);
        make.height.equalTo(@(COMMON_MARGIN_OFFSET_Y));
    }];
    return view;
}

//删除时候的抖动
- (void)setShaking
{
    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    [anim setToValue:[NSNumber numberWithFloat:-M_PI/64]];
    [anim setFromValue:[NSNumber numberWithDouble:M_PI/64]];
    [anim setDuration:0.1];
    [anim setRepeatCount:NSUIntegerMax];
    [anim setAutoreverses:YES];
    
    [self.layer addAnimation:anim forKey:@"SpringboardShake"];
}

//- (void)setEaseInWithDuration:(CGFloat)duration
//{
//    NSString *easeInKey = @"ease in opacity appear";
//    self.hidden = YES;
//    [self.layer removeAllAnimations];
//    CABasicAnimation* anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    anim.fromValue = [NSNumber numberWithFloat:0];
//    anim.toValue = [NSNumber numberWithFloat:1.0];
//    anim.duration = duration;
//    anim.removedOnCompletion = YES;
//    [self.layer addAnimation:anim forKey:easeInKey];
//    self.hidden = NO;
//}

- (void)setEaseInWithDuration:(CGFloat)duration
{
    [self.layer pop_removeAllAnimations];
    NSString *easeInKey = @"ease in opacity appear";
    POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = duration;
    [self.layer pop_addAnimation:animation forKey:easeInKey];
}
- (void)setEaseOutWithDuration:(CGFloat)duration
{
    [self.layer pop_removeAllAnimations];
    NSString *easeOutKey = @"ease out opacity appear";
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    anim.fromValue = [NSNumber numberWithFloat:1.0];
    anim.toValue = [NSNumber numberWithFloat:0];
    anim.duration = duration;
    anim.removedOnCompletion = YES;
    [self.layer pop_addAnimation:anim forKey:easeOutKey];
}

- (void)pullDownWithDuration:(CGFloat)duration superView:(UIView *)superView height:(float)height
{
//    [superView removeConstraints:self.constraints];
//    [superView removeConstraints:superView.constraints];
//    [superView removeConstraints:self.constraintArray];
//    [self removeConstraints:self.constraintArray];
//    [self.constraintArray removeAllObjects];
    NSMutableArray *constraintArray = [[NSMutableArray alloc]init];
    [UIView animateWithDuration:duration animations:^{
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *viewsDictionary = @{@"view":self};
        NSArray *layoutConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view(height)]"
                                                                                 options:0
                                                                                 metrics:@{@"height":@(height)}
                                                                                   views:viewsDictionary];
        [constraintArray addObjectsFromArray:layoutConstraintArray];
    }];
    
    [superView addConstraints:constraintArray];
    [self layoutIfNeeded];
//    self.isAnimation = YES;
}

- (void)pullUpWithDuration:(CGFloat)duration superView:(UIView *)superView height:(float)height
{
    [superView removeConstraints:self.constraints];
    //    [superView removeConstraints:superView.constraints];
    //    [superView removeConstraints:self.constraintArray];
    //    [self removeConstraints:self.constraintArray];
    //    [self.constraintArray removeAllObjects];
    [UIView animateWithDuration:duration animations:^{
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *viewsDictionary = @{@"view":self};
        NSArray *layoutConstraintArray = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view(height)]"
                                                                                 options:0
                                                                                 metrics:@{@"height":@(height)}
                                                                                   views:viewsDictionary];
        //        [self.constraintArray addObjectsFromArray:layoutConstraintArray];
        
        [superView addConstraints:layoutConstraintArray];
    }];
    
    [self layoutIfNeeded];
    //    self.isAnimation = YES;
}
@end

@implementation UISearchBar (UISearchBarUtils)

- (void)setSearchBarBackgroundByImage:(NSString*)imageName
{
	// hide the search bar background
	UIView* segment=[self.subviews objectAtIndex:0];
	segment.hidden=YES;		
	
	//	UIView* bg=[searchBar.subviews objectAtIndex:1];
	//	bg.hidden=YES;	
	UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[imageView setImage:[UIImage imageNamed:imageName]];
	
	[self insertSubview:imageView atIndex:1];
}

- (void)setSearchBarBackgroundByView:(UIImageView*)imageView
{
	// hide the search bar background
	UIView* segment=[self.subviews objectAtIndex:0];
	segment.hidden=YES;		

	//	UIView* bg=[searchBar.subviews objectAtIndex:1];
	//	bg.hidden=YES;	
	
	[self addSubview:imageView];
	[self sendSubviewToBack:imageView];
}



@end


CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}