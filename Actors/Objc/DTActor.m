//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActor.h"
#import "DTMessageDispatcher.h"
#import "DTActorSystem.h"


@interface DTActor ()
@property(nonatomic, strong) DTMessageDispatcher *dispatcher;
@end

@implementation DTActor

#pragma mark - Initialization

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem {
    self = [super init];
    if (self) {
        _actorSystem = actorSystem;
        _dispatcher = [DTMessageDispatcher new];
        _serviceLocator = actorSystem.serviceLocator;
        _configs = actorSystem.configs;
        [self setup];
    }

    return self;
}

+ (instancetype)actorWithActorSystem:(id<DTActorSystem>)actorSystem {
    return [[self alloc] initWithActorSystem:actorSystem];
}

#pragma mark - Public

- (void)setup {
    
}

- (void)on:(Class)messageType _do:(void (^)(id))handler {
    [self.dispatcher on:messageType do:handler];
}

- (void)on:(Class)messageType doFuture:(DTFutureMessageBlock)handler {
    [self.dispatcher on:messageType doFuture:handler];
}

- (void)on:(Class)messageType doResult:(DTResultMessageBlock)handler {
    [self.dispatcher on:messageType doResult:handler];
}

#pragma mark - DTActorHandler

- (RXPromise *)handle:(id)message {
    return [self.dispatcher handle:message];
}

@end


@interface DTActorRef()
@property (nonatomic, strong) id<DTActorHandler> actor;
@property (nonatomic, weak, nullable) id caller;
@end

@implementation DTActorRef

- (instancetype)initWithActor:(id<DTActorHandler>)actor caller:(nullable id)caller {
    if (self = [super init]) {
        _actor = actor;
        _caller = caller;
    }

    return self;
}

- (instancetype)initWithActor:(id<DTActorHandler>)actor {
    return [self initWithActor:actor caller:nil];
}


- (RXPromise *)ask:(id)message {
    return [self.actor handle:message];
}

- (void)tell:(id)message {
    [self.actor handle:message];
}

@end