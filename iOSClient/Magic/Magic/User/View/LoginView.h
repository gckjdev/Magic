//
//  LoginView.h
//  BarrageClient
//
//  Created by gckj on 15/1/28.
//  Copyright (c) 2015年 PIPICHENG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic,strong)UITextField *accountTextField;
@property (nonatomic,strong)UITextField *passwordTextField;
@property (nonatomic,strong)UIButton *button;

-(instancetype)initWithAccount:(NSString*)accountPlaceholder
                      password:(NSString*)passwordPlaceholder
                        button:(NSString*)buttonTitle
                    controller:(id)controller
                  buttonAction:(SEL)action;
@end
