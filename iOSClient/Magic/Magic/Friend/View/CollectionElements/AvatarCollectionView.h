//
//  AvatarCollectionView.h
//  BarrageClient
//
//  Created by HuangCharlie on 2/5/15.
//  Copyright (c) 2015 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.pb.h"

@protocol AvatarCollectionViewDelegate <NSObject>

@optional
-(void)didClickOnOneUserAvatar:(PBUser*)pbUser;
-(void)didClickAddIcon;
-(void)didDeleteAvatarOfUser:(PBUser*)pbUser;

@end

typedef enum {
    DisplayMode = 0,
    EditMode,
    DeleteMode
} AvatarCollectionViewMode;

@interface AvatarCollectionView : UICollectionView

@property (nonatomic,assign) id<AvatarCollectionViewDelegate> actionDelegate;
@property (nonatomic,strong) NSArray* pbUserList;

//views that may be change by outside situation
@property (nonatomic,strong) UIView *header;
@property (nonatomic,strong) UIView *footer;

+ (UICollectionViewFlowLayout*)flowLayoutWithHeaderSize:(CGSize)headerViewSize
                                             footerSize:(CGSize)footerSize;

+ (UIView*)setHeaderView;
+ (UIView*)setFooterView;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
             presentationMode:(AvatarCollectionViewMode)mode
                   headerView:(UIView*)headerView
                   footerView:(UIView*)footerView;

- (void)loadPbUserList:(NSArray*)pbuserList;
- (void)backToEditMode;

@end


/*
 ReadMe:
 The following is how to use:
 
 UICollectionViewFlowLayout *layout = [AvatarCollectionView flowLayoutWithHeaderSize:
 footerSize:]
 //do something one layout if needed
 //....
 UIView *h = [AvatarCollectionView setheaderView]
 //do something on headerview according to desing
 UIView *f = [AvatarCollectionView setfooterView]
 //do something on footerview according to desing
 AvatarCollecionView *avatarCollecionView = [... alloc]initwithframe:layout:mode:headerView;footerView:];

 */
