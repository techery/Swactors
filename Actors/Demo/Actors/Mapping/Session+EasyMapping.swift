//
//  Session+EasyMapping.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

extension Session: EKMappingProtocol {
    @objc static func objectMapping() -> EKObjectMapping! {        
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromArray(["token"])
        mapping.hasOne(User.self, forKeyPath: "user")
        mapping.hasMany(Session.Permission.self, forKeyPath: "permissions")
        
        return mapping
    }
}

extension Session.Permission: EKMappingProtocol {
    @objc static func objectMapping() -> EKObjectMapping! {
        var mapping = EKObjectMapping(objectClass: self)
         mapping.mapPropertiesFromArray(["name"])
        return mapping
    }
}