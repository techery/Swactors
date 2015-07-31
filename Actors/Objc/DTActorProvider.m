//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActorProvider.h"
#import "DTActor.h"


@interface DTSingletonActorProvider ()
@property (nonatomic, readwrite) DTActor *actor;
@end

@implementation DTSingletonActorProvider

- (instancetype)initWithActorType:(Class)actorType {
    if (self = [super init]) {
        _actorType = actorType;
    }

    return self;
}

+ (instancetype)providerWithActorType:(Class)actorType {
    return [[self alloc] initWithActorType:actorType];
}

#pragma mark - DTActorProvider

- (DTActor *)create:(id <DTActorSystem>)actorSystem {
    if (!self.actor) {
        self.actor = [self.actorType actorWithActorSystem:actorSystem];
    }

    return self.actor;
}

@end