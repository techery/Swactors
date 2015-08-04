import Foundation

class APIActor: DTActor {
    
    let operationQueue:NSOperationQueue = NSOperationQueue()
    
    class Get : NSObject, Request {
        let path:String
        let parameters: [String: String]
        
        typealias Result = String
        
        init(path: String, parameters: [String: String]) {
            self.path = path
            self.parameters = parameters
        }
    }
    
    override func setup() {
        operationQueue.maxConcurrentOperationCount = 1
        
        on(Get.self, doFuture: {(msg) -> RXPromise! in
            if let message = msg as? Get {
                return self.get(message)
            } else {
                let promise = RXPromise()
                promise.rejectWithReason("Wrong message type")
                return promise
            }
        })
    }
    
    func get(message:Get) -> RXPromise {
        let promise = RXPromise()
        var request = HTTPTask()
        
        var operation = request.create(message.path, method: .POST, parameters: message.parameters) { (response) -> Void in
            if let err = response.error {
                promise.rejectWithReason(err)
                return
            }
            
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let responseString = str as? String {
                    promise.resolveWithResult(responseString)
                } else {
                    promise.rejectWithReason("Can't parse response")
                }
            }
            
            promise.rejectWithReason("Empty body received")
        }
        
        if let op = operation {
            operationQueue.addOperation(op)
        }
        
        return promise
    }
}