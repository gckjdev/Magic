//
//  PhoneRegisterView.h
//  BarrageClient
//
//  Created by Teemo on 15/3/17.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LoginView.h"
#import "UILineLabel.h"

typedef void (^LabelActionBlock) ();


@interface PhoneRegisterView : UIView
@property (nonatomic,strong)UITextField *verifyCodeField;
@property (nonatomic,strong)UILineLabel *lineLabel;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)LabelActionBlock labelActoinBlock;
-(instancetype)initWithVerify:(NSString *)verifyPlaceholder
                       button:(NSString *)buttonTitle
                   controller:(id)controller
                 buttonAction:(SEL)buttonAction;

@end
