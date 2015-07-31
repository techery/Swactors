import Foundation

public protocol ActorProvider {
    func create(system:ActorSystem) -> ActorHandler
    func type() -> AnyClass
}

public class SingletoneActorProvider<T:Actor> : ActorProvider {
    let actorType:T.Type
    var actorInstance:ActorHandler?
    
    init(_ type:T.Type) {
        actorType = type
    }
    
    public func create(system:ActorSystem) -> ActorHandler {
        if actorInstance == nil {
            let actor = T.create(T.self, sys:system) as Actor
            let executor = ActorExecutor(actor)
            actorInstance = executor
        }
        
        return actorInstance!
    }
    
    public func type() -> AnyClass {
        return T.self
    }
}