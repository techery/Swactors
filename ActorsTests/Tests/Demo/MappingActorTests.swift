//
//  MappingActorTests.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/17/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Quick
import Nimble
import Actors

class MappingActorTests: QuickSpec {
    override func spec() {
        describe("MappingActor") {
            var sut: MappingActor!
            var mappingActorRef: DTActorRef!
            
            beforeSuite {
                sut = MappingActorMock(actorSystem: ActorSystemMock())
                mappingActorRef = DTActorRef(actor: sut)
            }
            
            context("on MappingRequest message") {
                context("if payload is not a JSON string") {
                    let message = MappingRequest(payload: "i_am_not_a_JSON", resultType: TestModel.self)
                    
                    it("should return failed result") {
                        let result = mappingActorRef.ask(message)
                        result.wait()
                        expect(result).to(beRejected())
                    }
                }
                
                context("if no mapping found for provided model") {
                    let message = MappingRequest(payload: "{\"i_am\":\"json\"}", resultType: NSObject.self)
                    
                    it("should return failed result") {
                        let result = mappingActorRef.ask(message)
                        result.wait()
                        expect(result).to(beRejected())
                    }
                }

                it("should return mapped object") {
                    let message = MappingRequest(payload: "{\"name\": \"John\",\"birth_date\": \"2015-08-17\", \"url\": \"https://www.google.com\"}", resultType: TestModel.self)
                    let result = mappingActorRef.ask(message)
                    result.wait()
                    let model = result.get() as? TestModel
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    dateFormatter.timeZone = NSTimeZone(name: "GMT")
                    let verifyModel = TestModel(name: "John", url: NSURL(string: "https://www.google.com")!, birthday: dateFormatter.dateFromString("2015-08-17")!)
                    expect(model).notTo(beNil())
                    expect(model).to(equal(verifyModel))
                }
            }
        }
    }
    
    // MARK: - Mocks
    
    class MappingActorMock: MappingActor {
        override init(actorSystem: DTActorSystem) {
            super.init(actorSystem: actorSystem)
            
            self.mappingProvider = MappingProviderMock()
        }
    }
    
    class MappingProviderMock: MappingProvider {
        init() {
            
        }
        
        func mapping(forClass: AnyClass) -> EKObjectMapping? {
            if forClass === TestModel.self {
                return TestModel.objectMapping()
            } else {
                return nil
            }
        }
    }
        
    class TestModel: NSObject, EKMappingProtocol, Equatable {
        var name: String? = nil
        var url: NSURL? = nil
        var birthday: NSDate? = nil
        
        override init() {
            super.init()
        }
        
        init(name: String, url: NSURL, birthday: NSDate) {
            self.name = name
            self.url = url
            self.birthday = birthday
            super.init()
        }
        
        @objc static func objectMapping() -> EKObjectMapping! {
            var mapping = EKObjectMapping(objectClass: self)
            
            mapping.mapPropertiesFromDictionary(
                ["name" : "name"]
            )
            
            mapping.mapKeyPath("birth_date", toProperty: "birthday", withDateFormatter: NSDateFormatter.ek_formatterForCurrentThread())
            mapping.mapKeyPath("url", toProperty: "url", withValueBlock: EKMappingBlocks.urlMappingBlock(), reverseBlock: EKMappingBlocks.urlReverseMappingBlock())
            
            return mapping
        }
    }
}

func == (lhs: MappingActorTests.TestModel, rhs: MappingActorTests.TestModel) -> Bool {
    return lhs.name == rhs.name && lhs.url == rhs.url && lhs.birthday == rhs.birthday
}
