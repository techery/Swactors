//
//  Session.swift
//  Actors
//
//  Created by Anastasiya Gorban on 7/30/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

@objc
class Session: NSObject {
    class Permission: NSObject {
        var name = ""
    }
    
    var token = ""
    var user = User()
    var permissions: [Permission] = []
    
    override init() {}
}

