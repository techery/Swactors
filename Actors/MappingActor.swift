

import Foundation

@objc
class MappingRequest : NSObject {
    let payload:String
    let resultType:AnyClass

    init(payload: String, resultType: AnyClass) {
        self.payload = payload
        self.resultType = resultType
    }
}

class MappingActor: DTActor {
    private let mappingProvider: MappingProvider = MappingProvider()
    
    override func setup() {
        on(MappingRequest.self, doFuture: { (msg) -> RXPromise! in
            let promise = RXPromise()
            if let message = msg as? MappingRequest {
                promise.bind(self.map(message.payload, toType: message.resultType))
            } else {
                promise.rejectWithReason("Wrong message type")
            }
            
            return promise
        })
    }
    
    func map(payload: String, toType: AnyClass) -> RXPromise {
        let data = payload.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        
        let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil)
        
        let promise = RXPromise()
        if let j = json as? [NSObject : AnyObject] {
            if let mapping = self.mappingProvider.mapping(toType) {
                let o: AnyObject! = EKMapper.objectFromExternalRepresentation(j, withMapping: mapping)
                promise.resolveWithResult(o)
            } else {
                promise.rejectWithReason("No mapping rules for object class \(NSStringFromClass(toType))")
            }
        } else {
            promise.rejectWithReason("Can't parse \(json)")
        }
        
        return promise
    }
}