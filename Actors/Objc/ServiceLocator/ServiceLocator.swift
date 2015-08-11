//
//  ServiceLocator.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/7/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

class ServiceLocator: DTServiceLocator {
    init(builder: ServiceLocator -> Void) {
        super.init(builderBlock: { locator in
            builder(locator as! ServiceLocator)
        })
    }

    
    func register<T: AnyObject>(service: T) {
        super.registerService(service, forClass: T.self)
    }
    
    func service<T: AnyObject>() -> T? {
        return super.serviceForClass(T.self) as? T
    }
}
