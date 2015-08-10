import Foundation


class SessionActor : DActor {

    class Login : NSObject {
        let email:String
        let password:String
        
        typealias Result = Session
        
        init(email: String, password: String) {
            self.email = email
            self.password = password
        }
    }
    
    class Logout {
        
    }
    
    let sessionApiActor: DTActorRef
    let apiActor: DTActorRef
    let mappingActor: DTActorRef
    let sessionStorage: SessionStorage?
    
    override init!(actorSystem: DTActorSystem!) {
        sessionApiActor = actorSystem.actorOfClass(SessionAPIActor)!
        apiActor = actorSystem.actorOfClass(APIActor)!
        mappingActor = actorSystem.actorOfClass(MappingActor)!
        sessionStorage = actorSystem.serviceLocator.service()
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        let returningClass = Login.self
        
        on { (msg: Login) -> RXPromise in
            return self.askSession(msg.email, password: msg.password)
        }
    }
    
    private func askSession(login: String, password: String) -> RXPromise {
        let session = self.sessionApiActor.ask(SessionAPIActor.Session(login: login, password: password))
        let mapSession = session.then({ result in
            if let payload = result as? String {
                return self.mappingActor.ask(MappingActor.MappingRequest(payload: payload, resultType: Session.self))
            } else {
                return nil
            }
            }, nil)
        
        let storeSession = mapSession.then({result in
            return self.tryStoreSession(result)
        }, nil)
        
        return storeSession
    }
    
    private func tryStoreSession(session: AnyObject) -> RXPromise {
        let promise = RXPromise()
        if let s = session as? Session {
            if let storage = sessionStorage {
                storage.session = s
                promise.resolveWithResult(s)
            }
        }
        
        promise.rejectWithReason("Failed to store session")
        return promise
    }
    
    private func setTokenToHeaders() {
        
    }
}