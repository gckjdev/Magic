//
//  InviteCodeManager.m
//  BarrageClient
//
//  Created by pipi on 15/1/10.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import "InviteCodeManager.h"
#import "UIViewUtils.h"
#import "PPDebug.h"
#import "ShareUserDBManager.h"

#define KEY_INVITE_CODES                @"KEY_INVITE_CODES"
#define KEY_INVITE_CODES_USED           @"KEY_INVITE_CODES_USED"
#define KEY_CURRENT_INVITE_CODE         @"KEY_CURRENT_INVITE_CODE"

#define KEY_USER_INVITE_CODE_LIST       @"KEY_USER_INVITE_CODE_LIST"

@interface InviteCodeManager()

@property (nonatomic, strong) PBUserInviteCodeList* inviteCodeList;

@end

@implementation InviteCodeManager

IMPL_SINGLETON_FOR_CLASS(InviteCodeManager)

- (NSArray*)getCodes
{
    return UD_GET(KEY_INVITE_CODES);
}

- (void)storeCodes:(NSArray*)codes
{
    if ([codes count] == 0){
        PPDebug(@"<storeCodes> but no codes to store");
        return;
    }

    NSMutableArray* newCodes = [NSMutableArray array];
    
    NSArray* currentCodes = UD_GET(KEY_INVITE_CODES);
    if (currentCodes != nil){
        [newCodes addObjectsFromArray:currentCodes];
    }
    
    [newCodes addObjectsFromArray:codes];
    UD_SET(KEY_INVITE_CODES, newCodes);
    
    [self printCodes];
}

- (NSArray*)getUsedCodes
{
    return UD_GET(KEY_INVITE_CODES_USED);
}

- (void)useCode:(NSString*)code info:(NSString*)info
{
    if (code == nil){
        PPDebug(@"use code but code %@ is nil", code);
        return;
    }
    
    // remove from current
    NSMutableArray* newCodes = [NSMutableArray array];
    NSArray* currentCodes = UD_GET(KEY_INVITE_CODES);
    if (currentCodes != nil){
        [newCodes addObjectsFromArray:currentCodes];
        [newCodes removeObject:code];
        UD_SET(KEY_INVITE_CODES, newCodes);
    }
    
    // save to used
    NSMutableArray* newUsedCodes = [NSMutableArray array];
    NSArray* currentUsedCodes = UD_GET(KEY_INVITE_CODES);
    if (currentUsedCodes != nil){
        [newUsedCodes addObjectsFromArray:currentCodes];
    }
    [newUsedCodes addObject:code];
    UD_SET(KEY_INVITE_CODES_USED, newUsedCodes);
    
    [self printCodes];
}

- (void)printCodes
{
    NSArray* codes = [self getCodes];
    NSArray* used = [self getUsedCodes];
    PPDebug(@"codes=%@, used=%@", codes, used);
}

#pragma makr - User Invite Code List

- (void)storeUserInviteCodeList:(PBUserInviteCodeList*)newList
{
    if (newList == nil){
        return;
    }
    
    NSData* data = [newList data];
    if (data == nil){
        return;
    }
    
    [[[ShareUserDBManager sharedInstance] db] setObject:data forKey:KEY_USER_INVITE_CODE_LIST];
    
    self.inviteCodeList = newList;
}

- (PBUserInviteCodeList*)loadFromStroage
{
    NSData* data = [[[ShareUserDBManager sharedInstance] db] objectForKey:KEY_USER_INVITE_CODE_LIST];
    if (data == nil){
        return nil;
    }
    
    PBUserInviteCodeList* list = [PBUserInviteCodeList parseFromData:data];
    self.inviteCodeList = list;
    return list;
}

- (PBUserInviteCodeList*)getUserInviteCodeList
{
    if (self.inviteCodeList != nil){
        return self.inviteCodeList;
    }
    
    return [self loadFromStroage];
}

#pragma mark - Current Invite Code Cache

- (void)setCurrentInviteCode:(NSString*)code
{
    if ([code length] > 0){
        UD_SET(KEY_CURRENT_INVITE_CODE, code);
    }
}

- (NSString*)getCurrentInviteCode
{
    return UD_GET(KEY_CURRENT_INVITE_CODE);
}

- (void)clearCurrentInviteCode
{
    UD_REMOVE(KEY_CURRENT_INVITE_CODE);
}

@end
