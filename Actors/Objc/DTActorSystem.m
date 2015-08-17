//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActorSystem.h"
#import "DTActor.h"
#import "DTActorProvider.h"
#import "Actors-Swift.h"


@interface DTMainActorSystem()
@property (nonatomic, strong) NSMutableDictionary *actorsProviders;
@property (nonatomic, strong) ServiceLocator *serviceLocator;
@end

@implementation DTMainActorSystem

- (instancetype)initWithConfigs:(id <Configs>)configs serviceLocator:(ServiceLocator *)serviceLocator builderBlock:(void (^)(DTActorSystemBuilder *))builderBlock {
    if (self = [super init]) {
        _actorsProviders = [NSMutableDictionary new];
        _serviceLocator = serviceLocator;
        _configs = configs;
        DTActorSystemBuilder *builder = [[DTActorSystemBuilder alloc] initWithActorSystem:self];
        builderBlock(builder);
    }
    
    return self;
}

#pragma mark -  DTActorSystem

- (DTActorRef *)actorOfClass:(Class)class {
    id<DTActorHandler> actor = [self getActor:class];
    if (actor) {
        DTActorRef *actorRef = [[DTActorRef alloc] initWithActor:actor];
        return actorRef;
    } else {
        return nil;
    }
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