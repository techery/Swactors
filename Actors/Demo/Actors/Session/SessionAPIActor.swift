//
// Created by Anastasiya Gorban on 8/5/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

class Endpoint: NSObject {
    let relativePath: String
    let method: String
    let parameters: [String:String]

    init(relativePath: String, method: String, parameters: [String:String] = [:]) {
        self.relativePath = relativePath
        self.method = method
        self.parameters = parameters
    }
}

class GetSession: Endpoint, Equatable {
    init(login: String, password: String) {
        super.init(relativePath: "api/sessions", method: "POST", parameters: ["username": login, "password": password])
    }
}

func == (lhs: GetSession, rhs: GetSession) -> Bool {
    return true
}


class SessionAPIActor: DActor {

    let apiActor: DTActorRef
    private(set) var baseURL: NSURL = NSURL()

    // MARK: - Messages


    // MARK: - DTActor

    override init!(actorSystem: DTActorSystem!) {
        apiActor = actorSystem.actorOfClass(APIActor)!
        super.init(actorSystem: actorSystem)
        let urlString: String = configs[TripsConfigs.Keys.baseURL] as! String
        baseURL = NSURL(string: urlString)!
    }

    override func setup() {
        on {
            (msg: GetSession) -> RXPromise in
            return self.askEndpoint(msg)
        }
    }

    // MARK: - Private    

    private func askEndpoint(endpoint: Endpoint) -> RXPromise {
        switch endpoint.method {
        case "POST":
            return self.apiActor.ask(APIActor.Post(path: self.urlForEndpoint(endpoint), parameters: endpoint.parameters))
        case "GET":
            return self.apiActor.ask(APIActor.Get(path: self.urlForEndpoint(endpoint), parameters: endpoint.parameters))
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
