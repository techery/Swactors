//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTActorProvider, Configs;
@class DTActorRef, DTActor, ServiceLocator;

NS_ASSUME_NONNULL_BEGIN

@protocol DTActorSystem

@property(nonatomic, readonly) ServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<Configs> configs;

- (nullable DTActorRef *)actorOfClass:(Class)class caller:(id)caller;
- (void)addActorProvider:(id<DTActorProvider>)actorProvider;

@end

@interface DTActorSystemBuilder: NSObject

@property (nonatomic, readonly) id<DTActorSystem> actorSystem;

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem;
+ (instancetype)builderWithActorSystem:(id <DTActorSystem>)actorSystem;

- (void)addActor:(Class)actorType;

@end

@interface DTMainActorSystem : NSObject <DTActorSystem>

@property(nonatomic, readonly) ServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<Configs> configs;

- (instancetype)initWithConfigs:(id<Configs>)configs
                 serviceLocator:(ServiceLocator *)serviceLocator
                   builderBlock:(void (^)(DTActorSystemBuilder *))builderBlock;
@end

NS_ASSUME_NONNULL_END