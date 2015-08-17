//
//  SettingsStorage.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//


import Foundation

@objc
public protocol SettingsProvider {
    var settings: Settings? { get }
}

@objc
public class SettingsStorage: NSObject, SettingsProvider {
    public var settings: Settings? {
        didSet {
            if let s = settings {
                archiveSettings(s)
            }
        }
    }
    
    override public init() {
        super.init()
        self.settings = unarchiveSettings()
    }
    
    // MARK: - Private
    
    private func archiveSettings(settings: Settings) {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(settings)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "settings")
    }
    
    private func unarchiveSettings() -> Settings? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let saved = defaults.objectForKey("settings") as? NSData {
            return NSKeyedUnarchiver.unarchiveObjectWithData(saved) as? Settings
        }
        
        return nil
    }
}
