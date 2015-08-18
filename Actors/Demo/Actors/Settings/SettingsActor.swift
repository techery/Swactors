//
//  SettingsActor.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/5/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

public class GetSettings:NSObject {}

public class SettingsActor: DActor {
    private(set) var apiActor: DTActorRef!
    private(set) var mappingActor: DTActorRef!
    let settingsStorage: SettingsStorage?
    
    override public init(actorSystem: DTActorSystem) {
        settingsStorage = actorSystem.serviceLocator.service()
        super.init(actorSystem: actorSystem)
        apiActor = actorSystem.actorOfClass(APIActor.self, caller: self)
        mappingActor = actorSystem.actorOfClass(MappingActor.self, caller: self)
    }
    
    override public func setup() {
        on { (msg: GetSettings) -> RXPromise in
            let settingsURL = self.configs[TripsConfigs.Keys.settingsURL] as! String
            let settings = self.apiActor.ask(Get(path: settingsURL))
            let mapSettings = settings.then({result in
                if let payload = result as? String {
                    return self.mappingActor.ask(MappingRequest(payload: payload, resultType: Settings.self))
                } else {
                    return nil
                }
            }, nil)
            
            let storeSettings = mapSettings.then({result in
                let promise = RXPromise()
                if let s = result as? Settings {
                    if let storage = self.settingsStorage {
                        storage.settings = s
                        promise.resolveWithResult(s)
                    }
                }
                
                promise.rejectWithReason("Failed to store settings")
                return promise
            }, nil)
            
            return storeSettings
        }
    }
}
