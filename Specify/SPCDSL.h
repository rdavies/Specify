// The MIT License
// 
// Copyright (c) 2013 Ryan Davies
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Inline/Inline.h>

#define SpecBegin(class) \
@interface class##Spec : INLSenTestCase \
@end \
@implementation class##Spec \
- (NSArray *)tests \
{ \
    SPCDSL *dsl = [SPCDSLFactory createDSL]; \
    __attribute__((__unused__)) void(^it)(NSString *, INLVoidBlock) = [dsl it]; \
    __attribute__((__unused__)) void(^context)(NSString *, INLVoidBlock) = [dsl context]; \
    __attribute__((__unused__)) void(^describe)(NSString *, INLVoidBlock) = context; \
    __attribute__((__unused__)) void(^when)(NSString *, INLVoidBlock) = [dsl when]; \
    __attribute__((__unused__)) void(^before)(INLVoidBlock) = [dsl before]; \
    __attribute__((__unused__)) void(^after)(INLVoidBlock) = [dsl after]; \
    __attribute__((__unused__)) void(^beforeEach)(INLVoidBlock) = before; \
    __attribute__((__unused__)) void(^afterEach)(INLVoidBlock) = after; \
    context(@"", ^{ \

#define SpecEnd \
    }); \
    return [dsl tests]; \
} \
@end

#define PENDING nil _Pragma("message(\"Pending\")")

@interface SPCDSL : NSObject

- (id)initWithTests:(NSMutableArray *)tests nameStack:(NSMutableArray *)nameStack contextStack:(NSMutableArray *)contextStack contextDelegatesStack:(NSMutableArray *)contextDelegatesStack;

- (NSMutableArray *)tests;

- (void(^)(NSString *, INLVoidBlock))it;
- (void(^)(NSString *, INLVoidBlock))context;
- (void(^)(NSString *, INLVoidBlock))when;
- (void(^)(INLVoidBlock))before;
- (void(^)(INLVoidBlock))after;

@end

@interface SPCDSLFactory : NSObject

+ (id)createDSL;

@end
