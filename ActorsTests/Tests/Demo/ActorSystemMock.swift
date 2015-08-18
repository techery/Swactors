//
//  ActorSystemMock.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/17/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Actors

class ActorSystemMock: DTMainActorSystem {
    override init() {
        let serviceLocator = ServiceLocator(builder: {_ in})
        super.init(configs: ConfigsMock(), serviceLocator: serviceLocator, builderBlock: {_ in})
    }
}

class ConfigsMock: Configs {
    @objc subscript(key: String) -> AnyObject? {
        get {return nil}
        set {}
    }
}

