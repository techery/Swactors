//
//  SettingsActorTest.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/17/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Quick
import Nimble
import Actors

class SettingsActorTest: QuickSpec {
    override func spec() {
        var sut: SettingsActor!
        var settingsActorRef: DTActorRef!
        let actorSystem = ActorSystemMock()
        
        beforeSuite {
            sut = SettingsActor(actorSystem: actorSystem)
            settingsActorRef = DTActorRef(actor: sut, caller: self)
        }
        
        describe("SettingsActor") {
            context("on GetSettings message") {
                let message = GetSettings()
                let apiActor = actorSystem.actorOfClass(APIActor.self, caller: self) as! APIActorMock
                
                it("APIActor should receive valid GET message") {
                    settingsActorRef.ask(message)                    
                    
                    let settingsURL = actorSystem.configs[""] as! String
                    let get = Get(path: settingsURL, parameters: [:])
                    
                    expect(apiActor.receivedGetMessage).toEventually(equal(get))
                }
                
                context("APIActor succeeded") {
                    let mappingActor = actorSystem.actorOfClass(MappingActor.self, caller: self) as! MappingActorMock
                    
                    it("MappingActor should receive MessageRequest") {
                        apiActor.shouldSucceed = true
                        
                        settingsActorRef.ask(message)
                        
                        let mappingRequest = MappingRequest(payload: apiActor.result, resultType: Settings.self)
                        
                        expect(mappingActor.receivedMessage).toEventually(equal(mappingRequest))
                        
                        context("MappingActor succeeded") {
                            beforeSuite {
                                mappingActor.shouldSucceed = true
                            }
                            
                            it("settings storage should contain mapped settings") {
                                let settingsStorage = actorSystem.serviceLocator.serviceForClass(SettingsStorage) as! SettingsStorage
                                settingsActorRef.ask(message)
                                
                                expect(settingsStorage.settings).toEventuallyNot(beNil())
                                expect(settingsStorage.settings).toEventually(equal(mappingActor.result))
                            }
                            
                            it("result should contain mapped settings") {
                                let result = settingsActorRef.ask(message)
                                result.wait()
                                expect(result).toEventually(beFulfilled())
                                let settings = result.get() as? Settings
                                expect(settings).toEventually(equal(mappingActor.result))
                            }
                        }
                        
                        context("MappingActor failed") {
                            it("should return failed result") {
                                mappingActor.shouldSucceed = false
                                let result = settingsActorRef.ask(message)
                                result.wait()
                                expect(result).to(beRejected())
                            }
                        }
                    }
                }
                
                context("APIActor failed") {
                    it("should return failed result") {
                        apiActor.shouldSucceed = false
                        let result = settingsActorRef.ask(message)
                        result.wait()
                        expect(result).to(beRejected())
                    }
                }
            }
        }
    }
    
    // MARK: - Mocks
    
    class ActorSystemMock: DTMainActorSystem {
        override init() {
            let serviceLocator = ServiceLocator(builder: {_ in})
            super.init(configs: ConfigsMock(), serviceLocator: serviceLocator, builderBlock: {_ in})
        }
        
        let apiActor = APIActorMock()
        let mappingActor = MappingActorMock()
        
        override func actorOfClass(aClass: AnyClass, caller: AnyObject?) -> DTActorRef? {
            if aClass === APIActor.self {
                return apiActor
            }
            if aClass === MappingActor.self {
                return mappingActor
            }
            
            return nil
        }
    }
    
    class ConfigsMock: Configs {
        @objc subscript(key: String) -> AnyObject? {
            get {return "test_settings_url"}
            set {}
        }
    }
    
    class ServiceLocatorMock: ServiceLocator {
        let settingsStorage = SettingsStorage()
        
        override func serviceForClass(aClass: AnyClass!) -> AnyObject! {
            if aClass === SettingsStorage.self {
                return settingsStorage
            }
            
            return nil
        }
    }
    
    class APIActorMock: DTActorRef {
        var receivedGetMessage: Get? = nil
        var shouldSucceed = true
        
        let result = "{\"i_am\":\"json\"}"
        
        override func ask(message: AnyObject) -> RXPromise {
            receivedGetMessage = message as? Get
            let promise = RXPromise()
            shouldSucceed ? promise.resolveWithResult(result) : promise.rejectWithReason(nil)
            return promise
        }
    }
    
    class MappingActorMock: DTActorRef {
        var receivedMessage: MappingRequest? = nil
        var shouldSucceed = true
        
        let result = Settings()
        
        override func ask(message: AnyObject) -> RXPromise {
            receivedMessage = message as? MappingRequest
            let promise = RXPromise()
            shouldSucceed ? promise.resolveWithResult(result) : promise.rejectWithReason(nil)
            return promise
        }
        
    }
}
