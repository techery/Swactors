#import <Kiwi/Kiwi.h>
// Class under test
#import "DTServiceLocator.h"

@protocol DTServiceLocatorTestProtocol
@end

SPEC_BEGIN(DTServiceLocatorTests)
describe(@"DTServiceLocator", ^{
    __block id classService;
    __block id<DTServiceLocatorTestProtocol> protocolService;
    __block DTServiceLocator *sut;

    beforeAll(^{
        classService = any();
        protocolService = any();
        sut = [[DTServiceLocator alloc] initWithBuilderBlock:^(DTServiceLocator *locator) {
            [locator registerService:classService forClass:[classService class]];
            [locator registerService:protocolService forProtocol:@protocol(DTServiceLocatorTestProtocol)];
        }];
    });
    
    it(@"should return service for class if registered", ^{
        id service = [sut serviceForClass:[classService class]];
        [[service shouldNot] beNil];
        [[service should] beKindOfClass:[classService class]];
    });
    
    it(@"should return nil if no registered class", ^{
        id service = [sut serviceForClass:[NSObject class]];
        [[service should] beNil];
    });
    
    it(@"should return service for protocol if registered", ^{
        id service = [sut serviceForProtocol:@protocol(DTServiceLocatorTestProtocol)];
        [[service shouldNot] beNil];
    });
    
    it(@"should return nil if no registered service for protocol", ^{
        id service = [sut serviceForProtocol:@protocol(NSObject)];
        [[service should] beNil];
    });
    
});
SPEC_END
