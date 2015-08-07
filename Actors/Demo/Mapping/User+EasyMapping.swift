//
//  User+EasyMapping.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

extension User: EKMappingProtocol {
    @objc static func objectMapping() -> EKObjectMapping! {
        var mapping = EKObjectMapping(objectClass: self)
        
        mapping.mapPropertiesFromDictionary([
            "userId" : "id",
            "username" : "username",
            "firstName" : "first_name",
            "lastName" : "last_name",
            "email" : "email",
            "locationName" : "location",
            "subscriptions" : "subscriptions",
            "roviaBucks" : "rovia_bucks",
            "dreamTripsPoints" : "dream_trips_points",
            "tripImagesCount" : "trip_images_count",
            "bucketListItemsCount" : "bucket_list_items_count",
            "circleIds" : "circle_ids",
            "isSocialEnabled" : "social_enabled"
            ])
        
        return mapping
    }
}

