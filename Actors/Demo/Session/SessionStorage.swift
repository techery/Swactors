//
// Created by Anastasiya Gorban on 8/5/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

@objc
protocol SessionProvider {
    var session: Session? { get }
}

@objc
class SessionStorage: NSObject, SessionProvider {
    var session: Session?
}
