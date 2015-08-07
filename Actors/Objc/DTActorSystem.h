//
// Created by Anastasiya Gorban on 7/30/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTServiceLocator.h"

@protocol DTActorProvider;
@protocol Configs;
@class DTActorRef;
@class DTActor;


@protocol DTActorSystem

@property(nonatomic, readonly) DTServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<Configs> configs;

- (DTActorRef *)actorOfClass:(Class)class;
- (void)addActorProvider:(id<DTActorProvider>)actorProvider;

@end

@interface DTActorSystemBuilder: NSObject

@property (nonatomic, readonly) id<DTActorSystem> actorSystem;

- (instancetype)initWithActorSystem:(id <DTActorSystem>)actorSystem;
+ (instancetype)builderWithActorSystem:(id <DTActorSystem>)actorSystem;

- (void)addActor:(Class)actorType;

@end

@interface DTMainActorSystem : NSObject <DTActorSystem>

@property(nonatomic, readonly) DTServiceLocator *serviceLocator;
@property (nonatomic, readonly) id<Configs> configs;

- (instancetype)initWithConfigs:(id<Configs>)configs
                 serviceLocator:(DTServiceLocator *)serviceLocator
                   builderBlock:(void (^)(DTActorSystemBuilder *))builderBlock;
@end
