import Foundation


class Logout: NSObject{
    override init() {
        super.init()
    }
}

class SessionActor : DActor {
    
    let sessionApiActor: DTActorRef
    let mappingActor: DTActorRef
    let sessionStorage: SessionStorage?
    
    override init!(actorSystem: DTActorSystem!) {
        sessionApiActor = actorSystem.actorOfClass(SessionAPIActor)!
        mappingActor = actorSystem.actorOfClass(MappingActor)!
        sessionStorage = actorSystem.serviceLocator.service()
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        let returningClass = Login.self
        
        on { (msg: Login) -> RXPromise in
            return self.askSession(msg.email, password: msg.password)
        }
        
        on { (msg: Logout) -> Void in
            sessionStorage?.clear()
        }
    }
    
    // MARK: - Private
    
    private func askSession(login: String, password: String) -> RXPromise {
        let session = self.sessionApiActor.ask(GetSession(login: login, password: password))
        let mapSession = session.then({ result in
            if let payload = result as? String {
                return self.mappingActor.ask(MappingActor.MappingRequest(payload: payload, resultType: Session.self))
            } else {
                return NSError(domain: DTActorsErrorDomain, code: 0, userInfo: [DTActorsErrorMessageKey : "Wrong result type"])
            }
            }, nil)
        
        let storeSession = mapSession.then({result in
            return self.tryStoreSession(result)
        }, nil)
        
        return storeSession
    }
    
    private func tryStoreSession(session: AnyObject) -> RXPromise {
        let promise = RXPromise()
        if let s = session as? Session, storage = sessionStorage {
            storage.session = s
            promise.resolveWithResult(s)
        }
        
        promise.rejectWithReason("Failed to store session")
        return promise
    }
}