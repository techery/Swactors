
//
//  DTAuthActor.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTAuthActor.h"
#import "DTActorSystem.h"
#import "Actors-Swift.h"
#import "RXPromise+RXExtension.h"

@implementation DTAuthActor

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem {
    if (self = [super initWithActorSystem:actorSystem]) {
        _sessoinActor = [actorSystem actorOfClass:[SessionActor class]];
        _settingsActor = [actorSystem actorOfClass:[SettingsActor class]];
    }

    return self;
}

- (void)setup {
    [self on:[Login class] doFuture:^RXPromise *(Login *message) {
        RXPromise *sessoin = [self.sessoinActor ask:message];
        RXPromise *settings = [self.settingsActor ask:[GetSettings new]];
        return [RXPromise allSettled:@[sessoin, settings]];
    }];
}

@end
