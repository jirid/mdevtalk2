//
//  NSArray+Swizzling.m
//  ObjCRuntime
//
//  Created by Jiri Dutkevic on 14/03/16.
//  Copyright © 2016 Jiri Dutkevic. All rights reserved.
//

#import "NSArray+Swizzling.h"

@implementation NSArray(Swizzling)

- (NSUInteger)myCount
{
    return [self myCount] + 1;
}

@end
