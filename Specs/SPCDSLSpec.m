//
//  SPCDSLTests.m
//  Specify
//
//  Created by Ryan Davies on 15/01/2013.
//  Copyright (c) 2013 Ryan Davies. All rights reserved.
//

// TODO: What we really need here is the ability to mock class methods.

@interface SPCMockSpecification : NSObject
@end

@implementation SPCMockSpecification

+ (SPCBuilder *)builder
{
    static id mock = nil;
    if (mock == nil) mock = [OCMockObject mockForClass:[SPCBuilder class]];
    return mock;
}

@end

#pragma mark -

@interface SPCDSLTests : SenTestCase
@end

@implementation SPCDSLTests

- (void)setUp
{
    [SPCSpecification setCurrentSpecification:[SPCMockSpecification class]];
}

- (void)test_It_CreatesAndAddsExample
{
    void(^implementation)(void) = ^{};
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example label] isEqualToString:@"should work"] && [example block] == implementation;
    }]];
    
    it(@"should work", implementation);
    
    [builder verify];
}

- (void)test_Context_AddsExamplesInBlock
{
    void(^implementation)(void) = ^{
        it(@"should work with contexts", ^{});
    };
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] enterGroup:[OCMArg checkWithBlock:^BOOL(id group) {
        return [[group label] isEqualToString:@"should work"];
    }]];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example label] isEqualToString:@"should work with contexts"];
    }]];
    [[builder expect] leaveGroup];
    
    context(@"should work", implementation);
    
    [builder verify];
}

- (void)test_Describe_AddsExamplesInBlock
{
    void(^implementation)(void) = ^{
        it(@"should work with contexts", ^{});
    };
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] enterGroup:[OCMArg checkWithBlock:^BOOL(id group) {
        return [[group label] isEqualToString:@"should work"];
    }]];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example label] isEqualToString:@"should work with contexts"];
    }]];
    [[builder expect] leaveGroup];
    
    describe(@"should work", implementation);
    
    [builder verify];
}

- (void)test_When_AddsExamplesInBlock
{
    void(^implementation)(void) = ^{
        it(@"should work with contexts", ^{});
    };
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] enterGroup:[OCMArg checkWithBlock:^BOOL(id group) {
        return [[group label] isEqualToString:@"when not dead"];
    }]];
    [[builder expect] addExample:[OCMArg checkWithBlock:^BOOL(id example) {
        return [[example label] isEqualToString:@"should work with contexts"];
    }]];
    [[builder expect] leaveGroup];
    
    when(@"not dead", implementation);
    
    [builder verify];
}

- (void)test_BeforeEach_AddsBeforeEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    beforeEach(implementation);
    
    [builder verify];
}

- (void)test_Before_AddsBeforeEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    before(implementation);
    
    [builder verify];
}

- (void)test_AfterEach_AddsAfterEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    afterEach(implementation);
    
    [builder verify];
}

- (void)test_After_AddsBeforeEachHook
{
    void(^implementation)(void) = ^{};
    
    id builder = [SPCMockSpecification builder];
    [[builder expect] addHook:[OCMArg checkWithBlock:^BOOL(id hook) {
        return [hook block] == implementation;
    }]];
    
    after(implementation);
    
    [builder verify];
}

@end