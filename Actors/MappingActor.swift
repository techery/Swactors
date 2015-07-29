

import Foundation

struct MappingRequest<T> : Request {
    let payload:String
    let resultType:T.Type
    
    typealias Result = T
}

class MappingActor: Actor {
    
    override func setup() {
        on { (msg:MappingRequest<Any>) -> MappingRequest<Any>.Result in
            return self.map(msg)
        }
    }
    
    func map<T>(message:MappingRequest<T>) -> MappingRequest<T>.Result {
        let result = message.payload as! MappingRequest<T>.Result
        
        return result
    }
}