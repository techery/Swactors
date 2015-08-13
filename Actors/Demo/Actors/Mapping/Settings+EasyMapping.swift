//
//  Settings+EasyMapping.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

extension Settings: EKMappingProtocol {
    @objc static func objectMapping() -> EKObjectMapping! {
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromDictionary(
            ["FlagContent.default" : "flagOptions",
            "facebook_gallery_enabled" : "facebookGalleryEnabled",
            "URLS.Production" : "urls"]
        )
        mapping.hasOne(ServerStatus.self, forKeyPath: "server_status.production", forProperty: "serverStatus")
        
        return mapping
    }
}

extension Settings.ServerStatus: EKMappingProtocol {
    @objc static func objectMapping() -> EKObjectMapping! {
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromDictionary(["status" : "status", "outage_type" : "outageType", "message" : "message"])
        
        return mapping
    }
    
}
