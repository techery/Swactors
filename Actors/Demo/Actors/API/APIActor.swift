import Foundation

public class APIRequest: NSObject, Equatable {
    let path:String
    let parameters: [String: String]
    
    typealias Result = String
    
    public init(path: String, parameters: [String: String] = [:]) {
        self.path = path
        self.parameters = parameters
    }
}

public func == (lhs: APIRequest, rhs: APIRequest) -> Bool {
    return lhs.path == rhs.path && lhs.parameters == rhs.parameters
}


// MARK: - Messages

public class Post : APIRequest {}
public class Get : APIRequest {}

// MARK: - APIActor

public class APIActor: DActor {
    
    let operationQueue: NSOperationQueue = NSOperationQueue()
    
    // MARK: - DTActor
    
    override public func setup() {
        operationQueue.maxConcurrentOperationCount = 1
        
        on { (msg: Post) -> RXPromise in
            return self.request(msg, method: HTTPMethod.POST)
        }
        
        on { (msg: Get) -> RXPromise in
            return self.request(msg, method: HTTPMethod.GET)
        }
    }
    
    // MARK: - Private
        
    private func request(message: APIRequest, method: HTTPMethod) -> RXPromise {
        let promise = RXPromise()
        var request = HTTPTask()
        
        var operation = request.create(message.path, method: method, parameters: message.parameters) { (response) -> Void in
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