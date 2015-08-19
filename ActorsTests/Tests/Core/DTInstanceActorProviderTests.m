#import <Kiwi/Kiwi.h>
// Class under test
#import "DTInstanceActorProvider.h"

#import "DTActor.h"

SPEC_BEGIN(DTInstanceActorProviderTests)
describe(@"DTInstanceActorProvider", ^{
    DTActor *instance = [DTActor mock];
    DTInstanceActorProvider *sut = [DTInstanceActorProvider providerWithInstance:instance];
    
    it(@"should correctly create handler", ^{
        id actor = [sut create:any()];
        [[actor should] equal:instance];
    });
    
    it(@"should return correct actor type", ^{
        [[(id)[sut actorType] should] equal:[instance class]];
    });
});
SPEC_END
