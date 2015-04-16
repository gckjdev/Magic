//
//  EditingController.m
//  BarrageClient
//
//  Created by gckj on 15/1/3.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//
//  refactor by Shaowu Cai on 15/4/9

#import "EditingController.h"
#import "Masonry.h"
#import "PPDebug.h"
#import "ColorInfo.h"
#import "FontInfo.h"
#import "UIViewUtils.h"
#import "UIViewController+Utils.h"
#import "PlaceholderTextView.h"

const CGFloat kMargin = 20.0f;
const float kTextViewHeight = 50.0f;

@interface EditingController ()
@property (nonatomic,assign)BOOL isMulti;
@end

@implementation EditingController

#pragma mark - Public methods

- (id)initWithText:(NSString *)editText
   placeHolderText:(NSString *)placeHolderText
              tips:(NSString *)tips
           isMulti:(BOOL)isMulti
   saveActionBlock:(EditSaveBlock)saveActionBlock
{
    self = [super init];
    self.editText = editText;
    self.placeHolderText = placeHolderText;
    self.tips = tips;
    self.saveActionBlock = saveActionBlock;
    self.isMulti = isMulti ? isMulti : NO;
    return self;
}

#pragma mark - Default methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)loadView
{
    [super loadView];
    self.view.backgroundColor = BARRAGE_BG_COLOR;
    self.isMulti ? [self loadTextView] : [self loadTextField];
    [self loadTipsLabel];
    [self loadSaveButton];
}
#pragma mark - Private methods

- (void)loadTextField
{
    self.textField = [UITextField defaultTextField:self.placeHolderText
                                         superView:self.view];
    self.textField.text = self.editText;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kMargin);
    }];
}

- (void)loadTextView
{
    NSString *placeHolderString = self.editText ? nil : self.placeHolderText;
    self.textView = [[PlaceholderTextView alloc]initWithPlaceholder:placeHolderString
                                                   placeholderColor: nil
                                                    placeholderFont:BARRAGE_TEXTVIEW_PLACEHOLDER_FONT];
    [self.view addSubview:self.textView];
    self.textView.text = self.editText;
    self.textView.layer.borderWidth = COMMON_LAYER_BORDER_WIDTH;
    self.textView.layer.borderColor = [BARRAGE_TEXTFIELD_LAYER_COLOR CGColor];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(kMargin);
        make.width.equalTo(self.view).with.offset(+COMMON_LAYER_BORDER_WIDTH*2);;
        make.height.equalTo(@(kTextViewHeight));
        make.centerX.equalTo(self.view);
    }];
    self.textView.font = BARRAGE_TEXTVIEW_PLACEHOLDER_FONT;
}

- (void)loadTipsLabel
{
    self.tipsLabel = [[UILabel alloc]init];
    self.tipsLabel.text = self.tips;
    self.tipsLabel.textAlignment =  NSTextAlignmentCenter;
    self.tipsLabel.font = BARRAGE_LABEL_FONT;   //  字体
    [self.view addSubview:self.tipsLabel];
    
    UIView *preView = (self.isMulti ? self.textView : self.textField);
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(preView.mas_bottom).with.offset(+kMargin);
        make.centerX.equalTo(self.view);
    }];
}

- (void)loadSaveButton
{
    [self addRightButtonWithTitle:@"提交" target:self action:@selector(clickSaveButton:)];
}
#pragma mark - Utils
- (void)clickSaveButton:(id)sender
{
    [self save];
}

- (void)save
{
    NSString *text = self.isMulti ? self.textView.text : self.textField.text;
    EXECUTE_BLOCK(self.saveActionBlock, text);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
