//
// Created by Anastasiya Gorban on 8/13/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation
import Bond

class LoginViewModel {
    let actorSystem: DTMainActorSystem

    var email = Dynamic<String>("")
    var password = Dynamic<String>("")
    
    var loginInProccess = Dynamic<Bool>(false)
    
    var error: Dynamic<String> = Dynamic<String>("")
    
    init (actorSystem: DTMainActorSystem) {
        self.actorSystem = actorSystem
    }
    
    func login() -> RXPromise {
        loginInProccess.value = true
        error.value = ""
        
        let sessionActor = actorSystem.actorOfClass(DTSessionActor)!
        let result = sessionActor.ask(Login(email: email.value, password: password.value))
        result.thenOnMain({result in
            self.loginInProccess.value = false
            self.error.value = ""
            return result
            }, {error in
            self.loginInProccess.value = false
            self.error.value = error.localizedDescription
                return error
        })
        
        return result
    }
    
    var userViewModel: UserViewModel {
        get {
            let sessionStorage: DTSessionStorage = actorSystem.serviceLocator.service()!
            return UserViewModel(actorSystem: actorSystem, user: sessionStorage.session?.user)
        }
    }
}
