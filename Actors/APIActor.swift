import Foundation

class APIActor: Actor {
    
    let operationQueue:NSOperationQueue = NSOperationQueue()
    
    struct Get : Request {
        let path:String
        
        typealias Result = String
    }
    
    override func setup() {
        operationQueue.maxConcurrentOperationCount = 1
        
        on { (msg:Get) -> Future<Get.Result> in
            return self.get(msg)
        }
    }
    
    func get(message:Get) -> Future<String> {
        let promise = Promise<String>()
        var request = HTTPTask()
        
        var operation = request.create(message.path, method: .GET, parameters: nil) { (response) -> Void in
            if let err = response.error {
                promise.completeWithFail(err)
                return
            }
            
            if let data = response.responseObject as? NSData {
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                if let responseString = str as? String {
                    promise.completeWithSuccess(responseString)
                } else {
                    promise.completeWithFail("Can't parse response")
                }
            }
            
            promise.completeWithFail("Empty body received")
        }
        
        if let op = operation {
            operationQueue.addOperation(op)
        }
        
        return promise.future
    }
}