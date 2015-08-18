#import <Kiwi/Kiwi.h>
// Class under test
#import "DTActorOperation.h"

#import "DTActor.h"
#import "DTPromiseMatcher.h"

SPEC_BEGIN(DTActorOperationTest)
registerMatchers(@"DT");

describe(@"DTActorOperation", ^{
    id handler = [KWMock mockForProtocol:@protocol(DTActorHandler)];
    id message = any();
    __block DTActorOperation *sut;
    
    beforeEach(^{
        sut = [[DTActorOperation alloc] initWithInvocation:message handler:handler];
    });
    
    it(@"should be correctly initialized", ^{
        [sut.promise shouldNotBeNil];
    });
    
    context(@"start", ^{
        it(@"should send message to handler", ^{
            RXPromise *failedPromise = [RXPromise new];
            [failedPromise rejectWithReason:nil];
            [failedPromise wait];

            [[handler should] receive:@selector(handle:) andReturn:failedPromise withArguments:message];
            [sut start];
        });
        
        it(@"shouldn't send message to handler if already started", ^{
            [sut start];
            [[handler shouldNot] receive:@selector(handle:) withArguments:message];
            [sut start];
        });        
        
        context(@"if handler fails", ^{
            it(@"should return failed result", ^{
                [sut start];
                [[sut.promise shouldEventually] beRejected];
            });
            
            
            // TODO: this test sometimes fails. need to figure out why
            it(@"should finish", ^{
                [sut start];
                [[theValue(sut.finished) shouldEventually] beTrue];
            });
        });
        
        context(@"if handler succeeded", ^{
            RXPromise *successPromise = [RXPromise new];
            id result = any();
            
            beforeAll(^{
                [successPromise resolveWithResult:result];
                [handler stub:@selector(handle:) andReturn:successPromise withArguments:message];
            });
            
            it(@"should return success result", ^{
                [sut start];
                [[sut.promise shouldEventually] beFulfilled];
                [[sut.promise.get shouldEventually] equal:result];
            });
            
            it(@"should finish", ^{
                [sut start];
                [[theValue(sut.finished) shouldEventually] beTrue];
            });
            
        });
    });
});
SPEC_END
