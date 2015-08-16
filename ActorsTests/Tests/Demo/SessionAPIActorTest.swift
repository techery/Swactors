//
//  SessionAPIActorTest.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/16/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Quick
import Nimble
import Actors

class SessionAPIActorTest: QuickSpec {
    override func spec() {
        var sut: DTActorRef!
        var sessionApiActor: SessionAPIActor!
        var actorSystem: DTMainActorSystem!
        
        beforeSuite {
            actorSystem = ActorSystemMock()
            sessionApiActor = SessionAPIActor(actorSystem: actorSystem)
            sut = DTActorRef(actor: sessionApiActor)
        }
        
        context("On GetSession message", {
            let message = GetSession(login: "login", password: "password")
            
            it("Api Actor should receive valid Post message") {
                sut.ask(message)
                
                let apiActor = actorSystem.actorOfClass(APIActor) as! APIActorMock
                
                let path = sessionApiActor.baseURL.URLByAppendingPathComponent(message.relativePath).absoluteString!
                let post = Post(path: path, parameters: message.parameters)
                
                expect(apiActor.receivedPostMessage).toEventually(equal(post))
            }
            
            context("If ApiActor succeeded") {
                it("Should return succeeded result") {
                    let apiActor = actorSystem.actorOfClass(APIActor) as! APIActorMock
                    
                    apiActor.shouldSucceed = true
                    
                    let result = sut.ask(message)
                    result.wait()
                    expect(result.isFulfilled).to(beTrue())
                }
            }
            
            context("If ApiActor failed") {
                it("Should return failed result") {
                    let apiActor = actorSystem.actorOfClass(APIActor) as! APIActorMock
                    
                    apiActor.shouldSucceed = false
                    
                    let result = sut.ask(message)
                    result.wait()
                    expect(result.isRejected).to(beTrue())
                }
            }
        })
    }
    
    // MARK: - Mocks
    
    class ConfigsMock: Configs {
        @objc subscript(key: String) -> AnyObject? {
            get {
                return "test_base_URL"
            }
            
            set {

            }
        }
    }
    
    class ActorSystemMock: DTMainActorSystem {
        let apiActor = APIActorMock()
        
        override init() {
            let serviceLocator = ServiceLocator(builder: {_ in})
            super.init(configs: ConfigsMock(), serviceLocator: serviceLocator, builderBlock: {_ in})
        }
        
        override func actorOfClass(`class`: AnyClass) -> DTActorRef? {
            return apiActor
        }
    }
    
    class APIActorMock: DTActorRef {
        var receivedPostMessage: Post? = nil
        var shouldSucceed = true
        
        override func ask(message: AnyObject!) -> RXPromise! {
            receivedPostMessage = message as? Post
            let promise = RXPromise()            
            shouldSucceed ? promise.resolveWithResult(nil) : promise.rejectWithReason(nil)
            return promise
        }
    }
}
