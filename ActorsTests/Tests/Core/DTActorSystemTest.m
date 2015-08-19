//
//  SampleSpec.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "DTActors.h"
#import "Actors-Swift.h"
#import "DTActorProvider.h"
#import "ActorSystemMock.h"
#import "DTSingletonActorProvider.h"
#import "DTInstanceActorProvider.h"

@class ServiceLocator;

@interface DTSingletonTest: DTActor
@end

@implementation DTSingletonTest
@end

@interface DTInstanceTest: DTActor
@end

@implementation DTInstanceTest
@end

SPEC_BEGIN(DTActorSystemTest)

describe(@"DTMainActorSystem", ^{
    __block DTMainActorSystem *actorSystem = nil;
    __block id<Configs> configs = nil;
    __block ServiceLocator *serviceLocator = nil;
    
    Class singleton = [DTSingletonTest class];
    __block DTInstanceTest *instance;
    
    beforeAll(^{
        serviceLocator =  [ServiceLocator mock];
        configs = [KWMock mockForProtocol:@protocol(Configs)];
        actorSystem = [[DTMainActorSystem alloc] initWithConfigs:configs serviceLocator:serviceLocator builderBlock:^(DTActorSystemBuilder * builder) {
            [builder addSingleton:singleton];
            [builder addActor:^DTActor *(id<DTActorSystem> system) {
                instance = [DTInstanceTest actorWithActorSystem:system];
                return instance;
            }];
        }];
    });
    
    it(@"should be correctly initialized", ^{
        [[actorSystem shouldNot] beNil];
        [[(NSObject *)actorSystem.configs shouldNot] beNil];
        [[actorSystem.serviceLocator shouldNot] beNil];
    });
    
    it(@"should return nil if provider wasn't added", ^{
        id actor = [actorSystem actorOfClass:[NSObject class] caller:self];
        [[actor should] beNil];
    });    
    
    it(@"should returt singleton if provider was added", ^{
        id actorRef = [actorSystem actorOfClass:singleton caller:self];
        [[actorRef shouldNot] beNil];
    });
    
    it(@"should return actor instance if provider was added", ^{
        DTActorRef *actorRef = [actorSystem actorOfClass:[instance class] caller:self];
        [[actorRef shouldNot] beNil];
    });
});

SPEC_END

SPEC_BEGIN(DTActorSystemBuilderTest)

describe(@"DTActorSystemBuilder", ^{
    id<DTActorSystem> actorSystem = actorSystemMock();
    DTActorSystemBuilder *sut = [[DTActorSystemBuilder alloc] initWithActorSystem:actorSystem];
    
    it(@"should be correctly initialized", ^{
        [[(id)sut.actorSystem should] equal:actorSystem];
        
        DTActorSystemBuilder *s = [DTActorSystemBuilder builderWithActorSystem:actorSystem];
        [[(id)s.actorSystem should] equal:actorSystem];
    });
    
    it(@"should add singleton provider", ^{
        [[(id)actorSystem should] receive:@selector(addActorProvider:)];
        KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
        [sut addSingleton:[DTActor class]];
        [[spy.argument should] beKindOfClass:[DTSingletonActorProvider class]];
    });
    
    it(@"should add instance provider", ^{
        [[(id)actorSystem should] receive:@selector(addActorProvider:)];
        KWCaptureSpy *spy = [(id)actorSystem captureArgument:@selector(addActorProvider:) atIndex:0];
        [sut addActor:^DTActor *(id<DTActorSystem> system) {
            return [DTActor actorWithActorSystem:system];
        }];
        [[spy.argument should] beKindOfClass:[DTInstanceActorProvider class]];
    });
});

SPEC_END

