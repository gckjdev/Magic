//
//  TagInfoViewController.h
//  BarrageClient
//
//  Created by gckj on 15/2/5.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

typedef enum {
    IsCreating = 0,
    IsEditing,
} TagInfoType;

@protocol TagInfoDelegate <NSObject>
//用于编辑tag后返回时自动跳转
-(void)didProcessTag:(PBUserTag*)tag newlyAdd:(BOOL)flag;

@end

@interface TagInfoViewController : UIViewController

@property (nonatomic, strong) PBUserTag* currentTag;
@property (nonatomic, strong) NSMutableArray* currentUserList;
@property (nonatomic, strong) NSArray* originUserList;

@property (nonatomic, assign) id<TagInfoDelegate> delegate;
@property (nonatomic, strong) UIViewController* fromController;//从何处而来,到何处而去

- (instancetype)initWithType:(TagInfoType)type
                    andPBTag:(PBUserTag*)tag
                   orPBUsers:(NSArray*)users;

@end
