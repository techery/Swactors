import Foundation

public protocol ActorHandler {
    func handle(msg:Any) -> Future<Any>
}

public class Actor : ActorHandler {
    let system:ActorSystem
    let dispatcher:MessageDispatcher = MessageDispatcher()
    
    class func create<T:Actor>(type:T.Type, sys:ActorSystem) -> T {
        let klass: T.Type = T.self
        return klass(sys) as T
    }
    
    public required init(_ sys:ActorSystem) {
        system = sys
        setup()
    }
    
    public func setup() {}
    
    public func handle(msg:Any) -> Future<Any> {
        return dispatcher.handle(msg)
    }
    
    func on<I>(handler:(msg:I) -> Void) {
        dispatcher.on(handler)
    }
    
    func on<I:Request>(handler:(msg:I) -> Future<I.Result>) {
        dispatcher.on(handler)
    }
    
    func on<I:Request>(handler:(msg:I) -> I.Result) {
        dispatcher.on(handler)
    }
}



public class ActorRef<A:ActorHandler> {
    private let actor:ActorHandler;
    
    init(_ anActor:ActorHandler) {
        actor = anActor
    }
    
    func tell(msg:Any) {
        actor.handle(msg)
    }
    
    func ask<T:Request>(msg:T) -> Future<T.Result> {
        return actor.handle(msg).As()
    }
}