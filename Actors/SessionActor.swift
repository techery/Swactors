import Foundation


class SessionActor : Actor {
    
    struct Login : Request {
        let email:String
        let password:String
        
        typealias Result = Session
    }
    
    class Logout {
        
    }
    
    let apiActor:ActorRef<APIActor>
    let mappingActor:ActorRef<MappingActor>
    
    required init(_ sys: ActorSystem) {
        apiActor = sys.actorOf(APIActor)
        mappingActor = sys.actorOf(MappingActor)
        super.init(sys)
    }
    
    override func setup() {
        
        on { (message:Logout) in
            
        }
        
        on { (msg:Login) -> Future<Login.Result> in
            let f = self.apiActor.ask(APIActor.Get(path:msg.email))
            return f.onSuccess({ (payload) -> Future<Session> in
                return self.mappingActor.ask(MappingRequest(payload: payload, resultType: Session.self))
            })
        }
    }
}