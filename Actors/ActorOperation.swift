import Foundation

public class BaseOperation : NSOperation {
    var _finished = false
    var _executing = false
    
    public override var executing:Bool {
        get { return _executing }
        set {
            willChangeValueForKey("isExecuting")
            _executing = newValue
            didChangeValueForKey("isExecuting")
        }
    }
    
    public override var finished:Bool {
        get { return _finished }
        set {
            willChangeValueForKey("isFinished")
            _finished = newValue
            didChangeValueForKey("isFinished")
        }
    }

    func finish() {
        self.executing = false
        self.finished = true
    }
    
    public override func start() {
        self.executing = true
    }
}

public class ActorOperation : BaseOperation {
    let message:Any
    let actorHandler:ActorHandler
    let promise:Promise<Any> = Promise()
    let future:Future<Any>
    
    init(_ msg:Any, _ actorHandler:ActorHandler) {
        message = msg
        self.actorHandler = actorHandler
        future = promise.future
        super.init()
        future.onCancel { () -> Void in
            self.cancel()
        }
    }
    
    public override func start() {
        super.start()
        
        actorHandler.handle(message).onSuccess { (result) -> Void in
            self.promise.completeWithSuccess(result)
            self.finish()
        }.onFail { (error) -> Void in
            self.promise.completeWithFail(error)
            self.finish()
        }
    }
}