import Foundation

public protocol ActorProvider {
    func create<A:Actor>(system:ActorSystem) -> A
    func type() -> AnyClass
}

public class SingletoneActorProvider<T:Actor> : ActorProvider {
    let actorType:T.Type
    var actorInstance:T?
    
    init(_ type:T.Type) {
        actorType = type
    }
    
    public func create<A:Actor>(system:ActorSystem) -> A {
        if actorInstance == nil {
            actorInstance = T.create(T.self, sys:system)
        }
        
        return actorInstance as! A
    }
    
    public func type() -> AnyClass {
        return T.self
    }
}