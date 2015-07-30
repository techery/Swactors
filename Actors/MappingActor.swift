

import Foundation
import Argo

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
    
    func map<T: Decodable where T == T.DecodedType>(message:MappingRequest<T>) -> T? {
        let data = message.payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
        
        if let j: AnyObject = json {
            let object: T? = decode(j)
            return object
        } else {
            return nil
        }
    }

    
    func map<T>(message:MappingRequest<T>) -> MappingRequest<T>.Result? {
        return nil
    }
}