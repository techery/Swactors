//
//  ServiceLocator.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

class ServiceLocator: NSObject {
    private var registry: [String : AnyObject] = [:]
    
    init(builderBlock: ServiceLocator -> Void) {
        super.init()
        builderBlock(self)
    }
    
    func register<T: AnyObject>(service: T) {
        register(service, key: toKey(T.self))
    }
    
    func register(service: AnyObject, forProtocol aProtocol: Protocol) {
        register(service, key: toKey(aProtocol))
    }
    
    func service<T: AnyObject>() -> T? {
        return registry[toKey(T.self)] as? T
    }
    
    func serviceFor(aProtocol: Protocol) -> AnyObject? {
        return registry[toKey(aProtocol)]
        
    }
    
    // MARK: - Private
    
    private func register(service: AnyObject, key: String) {
        registry[key] = service
    }
    
    private func toKey(aProtocol: Protocol) -> String {
        return "Protocol \(NSStringFromProtocol(aProtocol))"
    }

    private func toKey(aClass: AnyClass) -> String {
        return "Class \(NSStringFromClass(aClass))"
    }
}
