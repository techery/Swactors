//
//  Configs.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

@objc
public protocol Configs {
    subscript(key: String) -> AnyObject? { get set}
}

@objc
public class PlistConfigs: Configs {
    private var configs: [String : AnyObject]? = [:]
    
    init(fileName: String) {
        if let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "plist") {
            configs = NSDictionary(contentsOfFile: path) as? [String : AnyObject]
        }
    }
    
    public subscript(key: String) -> AnyObject? {
        get {
            return configs?[key]
        }
        
        set {
            configs?[key] = newValue
        }
    }
}