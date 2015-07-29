//
//  Obbcj.swift
//  Actors
//
//  Created by Sergey Zenchenko on 7/29/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

@objc
class Payload : NSObject {
    let val:String
    
    init(_ v:String) {
        val = v
        super.init()
    }
}

@objc
class ObjcX : NSObject {
    
    
    
    func get(val:String) -> Int {
        return count(val)
    }
    
    func payload(val:String) -> Payload {
        return Payload(val)
    }
}