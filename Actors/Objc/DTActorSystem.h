//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTActorProvider, Configs;
@class DTActorRef, DTActor, ServiceLocator;


@protocol DTActorSystem

@property(nonatomic, readonly, nonnull) ServiceLocator *serviceLocator;
@property (nonatomic, readonly, nonnull) id<Configs> configs;

- (nullable DTActorRef *)actorOfClass:(nonnull Class)class;
- (void)addActorProvider:(nonnull id<DTActorProvider>)actorProvider;

@end

@interface DTActorSystemBuilder: NSObject

@property (nonatomic, readonly, nonnull) id<DTActorSystem> actorSystem;

- (nonnull instancetype)initWithActorSystem:(nonnull id <DTActorSystem>)actorSystem;
+ (nonnull instancetype)builderWithActorSystem:(nonnull id <DTActorSystem>)actorSystem;

- (void)addActor:(nonnull Class)actorType;

@end

@interface DTMainActorSystem : NSObject <DTActorSystem>

@property(nonatomic, readonly, nonnull) ServiceLocator *serviceLocator;
@property (nonatomic, readonly, nonnull) id<Configs> configs;

- (nonnull instancetype)initWithConfigs:(nonnull id<Configs>)configs
                 serviceLocator:(nonnull ServiceLocator *)serviceLocator
                   builderBlock:(nonnull void (^)(DTActorSystemBuilder * __nonnull))builderBlock;
@end
