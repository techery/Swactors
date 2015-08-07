//
//  AuthActor.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/5/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

class AuthActor: DActor {
    
    class Login : NSObject {
        let email:String
        let password:String
        
        typealias Result = Session
        
        init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
    
    let sessionActor: DTActorRef
    let settingsActor: DTActorRef
    
    override init!(actorSystem: DTActorSystem!) {
        sessionActor = actorSystem.actorOfClass(SessionActor)
        settingsActor = actorSystem.actorOfClass(SettingsActor)
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        on { (msg: Login) -> RXPromise in
            let session = self.sessionActor.ask(SessionActor.Login(email: msg.email, password: msg.password))
            let settings = self.settingsActor.ask(SettingsActor.GetSettings())
            return RXPromise.allSettled([session, settings])
        }
    }
}
