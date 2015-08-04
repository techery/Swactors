

import Foundation
import Argo

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
            if let message = msg as? MappingRequest {
                let r:message.resultType = self.map(message.payload)!
                return ""
            } else {
                return nil
            }
        })
    }
    
    func map<T: Decodable where T == T.DecodedType>(message:String) -> T? {
        let data = message.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil)
        
        if let j: AnyObject = json {
            let object: T? = decode(j)
            return object
        } else {
            return nil
        }
    }

    
    func map<T>(message:String) -> T? {
        return nil
    }
}