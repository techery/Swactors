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
        apiActor = actorSystem.actorOfClass(APIActor)
        mappingActor = actorSystem.actorOfClass(MappingActor)        
        super.init(actorSystem: actorSystem)
    }
    
    override func setup() {
        let returningClass = Login.self
        
        on { (msg: Login) -> RXPromise in
            let f = self.apiActor.ask(APIActor.Post(path: "http://ec2-54-200-42-102.us-west-2.compute.amazonaws.com/api/sessions", parameters:["username": msg.email, "password" : msg.password]))
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