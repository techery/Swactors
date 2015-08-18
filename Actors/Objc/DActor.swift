//
//  DActor.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/3/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

public class DActor: DTActor {
    
    func on<I: AnyObject>(handler:(msg:I) -> Void) {
        on(I.self, _do: { object in
            handler(msg: object as! I)
        })
    }

    func on<I: AnyObject>(handler:(msg:I) -> AnyObject) {
        on(I.self, doResult: { object in
            return handler(msg: object as! I)
        })
    }

    func on<I: AnyObject>(handler:(msg:I) -> RXPromise) {
        on(I.self, doFuture: { object in
            return handler(msg: object as! I)
        })
    }
}
