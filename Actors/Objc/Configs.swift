//
//  Configs.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

@objc
protocol Configs {
    subscript(key: String) -> AnyObject? { get set}
}

@objc
class PlistConfigs: Configs {
    private var configs: [String : AnyObject]? = [:]
    
    init(fileName: String) {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            configs = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
        }
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            return configs?[key]
        }
        
        set {
            configs?[key] = newValue
        }
    }
}