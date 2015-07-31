//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DTActor;
@protocol DTActorSystem;
@protocol DTSystemActor;


@protocol DTActorProvider

@property (nonatomic, readonly) Class<DTSystemActor> actorType;

- (DTActor *)create:(id<DTActorSystem>)actorSystem;

@end

@interface DTSingletonActorProvider: NSObject<DTActorProvider>

@property (nonatomic, readonly) Class<DTSystemActor> actorType;
@property (nonatomic, readonly) DTActor *actor;

- (instancetype)initWithActorType:(Class)actorType;
+ (instancetype)providerWithActorType:(Class)actorType;

@end