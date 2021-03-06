#import <Kiwi/Kiwi.h>
// Class under test
#import "DTActorExecutor.h"

#import "DTActors.h"

SPEC_BEGIN(DTActorExecutorTest)
describe(@"DTActorExecutor", ^{
    __block DTActorExecutor *sut;
    
    beforeAll(^{
        id actorHandler = [KWMock mockForProtocol:@protocol(DTActorHandler)];
        [actorHandler stub:@selector(handle:) andReturn:[RXPromise new]];
        sut = [DTActorExecutor executorWithActorHandler:actorHandler];
    });
    
    it(@"Should be correctly initialized", ^{
        [[sut.operationQueue shouldNot] beNil];
        [[theValue(sut.operationQueue.maxConcurrentOperationCount) should] equal:theValue(1)];
        [[(NSObject *)sut.actorHandler shouldNot] beNil];
    });
    
    context(@"On handle", ^{
        it(@"Should add operation to operation queue", ^{
            [[theValue(sut.operationQueue.operationCount) should] beZero];
            [sut handle:[NSObject new]];
            [[theValue(sut.operationQueue.operationCount) should] equal:theValue(1)];
        });        
    });
});

SPEC_END
