//
//  UserViewModel.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/13/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Bond

class UserViewModel {
    let user: User?
    
    private(set) var fullName = "Undefined"
    private(set) var email = "Undefined"
    
    init(user: User?) {
        self.user = user
        
        if let u = user {
            fullName = u.firstName + u.lastName
            email = u.email
        }
    }
}
