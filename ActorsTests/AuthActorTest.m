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
        actorSystem = [DTMainActorSystem mock];
        
        [actorSystem stub:@selector(configs) andReturn:[KWMock mockForProtocol:@protocol(Configs)]];
        [actorSystem stub:@selector(serviceLocator) andReturn:[ServiceLocator mock]];
        
        [actorSystem stub:@selector(actorOfClass:) andReturn:sessionActor withArguments:[SessionActor class]];
        [actorSystem stub:@selector(actorOfClass:) andReturn:settingsActor withArguments:[SettingsActor class]];
        
        authActor = [[DTActorRef alloc] initWithActor:[[DTAuthActor alloc] initWithActorSystem:actorSystem]];
    });
    
    it(@"Should not be nil", ^{
        [[authActor shouldNot] beNil];
    });
    
    context(@"On Login message", ^{
        __block Login *login = nil;
//        __block id result = nil;
        
        beforeEach(^{
            [sessionActor stub:@selector(ask:) andReturn:[RXPromise new]];
            [settingsActor stub:@selector(ask:) andReturn:[RXPromise new]];
            login = [[Login alloc] initWithEmail:@"some" password:@""];
        });
        
        it(@"Session should receive Login message", ^{
            [[sessionActor shouldEventually] receive:@selector(ask:) withArguments:login];
            [authActor ask:login];
        });

        it(@"Settings should receive GetSettings message", ^{
            [[settingsActor shouldEventually] receive:@selector(ask:)];
            [authActor ask:login];
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