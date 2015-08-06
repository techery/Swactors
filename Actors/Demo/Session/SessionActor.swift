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
    
    let apiActor: DTActorRef
    let mappingActor: DTActorRef
    let sessionStorage: SessionStorage?
    
    override init!(actorSystem: DTActorSystem!) {
        apiActor = actorSystem.actorOfClass(SessionAPIActor)
        mappingActor = actorSystem.actorOfClass(MappingActor)
        sessionStorage = actorSystem.serviceLocator.serviceForClass(SessionStorage.self) as? SessionStorage
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        let returningClass = Login.self
        
        on { (msg: Login) -> RXPromise in
            return self.askSession(msg.email, password: msg.password)
        }
    }
    
    private func askSession(login: String, password: String) -> RXPromise {
        let session = self.apiActor.ask(SessionAPIActor.Session(login: login, password: password))
        let mappedSession = session.then({ result in
            if let payload = result as? String {
                let store = self.mappingActor.ask(MappingRequest(payload: payload, resultType: Session.self)).then({result in
                    self.storeSession(result)
                    return result
                }, nil)
                return store
            } else {
                return nil
            }
            }, nil)
        
        return mappedSession
    }
    
    private func storeSession(session: AnyObject) {
        if let s = session as? Session {
            if let storage = sessionStorage {
                storage.session = s
            }
        }
    }
}