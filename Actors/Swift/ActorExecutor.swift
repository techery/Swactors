import Foundation

public class ActorExecutor : ActorHandler {
    var operationQueue:NSOperationQueue = NSOperationQueue()
    
    let actorHandler:ActorHandler
    
    init(_ actor:ActorHandler) {
        let mirror = reflect(actor)
        operationQueue.name = "ActorExecutor#\(mirror.summary)"
        operationQueue.maxConcurrentOperationCount = 1
        actorHandler = actor
    }
    
    public func handle(msg:Any) -> Future<Any> {
        let operation = ActorOperation(msg, actorHandler)
        
        operationQueue.addOperation(operation)
        
        return operation.future
    }
}
