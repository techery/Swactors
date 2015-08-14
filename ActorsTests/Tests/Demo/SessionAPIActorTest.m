//
//  SessionAPIActorTest.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/13/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "Actors-Swift.h"
#import "ActorSystemMock.h"

SPEC_BEGIN(SessionAPIActorTest)

describe(@"SessionAPIActor", ^{
    __block DTActorRef *sut = nil;
    __block DTMainActorSystem *actorSystem = nil;
    __block DTActorRef *apiActor = nil;
    
    beforeAll(^{
        actorSystem = actorSystemMock();
        [actorSystem stub:@selector(actorOfClass:) andReturn:apiActor withArguments:[APIActor class]];
        
        sut = [[DTActorRef alloc] initWithActor:[[SessionAPIActor alloc] initWithActorSystem:actorSystem]];
        
        context(@"On GetSession message", ^{            
            
        });
    });
});

SPEC_END