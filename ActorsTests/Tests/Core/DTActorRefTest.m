#import <Kiwi/Kiwi.h>
// Class under test
#import "DTActor.h"
#import "ActorSystemMock.h"

SPEC_BEGIN(DTActorRefTest)
describe(@"DTActorRef", ^{
    id<DTActorHandler> actor = [KWMock mockForProtocol:@protocol(DTActorHandler)];
    DTActorRef *sut = [[DTActorRef alloc] initWithActor:actor caller:self];

    it(@"should be correctly initialized", ^{
        [(id)sut.actor shouldNotBeNil];
    });
    
    it(@"on ask: should redirect message to actor", ^{
        id message = any();
        [[(id) actor should] receive:@selector(handle:) withArguments:message];
        [sut ask:message];
    });
    
    it(@"on tell: should redirect message to actor", ^{
        id message = any();
        [[(id) actor should] receive:@selector(handle:) withArguments:message];
        [sut tell:message];
    });
});
SPEC_END
