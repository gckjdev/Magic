//
//  HYCTagView.h
//  BarrageClient
//
//  Created by HuangCharlie on 1/22/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYCTagButton.h"
#import "User.pb.h"

@class HYCTagView;

@protocol HYCTagViewDelegate <NSObject>

-(void)didTapTag:(PBUserTag*)pbTag inStatus:(BOOL)isSelected;
-(void)didLongPressTag:(PBUserTag*)pbTag;

@end


@interface HYCTagView : UIView

@property(nonatomic,assign) id<HYCTagViewDelegate>  delegate;

+ (NSArray*)createTagViewsWithFrame:(CGRect)frame
                       allPbTagList:(NSArray*)pbTagList
                      selectedUsers:(NSArray*)selectedUsers
                           delegate:(id)delegate;


+ (NSUInteger)getArrangedRowCountWithFrame:(CGRect)frame
                                   andTags:(NSArray*)tags;


@end

