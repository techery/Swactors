//
// Created by Anastasiya Gorban on 7/31/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DTActorSystem;
@protocol DTSystemActor;
@protocol DTActorHandler;

@protocol DTActorProvider

@property (nonatomic, readonly) Class<DTSystemActor> actorType;

- (id<DTActorHandler>)create:(id<DTActorSystem>)actorSystem;

@end
