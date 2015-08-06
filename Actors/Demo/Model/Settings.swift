//
//  Settings.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

@objc
class Settings: NSObject {
    class ServerStatus: NSObject {
        var status: String = ""
        var outageType: String = ""
        var message: String = ""
        
        override init(){}
    }
    
    var serverStatus: ServerStatus = ServerStatus()
    var flagOptions: [AnyObject] = []
    var facebookGalleryEnabled: Bool = false
    var urls: [String : String] = [:]
}

