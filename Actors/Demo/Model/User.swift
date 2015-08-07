//
//  User.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/6/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

class User: NSObject {
    var userId: Int = 0
    var username: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var enrollDate: NSDate = NSDate()
    var birthDate: NSDate = NSDate()
    var locationName: String = ""
    
    var subscriptions: [String] = []
    
    var circleIds: [String] = []
    var circles: [String] = []
    
    var circlesNames: [String] = []
    
    var roviaBucks: Float = 0
    var dreamTripsPoints: Float = 0
    var tripImagesCount: Int = 0
    var bucketListItemsCount: Int = 0
    
    var isSocialEnabled: Bool = false
    
    var avatarOriginalURL: NSURL?
    var avatarMediumURL: NSURL?
    var avatarThumbURL: NSURL?
    
    var coverPhotoURL: NSURL?
    
    var isDreamTripsUser: Bool = false
    var isGoldMember: Bool = false
    var isPlatinumMember: Bool = false
    var isRepUser: Bool = false

}
