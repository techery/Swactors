//
//  Settings.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

@objc
public class Settings: NSObject, NSCoding {
    var serverStatus: ServerStatus = ServerStatus()
    var flagOptions: [AnyObject] = []
    var facebookGalleryEnabled: Bool = false
    var urls: [String : String] = [:]
    
    // MARK: - NSCoding
    
    convenience required public init(coder decoder: NSCoder) {
        self.init()
        self.serverStatus = decoder.decodeObjectForKey("serverStatus") as! ServerStatus
        self.flagOptions = decoder.decodeObjectForKey("flagOptions") as! [AnyObject]
        self.facebookGalleryEnabled = decoder.decodeObjectForKey("facebookGalleryEnabled") as! Bool
        self.urls = decoder.decodeObjectForKey("urls") as! [String : String]
    }
    
    public func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.serverStatus, forKey: "serverStatus")
        coder.encodeObject(self.flagOptions, forKey: "flagOptions")
        coder.encodeObject(self.facebookGalleryEnabled, forKey: "facebookGalleryEnabled")
        coder.encodeObject(self.urls, forKey: "urls")
    }
    
    // MARK: - ServerStatus
    
    class ServerStatus: NSObject, NSCoding {
        var status: String = ""
        var outageType: String = ""
        var message: String = ""
        
        override init(){}
        
        // MARK: - NSCoding
        
        convenience required init(coder decoder: NSCoder) {
            self.init()
            self.status = decoder.decodeObjectForKey("status") as! String
            self.outageType = decoder.decodeObjectForKey("outageType") as! String
            self.message = decoder.decodeObjectForKey("message") as! String
        }
        
        func encodeWithCoder(coder: NSCoder) {
            coder.encodeObject(self.status, forKey: "status")
            coder.encodeObject(self.outageType, forKey: "outageType")
            coder.encodeObject(self.message, forKey: "message")
        }
    }
}

