import Foundation

struct Session {
    let token:String
}

class SessionActor : Actor {
    
    struct Login : Request {
        let email:String
        let password:String
        
        typealias Result = Session
    }
    
    struct Logout {
        
    }
    
    let apiActor:ActorRef<APIActor>
    
    required init(_ sys: ActorSystem) {
        apiActor = sys.actorOf(APIActor)
        super.init(sys)
    }
    
    override func setup() {
        
        on { (message:Logout) in
            
        }
        
        on { (msg:Login) -> Future<Login.Result> in
            let f = self.apiActor.ask(APIActor.Get(path:msg.email))
            return f.map({ (value) -> Session in
                return Session(token: value)
            })
        }
    }
}