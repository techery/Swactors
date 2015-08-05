//
//  MappingProvider.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

class MappingProvider {
    private(set) var mappers:[String: EKObjectMapping] = [:]
    
    func add<I:EKMappingProtocol>(forClass: I.Type) {
        mappers[NSStringFromClass(forClass)] = forClass.objectMapping()
    }
    
    func mapping(forClass: AnyClass) -> EKObjectMapping? {
        return mappers[NSStringFromClass(forClass)]
    }
    
    init() {
        add(Session.self)
    }
}
