//  Created by Anastasiya Gorban on 8/13/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"
#import "Actors-Swift.h"

SPEC_BEGIN(APIActorTest)

    describe(@"APIActor", ^{
        __block APIActor *sut = [APIActor new];

        it(@"Should have operation queue", ^{
            [[sut.operationQueue shouldNot] beNil];
        });
    });

SPEC_END