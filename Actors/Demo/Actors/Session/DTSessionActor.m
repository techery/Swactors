//
//  DTSessionActor.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTSessionActor.h"
#import "DTActorSystem.h"
#import "Actors-Swift.h"

@implementation DTSessionActor

- (instancetype)initWithActorSystem:(id<DTActorSystem>)actorSystem {
    self = [super initWithActorSystem:actorSystem];
    if (self) {
        _sessionApiActor = [actorSystem actorOfClass:[SessionAPIActor class] caller:self];
        _mappingActor = [actorSystem actorOfClass:[MappingActor class] caller:self];
        _sessionStorage = [actorSystem.serviceLocator serviceForClass:[DTSessionStorage class]];
    }

    return self;
}

- (void)setup {
    [super setup];

    [self on:[Login class] doFuture:^RXPromise *(Login *message) {
        return [self askSession:message.email password:message.password];
    }];

    [self on:[DTLogout class] _do:^(id o) {
        [self.sessionStorage clear];
    }];
}

- (RXPromise *)askSession:(NSString *)login password:(NSString *)password {
    RXPromise *session = [self.sessionApiActor ask:[[GetSession alloc] initWithLogin:login password:password]];
    RXPromise *mapSession = session.then(^id(NSString *result) {
        if ([result isKindOfClass:[NSString class]]) {
            return [self.mappingActor ask:[[MappingRequest alloc] initWithPayload:result resultType:[Session class]]];
        } else {
            return [NSError errorWithDomain:DTActorsErrorDomain code:0 userInfo:@{DTActorsErrorMessageKey : @"Wrong result type"}];
        }
    }, nil);
    
    RXPromise *storeSession = mapSession.then(^id(id result) {
        return [self tryStoreSession:result];
    }, nil);
    
    return storeSession;
}

- (RXPromise *)tryStoreSession:(id)session {
    RXPromise *promise = [RXPromise new];
    if ([session isKindOfClass:[Session class]] && self.sessionStorage != nil) {
        self.sessionStorage.session = session;
        [promise resolveWithResult:session];
    } else {
        [promise rejectWithReason:@"Failed to store session"];
    }
    
    return promise;
}

@end

@implementation DTLogout
@end
