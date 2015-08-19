#import <Kiwi/Kiwi.h>
// Class under test
#import "DTActorOperation.h"

#import "DTActor.h"
#import "DTPromiseMatcher.h"
#import "ActorSystemMock.h"

SPEC_BEGIN(DTActorOperationTest)
registerMatchers(@"DT");

describe(@"DTActorOperation", ^{
    __block id handler;
    __block DTInvocation *invocation;
    __block DTActorOperation *sut;
    
    beforeEach(^{
        invocation = [DTInvocation invocationWithMessage:[NSObject new] caller:self];
        handler = [KWMock mockForProtocol:@protocol(DTActorHandler)];
        RXPromise *failedPromise = [RXPromise new];
        [failedPromise rejectWithReason:nil];
        [failedPromise wait];
        [handler stub:@selector(handle:) andReturn:failedPromise withArguments:invocation];
        sut = [[DTActorOperation alloc] initWithInvocation:invocation handler:handler];
    });
    
    it(@"should be correctly initialized", ^{
        [[sut.promise shouldNot] beNil];
    });
    
    context(@"on start", ^{
        it(@"should send message to handler", ^{
            [[handler should] receive:@selector(handle:) withArguments:invocation];
            [sut start];
        });
        
        it(@"shouldn't send message to handler if already started", ^{
            [sut start];
            [[handler shouldNot] receive:@selector(handle:) withArguments:invocation];
            [sut start];
        });        
        
        context(@"if handler fails", ^{
            it(@"should return failed result", ^{
                [sut start];
                [[sut.promise shouldEventually] beRejected];
            });
            
            it(@"should finish", ^{
                [sut start];
                [[sut shouldEventually] receive:@selector(finish)];
            });
        });
        
        context(@"if handler succeeded", ^{
            RXPromise *successPromise = [RXPromise new];
            id result = any();
            
            beforeAll(^{
                [successPromise resolveWithResult:result];
                [handler stub:@selector(handle:) andReturn:successPromise withArguments:invocation];
            });
            
            it(@"should return success result", ^{
                [sut start];
                [[sut.promise shouldEventually] beFulfilled];
                [[sut.promise.get shouldEventually] equal:result];
            });
            
            it(@"should finish", ^{
                [sut start];
                [[sut shouldEventually] receive:@selector(finish)];
            });
            
        });
    });
});
SPEC_END
