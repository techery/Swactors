//
//  DTInvocation.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/18/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTInvocation.h"
#import "DTActorSystem.h"
#import "DTActor.h"

@implementation DTInvocation

- (instancetype)initWithMessage:(id)message caller:(nullable id)caller {
    self = [super init];
    if (self) {
        _message = message;
        _caller = caller;

        if ([caller isKindOfClass:[DTActor class]]) {
            _parent = [caller currentInvocation];
        }
    }

    return self;
}

+ (instancetype)invocationWithMessage:(id)message caller:(nullable id)caller {
    return [[self alloc] initWithMessage:message caller:caller];
}

- (void)start {
    NSLog(@"\nInvocation started\nmessage: %@\ncaller: %@\nparrent: %@", self.message, self.caller, self.parent);
    self.started = [NSDate new];
}

- (void)finish {
    self.finished = [NSDate new];
    double time = [self.finished timeIntervalSinceDate:self.started];
    NSLog(@"\nInvocation finished\nmessage: %@\ncaller: %@\nparrent: %@\ntime:%.3fs", self.message, self.caller, self.parent, time);
}

@end
