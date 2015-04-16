//
//  TagManager.h
//  BarrageClient
//
//  Created by pipi on 15/1/15.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "CommonManager.h"
#import "User.pb.h"

@interface TagManager : CommonManager

DEF_SINGLETON_FOR_CLASS(TagManager)

- (PBUserTagList*)allTags;
- (void)storeTags:(PBUserTagList*)newTagList;
- (void)printTags;

- (PBUserTag*)buildNewTag:(NSString*)name;

//为tag改名
- (PBUserTag*)updateTag:(PBUserTag*)originTag
            withNewName:(NSString*)name;

- (BOOL)isTagNameExist:(NSString*)name;

- (NSArray*)userListByTag:(PBUserTag*)tag;

- (PBUserTag*)getTagWithTID:(NSString*)tid;

- (BOOL)checkArray:(NSArray*)array belongToTag:(PBUserTag*)tag;

- (PBUserTag*)checkOverTagsForArray:(NSArray*)array;

- (NSArray*)getTagWithUser:(PBUser*)user;

@end
