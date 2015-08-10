//
//  SampleSpec.m
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(MathSpec)

describe(@"Math", ^{
    it(@"is pretty cool", ^{
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
});

SPEC_END
