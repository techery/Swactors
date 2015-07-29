import Foundation

class Playground {
    
    enum Messages {
        case Get(String)
        case Post(String, String)
    }
    
    let system = MainActorSystem() { builder in
        builder.add(SessionActor)
        builder.add(APIActor)
    }
    
    let sessionActor:ActorRef<SessionActor>
    let apiActor:ActorRef<APIActor>
    
    init() {
        sessionActor = system.actorOf(SessionActor)
        apiActor = system.actorOf(APIActor)
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
        let apiFuture = sessionActor.ask(SessionActor.Login(email: "http://localhost:8080", password: "1"))
        
        apiFuture.onSuccess { (result) -> Void in
            println(result)
        }.onFail { (error) -> Void in
            println(error)
        }
    }
}