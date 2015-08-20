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
    let actorSystem: DTMainActorSystem
    
    private(set) var fullName = "Undefined"
    private(set) var email = "Undefined"
    
    init(actorSystem: DTMainActorSystem, user: User?) {
        self.user = user
        self.actorSystem = actorSystem
        
        if let u = user {
            fullName = u.firstName + u.lastName
            email = u.email
        }
    }
    
    func logout() {
        let sessionActor = actorSystem.actorOfClass(DTSessionActor.self, caller: self)
        sessionActor?.ask(DTLogout())
    }
}
