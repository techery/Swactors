//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTActorConstants.h"

#pragma mark - Protocol - DTActorHandler

@protocol DTActorHandler
- (RXPromise *)handle:(id)message;
@end

@protocol DTActorSystem;

#pragma mark - Protocol - DTSystemActor

@protocol DTSystemActor

@property (nonatomic, readonly, weak) id<DTActorSystem> actorSystem;
+ (id)actorWithActorSystem:(id <DTActorSystem>)actorSystem;

@end

#pragma mark - DTActor

@protocol DTActorSystem;

@interface DTActor : NSObject<DTActorHandler, DTSystemActor>

@property (nonatomic, readonly, weak) id<DTActorSystem> actorSystem;

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem;
+ (instancetype)actorWithActorSystem:(id <DTActorSystem>)actorSystem;

- (void)setup;

- (void)on:(Class)messageType _do:(void (^)(id))handler;
- (void)on:(Class)messageType doFuture:(RXPromise *(^)(id))handler;
- (void)on:(Class)messageType doResult:(id (^)(id))handler;

@end

#pragma mark - DTActorRef

@interface DTActorRef: NSObject

- (instancetype)initWithActor:(id<DTActorHandler>)actor;

- (void)tell:(id)message;
- (RXPromise *)ask:(id)message;

@end