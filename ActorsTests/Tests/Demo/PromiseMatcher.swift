//
//  PromiseMatcher.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/17/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Nimble

public func beRejected() -> NonNilMatcherFunc<RXPromise> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be rejected"
        let m = actualExpression.evaluate()
        if let promise = m {
            return promise.isRejected
        } else {
            return false
        }
    }
}

public func beFulfilled() -> NonNilMatcherFunc<RXPromise> {
    return NonNilMatcherFunc { actualExpression, failureMessage in
        failureMessage.postfixMessage = "be fulfilled"
        let m = actualExpression.evaluate()
        if let promise = m {
            return promise.isFulfilled
        } else {
            return false
        }
    }
}

