import Foundation

class Playground {
    
    enum Messages {
        case Get(String)
        case Post(String, String)
    }
    
    let system = DTMainActorSystem() { builder in
        builder.addActor(SessionActor)
        builder.addActor(SessionAPIActor)
        builder.addActor(APIActor)
        builder.addActor(MappingActor)
    }
    
    let sessionActor:DTActorRef
    let apiActor:DTActorRef
    
    init() {
        sessionActor = system.actorOfClass(SessionActor)
        apiActor = system.actorOfClass(APIActor)
    }
    
    func logFuture(future:Future<SessionActor.Login.Result>) {
        future.onSuccess { (result:Session) -> Void in
            println("Login success:#\(result.token)")
            self.sessionActor.tell(SessionActor.Logout())
        }.onFail { (error) -> Void in
            println("Login failed:#\(error.localizedDescription)")
        }
    }
    
    func main() {
        let f = self.sessionActor.ask(SessionActor.Login(email: "888888", password: "travel1ns1de"))
        f.then({result in
            println(result)
            return nil
            }, { error in
            println(error)
            return nil                
        })
    }
}