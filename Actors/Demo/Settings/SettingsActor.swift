//
//  SettingsActor.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/5/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

class SettingsActor: DActor {
    class Settings{}
    
    let apiActor: DTActorRef
    
    override init!(actorSystem: DTActorSystem!) {
        apiActor = actorSystem.actorOfClass(APIActor)
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        on { (msg: Settings) -> RXPromise in
            let f = self.apiActor.ask(APIActor.Get(path: "http://dtapp.s3.amazonaws.com/config/settings_v4.json"))
            return f
        }
    }
}
