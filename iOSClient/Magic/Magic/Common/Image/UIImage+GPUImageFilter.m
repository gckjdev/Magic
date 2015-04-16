//
//  UIImage+GPUImageFilter.m
//  Draw
//
//  Created by 王 小涛 on 13-11-29.
//
//

#import "UIImage+GPUImageFilter.h"

@implementation UIImage (GPUImageFilter)

- (UIImage *)imageByFilteringFromFilterClassString:(NSString *)filterClassString
                                         paramters:(NSDictionary *)paramters{

    id filter = nil;
    Class filterClass = NSClassFromString(filterClassString);
    
    if (filterClass != Nil) {
        filter = [[filterClass alloc] init];
    }
    
    if (filter != nil) {
        
        [paramters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            
            NSString *paraKey = key;
            id paraVal = obj;
            [filter setValue:paraVal forKey:paraKey];
            
        }];
        
        if ([filter respondsToSelector:@selector(imageByFilteringImage:)]) {
            return [filter performSelector:@selector(imageByFilteringImage:) withObject:self];
        }
    }

    return self;
}
@end
