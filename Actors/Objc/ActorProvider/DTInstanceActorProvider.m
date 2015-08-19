//
// Created by Anastasiya Gorban on 8/19/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTInstanceActorProvider.h"
#import "DTActor.h"


@interface DTInstanceActorProvider ()
@property(nonatomic, strong) DTActor *instance;
@end

@implementation DTInstanceActorProvider

- (instancetype)initWithInstance:(DTActor *)instance {
    self = [super init];
    if (self) {
        self.instance = instance;
    }

    return self;
}

+ (instancetype)providerWithInstance:(DTActor *)instance {
    return [[self alloc] initWithInstance:instance];
}

#pragma mark - DTActorProvider

- (Class <DTSystemActor>)actorType {
    return [self.instance class];
}

- (id <DTActorHandler>)create:(id <DTActorSystem>)actorSystem {
    return self.instance;
}

@end