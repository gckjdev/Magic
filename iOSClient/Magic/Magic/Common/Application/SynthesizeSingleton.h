//
//  SynthesizeSingleton.h
//  BarrageClient
//
//  Created by pipi on 14/12/8.
//  Copyright (c) 2014年 PIPICHENG. All rights reserved.
//

//
// SynthesizeSingleton.h
// Copyright 2009 Matt Gallagher. All rights reserved.
//
// Modified by Oliver Jones and Byron Salau
//
// Permission is given to use this source code file without charge in any
// project, commercial or otherwise, entirely at your risk, with the condition
// that any redistribution (in part or whole) of source code must retain
// this copyright and permission notice. Attribution in compiled projects is
// appreciated but not required.

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)

#define DEF_SINGLETON_FOR_CLASS(UserService)\
+ (id) sharedInstance;

#define IMPL_SINGLETON_FOR_CLASS(classname)\
+ (id) sharedInstance {\
static dispatch_once_t pred = 0;\
__strong static id _sharedObject = nil;\
dispatch_once(&pred, ^{\
_sharedObject = [[self alloc] init];\
});\
return _sharedObject;\
}

#endif