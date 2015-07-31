//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActorSystem.h"
#import "DTActor.h"
#import "DTActorProvider.h"


@implementation DTMainActorSystem {
    NSMutableDictionary *_actorsProviders;
}

#pragma mark -  DTActorSystem

- (DTActorRef *)actorOfClass:(Class)class {
    id<DTActorHandler> actor = [self getActor:class];
    DTActorRef *actorRef = [[DTActorRef alloc] initWithActor:actor];
    return actorRef;
}

- (void)addActorProvider:(id<DTActorProvider>)actorProvider {
    NSString *key = NSStringFromClass(actorProvider.actorType);
    _actorsProviders[key] = actorProvider;
}

#pragma mark - Private

- (id<DTActorHandler>)getActor:(Class)actorType {
    NSString *key = NSStringFromClass(actorType);
    id<DTActorProvider> actorProvider = _actorsProviders[key];
    return [actorProvider create:self];
}

@end

@implementation DTActorSystemBuilder

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem {
    self = [super init];
    if (self) {
        _actorSystem = actorSystem;
    }

    return self;
}

+ (instancetype)builderWithActorSystem:(id <DTActorSystem>)actorSystem {
    return [[self alloc] initWithActorSystem:actorSystem];
}

- (void)addActor:(Class)actorType {
    [self.actorSystem addActorProvider:[DTSingletonActorProvider providerWithActorType:actorType]];
}

@end