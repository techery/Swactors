//
//  DActor.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/3/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

class DActor: DTActor {
    func on<I:AnyObject>(handler:(msg:I) -> RXPromise) {
//        on(I.self, doFuture: handler)
    }
}
