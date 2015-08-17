//
//  MappingProvider.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/4/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

public protocol MappingProvider {
    func mapping(forClass: AnyClass) -> EKObjectMapping?
}

public class TripsMappingProvider: MappingProvider {
    private(set) var mappers:[String: EKObjectMapping] = [:]
    
    func add<I:EKMappingProtocol>(forClass: I.Type) {
        mappers[NSStringFromClass(forClass)] = forClass.objectMapping()
    }
    
    public init() {
        add(Session.self)
        add(Settings.self)
    }
    
    // MARK: - MappingProvider
    
    public func mapping(forClass: AnyClass) -> EKObjectMapping? {
        return mappers[NSStringFromClass(forClass)]
    }
}
