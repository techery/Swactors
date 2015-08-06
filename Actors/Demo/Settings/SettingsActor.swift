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
    let mappingActor: DTActorRef
    
    override init!(actorSystem: DTActorSystem!) {
        apiActor = actorSystem.actorOfClass(APIActor)
        mappingActor = actorSystem.actorOfClass(MappingActor)
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        on { (msg: Settings) -> RXPromise in
            let settings = self.apiActor.ask(APIActor.Get(path: "http://dtapp.s3.amazonaws.com/config/settings_v4.json"))
            let mapSettings = settings.then({result in
                if let payload = result as? String {
                    return self.mappingActor.ask(MappingRequest(payload: payload, resultType: Actors.Settings.self))
                } else {
                    return nil
                }
            }, nil)
            
            return mapSettings
        }
    }
}
