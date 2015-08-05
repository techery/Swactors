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
    
    let apiActor:DTActorRef
    let mappingActor:DTActorRef
    
    override init!(actorSystem: DTActorSystem!) {
        apiActor = actorSystem.actorOfClass(SessionAPIActor)
        mappingActor = actorSystem.actorOfClass(MappingActor)        
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        let returningClass = Login.self
        
        on { (msg: Login) -> RXPromise in
            let f = self.apiActor.ask(SessionAPIActor.Session(login: msg.email, password: msg.password))
            return f.then({ result in
                if let payload = result as? String {
                    return self.mappingActor.ask(MappingRequest(payload: payload, resultType: Session.self))
                } else {
                    return nil
                }
                
                }, { error in
                    return error
            })
        }
    }
}