

import Foundation

class MappingRequest : NSObject {
    let payload:String
    let resultType:AnyObject.Type

    init(payload: String, resultType: AnyObject.Type) {
        self.payload = payload
        self.resultType = resultType
    }
}

class MappingActor: DTActor {
    
    override func setup() {
        on(MappingRequest.self, doResult: { (msg) -> AnyObject! in
            return nil
        })
    }
}