//
//  TimelineTableView.h
//  BarrageClient
//
//  Created by HuangCharlie on 4/9/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TimelineTableView : UITableView <UITableViewDataSource,UITableViewDelegate>
{
    
}


-(instancetype)initWithSuperController:(UIViewController*)superController;

@end
