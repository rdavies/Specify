//
//  BHVSuite.m
//  Beehive
//
//  Created by Ryan Davies on 11/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVSuite.h"
#import "BHVExample.h"
#import "BHVInvocation.h"

@interface BHVSuite ()
@property (nonatomic, strong) NSMutableArray *examples;
@end

@implementation BHVSuite

+ (id)sharedSuite
{
    static dispatch_once_t pred;
    static BHVSuite *suite = nil;
    dispatch_once(&pred, ^{ suite = [[self alloc] init]; });
    return suite;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.examples = [NSMutableArray array];
    }
    return self;
}

#pragma mark Invoking examples

- (NSArray *)invocations
{
    NSMutableArray *invocations = [NSMutableArray array];
    [[self examples] enumerateObjectsUsingBlock:^(BHVExample *example, NSUInteger idx, BOOL *stop) {
        NSString *encodingType = [NSString stringWithFormat:@"%s%s%s", @encode(void), @encode(id), @encode(SEL)];
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[encodingType UTF8String]];
        BHVInvocation *invocation = (BHVInvocation *)[BHVInvocation invocationWithMethodSignature:methodSignature];
        [invocation setExample:example];
        [invocations addObject:invocation];
    }];
    
    return [NSArray arrayWithArray:invocations];
}

#pragma mark Managing examples

- (void)addExample:(BHVExample *)example
{
    [[self examples] addObject:example];
}

- (void)removeExample:(BHVExample *)example
{
    [[self examples] removeObject:example];
}

#pragma mark Example events

- (void)exampleDidExecute:(BHVExample *)example
{
    [self removeExample:example];
}

@end
