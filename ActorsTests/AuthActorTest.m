//
//  AuthActorTest.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "Actors-Swift.h"
#import "DTActorSystem.h"
#import "DTAuthActor.h"

SPEC_BEGIN(AuthActorTest)

describe(@"AuthActor", ^{
    __block DTActorRef *authActor = nil;
    __block DTActorRef *sessionActor = [DTActorRef mock];
    __block DTActorRef *settingsActor = [DTActorRef mock];
    __block DTMainActorSystem *actorSystem = nil;
    
    beforeAll(^{
        actorSystem = [[DTMainActorSystem alloc] initWithConfigs:[KWMock mockForProtocol:@protocol(Configs)]
                                                     serviceLocator:[ServiceLocator mock]
                                                       builderBlock:^(DTActorSystemBuilder * builder) {
            [builder addActor:[DTAuthActor class]];
        }];
        
        [actorSystem stub:@selector(actorOfClass:) andReturn:sessionActor withArguments:[SessionActor class]];
        [actorSystem stub:@selector(actorOfClass:) andReturn:settingsActor withArguments:[SettingsActor class]];
        authActor = [actorSystem actorOfClass:[DTAuthActor class]];    
    });
    
    it(@"Should not be nil", ^{
        [[authActor shouldNot] beNil];
    });
    
    context(@"On Login message", ^{
        __block Login *login = nil;
        
        beforeEach(^{
            [sessionActor stub:@selector(ask:) andReturn:[RXPromise new]];
            [settingsActor stub:@selector(ask:) andReturn:[RXPromise new]];
            login = [[Login alloc] initWithEmail:@"some" password:@""];
            [authActor ask:login];
        });
        
        it(@"Session should receive Login message", ^{
            [[sessionActor shouldEventuallyBeforeTimingOutAfter(1)] receive:@selector(ask:) withArguments:login];
        });

        it(@"Settings should receive GetSettings message", ^{
            [[settingsActor shouldEventuallyBeforeTimingOutAfter(1)] receive:@selector(ask:) withArguments:[GetSettings new]];
        });
        
        
//        context(@"If Session Actor fails", ^{
//            it(@"Should receive failed result", ^{
//                RXPromise *failedPromise = [RXPromise new];
//                [failedPromise rejectWithReason:nil];
//                [sessionActor stub:@selector(ask:) andReturn:failedPromise];
//                
//                [[result shouldNotEventually] receive:@selector(resolveWithResult:)];
//            });
//        });
    });
});

SPEC_END