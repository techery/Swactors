
//
//  SettingsActorTest.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/11/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "DTActors.h"
#import "Actors-Swift.h"
#import "ActorSystemMock.h"
#import "DTPromiseMatcher.h"

SPEC_BEGIN(DTSessionActorTest)
    registerMatchers(@"DT");

    describe(@"DTSessionActor", ^{
        __block DTActorRef *sessionActor = nil;
        __block DTActorRef *sessionApiActor = [DTActorRef mock];
        __block DTActorRef *mappingActor = [DTActorRef mock];
        __block DTSessionStorage *sessionStorage = [DTSessionStorage new];
        __block DTMainActorSystem *actorSystem = nil;
        
        beforeAll(^{
            actorSystem = actorSystemMock();
            [actorSystem stub:@selector(actorOfClass:) andReturn:sessionApiActor withArguments:[SessionAPIActor class]];
            [actorSystem stub:@selector(actorOfClass:) andReturn:mappingActor withArguments:[MappingActor class]];
            
            [actorSystem stub:@selector(serviceLocator) andReturn:[[ServiceLocator alloc] initWithBuilder:^(ServiceLocator *locator) {
                [locator registerService:sessionStorage forClass:[DTSessionStorage class]];
            }]];
            
            sessionActor = [[DTActorRef alloc] initWithActor:[[DTSessionActor alloc] initWithActorSystem:actorSystem]];
        });
        
        context(@"On Logout message", ^{
            it(@"Should clear session storage", ^{
                DTLogout *logout = [DTLogout new];
                [[sessionStorage shouldEventually] receive:@selector(clear)];
                [sessionActor ask:logout];
            });
        });
        
        context(@"On Login message", ^{
            __block Login *login = [[Login alloc] initWithEmail:@"some" password:@""];
            __block RXPromise *failedPromise = [RXPromise new];
            
            beforeAll(^{
                [failedPromise rejectWithReason:@"reason"];
            });
            
            beforeEach(^{
                [sessionApiActor stub:@selector(ask:) andReturn:[RXPromise new]];
                [mappingActor stub:@selector(ask:) andReturn:[RXPromise new]];
            });
            
            it(@"Session API Actor should receive message", ^{
                [[sessionApiActor shouldEventually] receive:@selector(ask:)];
                [sessionActor ask:login];
            });
            
            context(@"Session API Actor succeeded", ^{
                beforeEach(^{
                    RXPromise *sessionAPI = [RXPromise new];
                    [sessionAPI resolveWithResult:@"some"];
                    [sessionApiActor stub:@selector(ask:) andReturn:sessionAPI];
                });
                
                it(@"Mapping Actor should receive message", ^{
                    [[mappingActor shouldEventually] receive:@selector(ask:)];
                    [sessionActor ask:login];
                });
                
                context(@"Mapping Actor succeeded", ^{
                    __block Session *session = [Session new];

                    beforeEach(^{
                        RXPromise *mapping = [RXPromise new];
                        [mapping resolveWithResult:session];
                        [mappingActor stub:@selector(ask:) andReturn:mapping];
                    });

                    it(@"Session storage should contain mapped result", ^{
                        [sessionActor ask:login];
                        
                        [[sessionStorage.session shouldEventually] equal:session];
                    });
                    
                    it(@"Should receive success result", ^{
                        RXPromise *result = [sessionActor ask:login];
                        [result wait];
                        [[theValue(result.isFulfilled) should] beTrue];
                    });

                    it(@"Result should contain mapped session", ^{
                        RXPromise *result = [sessionActor ask:login];
                        id r = [result get];
                        [[r should] equal:session];
                    });
                });
                
                context(@"Mapping Actor failed", ^{
                    it(@"Should receive failed result", ^{
                        [mappingActor stub:@selector(ask:) andReturn:failedPromise];
                        RXPromise *result = [sessionActor ask:login];
                        [result wait];
                        [[result should] beRejected];
                    });

                });
            });

            context(@"Session API Actor failed", ^{
                it(@"Should receive failed result", ^{
                    [sessionApiActor stub:@selector(ask:) andReturn:failedPromise];
                    RXPromise *result = [sessionActor ask:login];
                    [result wait];
                    [[result should] beRejected];
                });
            });
        });
    });

SPEC_END