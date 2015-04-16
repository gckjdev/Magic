//
//  UIImage+GPUImageFilter.h
//  Draw
//
//  Created by 王 小涛 on 13-11-29.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (GPUImageFilter)

- (UIImage *)imageByFilteringFromFilterClassString:(NSString *)filterClassString
                                         paramters:(NSDictionary *)paramters;

@end
