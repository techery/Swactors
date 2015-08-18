//
//  APIActorTest.swift
//  Actors
//
//  Created by Anastasiya Gorban on 8/16/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Nimble
import Quick
import Actors

class APIActorTest: QuickSpec {
    override func spec() {
        describe("APIActor") {
            var apiActorRef: DTActorRef!
            var sut: APIActor!
            
            beforeSuite {
                sut = APIActor(actorSystem: ActorSystemMock())
                apiActorRef = DTActorRef(actor: sut)
            }
            
            it("Should be correctly initialized") {
                expect(sut.operationQueue).notTo(beNil())

                expect(sut.operationQueue.maxConcurrentOperationCount).to(equal(1))
            }
            
//            context("On POST message") {
//                it("Should add operation to queue") {
//                    let message = Post(path: "post", parameters: [:])
//                    let count = sut.operationQueue.operationCount
//                    apiActorRef.ask(message)
//                    expect(sut.operationQueue.operationCount).toEventually(equal(count + 1))
//                }
//            }
        }
    }
}
