//
//  DemoViewController.m
//  BarrageClient
//
//  Created by Teemo on 15/3/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "DemoViewController.h"
#import "TimelineCell.h"
#import "Feed.h"
#import "FeedManager.h"
#import "AppDelegate.h"
#import "CommonBarrageCell.h"
#import "UILineLabel.h"
#import "UIUtils.h"
#import "UIViewUtils.h"

#define DEMO_FILE_COUNT 13

#define LINELABEL_TOP_INSET 200.0f

@interface DemoViewController ()
@property (nonatomic,strong) CommonBarrageCell   *cell;
@property (nonatomic,strong) UILineLabel   *lineLabel;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = NAVIGATIONBAR_BLACK;
    self.title = @"展示";
    
    [self setupBarrageCell];
    [self setupLineLabel];
}
-(void)setupBarrageCell{
    CGRect feedViewFrame = CGRectMake(0, 0, kScreenWidth, BARRAGE_HEIGHT(kScreenWidth));
    _cell = [CommonBarrageCell initWithFrame:feedViewFrame type:BARRAGE_CELL_SIMPLE];
    
    [self addTapHandler];
    
    Feed *feed = [self getDemoData];
    if (feed == nil) {
        return;
    }
    [_cell updateCellData:feed];
    [self.view addSubview:_cell];
    
    _cell.center = self.view.center;

}
-(void)setupLineLabel{
    _lineLabel =  [UILineLabel initWithText:@"点击退出" Font:BARRAGE_LABEL_FONT Color:[UIColor whiteColor] Type:UILINELABELTYPE_DOWN];
    [_lineLabel addTapGestureWithTarget:self selector:@selector(quitAction)];
    _lineLabel.center = CGPointMake(self.view.center.x, self.view.center.y+ LINELABEL_TOP_INSET);
    [self.view addSubview:_lineLabel];
    
}

-(Feed*)getDemoData{
    static int i = 1;
    NSString *path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"demo%d",i] ofType:@"dat"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data == nil){
        return nil;
    }
    
    if (++i >DEMO_FILE_COUNT) {
        i = 1;
    }
    
    @try {
        PBFeed* newFeed = [PBFeed parseFromData:data];
        
        return [Feed feedWithPBFeed:newFeed];
    }
    @catch (NSException *exception) {
        PPDebug(@"catch exception while parse user data, exception=%@", [exception description]);
        return nil;
    }
    
   
    return nil;
}
-(void)addTapHandler{
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeDemo)];
    
    /**
     *  单击
     */
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    [self.view addGestureRecognizer:singleRecognizer];
}

-(void)quitAction{
    [self dismissViewControllerAnimated:NO completion:^{
//        self.demoNavigationController = nil;
    }];
}
-(void)changeDemo{
    Feed *feed = [self getDemoData];
    if (feed == nil) {
        return;
    }
    [_cell updateCellData:feed];
}
@end
