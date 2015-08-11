//
//  DTAuthActor.h
//  Actors
//
//  Created by Anastasiya Gorban on 8/10/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "DTActor.h"

@interface DTAuthActor : DTActor

@property(readonly, nonatomic) DTActorRef *sessionActor;
@property(readonly, nonatomic) DTActorRef *settingsActor;

@end
