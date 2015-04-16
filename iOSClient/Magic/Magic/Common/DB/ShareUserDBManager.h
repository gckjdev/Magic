//
//  ShareUserDBManager.h
//  BarrageClient
//
//  Created by pipi on 15/1/20.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "LevelDBManager.h"

// 保存在本对象数据库中的数据必须是和某个用户相关的，和用户无关的不允许保存在本数据库中（请保存在NSUserDefault中或其他地方）

@interface ShareUserDBManager : CommonManager

DEF_SINGLETON_FOR_CLASS(ShareUserDBManager)

- (APLevelDB*)db;
- (APLevelDB*)dbForFeedPlayIndex;

@end
