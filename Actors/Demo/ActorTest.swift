import Foundation

class Playground {
    
    let system = DTMainActorSystem() { builder in
        builder.addActor(AuthActor)
        builder.addActor(SessionActor)
        builder.addActor(SessionAPIActor)
        builder.addActor(APIActor)
        builder.addActor(MappingActor)
        builder.addActor(SettingsActor)
    }
    
    let authActor:DTActorRef
    
    init() {
        authActor = system.actorOfClass(AuthActor)
    }
    
    func main() {
        let f = self.authActor.ask(AuthActor.Login(email: "888888", password: "travel1ns1de"))
        f.then({result in
            println(result)
            return nil
            }, { error in
            println(error)
            return nil                
        })
    }
}