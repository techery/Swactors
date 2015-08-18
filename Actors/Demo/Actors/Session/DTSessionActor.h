//
//  DTSessionActor.h
//  Actors
//
//  Created by Anastasiya Gorban on 8/14/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActor.h"

@class DTSessionStorage;

@interface DTSessionActor : DTActor

@property (nonatomic, readonly) DTActorRef *sessionApiActor;
@property (nonatomic, readonly) DTActorRef *mappingActor;
@property (nonatomic, readonly) DTSessionStorage *sessionStorage;

@end

@interface DTLogout : NSObject
@end