//
//  BHVHookTests.m
//  Beehive
//
//  Created by Ryan Davies on 29/11/2012.
//  Copyright (c) 2012 Ryan Davies. All rights reserved.
//

#import "BHVHook.h"
#import "BHVContext.h"
#import "BHVExample.h"

@interface PSTBeMatcher ()
- (BOOL)beExecuted;
@end

@interface BHVHookTests : SenTestCase
@end

@implementation BHVHookTests

- (void)test_Execution_InvokesBlock
{
    __block BOOL invoked = NO;
    BHVHook *hook = [[BHVHook alloc] init];
    [hook setBlock:^{ invoked = YES; }];
    [hook execute];
    [[@(invoked) should] beTrue];
}

- (void)test_Execution_MarksAsExecuted
{
    BHVHook *hook = [[BHVHook alloc] init];
    [[hook shouldNot] beExecuted];
    [hook execute];
    [[hook should] beExecuted];
}

#pragma mark BeforeEach

- (void)test_Before_Each_ExecutesIfExampleHasNotBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyEach];
    BHVExample *example = [[BHVExample alloc] init];
    [hook setExample:example];
    [hook execute];
    [[hook should] beExecuted];
}

- (void)test_Before_Each_ExecutesIfExampleIsBelowHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    examplesByAddingToContext(contexts[1], 10, NO);
    NSArray *deepestExamples = examplesByAddingToContext(contexts[2], 10,NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyEach];
    [contexts[1] addNode:hook];
    
    // Set example to any in the deepest context and execute hook:
    [hook setExample:deepestExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_Before_Each_ExecutesIfExampleIsAtSameLevelAsHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyEach];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_Before_Each_DoesNotExecuteIfExampleHasBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyEach];
    BHVExample *example = [[BHVExample alloc] init];
    [example setExecuted:YES];
    [hook setExample:example];
    [hook execute];
    [[hook shouldNot] beExecuted];
}

- (void)test_Before_Each_DoesNotExecuteIfExampleIsAboveHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the deepest context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyEach];
    [contexts[2] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook was not executed:
    [[hook shouldNot] beExecuted];
}

#pragma mark AfterEach

- (void)test_After_Each_ExecutesIfExampleHasBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyEach];
    BHVExample *example = [[BHVExample alloc] init];
    [example setExecuted:YES];
    [hook setExample:example];
    [hook execute];
    [[hook should] beExecuted];
}

- (void)test_After_Each_ExecutesIfExampleIsBelowHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    examplesByAddingToContext(contexts[1], 10, YES);
    NSArray *deepestExamples = examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyEach];
    [contexts[1] addNode:hook];
    
    // Set example to any in the deepest context and execute hook:
    [hook setExample:deepestExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_After_Each_ExecutesIfExampleIsAtSameLevelAsHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyEach];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_After_Each_DoesNotExecuteIfExampleHasNotBeenExecuted
{
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyEach];
    BHVExample *example = [[BHVExample alloc] init];
    [hook setExample:example];
    [hook execute];
    [[hook shouldNot] beExecuted];
}

- (void)test_After_Each_DoesNotExecuteIfExampleIsAboveHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the deepest context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyEach];
    [contexts[2] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook was not executed:
    [[hook shouldNot] beExecuted];
}

#pragma mark BeforeAll

- (void)test_Before_All_ExecutesIfNoExamplesInContextOrNestedContextsHaveBeenExecuted
{
    // Create a stack of contexts with examples in each, with only those at the top level marked as executed:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_Before_All_ExecutesIfExampleIsBelowHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    examplesByAddingToContext(contexts[1], 10, NO);
    NSArray *deepestExamples = examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the deepest context and execute hook:
    [hook setExample:deepestExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_Before_All_ExecutesIfExampleIsAtSameLevelAsHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_Before_All_DoesNotExecuteIfAnyExamplesInContextHaveBeenExecuted
{
    // Create a stack of contexts with examples in each, with the top two levels marked as executed:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook did not execute:
    [[hook shouldNot] beExecuted];
}

- (void)test_Before_All_DoesNotExecuteIfAnyExamplesInNestedContextsHaveBeenExecuted
{
    // Create a stack of contexts with examples in each, with the bottommost marked as executed:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook did not execute:
    [[hook shouldNot] beExecuted];
}

- (void)test_Before_All_DoesNotExecuteIfExampleIsAboveHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the deepest context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionBefore frequency:BHVHookFrequencyAll];
    [contexts[2] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook was not executed:
    [[hook shouldNot] beExecuted];
}

#pragma mark AfterAll

- (void)test_After_All_ExecutesIfAllExamplesInContextAndNestedContextsHaveBeenExecuted
{
    // Create a stack of contexts with examples in each, with the bottom two marked as executed:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, YES);
        
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the deepest context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_After_All_ExecutesIfExampleIsBelowHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    examplesByAddingToContext(contexts[1], 10, YES);
    NSArray *deepestExamples = examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the deepest context and execute hook:
    [hook setExample:deepestExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_After_All_ExecutesIfExampleIsAtSameLevelAsHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook executed:
    [[hook should] beExecuted];
}

- (void)test_After_All_DoesNotExecuteIfAnyExampleInContextHasNotBeenExecuted
{
    // Create a stack of contexts with examples in each, with the hook context examples marked as executed:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, NO);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook was not executed:
    [[hook shouldNot] beExecuted];
}

- (void)test_After_All_DoesNotExecuteIfAnyExampleInNestedContextsHasNotBeenExecuted
{
    // Create a stack of contexts with examples in each, with the bottommost marked as executed:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, NO);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, NO);
    examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the middle context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll];
    [contexts[1] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook was not executed:
    [[hook shouldNot] beExecuted];
}

- (void)test_After_All_DoesNotExecuteIfExampleIsAboveHookInStack
{
    // Create a stack of contexts with examples in each:
    NSArray *contexts = stackOfContexts(3);
    examplesByAddingToContext(contexts[0], 10, YES);
    NSArray *middleExamples = examplesByAddingToContext(contexts[1], 10, YES);
    examplesByAddingToContext(contexts[2], 10, YES);
    
    // Put a hook in the deepest context:
    BHVHook *hook = [[BHVHook alloc] initWithPosition:BHVHookPositionAfter frequency:BHVHookFrequencyAll];
    [contexts[2] addNode:hook];
    
    // Set example to any in the middle context and execute hook:
    [hook setExample:middleExamples[0]];
    [hook execute];
    
    // Verify that the hook was not executed:
    [[hook shouldNot] beExecuted];
}

@end
