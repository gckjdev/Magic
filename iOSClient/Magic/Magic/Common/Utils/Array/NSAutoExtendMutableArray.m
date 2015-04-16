//
//  NSAutoExtendMutableArray.m
//  WhereTimeGoes
//
//  Created by qqn_pipi on 09-10-24.
//  Copyright 2009 QQN-PIPI.com. All rights reserved.
//

#import "NSAutoExtendMutableArray.h"


@implementation NSAutoExtendMutableArray

@synthesize array;
@synthesize extendLength;
@synthesize isExtend;

+ (id)arrayWithArrayAndExtendLength:(NSArray *)array length:(int)length
{
	NSAutoExtendMutableArray* arr = [[NSAutoExtendMutableArray alloc] initWithExtendLength:length];
	
	if (arr){		
		[arr.array addObjectsFromArray:array];		
		[arr extend];
	}
	
	return arr;
}

- (id)initWithExtendLength:(int)length
{
	if (self = [super init]){
		array = [[NSMutableArray alloc] initWithCapacity:kAutoExtendArrayDefaultCapacity];
		extendLength = length;
		isExtend = NO;
	}
	return self;
}

// extend object by extendLength
- (void)extend
{
	if (isExtend == YES)
		return;
	
	for (int i=0; i<extendLength; i++)
		[self.array addObject:@""];
	
	isExtend = YES;
}

- (NSUInteger)validCount
{
	if (isExtend == YES)
		return [self.array count] - self.extendLength;
	else
		return [self.array count];
}

- (NSUInteger)count
{
	return [self.array count];
}

- (id)objectAtIndex:(int)index
{
	return [self.array objectAtIndex:index];
}

@end
