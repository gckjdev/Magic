//
//  NSAutoExtendMutableArray.h
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-24.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAutoExtendArrayDefaultCapacity 20

@interface NSAutoExtendMutableArray : NSObject {
	
	NSMutableArray* array;
	
	int extendLength;	
	BOOL isExtend;
}

+ (id)arrayWithArrayAndExtendLength:(NSArray *)array length:(int)length;

- (id)initWithExtendLength:(int)length;

- (void)extend;

- (NSUInteger)validCount;
- (NSUInteger)count;
- (id)objectAtIndex:(int)index;

@property (nonatomic) int extendLength;
@property (nonatomic) BOOL isExtend;
@property (nonatomic, retain) NSMutableArray* array;

@end