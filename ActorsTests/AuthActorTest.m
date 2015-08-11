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
        
        authActor = [[DTActorRef alloc] initWithActor:[[AuthActor alloc] initWithActorSystem:actorSystem]];
    });
    
    it(@"Should not be nil", ^{
        [[authActor shouldNot] beNil];
    });
    
    context(@"On Login message", ^{
        __block Login *login = nil;
        __block RXPromise *successPromise = [RXPromise new];
        __block RXPromise *failedPromise = [RXPromise new];
        
        beforeAll(^{
            [successPromise resolveWithResult:nil];
            [failedPromise rejectWithReason:@"reason"];
        });
        
        beforeEach(^{
            [sessionActor stub:@selector(ask:) andReturn:successPromise];
            [settingsActor stub:@selector(ask:) andReturn:successPromise];
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
        
        context(@"If all actors succeeded", ^{
            it(@"Should receive success result", ^{
                RXPromise *result = [authActor ask:login];
                [result wait];
                [[theValue(result.isFulfilled) should] beTrue];
            });
            
            it(@"Result should contain results from both actors", ^{
                id sessionResult = [NSObject new];
                id settingsResult = [NSObject new];
                
                RXPromise *session = [RXPromise new];
                [session resolveWithResult:sessionResult];
                RXPromise *settings = [RXPromise new];
                [settings resolveWithResult:settingsResult];
                
                [sessionActor stub:@selector(ask:) andReturn:session];
                [settingsActor stub:@selector(ask:) andReturn:settings];
                
                RXPromise *auth = [authActor ask:login];
                NSArray *authResult = (NSArray *)[auth get];
                [[[authResult firstObject] should] equal:sessionResult];
                [[[authResult lastObject] should] equal:settingsResult];
            });
        });
        
        context(@"If Session actor fails", ^{
            it(@"Should receive failed result", ^{
                [sessionActor stub:@selector(ask:) andReturn:failedPromise];
                RXPromise *result = [authActor ask:login];
                [result wait];
                [[theValue(result.isRejected) should] beTrue];
            });
        });
        
        context(@"If Settings actor fails", ^{
            it(@"Should receive failed result", ^{
                [settingsActor stub:@selector(ask:) andReturn:failedPromise];
                RXPromise *result = [authActor ask:login];
                [result wait];
                [[theValue(result.isRejected) should] beTrue];
            });
        });
    });
});

SPEC_END