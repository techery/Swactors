//
// Created by Anastasiya Gorban on 8/5/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

public class Endpoint: NSObject {
    public let relativePath: String
    public let method: String
    public let parameters: [String:String]

    public init(relativePath: String, method: String, parameters: [String:String] = [:]) {
        self.relativePath = relativePath
        self.method = method
        self.parameters = parameters
    }
}

public class GetSession: Endpoint {
    public init(login: String, password: String) {
        super.init(relativePath: "api/sessions", method: "POST", parameters: ["username": login, "password": password])
    }
}

public class SessionAPIActor: DActor {

    private(set) var apiActor: DTActorRef!
    private(set) public var baseURL: NSURL = NSURL()

    // MARK: - DTActor

    override public init(actorSystem: DTActorSystem) {
        super.init(actorSystem: actorSystem)
        apiActor = actorSystem.actorOfClass(APIActor.self, caller: self)
        let urlString: String = configs[TripsConfigs.Keys.baseURL] as! String
        baseURL = NSURL(string: urlString)!
    }

    override public func setup() {
        on {
            (msg: GetSession) -> RXPromise in
            return self.askEndpoint(msg)
        }
    }

    // MARK: - Private    

    private func askEndpoint(endpoint: Endpoint) -> RXPromise {
        switch endpoint.method {
        case "POST":
            return self.apiActor.ask(Post(path: self.urlForEndpoint(endpoint), parameters: endpoint.parameters))
        case "GET":
            return self.apiActor.ask(Get(path: self.urlForEndpoint(endpoint), parameters: endpoint.parameters))
        default:
            let promise = RXPromise()
            promise.rejectWithReason("No such method:\(endpoint.method)")
            return promise
        }
    }

    private func urlForEndpoint(endpoint: Endpoint) -> String {
        let URLString = baseURL.URLByAppendingPathComponent(endpoint.relativePath).absoluteString!
        return URLString
    }

}
