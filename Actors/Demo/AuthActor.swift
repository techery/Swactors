//
//  AuthActor.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/5/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

class Login : NSObject {
    let email:String
    let password:String
    
    typealias Result = Session
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

@objc class AuthActor: DActor {
    
    let sessionActor: DTActorRef
    let settingsActor: DTActorRef
    
    override init!(actorSystem: DTActorSystem!) {
        sessionActor = actorSystem.actorOfClass(DTSessionActor.self)!
        settingsActor = actorSystem.actorOfClass(SettingsActor.self)!
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        on { (msg: Login) -> RXPromise in
            let session = self.sessionActor.ask(msg)
            let settings = self.settingsActor.ask(GetSettings())
            return RXPromise.all([session, settings])
        }
    }
}
