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

@class ServiceLocator;

SPEC_BEGIN(ActorSystemTest)

describe(@"DTActorSystem", ^{
    __block DTMainActorSystem *actorSystem = nil;
    __block id<Configs> configs = nil;
    __block ServiceLocator *serviceLocator = nil;
    
    beforeAll(^{
        serviceLocator =  [ServiceLocator mock];
        configs = [KWMock mockForProtocol:@protocol(Configs)];
        actorSystem = [[DTMainActorSystem alloc] initWithConfigs:configs serviceLocator:serviceLocator builderBlock:^(DTActorSystemBuilder * builder__nonnull) {
            
        }];
    });
    
    it(@"should be correctly initialized", ^{
        [[actorSystem shouldNot] beNil];
        [[(NSObject *)actorSystem.configs shouldNot] beNil];
        [[actorSystem.serviceLocator shouldNot] beNil];
    });
});

SPEC_END
