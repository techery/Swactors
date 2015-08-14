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

@class ServiceLocator;

SPEC_BEGIN(ActorSystemTest)

describe(@"DTMainActorSystem", ^{
    __block DTMainActorSystem *actorSystem = nil;
    __block id<Configs> configs = nil;
    __block ServiceLocator *serviceLocator = nil;
    
    beforeAll(^{
        serviceLocator =  [ServiceLocator mock];
        configs = [KWMock mockForProtocol:@protocol(Configs)];
        actorSystem = [[DTMainActorSystem alloc] initWithConfigs:configs serviceLocator:serviceLocator builderBlock:^(DTActorSystemBuilder * builder__nonnull) {
            
        }];
    });
    
    it(@"Should be correctly initialized", ^{
        [[actorSystem shouldNot] beNil];
        [[(NSObject *)actorSystem.configs shouldNot] beNil];
        [[actorSystem.serviceLocator shouldNot] beNil];
    });
    
    it(@"Should return nil if provider wasn't added", ^{
        id actor = [actorSystem actorOfClass:[NSObject class]];
        [[actor should] beNil];
    });    
    
    it(@"Should returt Actor if provider was added", ^{
        id actorProvider = [KWMock mockForProtocol:@protocol(DTActorProvider)];
        Class actorClass = [NSObject class];
        [actorProvider stub:@selector(actorType) andReturn:actorClass];
        [actorProvider stub:@selector(create:) andReturn:[NSObject new]];
        
        [actorSystem addActorProvider:actorProvider];
        
        id actor = [actorSystem actorOfClass:actorClass];
        [[actor shouldNot] beNil];
    });
});

SPEC_END
